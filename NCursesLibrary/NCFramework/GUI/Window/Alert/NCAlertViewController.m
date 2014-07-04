//
//  NCAlertViewController.m
//  NCursesLibrary
//
//  Created by Christer on 2014-06-19.
//  Copyright (c) 2014 None. All rights reserved.
//

#import "NCAlertViewController.h"
#import "NCAlertView.h"
#import "NCAlertView_Protected.h"
#import "NCApplication.h"
#import "NCWindow.h"

@implementation NCAlertViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(self.alertView) {
        [self.view addSubview:self.alertView];
    }
}

- (void)keyPress:(NCKey *)key
{
    if(self.alertView) {
        if([key isEqualTo:[NCKey NCKEY_ENTER]]) {
            [self.alertView select];
            [self done];
        } else if([key isEqualTo:[NCKey NCKEY_ARROW_LEFT]]) {
            [self.alertView moveLeft];
        } else if([key isEqualTo:[NCKey NCKEY_ARROW_RIGHT]]) {
            [self.alertView moveRight];
        }
    } else {
        [self done];
    }
}

- (void) done
{
    [[NCApplication sharedApplication] removeWindow:self.window];
}

@end
