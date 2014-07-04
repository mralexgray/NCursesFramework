//
//  NCRenderContext.m
//  NCursesLibrary
//
//  Created by Christer on 2014-06-16.
//  Copyright (c) 2014 None. All rights reserved.
//

#import "NCRenderContext.h"
#import "NCRender.h"
#import <curses.h>

@interface NCRenderContext ()
@property (nonatomic, strong) NSMutableArray *matrix;
@property (nonatomic, assign) CGSize size;
@end

@implementation NCRenderContext

- (id) initWithSize:(CGSize)size
{
    self = [super init];
    if(self) {
        self.size = size;
        self.matrix = [NSMutableArray array];
        for(int x = 0; x < size.width; x++) {
            NSMutableArray *col = [NSMutableArray array];
            for(int y = 0; y < size.height; y++) {
                [col addObject:[[NCRender alloc] init]];
            }
            [self.matrix addObject:col];
        }
    }
    return self;
}

- (void) drawText:(NSString*)text
           inRect:(CGRect)rect
   withForeground:(NCColor*)fcolor
   withBackground:(NCColor*)bcolor
        breakMode:(NCLineBreakMode)linebreak
     truncateMode:(NCLineTruncationMode)truncate
    alignmentMode:(NCLineAlignment)alignment
{
#ifdef USE_CURSES
    NSArray *lines = [self lineBreakAndTruncate:text
                                         inRect:rect
                                      lineBreak:linebreak
                                      truncMode:truncate];
    
    for(int y = 0; lines && y < lines.count; y++) {
        NSString *text = [lines objectAtIndex:y];
        for(int x = 0; x < text.length; x++) {
            char c = [text characterAtIndex:x];
            if(rect.origin.x + x >= 0 && rect.origin.x + x < self.size.width &&
               rect.origin.y + y >= 0 && rect.origin.y + y < self.size.height) {
                
                int xOffset = 0;
                if(alignment == NCLineAlignmentRight && text.length < rect.size.width) {
                    xOffset = rect.size.width - text.length;
                } else if(alignment == NCLineAlignmentCenter) {
                    xOffset = (rect.size.width - text.length) / 2;
                }
                
                NCRender *render = [[self.matrix objectAtIndex:rect.origin.x + x + xOffset] objectAtIndex:rect.origin.y + y];
                render.character = c;
                if(fcolor && ![fcolor isEqual:[NCColor clearColor]]) {
                    render.foregroundColor = fcolor;
                }
                if(bcolor && ![bcolor isEqual:[NCColor clearColor]]) {
                    render.backgroundColor = bcolor;
                }
            } else {
                break;
            }
        }
    }
#endif
}

- (CGSize) sizeOfText:(NSString*)text
            breakMode:(NCLineBreakMode)linebreak
                width:(int)width
{
    NSArray *lines = [self lineBreakText:text
                                  inRect:CGRectMake(0, 0, width, NSIntegerMax)
                                withMode:linebreak];
    NSUInteger w = 0;
    for(NSString *line in lines) {
        if(w < line.length) {
            w = line.length;
        }
    }
    return CGSizeMake(w, lines.count);
}

- (NSArray*) lineBreakAndTruncate:(NSString*)text
                           inRect:(CGRect)rect
                        lineBreak:(NCLineBreakMode)lineMode
                        truncMode:(NCLineTruncationMode)trucMode
{
    NSMutableArray *lines = [NSMutableArray arrayWithArray:[self lineBreakText:text
                                                                        inRect:rect withMode:lineMode]];
    for(int i = 0; i < lines.count; i++) {
        NSString *line = [lines objectAtIndex:i];
        [lines replaceObjectAtIndex:i withObject:[self truncateText:line
                                                             inRect:rect
                                                           withMode:trucMode]];
    }
    return lines;
}

