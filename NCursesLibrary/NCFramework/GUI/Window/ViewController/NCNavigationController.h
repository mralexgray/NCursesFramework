//
//  NCNavigationController.h
//  NCursesLibrary
//
//  Created by Christer on 2014-06-18.
//  Copyright (c) 2014 None. All rights reserved.
//

#import "NCViewController.h"

@interface NCNavigationController : NCViewController

- (id) initWithRootViewController:(NCViewController*)rootViewController;

- (void) setRootViewController:(NCViewController*)rootViewController;

- (void) popViewController;

- (void) pushViewController:(NCViewController*)viewController;

@end
