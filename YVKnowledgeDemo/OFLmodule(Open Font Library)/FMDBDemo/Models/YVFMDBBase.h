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

#pragma mark Creation
/*!
 * @brief CreateDataBase
 * @param sqliteName (currentSqliteName)
 * @param form (a form, support Array(key1, key2, ...; or create for a dictionary with key and type) and Dictionary(create with key and type))
 * @return createdResult
 */
- (BOOL)createDataBaseWithSqliteName:(NSString *)sqliteName
                                form:(id)form;

#pragma mark Update
/*!
 * @brief AppendingInsertionQueryString
 * @param tableName (a table's Name)
 * @param keyProperties (properties of a table)
 * @param insertProperties (insert properties)
 */
 NSString *AppendingInsertionQueryString(NSString *tableName, NSMutableArray *keyProperties, NSMutableArray *insertProperties);
/*!
 * @brief AppendingDeletionQueryString
 * @param tableName (a table's Name)
 * @param keyProperties (properties of a table)
 * @param conditions (conditions array)
 */
NSString *AppendingDeletionQueryString(NSString *tableName, NSMutableArray *keyProperties, NSMutableArray *conditions);
/*!
 * @brief AppendingUpdateQueryString
 * @param tableName (a table's Name)
 * @param keyProperties (properties of a table)
 * @param conditions (conditions array)
 */
NSString *AppendingUpdateQueryString(NSString *tableName, NSMutableArray *keyProperties, NSMutableArray *conditions);
/*!
 * @brief UpdateInfo
 * @param queryString (insert sqlQuery, please use)
 * @param ... (nonquantitative parameters, please insert value with dataSources index)
 * @return deleteResult
 */
- (BOOL)updateDataBaseInfoWithQueryString:(NSString *)queryString,...;

#pragma mark Selection
/*!
 * @brief AppendingInsertionQueryString
 * @param tableName (a table's Name)
 * @param keyProperties (properties of a table)
 * @param conditions (conditions array)
 */
NSString *AppendingSelectionQueryString(NSString *tableName, NSMutableArray *keyProperties, NSMutableArray *conditions);
/*!
 * @brief selectedInfo
 * @param objName (insert a name and it will used for creation list, if don't need, set it nil)
 * @param queryString (insert sqlQuery, please use)
 * @param ... (nonquantitative parameters, please insert value with dataSources index)
 * @return results
 */
- (NSMutableArray *)selectedInfoWithObjectName:(NSString *)objName
                                   queryString:(NSString *)queryString,...;

@end
