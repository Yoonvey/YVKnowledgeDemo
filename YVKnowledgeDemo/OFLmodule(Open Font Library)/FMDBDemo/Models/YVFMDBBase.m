//
//  YVFMDBBase.m
//  YVKnowledgeDemo
//
//  Created by Yoonvey on 2018/4/23.
//  Copyright © 2018年 YoonveyTest. All rights reserved.
//

#import "YVFMDBBase.h"

#import <objc/runtime.h>
#import <stdarg.h>

@interface YVFMDBBase ()

@property (nonatomic, strong) FMDatabase *dataBase;
@property (nonatomic) NSInteger idserial;

@end

@implementation YVFMDBBase

#pragma mark - <Instance>
+ (instancetype)sharedDataBase
{
    static YVFMDBBase *instance;
    static dispatch_once_t token;
    dispatch_once(&token, ^
    {
        instance = [[YVFMDBBase alloc]init];
    });
    return instance;
}

- (void)dealloc
{
    
}

- (NSMutableArray *)keyProperties
{
    if (!_keyProperties)
    {
        _keyProperties = [NSMutableArray array];
    }
    return _keyProperties;
}

#pragma mark - <Resources>
//GetSqlitePath
NSString *GetSqlitePathWithFileName(NSString *fileName)
{
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *sqlitePath = [doc stringByAppendingString:[NSString stringWithFormat:@"/%@.sqlite", fileName]];
    return sqlitePath;
}

