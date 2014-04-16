//
//  MasterViewController.m
//  Homework
//
//  Created by Jacob Holman on 4/3/14.
//  Copyright (c) 2014 Jacob Holman. All rights reserved.
//

#import "MasterViewController.h"
#import "APIAccess.h"
#import "DetailViewController.h"
NSString *const ApiURL = @"http://www.reddit.com/.json";
NSString *const ApiBaseURL = @"http://www.reddit.com/.json?after=";
@interface MasterViewController ()
@property (nonatomic, strong) NSMutableArray *reddit;
@end

@implementation MasterViewController{
    ApiAccess *_api;
    NSString *afterIDString;
    NSMutableArray *_imageArray;
    MBProgressHUD *_HUD;
    id _jsonReturn;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _reddit = [NSMutableArray array];
    _imageArray = [NSMutableArray array];
    
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    
    // Configure Refresh Control
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    // Configure View Controller
    [self setRefreshControl:refreshControl];
    
    _api = [[ApiAccess alloc] init];
    _api.delegate = self;
    [self apiCall];
   
}
#pragma mark - API Call
-(void)apiCall{
    [self toast:@"Loading..."];
    [_api getDataFromURL:ApiURL];
   
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _reddit.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Reddit *reddit = _reddit[indexPath.row];
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.imageView.image = reddit.imaged;
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",reddit.title];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Score: %@ Comments:%@",reddit.score,reddit.num_comments];
    
        return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"DetailSegue" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //check when to load more data
    if (indexPath.row == _reddit.count-1) {
        [self infiniteLoad];
    }
}

#pragma mark - more content handler
-(void)infiniteLoad{
    if([afterIDString isEqualToString:@""]){
      [self toast:@"End of the Line"];
      double delayInSeconds = 3.0;
      dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
      dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
           [_HUD removeFromSuperview];
        });
      
    }
    else {
      [self toast:@"Loading..."];
      [_api getDataFromURL:[NSString stringWithFormat:@"%@%@",ApiBaseURL,afterIDString]];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}
#pragma mark - Refresh
- (void)refresh:(id)sender {
    NSLog(@"Refreshing");
    [self apiCall];
    // End Refreshing
    [(UIRefreshControl *)sender endRefreshing];
}

#pragma mark - API Delegate
-(void)apiDidReturnData:(NSData *)data{
    NSError *error;
     _jsonReturn = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
   
    if (_jsonReturn != nil){
        if([_jsonReturn isKindOfClass:[NSDictionary class]]){
            NSDictionary *data = _jsonReturn[@"data"];
            afterIDString = data[@"after"];
            NSArray *children = data[@"children"];
              for(NSDictionary *childDictionary in children){
            
                  Reddit *red = [[Reddit alloc] initWithDictionary:childDictionary[@"data"]];
                  NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                  if([UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:red.thumbnail]]] == nil){
                      [dict setObject:[UIImage imageNamed:@"placeHolder.png"] forKey:@"imaged"];
                  }else{
                  [dict setObject:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:red.thumbnail]]] forKey:@"imaged"];
                  }
                  [dict addEntriesFromDictionary:childDictionary[@"data"]];
                  red = [[Reddit alloc] initWithDictionary:dict];
                  
                  [_reddit addObject:red];
          }
       }
    }
    [_HUD removeFromSuperview];
    [self.tableView reloadData];
}

-(void)apiFailedToReturnData:(NSString *)message
{
    [_HUD removeFromSuperview];
    [self toast:@"Load Error Pull Down On Table To Retry"];
}



#pragma mark - Loading Toast
-(void)toast:(NSString *)message{
    //Love Toast!! Wheres the butter?!
    _HUD =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _HUD.mode = MBProgressHUDModeCustomView;
    [_HUD  setLabelText:message];
    [_HUD  setLabelFont:[UIFont systemFontOfSize:12]];
    [_HUD  show:YES];
    _HUD.delegate = self;
    
}


#pragma mark - segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"DetailSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Reddit *reddit = _reddit[indexPath.row];
        DetailViewController *cont = [segue destinationViewController];
        cont.reddit = reddit;
       
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
