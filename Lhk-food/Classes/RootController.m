//
//  MYViewController.m
//  IntroductionExample
//
//  Copyright (C) 2013, Matt York
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//  of the Software, and to permit persons to whom the Software is furnished to do
//  so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import "RootController.h"


@interface RootController ()

@end

@implementation RootController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    
    
    //判断是否试首次登录
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [userDefaults objectForKey:@"versions"];
//    这里的string是versions键的值，肯定是空的，没有设置过，判断是否是首次使用
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    
    if (string == nil||(![string isEqualToString:app_Version])) {
//        GuideViewController *guideViewController = [[GuideViewController alloc]initWithNibName:@"GuideViewController" bundle:nil];
//        [self.window addSubview:guideViewController.view];
        
   
    //STEP 1 Construct Panels
        MYIntroductionPanel *panel = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"ydy1"]  title :@"辩访周边美食"description:@"Welcome to MYIntroductionView, your 100 percent customizable interface for introductions and tutorials! Simply add a few classes to your project, and you are ready to go!"];
    
    //You may also add in a title for each panel
    MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"ydy2"] title:@"只需轻松一点" description:@"MYIntroductionView is your ticket to a great tutorial or introduction!"];
        
    MYIntroductionPanel *panel3 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"ydy3"] title:@"乐享美味 近在周边" description:@"MYIntroductionView is your ticket to a great tutorial or introduction!"];

    //STEP 2 Create IntroductionView
    
    /*A standard version*/
    //MYIntroductionView *introductionView = [[MYIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) headerImage:[UIImage imageNamed:@"SampleHeaderImage.png"] panels:@[panel, panel2]];
    
    
    /*A version with no header (ala "Path")*/
    //MYIntroductionView *introductionView = [[MYIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) panels:@[panel, panel2]];
    
    /*A more customized version*/
    
    CGRect rx = [ UIScreen mainScreen ].bounds;
    MYIntroductionView *introductionView = [[MYIntroductionView alloc] initWithFrame:CGRectMake(0, 0, rx.size.width, rx.size.height) headerText:@"" panels:@[panel, panel2,panel3] languageDirection:MYLanguageDirectionLeftToRight];
    [introductionView setBackgroundImage:[UIImage imageNamed:@"SampleBackground"]];
//        [introductionView setBackgroundColor:(UIColor *)];
    
    //Set delegate to self for callbacks (optional)
    introductionView.delegate = self;
    
    //STEP 3: Show introduction view
    [introductionView showInView:self.view];
        
        
        //保存版本信息，第一次运行程序才显示引导页
    NSUserDefaults *userDefaults = [NSUserDefaults  standardUserDefaults];
    
    //保存数据
    [userDefaults setObject:app_Version  forKey:@"versions" ];
    
    //加载数据
    //    array = [userDefaults objectForKey:@"userInfo"];
    
    NSLog(@"login name :  %s",[ app_Version UTF8String ]);
    
    //删除数据
    //    [userDefaults removeObjectForKey:@"userInfo"];
    
    //退出程序后再次运行程序获取上一次保存的数据
    [userDefaults synchronize];     //重点

     }
    
    [self initTabBar];


    
    //    self.tabBar.

//
//    [item setFinishedSelectedImage:[UIImage imageNamed:@"1.png"]
//       withFinishedUnselectedImage:[UIImage imageNamed:@"2.png"]];
}

-(void) initTabBar
{
    //设置tabbar的字体颜色和选择后的图片样式
    UITabBarItem * item = [self.tabBar.items objectAtIndex:0];
    item.selectedImage = [[UIImage imageNamed:@"footbar_inquiry_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NSMutableDictionary *selectedtextAttrs=[NSMutableDictionary dictionary];
    selectedtextAttrs[UITextAttributeTextColor]=[UIColor colorWithRed:0xe6/255.0f green:0x50/255.0f blue:0x3c/255.0f alpha:1];
    
    [item setTitleTextAttributes:selectedtextAttrs forState:UIControlStateSelected];
    
    item = [self.tabBar.items objectAtIndex:1];
    item.selectedImage = [[UIImage imageNamed:@"footbar_recommend_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
   selectedtextAttrs=[NSMutableDictionary dictionary];
    selectedtextAttrs[UITextAttributeTextColor]=[UIColor colorWithRed:0xe6/255.0f green:0x50/255.0f blue:0x3c/255.0f alpha:1];
    
    [item setTitleTextAttributes:selectedtextAttrs forState:UIControlStateSelected];
    
    item = [self.tabBar.items objectAtIndex:2];
    item.selectedImage = [[UIImage imageNamed:@"footbar_On_Sale_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    selectedtextAttrs=[NSMutableDictionary dictionary];
    selectedtextAttrs[UITextAttributeTextColor]=[UIColor colorWithRed:0xe6/255.0f green:0x50/255.0f blue:0x3c/255.0f alpha:1];
    
    [item setTitleTextAttributes:selectedtextAttrs forState:UIControlStateSelected];
    
    
    item = [self.tabBar.items objectAtIndex:3];
    item.selectedImage = [[UIImage imageNamed:@"footbar_mine_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    selectedtextAttrs=[NSMutableDictionary dictionary];
    selectedtextAttrs[UITextAttributeTextColor]=[UIColor colorWithRed:0xe6/255.0f green:0x50/255.0f blue:0x3c/255.0f alpha:1];
    
    [item setTitleTextAttributes:selectedtextAttrs forState:UIControlStateSelected];
    
    
    item = [self.tabBar.items objectAtIndex:4];
    item.selectedImage = [[UIImage imageNamed:@"footbar_else_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
     selectedtextAttrs=[NSMutableDictionary dictionary];
    selectedtextAttrs[UITextAttributeTextColor]=[UIColor colorWithRed:0xe6/255.0f green:0x50/255.0f blue:0x3c/255.0f alpha:1];
    
    [item setTitleTextAttributes:selectedtextAttrs forState:UIControlStateSelected];
}



-(void)viewDidAppear:(BOOL)animated{
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Sample Delegate Methods

-(void)introductionDidFinishWithType:(MYFinishType)finishType{
    if (finishType == MYFinishTypeSkipButton) {
        NSLog(@"Did Finish Introduction By Skipping It");
    }
    else if (finishType == MYFinishTypeSwipeOut){
        NSLog(@"Did Finish Introduction By Swiping Out");
    }
    
    //One might consider making the introductionview a class variable and releasing it here.
    // I didn't do this to keep things simple for the sake of example.
}

-(void)introductionDidChangeToPanel:(MYIntroductionPanel *)panel withIndex:(NSInteger)panelIndex{
    NSLog(@"%@ \nPanelIndex: %d", panel.Description, panelIndex);
}

@end
