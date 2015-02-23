//
//  NCViewController.m
//  NCursesLibrary
//
//  Created by Christer on 2014-06-13.
//  Copyright (c) 2014 None. All rights reserved.
//

#import "NCViewController.h"

@implementation NCViewController

- (id) init
{
    self = [super init];
    if(self) {
        _view = [[NCView alloc] init];
        [_view setFrame:CGRectZero];
    }
    return self;
}

- (void) viewDidLoad
{
    self.didLoad = YES;
}

- (void) viewDidAppear
{

}

- (void) viewDidDissapear
{

}

- (void)keyPress:(NCKey *)key
{
    
}

@end
