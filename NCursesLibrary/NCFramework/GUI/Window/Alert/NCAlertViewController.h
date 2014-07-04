//
//  NCAlertViewController.h
//  NCursesLibrary
//
//  Created by Christer on 2014-06-19.
//  Copyright (c) 2014 None. All rights reserved.
//

#import "NCViewController.h"
@class NCAlertView;
@class NCWindow;

@interface NCAlertViewController : NCViewController

@property (nonatomic, strong) NCAlertView *alertView;
@property (nonatomic, strong) NCWindow *window;

@end
