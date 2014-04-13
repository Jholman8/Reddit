//
//  DetailViewController.m
//  Homework
//
//  Created by Jacob Holman on 4/3/14.
//  Copyright (c) 2014 Jacob Holman. All rights reserved.
//

#import "MasterViewController.h"
#import "APIAccess.h"
#import "Reddit.h"
#import "DetailViewController.h"
NSString *const ApiBaseURL = @"http://www.reddit.com/.json?after=";

@interface DetailViewController ()
@property (nonatomic, strong) IBOutlet UIWebView *webView;
@end

@implementation DetailViewController{
ApiAccess *_api;
MBProgressHUD *_HUD;
NSDictionary *_apiJson;
NSMutableArray *_urlString;
id _jsonReturn;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	_reddit = [NSMutableArray array];
    _urlString = [NSMutableArray array];
    _api = [[ApiAccess alloc] init];
    _api.delegate = self;
    self.webView.delegate = self;
    [self toast];
    [self apiCall];
 
}

-(void)apiCall{
    [_api getDataFromURL:[NSString stringWithFormat:@"%@%@",ApiBaseURL,self.afterId]];
}


#pragma mark - API Delegate
-(void)apiDidReturnData:(NSData *)data{
    NSError *error;
    _jsonReturn = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (_jsonReturn != nil){
        if([_jsonReturn isKindOfClass:[NSDictionary class]]){
            NSDictionary *data = _jsonReturn[@"data"];
            NSArray *children = data[@"children"];
            for(NSDictionary *childDictionary in children){
              [_urlString  addObject:[[childDictionary objectForKey:@"data"]objectForKey:@"permalink"]];
            }
        }
    }
    //Make webcall
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.reddit.com/%@",_urlString[self.index]]]];
    [self.webView loadRequest:request];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_HUD removeFromSuperview];
}
-(void)apiFailedToReturnData:(NSString *)message
{
    NSLog(@"%@",message);
}
#pragma mark - Loading Toast
-(void)toast{
    _HUD =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _HUD.mode = MBProgressHUDModeCustomView;
    [_HUD  setLabelText:@"Loading Reddit Data"];
    [_HUD  setLabelFont:[UIFont systemFontOfSize:12]];
    [_HUD  show:YES];
    _HUD.delegate = self;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
