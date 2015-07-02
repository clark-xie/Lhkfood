//
//  LMImage.h
//  Lhk-food
//
//  Created by 谢超 on 14/12/21.
//  Copyright (c) 2014年 huwei. All rights reserved.
//

#import <Foundation/Foundation.h>



@protocol LMImageDelegate <NSObject>

@optional

-(void)imageSet:(NSString *) str;

//// These are the default delegate methods for request status
//// You can use different ones by setting didStartSelector / didFinishSelector / didFailSelector
//- (void)requestStarted:(ASIHTTPRequest *)request;
//- (void)requestReceivedResponseHeaders:(ASIHTTPRequest *)request;
//- (void)requestFinished:(ASIHTTPRequest *)request;
//- (void)requestFailed:(ASIHTTPRequest *)request;
//
//// When a delegate implements this method, it is expected to process all incoming data itself
//// This means that responseData / responseString / downloadDestinationPath etc are ignored
//// You can have the request call a different method by setting didReceiveDataSelector
//- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data;
//
//// If a delegate implements one of these, it will be asked to supply credentials when none are available
//// The delegate can then either restart the request ([request retryUsingSuppliedCredentials]) once credentials have been set
//// or cancel it ([request cancelAuthentication])
//- (void)authenticationNeededForRequest:(ASIHTTPRequest *)request;
//- (void)proxyAuthenticationNeededForRequest:(ASIHTTPRequest *)request;

@end

@interface LMImage : NSObject<ASIHTTPRequestDelegate>

@property id <LMImageDelegate> delegate;

-(void) requestFailed:(ASIHTTPRequest *)request;
-(void) requestFinished:(ASIHTTPRequest *)request;

- (void) saveImage :(UIImage *) image;


@end
