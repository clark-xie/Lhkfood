//
//  HttpRequest.m
//  Bus
//
//  Created by Tide Zhang on 11-5-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HttpRequest.h"
#import "ASIHTTPRequest.h"
#import "ZipArchive.h"

// 定义URL, 以便将来更换服务器地址
#define BaseURL	@"http://27.17.60.3:8080/Mobile_Tiled_Zip/"
#define TimeOutSeconds 30

@interface HttpRequest(Private)

// 在主线程中通知外部程序，开始发送请求
- (void)connectionStartOnMain;

// 在主线程中通知外部程序，连接错误
- (void)connectionFailedOnMain:(id)arg;

// 队列完成下载，调用该方法
- (void)downloadFinishedProcess:(ASIHTTPRequest *)httpRequest;

@end

static HttpRequest * _instance;

@implementation HttpRequest
@synthesize requestDelegate;

+ (HttpRequest *)sharedRequest
{
	if (_instance == nil)
	{
		_instance = [[HttpRequest alloc] init];
	}
	
	return _instance;
}

+ (void)releaseRequest
{
	if (_instance)
	{
		[_instance release];
		_instance = nil;
	}
}

- (id)init
{
	if (self = [super init])
	{
		networkQueue = [[ASINetworkQueue alloc] init];
		[networkQueue setDelegate:self];
		[networkQueue setDownloadProgressDelegate:self];
		[networkQueue setShowAccurateProgress:YES];
		[networkQueue setQueueDidFinishSelector:@selector(downloadFinishedProcess:)];
	}
	
	return self;
}

// 发送下载数据库的请求
- (void)sendDownloadDatabaseRequest:(NSString *)srcPath desPath:(NSString *)desPath shiPath:(NSString*)shipath;
{
	NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@", BaseURL, srcPath];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

	NSURL *downloadURL = [NSURL URLWithString:urlString];
	
   
	//设置文件下载到的临时路径以及下载完成将文件后移到的路径
	ASIHTTPRequest *downRequest = [[ASIHTTPRequest alloc] initWithURL:downloadURL];
	[downRequest setDownloadDestinationPath:desPath];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *tempPath = [((NSString *)[paths objectAtIndex:0]) stringByAppendingPathComponent:@"temp"];
	[downRequest setTemporaryFileDownloadPath:tempPath];
    [downRequest setDownloadDestinationPath:shipath];
	[downRequest setAllowResumeForFileDownloads:YES];
	[downRequest setDelegate:self];
	[downRequest setDownloadProgressDelegate:self];
	
	[networkQueue addOperation:downRequest];
	[networkQueue go];
	
	[downRequest release];
}



- (void)connectionStartOnMain
{
	if ([requestDelegate respondsToSelector:@selector(connectionStart:)])
	{
		[requestDelegate connectionStart:self];
	}
}

- (void)connectionFailedOnMain:(id)arg
{
	if ([requestDelegate respondsToSelector:@selector(connectionFailed:error:)])
	{
		[requestDelegate connectionFailed:self error:arg];
	}
}

#pragma mark -
#pragma mark ASI Delegate Methods
// 队列完成下载，调用该方法
- (void)downloadFinishedProcess:(ASIHTTPRequest *)httpRequest
{
	if ([requestDelegate respondsToSelector:@selector(connectionDownloadFinished:)])
	{
		[requestDelegate connectionDownloadFinished:self];
	}
	
}

- (void)requestStarted:(ASIHTTPRequest *)request
{
	if ([requestDelegate respondsToSelector:@selector(connectionDownloadStart:)])
	{
		[requestDelegate connectionDownloadStart:self];
	}
}

- (void)setProgress:(float)newProgress
{
	if ([requestDelegate respondsToSelector:@selector(connectionDownloadUpdateProcess:process:)])
	{
		[requestDelegate connectionDownloadUpdateProcess:self process:newProgress];
	}
}

- (void)dealloc
{
	[networkQueue release];
	requestDelegate = nil;
	[super dealloc];
}


@end
