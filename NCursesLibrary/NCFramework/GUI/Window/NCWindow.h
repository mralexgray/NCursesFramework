//
//  NCWindow.h
//  NCursesLibrary
//
//  Created by Christer on 2014-06-13.
//  Copyright (c) 2014 None. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NCViewController.h"

@interface NCWindow : NSObject

- (id) initWithFrame:(CGRect)frame;
- (void) keyPress:(NCKey *)key;
- (void) draw;

@property (nonatomic, strong) NCViewController *rootViewController;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign, readonly) CGRect bounds;

@end
