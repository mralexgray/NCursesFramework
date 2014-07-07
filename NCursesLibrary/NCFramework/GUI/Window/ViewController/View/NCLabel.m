//
//  NCLabel.m
//  NCursesLibrary
//
//  Created by Christer on 2014-07-07.
//  Copyright (c) 2014 None. All rights reserved.
//

#import "NCLabel.h"

@implementation NCLabel

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        self.lineBreak = NCLineBreakByWordWrapping;
        self.lineAlignment = NCLineAlignmentLeft;
        self.lineTruncation = NCLineTruncationByClipping;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
       inContext:(NCRenderContext *)context
{
    if(!self.hidden && self.text) {
        [context drawText:self.text
                   inRect:rect
           withForeground:self.foregroundColor ? self.foregroundColor : [NCColor whiteColor]
           withBackground:self.backgroundColor ? self.backgroundColor : [NCColor blackColor]
                breakMode:self.lineBreak
             truncateMode:self.lineTruncation
            alignmentMode:self.lineAlignment];
    }
    
    [super drawRect:rect
          inContext:context];
}

@end
