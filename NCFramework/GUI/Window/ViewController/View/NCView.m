//
//  NCView.m
//  NCursesLibrary
//
//  Created by Christer on 2014-06-13.
//  Copyright (c) 2014 None. All rights reserved.
//

#import "NCView.h"

@implementation NCView

- (id) init
{
    self = [super init];
    if(self) {
        self.frame = CGRectZero;
        self.subviews = [NSArray array];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [self init];
    if(self) {
        self.frame = frame;
    }
    return self;
}

- (void) addSubview:(NCView *)view
{
    self.subviews = [self.subviews arrayByAddingObject:view];
}

- (void) removeSubview:(NCView *)view
{
    NSMutableArray *tmp = [NSMutableArray arrayWithArray:self.subviews];
    [tmp removeObject:view];
    self.subviews = tmp;
}

- (void) drawRect:(CGRect)rect
        inContext:(NCRenderContext*)context
{
    if(!self.hidden)
    {
        if(self.backgroundColor) {
            [context drawRect:rect
                    withColor:self.backgroundColor];
        }
        for(NCView *view in self.subviews) {
            [view drawRect:view.frame
                 inContext:context];
        }
    }
}

- (CGRect) bounds
{
    return CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

@end
