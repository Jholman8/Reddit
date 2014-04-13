//
//  MasterViewController.m
//  Homework
//
//  Created by Jacob Holman on 4/3/14.
//  Copyright (c) 2014 Jacob Holman. All rights reserved.
//
#import "Reddit.h"
#import "MasterViewController.h"
#import "APIAccess.h"
#import "DetailViewController.h"
NSString *const ApiURL = @"http://www.reddit.com/.json";

@interface MasterViewController ()
@end

@implementation MasterViewController{
    ApiAccess *_api;
    MBProgressHUD *_HUD;
    NSDictionary *_apiJson;
    id _jsonReturn;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _reddit = [NSMutableArray array];
    
    [self toast:@"Loading Reddit"];
    
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
    [_api getDataFromURL:ApiURL];
    [self.tableView reloadData];
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
    
    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:reddit.photoUrl]]];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Title: %@",reddit.title];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Score: %@ Comments:%@",reddit.score,reddit.comments];
    
        return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"DetailSegue" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
            NSArray *children = data[@"children"];
              for(NSDictionary *childDictionary in children){
                  [_reddit addObject:[Reddit newRedditWithTitle:[[childDictionary objectForKey:@"data"]objectForKey:@"title"] score:[[childDictionary objectForKey:@"data"]objectForKey:@"score"] comments:[[childDictionary objectForKey:@"data"]objectForKey:@"num_comments"] afterLink:[[childDictionary objectForKey:@"data"]objectForKey:@"id"] photoUrl:[[childDictionary objectForKey:@"data"]objectForKey:@"thumbnail"]]];
          }
        }
    }
    [_HUD removeFromSuperview];
    [self.tableView reloadData];
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

-(void)apiFailedToReturnData:(NSString *)message
{
    [self toast:@"API Failed To Return Data"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"DetailSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Reddit *reddit = _reddit[indexPath.row];
        DetailViewController *cont = [segue destinationViewController];
        cont.afterId = reddit.afterLink;
        cont.index = indexPath.row;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
