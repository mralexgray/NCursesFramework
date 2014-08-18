//
//  NCColorRange.m
//  NCursesLibrary
//
//  Created by Christer on 2014-08-15.
//  Copyright (c) 2014 None. All rights reserved.
//

#import "NCColorRange.h"

@implementation NCColorRange
- (id)initWithForeground:(NCColor *)foreground
          withBackground:(NCColor *)background
               withRange:(NSRange)range
{
    self = [super init];
    if(self) {
        self.foreground = foreground;
        self.background = background;
        self.range = range;
    }
    return self;
}
@end
