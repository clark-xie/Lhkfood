//
//  AddShopViewController.m
//  Lhk-food
//
//  Created by 谢超 on 14/10/31.
//  Copyright (c) 2014年 huwei. All rights reserved.
//

#import "AddShopViewController.h"

@interface AddShopViewController ()
@property BOOL isFullScreen;

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
    //    self.shopType.text = self.shopType
    self.shopphone.text = self.shop.phone;
    self.starttime.text = [Helper stringFromDate: self.shop.open_from];
    self.endtime.text = [Helper stringFromDate: self.shop.opent_to];
    self.avg_price.text = [NSString stringWithFormat:@"%.2f",[self.shop.avg_spend  floatValue]];
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

    


- (void)dataPost {
    
    
    //    ASIFormDataRequest
    
    NSString *query = ShopsAdd;
    NSString *strUrl = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strUrl];
    
    [SVProgressHUD show];
    
    NSLog(@"%@",url);
    
//    user_id
//    name
//    desc
//    address
//    phone
//    open_from
//    open_to
//    avg_spend
//    images

    
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
    [self.asiFormDataRequest setPostValue:@"abc" forKey:@"images" ];
    [self.asiFormDataRequest setDelegate:self];
    [self.asiFormDataRequest startAsynchronous];
    
}



#pragma mark 表格操作

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //选择了添加选择图片的处理
    if([indexPath row]  == 0)
    {
        [self chooseImage];
    }
}


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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    
    [self saveImage:image withName:@"currentImage.png"];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    
    _isFullScreen = NO;
    
//    [self.imagebutton setImage:savedImage forState:UIControlStateNormal];
    [self.imageView setImage:savedImage];
    
    self.imageView.tag = 100;
    
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

@end
