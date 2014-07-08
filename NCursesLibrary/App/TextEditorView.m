//
//  TextEditorView.m
//  NCursesLibrary
//
//  Created by Christer on 2014-06-22.
//  Copyright (c) 2014 None. All rights reserved.
//

#import "TextEditorView.h"

@interface TextEditorView ()
@property (nonatomic, strong) FileBuffer *buffer;
@end

@implementation TextEditorView

- (void)moveLeft
{
    if(self.buffer.cursorOffsetX > 0) {
        self.buffer.cursorOffsetX--;
        self.buffer.cursorLineX = self.buffer.cursorOffsetX;
    } else if(self.buffer.cursorLineY > 0) {
        NSString *line = [self textOnLine:self.buffer.cursorLineY-1];
        if(line) {
            self.buffer.cursorLineX = (int)line.length;
        } else {
            self.buffer.cursorLineX = 0;
        }
        [self moveUp];
    }
}

- (void)moveUp
{
    if(self.buffer.cursorOffsetY > 0)
    {
        self.buffer.cursorOffsetY--;
        self.buffer.cursorLineY--;
    }
    else if(self.buffer.screenOffsetY > 0)
    {
        self.buffer.cursorLineY--;
        self.buffer.screenOffsetY--;
    }
    
    NSString *line = [self textOnLine:self.buffer.cursorLineY];
    if(line) {
        self.buffer.cursorOffsetX = MIN((int)line.length, self.buffer.cursorLineX);
    } else {
        self.buffer.cursorOffsetX = 0;
    }
}

- (void)moveRight
{
    NSString *line = [self textOnLine:self.buffer.cursorLineY];
    if(line && self.buffer.cursorOffsetX + 1 < line.length + 1) {
        self.buffer.cursorOffsetX++;
        self.buffer.cursorLineX = self.buffer.cursorOffsetX;
    }
    else if(self.buffer.cursorLineY+1 < self.buffer.lines.count) {
        self.buffer.cursorLineX = 0;
        [self moveDown];
    }
}

- (void)moveDown
{
    if(self.buffer.cursorOffsetY + 1 < MIN(self.frame.size.height, (int)self.buffer.lines.count-1))
    {
        self.buffer.cursorOffsetY++;
        self.buffer.cursorLineY++;
    }
    else if(self.buffer.cursorLineY + 1 < (int)self.buffer.lines.count-1)
    {
        self.buffer.cursorLineY++;
        self.buffer.screenOffsetY++;
    }
    
    NSString *line = [self textOnLine:self.buffer.cursorLineY];
    if(line) {
        self.buffer.cursorOffsetX = MIN((int)line.length, self.buffer.cursorLineX);
    } else {
        self.buffer.cursorOffsetX = 0;
    }
}

- (void)backspace
{
    NSMutableString *line = [self textOnLine:self.buffer.cursorLineY];
    if(line) {
        if(line.length > 0) {
            if(self.buffer.cursorOffsetX - 1 >= 0) {
                [line deleteCharactersInRange:NSMakeRange(self.buffer.cursorOffsetX-1, 1)];
                [self moveLeft];
            } else {
                if(self.buffer.cursorLineY > 0) {
                    NSMutableString *lineAbove = [self textOnLine:self.buffer.cursorLineY - 1];
                    self.buffer.cursorLineX = (int)lineAbove.length;
                    [lineAbove appendString:line];
                    [self moveUp];
                    [self.buffer.lines removeObject:line];
                }
            }
        } else {
            [self moveUp];
            [self.buffer.lines removeObject:line];
        }
    }
}

- (void)addNewLine
{
    NSMutableString *line = [self textOnLine:self.buffer.cursorLineY];
    if(line) {
        NSString *rightSideOfCursor = [line substringFromIndex:self.buffer.cursorOffsetX];
        NSMutableString *toAdd = [NSMutableString stringWithString:rightSideOfCursor];
        [line deleteCharactersInRange:NSMakeRange(self.buffer.cursorOffsetX, line.length - self.buffer.cursorOffsetX)];
        [self.buffer.lines insertObject:toAdd atIndex:self.buffer.cursorLineY+1];
        self.buffer.cursorLineX = 0;
        [self moveDown];
    }
}

- (void)addCharacter:(char)character
{
    NSMutableString *line = [self textOnLine:self.buffer.cursorLineY];
    if(line) {
        [line insertString:[NSString stringWithFormat:@"%c",character] atIndex:self.buffer.cursorOffsetX];
        [self moveRight];
    }
}

- (void)openBuffer:(FileBuffer *)buffer
{
    self.buffer = buffer;
}

- (BOOL) bufferIsOpen
{
    return self.buffer != nil;
}

- (BOOL) bufferIsEmpty
{
    return !self.buffer.lines || self.buffer.lines.count == 0;
}

- (void) drawRect:(CGRect)rect
        inContext:(NCRenderContext *)context
{
    if(!self.hidden) {
        if([self bufferIsOpen]) {
            if(![self bufferIsEmpty]) {
                int y = 0;
                for(int i = self.buffer.screenOffsetY; i < self.buffer.lines.count; i++) {
                    NSString *line = [self.buffer.lines objectAtIndex:i];
                    if(line) {
                        CGSize size = [context sizeOfText:line
                                                breakMode:NCLineBreakByWordWrapping
                                                    width:rect.size.width];
                        size.height = MAX(size.height, 1);
                        
                        [context drawText:line
                                   inRect:CGRectMake(rect.origin.x, rect.origin.y + y, rect.size.width, size.height)
                           withForeground:[NCColor whiteColor]
                           withBackground:[NCColor blackColor]
                                breakMode:NCLineBreakByWordWrapping
                             truncateMode:NCLineTruncationByClipping
                            alignmentMode:NCLineAlignmentLeft];
                        
                        if(i == self.buffer.cursorLineY) {
                            int cx = self.buffer.cursorOffsetX;
                            int cy = 0;
                            while(cx >= size.width && size.height > 1) {
                                cx -= size.width;
                                cy++;
                            }
                            [context drawPoint:CGSizeMake(self.frame.origin.x + cx, self.frame.origin.y + y + cy)
                                withForeground:[NCColor blackColor]
                                withBackground:[NCColor whiteColor]];
                        }
                        
                        y += size.height;
                        if(y >= rect.size.height) {
                            break;
                        }
                    }
                }
            }
            
        } else {
            [context drawText:@"No buffer open"
                       inRect:CGRectMake(rect.origin.x, rect.origin.y + rect.size.height / 2, rect.size.width, 1)
               withForeground:[NCColor whiteColor]
               withBackground:[NCColor blackColor]
                    breakMode:NCLineBreakByNoWrapping
                 truncateMode:NCLineTruncationByTruncationTail
                alignmentMode:NCLineAlignmentCenter];
        }
    }
    [super drawRect:rect
          inContext:context];
}

- (NSMutableString*) textOnLine:(int)line
{
    if(line >= 0 && line < self.buffer.lines.count)
    {
        return [self.buffer.lines objectAtIndex:line];
    }
    return nil;
}

@end