NSArray *GetPropertiesFromObject(id object)
{
    NSMutableArray *propertyNames = [NSMutableArray array];
    unsigned int outCount, i;
    //Get properties from object
    objc_property_t *properties = class_copyPropertyList([object class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        //Transform to string
        NSString *propertyName = [[NSString alloc]initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [propertyNames addObject:propertyName];
        free(property);//FreeElement
    }
    free(properties);//FreeLIst
    return propertyNames;
}

//CheckProperties
BOOL CheckIsExistProperties(id instance, NSString *verifyPropertyName)
{
    //Check
    if ([instance isKindOfClass:[NSDictionary class]])
    {
        for (NSString *propertyName in instance)
        {
            if ([propertyName isEqualToString:verifyPropertyName])
            {
                return YES;
            }
        }
    }
    else
    {
        for (NSString *propertyName in GetPropertiesFromObject(instance))
        {
            if ([propertyName isEqualToString:verifyPropertyName])
            {
                return YES;
            }
        }
    }
    return NO;
}

//CheckIsTableExist
BOOL CheckIsTableExist(FMDatabase *db,NSString * tableName)

{
    FMResultSet *result = [db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    while ([result next])
    {
        // just print out what we've got in a number of formats.
        NSInteger count = [result intForColumn:@"count"];
        NSLog(@"isTableOK %li", count);
        if (0 == count)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    return NO;
}

//CreationQuery
NSString *AppendingCreationQueryString(id form, id class, NSString *tableName, NSMutableArray *keyProperties)
{
    if (keyProperties.count != 0)//Remove old keyProperties
    {
        [keyProperties removeAllObjects];
    }
    NSMutableArray *newKeyProperties = [NSMutableArray arrayWithArray:keyProperties];
    NSString *queryString = [NSString stringWithFormat:@"create table if not exists %@ (id integer primary key autoincrement,", tableName];
    [newKeyProperties addObject:@"id"];
    if([form isKindOfClass:[NSArray class]])
    {
        for (id obj in form)
        {
            if ([obj isKindOfClass:[NSString class]])//NSString
            {
                queryString = [queryString stringByAppendingString:[NSString stringWithFormat:@", %@ text", obj]];
            }
            else if([obj isKindOfClass:[NSDictionary class]])//NSDictionary
            {
                for (NSString *keyWord in GetPropertiesFromObject(form))
                {
                    queryString = [queryString stringByAppendingString:[NSString stringWithFormat:@", %@ %@", keyWord, [form valueForKey:keyWord]]];
                    [newKeyProperties addObject:keyWord];
                }
            }
            queryString = [queryString stringByAppendingString:@")"];//Appending ')'
        }
    }
    else if([form isKindOfClass:[NSDictionary class]])//NSDictionary
    {
        BOOL insert = NO;
        for (NSString *keyWord in form)
        {
            queryString = [queryString stringByAppendingString:[NSString stringWithFormat:@"%@ %@,", keyWord, [form valueForKey:keyWord]]];
            [newKeyProperties addObject:keyWord];
            insert = YES;
        }
        if (insert)
        {
            queryString = [queryString substringWithRange:NSMakeRange(0, queryString.length-1)];//Delete ','
        }
        queryString = [queryString stringByAppendingString:@")"];//Appending ')'
    }
    else
    {
        BOOL insert = NO;
        for (NSString *keyWord in GetPropertiesFromObject(form))
        {
            queryString = [queryString stringByAppendingString:[NSString stringWithFormat:@"%@ %@,", keyWord, [form valueForKey:keyWord]]];
            [newKeyProperties addObject:keyWord];
        }
        if (insert)
        {
            queryString = [queryString substringWithRange:NSMakeRange(0, queryString.length-1)];//Delete ','
        }
        queryString = [queryString stringByAppendingString:@")"];//Appending ')'
    }
    [class setValue:newKeyProperties forKey:NSStringFromSelector(@selector(keyProperties))];
    return queryString;
}

//InsertionQuery
NSString *AppendingInsertionQueryString(NSString *tableName, NSMutableArray *keyProperties, NSMutableArray *insertProperties)
{
    NSString *queryString = [NSString stringWithFormat:@"insert into %@ (", tableName];//Get table
    //Insert keys
    for (NSString *keyProperty in keyProperties)
    {
        if (![keyProperty isEqualToString:@"id"])
        {
            for (NSString *property in insertProperties)
            {
                if ([keyProperty isEqualToString:property])
                {
                    queryString = [queryString stringByAppendingString:[NSString stringWithFormat:@" %@,", keyProperty]];
                }
            }
        }
    }
    queryString = [queryString substringWithRange:NSMakeRange(0, queryString.length-1)];//Delete ','
    queryString = [queryString stringByAppendingString:@") values("];
    
    for (NSString *keyProperty in keyProperties)
    {
        if(![keyProperty isEqualToString:@"id"])
        {
            for (NSString *property in insertProperties)
            {
                if ([keyProperty isEqualToString:property])
                {
                    queryString = [queryString stringByAppendingString:@" ?,"];
                }
            }
        }
    }
    queryString = [queryString substringWithRange:NSMakeRange(0, queryString.length-1)];//Delete ','
    queryString = [queryString stringByAppendingString:@")"];
    
    return queryString;
}

//SelectionQuery
NSString *AppendingDeletionQueryString(NSString *tableName, NSMutableArray *keyProperties, NSMutableArray *conditions)
{
    if (!conditions || [conditions isEqual:[NSNull null]])
    {
        return [NSString stringWithFormat:@"delete from %@", tableName];//Delete all
    }
    else
    {
        NSString *queryString = [NSString stringWithFormat:@"delete from %@ where", tableName];
        
        //Insert conditions
        if ([conditions isKindOfClass:[NSArray class]])
        {
            BOOL isInsert = NO;
            for (NSString *keyProperty in conditions)
            {
                queryString = [queryString stringByAppendingString:[NSString stringWithFormat:@" %@ = ? and", keyProperty]];
                isInsert = YES;
            }
            if (isInsert)
            {
                queryString = [queryString substringWithRange:NSMakeRange(0, queryString.length-3)];//Delete 'and'
            }
        }
        else
        {
            NSLog(@"condition is not a dictionary class object!");
        }
        return queryString;
    }
}

//SelectionQuery
NSString *AppendingSelectionQueryString(NSString *tableName, NSMutableArray *keyProperties, NSMutableArray *conditions)
{
    if (!conditions || [conditions isEqual:[NSNull null]])
    {
        return [NSString stringWithFormat:@"select * from %@", tableName];
    }
    else
    {
        NSString *queryString = @"select";
        //Insert keys
        for (NSString *keyProperty in keyProperties)
        {
            queryString = [queryString stringByAppendingString:[NSString stringWithFormat:@" %@,", keyProperty]];
        }
        queryString = [queryString substringWithRange:NSMakeRange(0, queryString.length-1)];//Delete ','
        queryString = [queryString stringByAppendingString:[NSString stringWithFormat:@" from %@ where", tableName]];
        
        //Insert conditions
        if ([conditions isKindOfClass:[NSArray class]])
        {
            BOOL isInsert = NO;
            for (NSString *keyProperty in conditions)
            {
                queryString = [queryString stringByAppendingString:[NSString stringWithFormat:@" %@ = ? and", keyProperty]];
                isInsert = YES;
            }
            if (isInsert)
            {
                queryString = [queryString substringWithRange:NSMakeRange(0, queryString.length-3)];//Delete 'and'
            }
        }
        else
        {
            NSLog(@"condition is not a dictionary class object!");
        }
        return queryString;
    }
}

#pragma mark - <Action>
//Open DataBase
- (BOOL)createDataBaseWithSqliteName:(NSString *)sqliteName form:(id)form
{
    if (!_dataBase)
    {
        _dataBase = [FMDatabase databaseWithPath:GetSqlitePathWithFileName(sqliteName)];
        self.tableName = [NSString stringWithFormat:@"%@Table", sqliteName];
    }
    
    if ([_dataBase open])
    {
        return [_dataBase executeUpdate:AppendingCreationQueryString(form, self, self.tableName, self.keyProperties)];
    }
    return NO;
}

//Update DataSources
- (BOOL)updateDataBaseInfoWithQueryString:(NSString *)queryString,...
{
    if (!queryString || [queryString isEqual:[NSNull null]])
    {
        NSLog(@"queryString is null!");
        return NO;
    }
    else
    {
        if ([_dataBase open])
        {
            va_list args;
            va_start(args, queryString);
            BOOL flag = [_dataBase executeUpdate:queryString withVAList:args];
            va_end(args);
            return flag;
        }
        else
        {
           return NO;
        }
    }
}

//Selected specified info
- (NSMutableArray *)selectedInfoWithObjectName:(NSString *)objName queryString:(NSString *)queryString,...
{
    NSMutableArray *results = [NSMutableArray array];
    va_list args;
    va_start(args, queryString);
    FMResultSet *resultSet = [_dataBase executeQuery:queryString withVAList:args];
    va_end(args);
    if ([_dataBase open])
    {
        while ([resultSet next])
        {
            //Get object
            NSObject *objClass = [[NSClassFromString(objName) alloc] init];
            if (!objClass)
            {
                objClass = [NSMutableDictionary dictionary];
                for (NSString *property in self.keyProperties)
                {
                    NSString *resultString = [resultSet stringForColumn:property];
                    [objClass setValue:resultString forKey:property];
                }
            }
            else
            {
                //Get properties and set value
                unsigned int count = 0;
                Ivar *ivarList = class_copyIvarList([objClass class], &count);
                for (int i = 0; i<count; i++)
                {
                    const char *name = ivar_getName(ivarList[i]);
                    NSString *stringName = [NSString stringWithUTF8String:name];
                    if (CheckIsExistProperties(objClass, stringName))
                    {
                        [objClass setValue:[resultSet stringForColumn:stringName] forKey:stringName];
                    }
                    [results addObject:objClass];
                }
                free(ivarList);//Free
            }
            [results addObject:objClass];
        }
    }
    return results;
}

@end
