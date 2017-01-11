//
//  RubyPersonTool.h
//  RubyInfo
//
//  Created by tyhmeng on 17/1/11.
//  Copyright © 2017年 tyhmeng. All rights reserved.
//

#import <Foundation/Foundation.h>


@class RubyPerson;

@interface RubyPersonTool : NSObject
//保存一个联系人

+ (void)save:(RubyPerson *)per;


//查询所有的联系人
+ (NSArray *)query;

+ (NSArray *)queryWithCondition:(NSString *)condition;




@end
