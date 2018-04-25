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

#pragma mark temp
void invokeSelector(id object, SEL selector, NSArray *arguments)
{
    NSMethodSignature *signature = [object methodSignatureForSelector:selector];
    
    if (signature.numberOfArguments == 0)
    {
        return; //@selector未找到
    }
    
    if (signature.numberOfArguments > [arguments count]+2)
    {
        return; //传入arguments参数不足。signature至少有两个参数，self和_cmd
    }
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:object];
    [invocation setSelector:selector];
    
    for(int i=0; i<[arguments count]; i++)
    {
        id arg = [arguments objectAtIndex:i];
        [invocation setArgument:&arg atIndex:i+2]; // The first two arguments are the hidden arguments self and _cmd
    }
    
    [invocation invoke]; // Invoke the selector
}

//CreationQuery
NSString *AppendingCreationQueryString(id form, id class, NSString *tableName, NSMutableArray *keyProperties)
{
    NSMutableArray *newKeyProperties = [NSMutableArray arrayWithArray:keyProperties];
    NSString *queryString = [NSString stringWithFormat:@"create table if not exists %@ (id integer primary key autoincrement,", tableName];
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
NSString *AppendingInsertionQueryString(NSString *tableName, NSMutableArray *keyProperties, id value)
{
    NSString *queryString = [NSString stringWithFormat:@"insert into %@ (", tableName];//Get table
    //Insert keys
    for (NSString *keyProperty in keyProperties)
    {
        queryString = [queryString stringByAppendingString:[NSString stringWithFormat:@" %@,", keyProperty]];
    }
    queryString = [queryString substringWithRange:NSMakeRange(0, queryString.length-1)];//Delete ','
    queryString = [queryString stringByAppendingString:@") values("];
    
    for (NSString *keyProperty in keyProperties)
    {
        if(keyProperty)
        {
            
        }
        queryString = [queryString stringByAppendingString:@" ?,"];
    }
    queryString = [queryString substringWithRange:NSMakeRange(0, queryString.length-1)];//Delete ','
    queryString = [queryString stringByAppendingString:@")"];
    
    return queryString;
}

//SelectionQuery
NSString *AppendingSelectionQueryString(NSString *tableName, NSMutableArray *keyProperties, NSDictionary *condition)
{
    if (!condition || [condition isEqual:[NSNull null]])
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
        if ([condition isKindOfClass:[NSDictionary class]])
        {
            BOOL isInsert = NO;
            for (NSString *keyProperty in keyProperties)
            {
                if (CheckIsExistProperties(condition, keyProperty))
                {
                    queryString = [queryString stringByAppendingString:[NSString stringWithFormat:@" %@ = ? and", [condition valueForKey:keyProperty]]];
                    isInsert = YES;
                }
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

//Insert DataSources
- (BOOL)insertDataSources:(NSString *)queryString,...
{
    if (!queryString || [queryString isEqual:[NSNull null]])
    {
        NSLog(@"dataSources is null!");
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
        return YES;
    }
}
//- (BOOL)insertDataSources:(id)dataSources,...
//{
//    if (!dataSources || [dataSources isEqual:[NSNull null]])
//    {
//        NSLog(@"dataSources is null!");
//        return NO;
//    }
//    else
//    {
//        if ([_dataBase open])
//        {
//            NSString *queryString = AppendingInsertionQueryString(self.tableName, self.keyProperties, dataSources);
//            va_list args;
//            va_start(args, queryString);
//            BOOL flag = [_dataBase executeUpdate:queryString withVAList:args];
//            va_end(args);
//            return flag;
//        }
//        return YES;
//    }
//}

//Selected specified info
- (NSMutableArray *)selectedInfoWithCondition:(NSDictionary *)condition objectName:(NSString *)objName
{
    NSMutableArray *results = [NSMutableArray array];
    FMResultSet *resultSet = [_dataBase executeQuery:AppendingSelectionQueryString(self.tableName, self.keyProperties, condition)];
    if ([_dataBase open])
    {
        while ([resultSet next])
        {
            //Get object
            NSObject *objClass = [[NSClassFromString(objName) alloc] init];
            if (!objClass)
            {
                objClass = [NSMutableDictionary dictionary];
                if (!condition)
                {
                    for (NSString *property in self.keyProperties)
                    {
                        NSString *resultString = [resultSet stringForColumn:property];
                        [objClass setValue:resultString forKey:property];
                    }
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
