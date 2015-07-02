//
//  AddShopViewController.m
//  Lhk-food
// 添加店铺
//  Created by 谢超 on 14/10/31.
//  Copyright (c) 2014年 huwei. All rights reserved.
//

#import "AddShopViewController.h"
#import "MyFoodTableViewController.h"
#import "MyOffeTableViewController.h"
#import "ShopSearchSpec.h"
#import "ZHPickView.h"
#import "UIImageView+WebCache.h"

@interface AddShopViewController () <ZHPickViewDelegate>
@property BOOL isFullScreen;
@property ZHPickView *pickView;
@property NSIndexPath *indexPath;
@property UIImage *image ;
@property NSString *imageStr; //保存图片的图片名
@property LMImage *imageSet;
@end


@implementation AddShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(_type == AddShopTypeUpdate)
    {
        //设置优惠和美食信息两个cell可见
        //NSIndexPath  *path = [NSIndexPath alloc]initWithIndex:<#(NSUInteger)#>
//        self.tableView cellForRowAtIndexPath:(NSIndexPath *)
        
//         UITableViewCell *cell= (UITableViewCell *)[self.tableView viewWithTag:101];
//        cell.hidden = YES;
//        
//        cell= (UITableViewCell *)[self.tableView viewWithTag:102];
//        cell.hidden = YES;
        
        [self initForm];
//        [self.tableView reloadData];
    }

}


//初始化表格
-(void) initForm
{
    self.shopname.text = self.shop.name;
    self.shopaddress.text = self.shop.address;
    self.foodtype.text =@"中餐";//self.shopType
    self.shopphone.text = self.shop.phone;
    self.starttime.text = [Helper stringFromDate: self.shop.open_from];
    self.endtime.text = [Helper stringFromDate: self.shop.opent_to];
    self.avg_price.text = [NSString stringWithFormat:@"%.2f",[self.shop.avg_spend  floatValue]];
//    self.imageView.image =
    
    NSString *str = [NSString stringWithFormat:@"http://111.47.52.51:3000/lhkfood/Upload/Thumbs/%@",self.shop.shop_images];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed: @"foodexmaple"]];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    //    return [self.resultArray count];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    //如果是更新数数据，显示全部菜单
    if(_type == AddShopTypeUpdate)
    {
        return  10;

    }
    //如果不是更新数据，不显示美食和店铺的菜单
    else return 8;

}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    if(_type == AddShopTypeUpdate)
////    {
//        if([indexPath row] == 8 || [indexPath row] == 9)
//        {
////            UITableViewCell *cell = tableView
//        }
//    
//}



-(void) postImage:(UIImage *) image
{
/* ios中获取图片的方法有两种，一种是UIImageJPEGRepresentation ，一种是UIImagePNGRepresentation 前者获取到图片的数据量要比后者的小很多。。 */
//    UIImage *im = [UIImage imageNamed:@"color_blue"];//通过path图片路径获取图片
    NSData *data = UIImagePNGRepresentation(image);//获取图片数据
    NSMutableData *imageData = [NSMutableData dataWithData:data];//ASIFormDataRequest 的setPostBody 方法需求的为NSMutableData类型
    NSString * url = UpdateImage;
    ASIFormDataRequest *aRequest = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [aRequest setDelegate:self];//代理
    [aRequest setRequestMethod:@"POST"];
//    [aRequest setPostBody:imageData];
//    [aRequest addRequestHeader:@"Content-Type" value:@"multipart/form-data"];//这里的value值 需与服务器端 一致
    
    [aRequest addData:imageData withFileName:@"abc.png" andContentType:@"image/png" forKey:@"image"];

    [aRequest startAsynchronous];//开始。异步
//    [aRequest setDidFinishSelector:@selector(headPortraitSuccess)];//当成功后会自动触发 headPortraitSuccess 方法
//    [aRequest setDidFailSelector:@selector(headPortraitFail)];//如果失败会 自动触发 headPortraitFail 方法

}


-(void)headPortraitSuccess :(ASIHTTPRequest *)request
{
    //NSArray* result = nil;
    NSData *data =[request responseData];
    //     NSString* resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (data!=nil) {
        NSObject *resultArrary = [data objectFromJSONData];
        
        
        NSLog(@"%@",resultArrary);
        
//        if()
        
//        if ([_ respondsToSelector:@selector(proxyAuthenticationNeededForRequest:)]) {

        
        [SVProgressHUD dismissWithSuccess:@"保存成功"];
        //        [SVProgressHUD dismiss];
        
    }
    
}

