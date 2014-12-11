//
//  MyTableViewController.m
//  Lhk-food
//
//  Created by 谢超 on 14/11/26.
//  Copyright (c) 2014年 huwei. All rights reserved.
//

#import "MyTableViewController.h"

typedef enum : NSUInteger{
    CellTagLogin = 101,
    CellTagFav = 102, //收藏
    CellTagCom = 103, //评论
    CellTagMyShop = 104,
} CellTag;

@implementation MyTableViewController



//view的初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    backItem.image=[UIImage imageNamed:@""];
    self.navigationItem.backBarButtonItem=backItem;
    
    //设置登录提示的框
    [self setLoginCell];

    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //根据tag值来判断进入那个view
    [self toSegue:cell tag:cell.tag];
}

-(void) toSegue:(UITableViewCell *) cell tag :(NSInteger)tag
{
    NSString *seguestr ;
    
    //判断是否已经登录，没有登录，则进入登录界面
     if(User.defaultUserid == nil || [User.defaultUserid integerValue] <0)
    {
        seguestr = @"myLoginSeque";
    }
    else
    {
        switch (tag) {
            case CellTagLogin:
                //登录后，按这个键应该是取消登录
//                seguestr =@"myLoginSeque";
                break;
            case CellTagFav:
                seguestr =@"favSeque";

                break;
            case CellTagCom:
                seguestr =@"comSeque";

                break;
            case CellTagMyShop:
                seguestr =@"myShopSeque";
                break;
            default:
                break;
        }
    }
    
    if(seguestr !=nil)
    {
    //进入对应的页面
        [self performSegueWithIdentifier:seguestr sender:cell];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //tag值
//    NSInteger  tag = [sender
//                      tag];

    if([segue.identifier isEqual: @"myShopSeque"])
    {
        
        //如果显示我的店铺，则做如下处理
        ResultTableViewController * tableviewController = [segue destinationViewController];
        //标示为显示我的店铺
        tableviewController.showtype =ResultTableStyleMyShop;
    }

}

- (IBAction)loginInAndLoginOut:(id)sender {
    if(User.defaultUserid == nil || [User.defaultUserid integerValue] <0)
    {
        [self performSegueWithIdentifier:@"myLoginSeque" sender:sender];
    }
    else
    {
        //退出登录，删除保存的user值
        [User deleteDefaultUser];
    }
    [self setLoginCell];

}

-(void) setLoginCell
{
    if(User.defaultUserid == nil || [User.defaultUserid integerValue] <0)
    {
        
        [self.userName setHidden:YES];
        [self.loginLabel setTitle:@"登录" forState:UIControlStateNormal];
        
    }
    else
    {
        //显示用户名
        [self.userName setHidden:NO];
        self.userName.text = User.defaultUserName;
        //设置用户图片
        //没有写
        [self.loginLabel setTitle:@"退出登录" forState:UIControlStateNormal];
    }
}
@end
