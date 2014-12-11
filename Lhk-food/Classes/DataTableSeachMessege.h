//
//  DataTableSeachMessege.h
//  DataTable
//
//  Created by hongda on 14-11-13.
//  Copyright (c) 2014年 ZHYD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataTableSeachMessege : NSObject

+(DataTableSeachMessege*)dataTableSeachMessege;//表格的单例，使用的时候要使用这个方法去调用，以及初始化，保证表的唯一性
-(BOOL) insertTableWith:(NSString*)keyWorld ;//插入数据
-(NSArray*)selectSearchMesWihtNum:(NSInteger)num; //查询最后num的记录条数，最近更改的
-(BOOL)deleteAllData;//删除表中所有数据
-(BOOL)closeDB;//慎用

@end
