//
//  NCScreen.m
//  NCursesLibrary
//
//  Created by Christer on 2014-06-13.
//  Copyright (c) 2014 None. All rights reserved.
//

#import "NCScreen.h"
#import <sys/ioctl.h>
#import <stdio.h>
#import <unistd.h>
#import <curses.h>

@implementation NCScreen

- (id) init
{
    self = [super init];
    if(self) {
    }
    return self;
}

static NCScreen *instance = nil;
+ (NCScreen*) sharedInstance
{
    if(!instance) {
        instance = [[NCScreen alloc] init];
    }
    return instance;
}

+ (CGRect) bounds
{
    struct winsize w;
    ioctl(STDOUT_FILENO, TIOCGWINSZ, &w);
    return CGRectMake(0, 0, w.ws_col, w.ws_row);
}

@end