- (NSString*) truncateText:(NSString*)text
                   inRect:(CGRect)rect
                 withMode:(NCLineTruncationMode)mode
{
    if(text && text.length > rect.size.width) {
        if(mode == NCLineTruncationByClipping)
        {
            text = [text substringToIndex:rect.size.width];
        }
        else if(mode == NCLineTruncationByTruncatingHead)
        {
            text = [NSString stringWithFormat:@"...%@",[text substringFromIndex:3]];
            text = [text substringToIndex:rect.size.width];
        }
        else if(mode == NCLineTruncationByTruncationTail)
        {
            text = [NSString stringWithFormat:@"%@...",[text substringToIndex:rect.size.width-3]];
        }
    }
    return text;
}

- (NSArray*) lineBreakText:(NSString*)text
                    inRect:(CGRect)rect
                  withMode:(NCLineBreakMode)mode
{
    NSMutableArray *preWrapping = [NSMutableArray arrayWithArray:[text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"]]];
    
    if(mode == NCLineBreakByNoWrapping) {
        return preWrapping;
    }
    
    NSMutableArray *lines = [NSMutableArray array];
    
    for(NSString *t in preWrapping)
    {
        NSString *text = t;
        while(text.length > 0 && lines.count < rect.size.height)
        {
            int maxPossibleLength = MIN(text.length, rect.size.width);
            
            if(mode == NCLineBreakByCharWrapping)
            {
                [lines addObject:[text substringToIndex:maxPossibleLength]];
                text = [text substringFromIndex:maxPossibleLength];
            }
            else if(mode == NCLineBreakByWordWrapping)
            {
                if(maxPossibleLength == text.length) {
                    [lines addObject:text];
                    text = @"";
                } else {
                    if(!isblank([text characterAtIndex:maxPossibleLength-1]) && !isblank([text characterAtIndex:maxPossibleLength])) {
                        int wordS = maxPossibleLength-1;
                        int wordL = 0;
                        for(int i = maxPossibleLength-1; i >= 0; i--) {
                            char c = [text characterAtIndex:i];
                            if(isblank(c)) {
                                break;
                            } else {
                                wordS = i;
                            }
                        }
                        for(int i = wordS; i < text.length; i++) {
                            char c = [text characterAtIndex:i];
                            wordL++;
                            if(isblank(c)) {
                                break;
                            }
                        }
                        if(wordL > rect.size.width) {
                            [lines addObject:[text substringToIndex:maxPossibleLength]];
                            text = [text substringFromIndex:maxPossibleLength];
                        } else {
                            [lines addObject:[text substringToIndex:wordS]];
                            text = [text substringFromIndex:wordS];
                        }
                        
                    } else {
                        [lines addObject:[text substringToIndex:maxPossibleLength]];
                        text = [text substringFromIndex:maxPossibleLength];
                    }
                }
            }
        }
    }
    
    return lines;
}

- (void) drawRect:(CGRect)rect
        withColor:(NCColor*)color
{
#ifdef USE_CURSES
    for(int x = rect.origin.x; x < rect.origin.x + rect.size.width; x++) {
        for(int y = rect.origin.y; y < rect.origin.y + rect.size.height; y++) {
            if(x >= 0 && x < self.size.width && y >= 0 && y < self.size.height) {
                NCRender *render = [[self.matrix objectAtIndex:x] objectAtIndex:y];
                render.backgroundColor = color;
            }
        }
    }
#endif
}

- (void)drawPoint:(CGSize)point
   withForeground:(NCColor *)fcolor
   withBackground:(NCColor *)bcolor
{
    if(point.width >= 0 && point.width < self.size.width &&
       point.height >= 0 && point.height < self.size.height) {
        NCRender *render = [[self.matrix objectAtIndex:point.width] objectAtIndex:point.height];
        if(fcolor && ![fcolor isEqual:[NCColor clearColor]]) {
            render.foregroundColor = fcolor;
        }
        if(bcolor && ![bcolor isEqual:[NCColor clearColor]]) {
            render.backgroundColor = bcolor;
        }
    }
}

- (void) render
{
    for(int x = 0; x < self.size.width; x++) {
        for(int y = 0; y < self.size.height; y++) {
            NCRender *render = [[self.matrix objectAtIndex:x] objectAtIndex:y];
            [render renderAt:CGSizeMake(x, y)];
        }
    }
    refresh();
}


@end
