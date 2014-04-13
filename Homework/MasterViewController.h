//
//  MasterViewController.h
//  Homework
//
//  Created by Jacob Holman on 4/3/14.
//  Copyright (c) 2014 Jacob Holman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIAccess.h"
#import "MBProgressHUD.h"
@interface MasterViewController : UITableViewController <ApiAccessDelegate,MBProgressHUDDelegate>
@property (nonatomic, strong) NSMutableArray *reddit;

@end
