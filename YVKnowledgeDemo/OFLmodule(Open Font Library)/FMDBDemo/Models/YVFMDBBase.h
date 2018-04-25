//
//  YVFMDBBase.h
//  YVKnowledgeDemo
//
//  Created by Yoonvey on 2018/4/23.
//  Copyright © 2018年 YoonveyTest. All rights reserved.
//

#import <Foundation/Foundation.h>

@import FMDB;

@interface YVFMDBBase : NSObject

@property (nonatomic, copy) NSString *tableName;
@property (nonatomic, strong) NSMutableArray *keyProperties;

//Instance a static dataBase
+ (instancetype)sharedDataBase;

/*!
 * @brief CreateDataBase
 * @param sqliteName (currentSqliteName)
 * @param form (a form, support Array(key1, key2, ...; or create for a dictionary with key and type) and Dictionary(create with key and type))
 * @return createdResult
 */
- (BOOL)createDataBaseWithSqliteName:(NSString *)sqliteName
                                form:(id)form;

/*!
 * @brief AppendingInsertionQueryString
 * @param tableName (a table's Name)
 * @param keyProperties (properties of a table)
 * @param value (insert info)
 */
 NSString *AppendingInsertionQueryString(NSString *tableName, NSMutableArray *keyProperties, id value);

/*!
 * @brief InsertDataSources
 * @param queryString (insert sqlQuery, please use)
 * @param ... (nonquantitative parameters, please insert value with dataSources index)
 * @@return insertResult
 */
- (BOOL)insertDataSources:(NSString *)queryString,...;

/*!
 * @brief selectedInfo
 * @param condition (selectedConditionList, if condition is nil ,it will select all)
 * @param objName (insert a name and it will used for creation list, if don't nedd, set it nil)
 * @return results
 */
- (NSMutableArray *)selectedInfoWithCondition:(NSDictionary *)condition
                                   objectName:(NSString *)objName;

@end
