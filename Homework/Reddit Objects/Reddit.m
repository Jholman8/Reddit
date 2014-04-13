//
//  Reddit.m
//  Homework
//
//  Created by Jacob Holman on 4/4/14.
//  Copyright (c) 2014 Jacob Holman. All rights reserved.
//

#import "Reddit.h"

@implementation Reddit
+(Reddit *)newRedditWithTitle:(NSString *)title score:(NSString *)score comments:(NSString *)comments afterLink:(NSString *)afterLink photoUrl:(NSString *)photoUrl;
{
    Reddit *reddit = [[Reddit alloc] init];
    reddit.title = title;
    reddit.score = score;
    reddit.comments = comments;
    reddit.photoUrl = photoUrl;
    if(afterLink != nil){
    reddit.afterLink = afterLink;
    }else{
        afterLink = @"a";
        reddit.afterLink = afterLink;
    }
    return reddit;
}

@end