-(void)headPortraitFail:(ASIHTTPRequest *)request
{
    
}


//检查输入信息
- (BOOL )check
{
    //检查输入信息的问题，有错误的内容保存在错误项error 字符串中
    return YES;
}


- (void)dataPost {
    
    
    //    ASIFormDataRequest
    
    NSString *query = ShopsAdd;
    NSString *strUrl = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strUrl];
    
    [SVProgressHUD show];
    
    NSLog(@"%@",url);
    
    self.asiFormDataRequest = [[ASIFormDataRequest alloc] initWithURL:url];
    
    //用户登录后，登录信息存储在NSUserDefaults中
    NSString * user_id = [[NSUserDefaults standardUserDefaults] stringForKey:@"user_id"];
    
    [self.asiFormDataRequest setPostValue:user_id forKey:@"user_id" ];
    NSString * name = self.shopname.text;
    [self.asiFormDataRequest setPostValue:name
                                   forKey:@"name" ];
    NSString * address = self.shopaddress.text;

    [self.asiFormDataRequest setPostValue:address forKey:@"address" ];
    NSString * open_from = self.starttime.text;

    [self.asiFormDataRequest setPostValue:open_from forKey:@"open_from" ];
    NSString * open_to = self.endtime.text;

    [self.asiFormDataRequest setPostValue:open_to forKey:@"open_to" ];
    NSString * avg_spend = self.avg_price.text;

    [self.asiFormDataRequest setPostValue:avg_spend forKey:@"avg_spend" ];
//    NSString * name = self.shopname.text;

    //图片上传需要再弄
    [self.asiFormDataRequest setPostValue:_imageStr forKey:@"images" ];
    [self.asiFormDataRequest setDelegate:self];
    [self.asiFormDataRequest startAsynchronous];
    
}



#pragma mark 表格操作

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_pickView remove];
    //选择了添加选择图片的处理
    if([indexPath row]  == 0)
    {
        [self chooseImage];
    }
//    else if([indexPath row] !=0)
//    {
//        return;
//    }
////    else if([indexPath row] != 0 || [indexPath row] != 2 || [indexPath row] != 5 || [indexPath row] !=6)
////    {
////        return;
////    }
    else if([indexPath row] == 2|| [indexPath  row]== 5 || [indexPath row] ==6)
    {
        _indexPath = indexPath;

        if([indexPath row] == 2)
        {
            NSArray *array=@[@[@"不限类别",@"中餐",@"西餐",@"饭店",@"茶馆",@"食品店",@"蛋糕店",@"特色饮食"]];
                  _pickView=[[ZHPickView alloc] initPickviewWithArray:array isHaveNavControler:NO];

        }
        else if([indexPath row] == 5 || [indexPath row] == 6)
        {
//            NSTimeInterval secondsPerDay = 24*60*60;
//            NSDate *tomorrow = [NSDate dateWithTimeIntervalSinceNow:secondsPerDay];
            NSDate *date = [[NSDate alloc] init];
            _pickView=[[ZHPickView alloc] initDatePickWithDate:date datePickerMode:UIDatePickerModeTime isHaveNavControler:NO];
        }
        _pickView.delegate = self;
        [_pickView show];
    }
    

}




//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    _indexPath=indexPath;
//    [_pickview remove];
//    UITableViewCell * cell=[self.tableView cellForRowAtIndexPath:indexPath];
//    if ([cell.textLabel.text isEqualToString:@"时间"]) {
//        NSDate *date=[NSDate dateWithTimeIntervalSinceNow:9000000];
//        _pickview=[[ZHPickView alloc] initDatePickWithDate:date datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
//    }else if ([cell.textLabel.text isEqualToString:@"通过数组创建"]) {
//        NSArray *array=@[@[@"1",@"小明",@"aa"],@[@"2",@"大黄",@"bb"],@[@"3",@"企鹅",@"cc"]];
//        _pickview=[[ZHPickView alloc] initPickviewWithArray:array isHaveNavControler:NO];
//    }else{
//        _pickview=[[ZHPickView alloc] initPickviewWithPlistName:cell.textLabel.text isHaveNavControler:NO];
//    }
//    _pickview.delegate=self;
//    
//    [_pickview show];
//    
//}


