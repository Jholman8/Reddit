//
//  DetailViewController.h
//  Homework
//
//  Created by Jacob Holman on 4/3/14.
//  Copyright (c) 2014 Jacob Holman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIAccess.h"
#import "MBProgressHUD.h"
@interface DetailViewController : UIViewController <ApiAccessDelegate,MBProgressHUDDelegate,UIWebViewDelegate>

@property (strong, nonatomic) NSString *afterId;
@property (nonatomic) NSInteger index;
@property (nonatomic, strong) NSMutableArray *reddit;
@end
