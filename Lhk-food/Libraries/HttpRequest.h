//
//  HttpRequest.h
//  Bus
//
//  Created by Tide Zhang on 11-5-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequestProtocol.h"
#import "ASINetworkQueue.h"

@interface HttpRequest : NSObject <ASIHTTPRequestDelegate>{
	id<HttpRequestDelegate> requestDelegate;
	ASINetworkQueue *networkQueue;
}

@property(nonatomic, assign) id<HttpRequestDelegate> requestDelegate;

+ (HttpRequest *)sharedRequest;
+ (void)releaseRequest;

// 发送下载书籍的请求
-(void)sendDownloadDatabaseRequest:(NSString *)srcPath desPath:(NSString *)desPath shiPath:(NSString*)shipath;

@end
