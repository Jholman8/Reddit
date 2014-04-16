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
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *score;
@property (nonatomic, retain) NSString *thumbnail;
@property (nonatomic, retain) NSString *num_comments;
@property (nonatomic, retain) NSString *after;
@property (nonatomic, retain) NSString *selftext;
@property (nonatomic, retain) UIImage *imaged;
@property (nonatomic, assign) BOOL is_self;

//Factory class method to create new reddit objects
+(Reddit *)newRedditWithTitle:(NSString *)title score:(NSString *)score comments:(NSString *)comments afterLink:(NSString *)afterLink photoUrl:(NSString *)photoUrl;
//Another Option to do this.

@end
