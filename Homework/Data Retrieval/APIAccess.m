//
//  APIAccess.m
//  Homework
//
//  Created by Jacob Holman on 4/3/14.
//  Copyright (c) 2014 Jacob Holman. All rights reserved.
//


#import "APIAccess.h"
#import "APIRequest.h"

#define CONTENT_TYPE @"ContentType"
#define JSON_CONTENT_TYPE @"application/json"
#define TIMEOUT_IN_SECONDS 20

typedef enum{
    HTTPGET,
    HTTPPOST,
    DOWNLOAD
}RequestType;

@implementation ApiAccess{
    dispatch_queue_t _backgroundQueue;
    ApiRequest *_apiRequest;
    RequestType _requestType;
    NSURLSession *_session;
    NSMutableURLRequest *_request;
    NSURL *_url;
    NSData *_reqestData;
    
}

-(instancetype)init{
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}

-(void)setUp{
    _apiRequest = [[ApiRequest alloc] init];
    _apiRequest.delegate = self;
    _backgroundQueue = dispatch_queue_create("api.fetch", NULL);
}


-(void)getDataFromURL:(NSString *)stringUrl{
    _requestType = HTTPGET;
    NSLog(@"Data Requested for url: %@", stringUrl);
    _url = [NSURL URLWithString:stringUrl];
    [self getData];
}

-(void)getData{
    [_apiRequest getDataFromApiUrl:_url];
}

#pragma mark - ApiRequestDelegate

-(void)apiRequestDidReturnData:(NSData *)data fromUrl:(NSURL *)url withResponse:(NSHTTPURLResponse *)response{
    NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
    NSLog(@"Response Code: %li", (long)[httpResp statusCode]);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (httpResp.statusCode == 200) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(apiDidReturnData:withResponse:)]) {
                [self.delegate apiDidReturnData:data withResponse:httpResp];
            }
            if ([self.delegate respondsToSelector:@selector(apiDidReturnData:)]) {
                [self.delegate apiDidReturnData:data];
            }
        });
        
    } else if(httpResp.statusCode == 415){
        // 415 is Bad API Key
        dispatch_async(dispatch_get_main_queue(), ^{
                    });
    } else if(httpResp.statusCode == 401){
        // 401 is if you need user name or login
        dispatch_async(dispatch_get_main_queue(), ^{
                               });
    } else if(httpResp.statusCode == 417){
        //result to big
        dispatch_async(dispatch_get_main_queue(), ^{
            
           
        });
    }
    
}
-(void)apiRequestFailedToReturnData:(NSError *)error{
    [self.delegate apiFailedToReturnData:@"Sorry but for some reason we are unable to retrieve the information you requested. :("];
}
#pragma mark - Caching
-(void)cacheData:(NSData*)data fromUrl:(NSString*)url withResponse:(NSHTTPURLResponse*)resp{
    
}
@end
