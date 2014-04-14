//
//  Reddit.m
//  Homework
//
//  Created by Jacob Holman on 4/4/14.
//  Copyright (c) 2014 Jacob Holman. All rights reserved.
//

#import "Reddit.h"

@implementation Reddit

//One way of doing it.
-(instancetype)initWithDictionary:(NSDictionary*)dictionary{
    self = [super init];
    
    if (self) {
        
        if (dictionary != nil) {
            [self setValuesForKeysWithDictionary:dictionary];
            
        }
        
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
   //  NSLog(@"Key %@ not found", key);
}

//another way of doing it.
+(Reddit *)newRedditWithTitle:(NSString *)title score:(NSString *)score comments:(NSString *)comments afterLink:(NSString *)afterLink photoUrl:(NSString *)photoUrl;
{
    NSLog(@"FACOTRY");
    Reddit *reddit = [[Reddit alloc] init];
    reddit.title = title;
    reddit.score = score;
    reddit.num_comments = comments;
    reddit.thumbnail = photoUrl;
    if(afterLink != nil){
    reddit.after = afterLink;
    }else{
        afterLink = @"";
        reddit.after = afterLink;
    }
    return reddit;
}

@end
