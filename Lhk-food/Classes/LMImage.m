//
//  LMImage.m
//  Lhk-food
//
//  Created by 谢超 on 14/12/21.
//  Copyright (c) 2014年 huwei. All rights reserved.
//

#import "LMImage.h"


@interface LMImage()
//@property ASIHTTPRequest * asiFormDataRequest;
@end

@implementation LMImage

- (void) saveImage :(UIImage *) image{
    
    
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
}


#pragma mark - Your actions


//- (void)requestFinished:(ASIHTTPRequest *)request;
//- (void)requestFailed:(ASIHTTPRequest *)request;

-(void) requestFailed:(ASIHTTPRequest *)request
{
    //    [SVProgressHUD dismiss];
    
    NSLog(@"请求出错");
}

-(void) requestFinished:(ASIHTTPRequest *)request
{
    //NSArray* result = nil;
    NSData *data =[request responseData];
    //     NSString* resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSError *error;
    if (data!=nil) {
        //初始imagePath 为空
        NSString *imagePath =@"";
        
        //if ([authenticationDelegate respondsToSelector:@selector(proxyAuthenticationNeededForRequest:)]) {

        NSDictionary *resultDic = [data objectFromJSONData];
        
        NSInteger code = [[resultDic objectForKey:@"code"] integerValue];
        
        if(code != 0) //code !=0是不正常的代码
        {
            
        }
        else {
        
            NSArray *array = [resultDic objectForKey:@"detail"];
            
            if([array count] >0)
            {
                //        "detail"
                //只有一张照片
                imagePath = [array objectAtIndex:0];
                if( [_delegate respondsToSelector:@selector(imageSet:) ])
                {
                    //设置delegate
                    [_delegate imageSet:imagePath];
                }
            }
        }
        
    }
    
}


@end
