//
//  FoodAddViewController.m
//  Lhk-food
//
//  Created by leadmap on 14/10/31.
//  Copyright (c) 2014年 leadmap. All rights reserved.
//

#import "FoodAddViewController.h"

@interface FoodAddViewController ()

@property BOOL isFullScreen;
@property Food *food;

@end

@implementation FoodAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //不显示后退按钮的标题
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    backItem.image=[UIImage imageNamed:@""];
    self.navigationItem.backBarButtonItem=backItem;
    self.food = [[Food alloc] init];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dataPost {
    
    
    //    ASIFormDataRequest
    
    
    //需要添加美食的关键字
    NSString *query = ShopsFoodsAdd(1);
    NSString *strUrl = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strUrl];
    
    [SVProgressHUD show];
    
    NSLog(@"%@",url);
    
    
    self.asiFormDataRequest = [[ASIFormDataRequest alloc] initWithURL:url];
    [self.asiFormDataRequest setPostValue:self.food.food_name forKey:@"food_name" ];
    [self.asiFormDataRequest setPostValue:self.food.desc forKey:@"food_desc" ];
    [self.asiFormDataRequest setPostValue:self.food.price forKey:@"food_price" ];
//    [self.asiFormDataRequest setPostValue:self.food.image forKey:@"food_images" ]; //image在这里应该使用列表类型，只存储图片的名称
    
    [self.asiFormDataRequest setDelegate:self];
    [self.asiFormDataRequest startAsynchronous];
    
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
        
    }
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //选择第一行时，加载图片
    if([indexPath row] == 0)
    {
        [self chooseImage];
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
    
    
    //使用代码添加一张图片
    CGRect rect =self.imageView.frame;
    CGFloat offset = self.imageView.frame.origin.x + self.imageView.frame.size.width + 10;
    CGRect r2 = CGRectOffset(rect, offset, 0);
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:r2];    //CGRectMake(50, 65, 90, 115);

    [imageView setImage:savedImage];
    [self.view addSubview:imageView];

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
    

    
}


-(void) chooseImage
{
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

- (IBAction)save:(id)sender {
    
    if(self.food == nil)
    {
        self.food = [[Food alloc] init];
    }
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *price = [f numberFromString:self.foodprice.text];
    
    self.food.price = price;
    self.food.food_name = self.foodname.text;
    self.food.desc = self.fooddesc.text;
    
    [self dataPost];
}
@end
