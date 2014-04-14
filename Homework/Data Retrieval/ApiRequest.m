//
//  ApiRequest.m
//  Homework
//
//  Created by Jacob Holman on 4/3/14.
//  Copyright (c) 2014 Jacob Holman. All rights reserved.
//

#import "ApiRequest.h"

#define CONTENT_TYPE @"ContentType"
#define JSON_CONTENT_TYPE @"application/json"
#define TIMEOUT_IN_SECONDS 20
@implementation ApiRequest{
    NSURLSession *_session;
}

-(instancetype)init{
    if (self = [super init]) {
        [self createSession];
    }
    return self;
}
-(void)createSession{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.HTTPMaximumConnectionsPerHost = 1;
    _session = [NSURLSession sessionWithConfiguration:config
                                            delegate:self
                                       delegateQueue:nil];
}
-(void)getDataFromApiUrl:(NSURL *)url{
    if (!_session) {
        [self createSession];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSLog(@"Getting data for url: %@", url);
    NSURLSessionDataTask *task = [_session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            NSLog(@"Data returned for url: %@", url);
            [self.delegate apiRequestDidReturnData:data fromUrl:url withResponse:httpResp];
        }else {
            // ALWAYS HANDLE ERRORS :-] //
            [self.delegate apiRequestFailedToReturnData:error];
        }
        // 4
    }];
    [task resume];
}

-(void)postData:(NSData *)data toApiUrl:(NSURL *)url{
    if (!_session) {
        [self createSession];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSMutableURLRequest *upLoadRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [upLoadRequest setHTTPMethod:@"POST"];
    NSLog(@"Getting data for url: %@", url);
    NSURLSessionUploadTask *task = [_session uploadTaskWithRequest:upLoadRequest fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if (!error) {
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*)response;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [self.delegate apiRequestDidReturnData:data fromUrl:url withResponse:httpResp];
        }else{
            [self.delegate apiRequestFailedToReturnData:error];
        }
    }];
    [task resume];
    
}
-(void)downloadDataFromUrl:(NSURL *)url{
    if (!_session) {
        [self createSession];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURLSessionDownloadTask *task = [_session downloadTaskWithURL:url];
    
    [task resume];
}
#pragma mark - Download Delegate methods
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    
}
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes{
    
    
}
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    
    if ([self.delegate respondsToSelector:@selector(apiRequestRecievedDownloadProgress:expectedSize:)]) {
        double expectedSize = totalBytesExpectedToWrite;
        double currentProgress = totalBytesWritten / totalBytesExpectedToWrite;
        [self.delegate apiRequestRecievedDownloadProgress:currentProgress expectedSize:expectedSize];
    }
    
}

@end
