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


@interface DetailViewController ()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UITextView *selfTextTextView;

@end

@implementation DetailViewController{
MBProgressHUD *_HUD;
UIImageView *_imageView;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.titleLabel.text = self.reddit.title;
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.titleLabel.frame.origin.y+10, self.reddit.imaged.size.width, self.reddit.imaged.size.height)];
    [_imageView setImage:self.reddit.imaged];
    [self.view addSubview:_imageView];

    if(self.reddit.imaged == [UIImage imageNamed:@"placeHolder.png"] ){
        CGRect frame = self.titleLabel.frame;
        frame.origin.x += -50;
        self.titleLabel.frame = frame;
    }
    self.infoLabel.text = [NSString stringWithFormat:@"Score: %@ Comments:%@",self.reddit.score,self.reddit.num_comments];
    
    
    
    if(self.reddit.is_self == YES){
        self.selfTextTextView.text = self.reddit.selftext;
    }else{
        self.selfTextTextView.text = @"No More Available Content.";
    }
    [_HUD removeFromSuperview];


}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
 
}


- (void)configureView{
  
    
    
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
