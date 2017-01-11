//
//  RubyPersonTool.m
//  RubyInfo
//
//  Created by tyhmeng on 17/1/11.
//  Copyright © 2017年 tyhmeng. All rights reserved.
//

#import "RubyPersonTool.h"
#import "RubyPerson.h"
#import <sqlite3.h>

@interface RubyPersonTool ()


@end

@implementation RubyPersonTool

static sqlite3 *db;
//需要有数据库
+ (void)initialize {
//数据库地址
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [doc stringByAppendingPathComponent:@"person.sqlite"];
    NSLog(@"路径%@",fileName);
//    将oc字符串转c字符串
    const char *cFile = fileName.UTF8String;
//   打开数据库
    int result = sqlite3_open(cFile, &db);
    if (result == SQLITE_OK) {
        NSLog(@"成功打开");
//        创建表
        const char * sql = "CREATE TABLE IF NOT EXISTS t_person (id integer PRIMARY KEY AUTOINCREMENT,name text NOT NULL,age integer NOT NULL);";
        
        char *errmsg = NULL;
        int resul = sqlite3_exec(db, sql, NULL, NULL, &errmsg);
        if (resul == SQLITE_OK) {
            NSLog(@"创建表成功");
        }else {
        
            NSLog(@"创建表失败");
        
        }
        
        
    }else {
    
        NSLog(@"打开失败");
    
    }
}

+ (void)save:(RubyPerson *)per {
//拼接sql语句
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_person (name,age) VALUES ('%@',%d);",per.name,per.age];
//    执行sql语句
    
    char *errmsg = NULL;
    sqlite3_exec(db, sql.UTF8String, NULL, NULL, &errmsg);
    if (errmsg) {
        NSLog(@"插入数据失败");
        
    }else {
    
        NSLog(@"插入数据成功");
    }


}

+ (NSArray *)query {

    return [self queryWithCondition:@""];
}

//模糊查询
+ (NSArray *)queryWithCondition:(NSString *)condition {
//用来存放所有查询到底联系人
    NSMutableArray *pers = nil;
    
    NSString *sqlM = [NSString stringWithFormat:@"SELECT id,name,age FROM t_person WHERE name  like '%%%@%%' ORDER BY age ASC;",condition];
    NSLog(@"%@",sqlM);

    const char *sql = sqlM.UTF8String;
    
    
    sqlite3_stmt *stmt = NULL;
    
//    进行查询前的准备工作
    
    if (sqlite3_prepare_v2(db, sql, -1, &stmt, NULL) == SQLITE_OK) {
        NSLog(@"查询语句没有问题");
        pers = [NSMutableArray array];
//        每调用一次sqlite3_step 函数，stmt就会指向下一条记录
        while (sqlite3_step(stmt)== SQLITE_ROW) {//找到一条记录
//          取出数据
//            取出第0列字段的值（int 类型的值）

            int ID = sqlite3_column_int(stmt, 0);
            
//            取出第1列字段的值（text类型的值）
            const unsigned char *name = sqlite3_column_text(stmt, 1);
//            取出第2列字段的值（int类型的值）
            int age = sqlite3_column_int(stmt, 2);
            RubyPerson *per = [[RubyPerson alloc]init];
            per.ID = ID;
            per.name = [NSString stringWithUTF8String:(const char *)name];
            per.age = age;
            
            [pers addObject:per];
            
        }
        
        
    }else {
    
        NSLog(@"查询失败");
    }
    
    
    return pers;
}


@end
