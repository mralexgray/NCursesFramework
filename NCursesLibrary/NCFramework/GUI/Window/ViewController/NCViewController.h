//
//  NCViewController.h
//  NCursesLibrary
//
//  Created by Christer on 2014-06-13.
//  Copyright (c) 2014 None. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NCNavigationController;
#import "NCView.h"
#import "NCKey.h"

@interface NCViewController : NSObject

@property (nonatomic, strong) NCView *view;
@property (nonatomic, strong) NCNavigationController *navigationController;
@property (nonatomic, assign) BOOL didLoad;

- (void) viewDidLoad;
- (void) viewDidAppear;
- (void) viewDidDissapear;

- (void) keyPress:(NCKey*)key;

@end