#pragma mark - Your actions


//- (void)requestFinished:(ASIHTTPRequest *)request;
//- (void)requestFailed:(ASIHTTPRequest *)request;

-(void) requestFailed:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
    
    NSLog(@"请求出错");
}

-(void) requestFinished:(ASIHTTPRequest *)request
{
    //NSArray* result = nil;
    NSData *data =[request responseData];
    //     NSString* resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (data!=nil) {
        NSObject *resultArrary = [data objectFromJSONData];
        
        NSLog(@"%@",resultArrary);
        
        
        [SVProgressHUD dismissWithSuccess:@"保存成功"];
//        [SVProgressHUD dismiss];
        
    }
    
}






#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    NSLog(@"%d",[sender tag]);

    //按下优惠cell
    if([sender tag] == 102)
    {
        MyOffeTableViewController *offeViewController = (MyOffeTableViewController *)  [segue destinationViewController];
        offeViewController.shopSearchSpec = [[ShopSearchSpec alloc]init];
        //设置shopid
        offeViewController.shopSearchSpec.shopid = [self.shop.shopid integerValue];
    }
    //按下美食cell
    else if ([sender tag]  == 101)
    {
        MyFoodTableViewController *foodViewController = (MyFoodTableViewController *) [segue destinationViewController];
        foodViewController.shopSearchSpec = [[ShopSearchSpec alloc] init];
        foodViewController.shopSearchSpec.shopid = [self.shop.shopid integerValue];
    }
    
    // Get the new view controller using .
    // Pass the selected object to the new view controller.
}


- (IBAction)insertPress:(id)sender {
    [self dataPost];
}



//下面是添加照片的代码
#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    
    // 将图片写入文件
    
    [imageData writeToFile:fullPath atomically:NO];
}

//bool isFullScreen
#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    _image = image;
    
    [self saveImage:image withName:@"currentImage.png"];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    
    _isFullScreen = NO;
    
//    [self.imagebutton setImage:savedImage forState:UIControlStateNormal];
    [self.imageView setImage:savedImage];
    
    self.imageView.tag = 100;
//    [self postImage:_image];
    _imageSet= [[LMImage alloc] init];
    _imageSet.delegate = self;
    [_imageSet saveImage:image];
    //显示进度条
    [SVProgressHUD show];
    
    
}

-(void)imageSet:(NSString *) str
{
    NSLog(@"test");
    if(![str isEqualToString:@"0"])
    {
        //存储店铺图片生成的地址
        _shop.shop_images = str;
    }
//    if(NSS)
    //隐藏显示
    [SVProgressHUD dismiss];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    _isFullScreen = !_isFullScreen;
    UITouch *touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInView:self.view];
    
    CGPoint imagePoint = self.imageView.frame.origin;
    //touchPoint.x ，touchPoint.y 就是触点的坐标
    
    // 触点在imageView内，点击imageView时 放大,再次点击时缩小
    if(imagePoint.x <= touchPoint.x && imagePoint.x +self.imageView.frame.size.width >=touchPoint.x && imagePoint.y <=  touchPoint.y && imagePoint.y+self.imageView.frame.size.height >= touchPoint.y)
    {
        // 设置图片放大动画
        [UIView beginAnimations:nil context:nil];
        // 动画时间
        [UIView setAnimationDuration:1];
        
        if (_isFullScreen) {
            // 放大尺寸
            
            self.imageView.frame = CGRectMake(0, 0, 320, 480);
        }
        else {
            // 缩小尺寸
            self.imageView.frame = CGRectMake(50, 65, 90, 115);
        }
        
        // commit动画
        [UIView commitAnimations];
        
    }
    
    
    
}

#pragma mark - actionsheet delegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 0:
                    // 取消
                    return;
                case 1:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                    
                case 2:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.allowsEditing = YES;
        
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
        
    }
}
- (IBAction)chooseImage:(id)sender {
    
    [self chooseImage];
    
}


-(void)chooseImage{
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
    }
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self.view];
}

#pragma mark ZhpickVIewDelegate

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    
    
    UITableViewCell * cell=[self.tableView cellForRowAtIndexPath:_indexPath];
    cell.detailTextLabel.text=resultString;
//    [self.tableView reloadData];
}



@end
