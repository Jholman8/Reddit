//
//  DetailViewController.h
//  Homework
//
//  Created by Jacob Holman on 4/3/14.
//  Copyright (c) 2014 Jacob Holman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface DetailViewController : UIViewController <MBProgressHUDDelegate,UIWebViewDelegate>

@property (strong, nonatomic) Reddit *reddit;


@end
