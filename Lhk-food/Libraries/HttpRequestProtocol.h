//
//  HttpRequestProtocol.h
//  Bus
//
//  Created by Tide Zhang on 11-5-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@class HttpRequest;


@protocol HttpRequestDelegate<NSObject>
@optional

// 开始发送请求通知外部程序
- (void)connectionStart:(HttpRequest *)request;

// 连接错误通知外部程序
- (void)connectionFailed:(HttpRequest *)request error:(NSError *)error;

// 开始下载，通知外部程序
- (void)connectionDownloadStart:(HttpRequest *)request;

// 下载结束，通知外部程序
- (void)connectionDownloadFinished:(HttpRequest *)request;

// 更新下载进度，通知外部程序
- (void)connectionDownloadUpdateProcess:(HttpRequest *)request process:(CGFloat)process;


@end
