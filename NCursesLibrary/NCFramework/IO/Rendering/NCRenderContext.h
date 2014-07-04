//
//  NCRenderContext.h
//  NCursesLibrary
//
//  Created by Christer on 2014-06-16.
//  Copyright (c) 2014 None. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NCColor.h"

typedef enum : NSUInteger {
    NCLineBreakByNoWrapping,
    NCLineBreakByWordWrapping,
    NCLineBreakByCharWrapping,
} NCLineBreakMode;

typedef enum : NSUInteger {
    NCLineTruncationByClipping,
    NCLineTruncationByTruncatingHead,
    NCLineTruncationByTruncationTail,
} NCLineTruncationMode;

typedef enum : NSUInteger {
    NCLineAlignmentLeft,
    NCLineAlignmentCenter,
    NCLineAlignmentRight,
} NCLineAlignment;

@interface NCRenderContext : NSObject

- (id) initWithSize:(CGSize)size;

- (void) drawText:(NSString*)text
           inRect:(CGRect)rect
   withForeground:(NCColor*)fcolor
   withBackground:(NCColor*)bcolor
        breakMode:(NCLineBreakMode)linebreak
     truncateMode:(NCLineTruncationMode)truncate
    alignmentMode:(NCLineAlignment)alignment;

- (CGSize) sizeOfText:(NSString*)text
            breakMode:(NCLineBreakMode)linebreak
                width:(int)width;

- (void) drawRect:(CGRect)rect
        withColor:(NCColor*)color;

- (void) drawPoint:(CGSize)point
    withForeground:(NCColor*)fcolor
    withBackground:(NCColor*)bcolor;

- (void) render;

@end
