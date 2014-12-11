//
//  GroupTable.h
//  爱普笔记
//
//  Created by ldci on 14-6-24.
//  Copyright (c) 2014年 ldci. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataBase.h"

@interface GroupTable : NSObject

@property (strong ,nonatomic) DataBase *data;

+(GroupTable*)groupTable;

-(id)init;
-(BOOL)createTable;
//select
-(NSArray *)selectAllData;
-(NSArray *)selectDataAtID:(int)groupId;
//insert

-(BOOL)insertDataWithID:(int)idNum Title:(NSString*)title;
-(BOOL)insertDataWithTitle:(NSString*)title;
//update
-(BOOL)updateGroupTitle:(NSString*)title AtID:(int)idNum;
//delete
-(BOOL)deleteDataAtID:(int)idNum;

-(BOOL)closeDB;
@end
