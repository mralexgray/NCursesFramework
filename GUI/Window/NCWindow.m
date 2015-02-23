//
//  NCWindow.m
//  NCursesLibrary
//
//  Created by Christer on 2014-06-13.
//  Copyright (c) 2014 None. All rights reserved.
//

#import "NCWindow.h"
#import "NCRenderContext.h"
#import "NCScreen.h"

@implementation NCWindow

- (id) initWithFrame:(CGRect)frame
{
    self = [super init];
    if(self) {
        self.frame = frame;
    }
    return self;
}

- (CGRect) bounds
{
    return CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (void) setRootViewController:(NCViewController *)rootViewController
{
    _rootViewController = rootViewController;
    if(CGRectIsEmpty(_rootViewController.view.frame)) {
        _rootViewController.view.frame = self.bounds;
    }
    [_rootViewController viewDidLoad];
    [self draw];
    [_rootViewController viewDidAppear];
}

- (void)keyPress:(NCKey *)key
{
    if(_rootViewController) {
        [_rootViewController keyPress:key];
    }
}

- (void) draw
{
    if(_rootViewController.view) {
        NCRenderContext *context = [[NCRenderContext alloc] initWithSize:[NCScreen bounds].size];
        [_rootViewController.view drawRect:_rootViewController.view.frame
                                 inContext:context];
        [context render];
    }
}

@end
