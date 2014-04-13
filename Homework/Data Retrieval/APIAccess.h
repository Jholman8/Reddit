//
//  APIAccess.h
//  Homework
//
//  Created by Jacob Holman on 4/3/14.
//  Copyright (c) 2014 Jacob Holman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiRequest.h"


@protocol ApiAccessDelegate <NSObject>
-(void)apiFailedToReturnData:(NSString *)message;

@optional
// Used when you are either making one call to the api and know the response type
-(void)apiDidReturnData:(NSData *)data;
// used when multiple calls are made using the api and the response type can be different
-(void)apiDidReturnData:(NSData *)data withResponse:(NSHTTPURLResponse*)response;
-(void)downloadProgressUpdatedTo:(double)progress;

@end


@interface ApiAccess : NSObject<NSURLSessionDelegate, ApiRequestDelegate, UIAlertViewDelegate>
-(void)getDataFromURL:(NSString*)url;
@property (nonatomic, weak) id<ApiAccessDelegate> delegate;


@end
