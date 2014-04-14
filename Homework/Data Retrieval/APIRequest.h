//
//  ApiRequest.h
//  Homework
//
//  Created by Jacob Holman on 4/3/14.
//  Copyright (c) 2014 Jacob Holman. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ApiRequestDelegate <NSObject>
-(void)apiRequestDidReturnData:(NSData *)data fromUrl:(NSURL *)url withResponse:(NSHTTPURLResponse*)response;
-(void)apiRequestFailedToReturnData:(NSError*)error;

@optional
-(void)apiRequestRecievedDownloadProgress:(double)percentComplete expectedSize:(NSInteger)expectedSize  ;


@end

@interface ApiRequest : NSObject <NSURLSessionDownloadDelegate>

@property (nonatomic, weak) id<ApiRequestDelegate> delegate;

-(void)getDataFromApiUrl:(NSURL*)url;

@end
