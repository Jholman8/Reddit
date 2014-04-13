//
//  Reddit.h
//  Homework
//
//  Created by Jacob Holman on 4/4/14.
//  Copyright (c) 2014 Jacob Holman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Reddit : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *score;
@property (nonatomic, strong) NSString *photoUrl;
@property (nonatomic, strong) NSString *comments;
@property (nonatomic, assign) NSString *afterLink;
//Only one way to do this
//Factory class method to create new reddit objects
+(Reddit *)newRedditWithTitle:(NSString *)title score:(NSString *)score comments:(NSString *)comments afterLink:(NSString *)afterLink photoUrl:(NSString *)photoUrl;


@end
