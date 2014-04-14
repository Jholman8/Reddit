//
//  Reddit.h
//  Homework
//
//  Created by Jacob Holman on 4/4/14.
//  Copyright (c) 2014 Jacob Holman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Reddit : NSObject
-(instancetype)initWithDictionary:(NSDictionary*)dictionary;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *score;
@property (nonatomic, strong) NSString *thumbnail;
@property (nonatomic, strong) NSString *num_comments;
@property (nonatomic, assign) NSString *after;
@property (nonatomic, assign) NSString *selftext;
@property (nonatomic, retain) UIImage *imaged;
@property (nonatomic, assign) BOOL is_self;

//Factory class method to create new reddit objects
+(Reddit *)newRedditWithTitle:(NSString *)title score:(NSString *)score comments:(NSString *)comments afterLink:(NSString *)afterLink photoUrl:(NSString *)photoUrl;
//Another Option to do this.

@end
