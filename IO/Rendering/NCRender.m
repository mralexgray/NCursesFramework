//
//  NCRender.m
//  NCursesLibrary
//
//  Created by Christer on 2014-06-16.
//  Copyright (c) 2014 None. All rights reserved.
//

#import "NCRender.h"
#import <curses.h>

@implementation NCRender

- (id) init
{
    self = [super init];
    if(self) {
        self.backgroundColor = [NCColor blackColor];
        self.foregroundColor = [NCColor whiteColor];
        self.character = ' ';
    }
    return self;
}

- (void)renderAt:(CGSize)point
{
#ifdef USE_CURSES
    int bcolor = COLOR_BLACK;
    if(self.backgroundColor) {
        bcolor = self.backgroundColor.color;
    }
    
    int fcolor = COLOR_WHITE;
    if(self.foregroundColor) {
        fcolor = self.foregroundColor.color;
    }
    
    attron(COLOR_PAIR(fcolor + bcolor * 10));
    mvaddch(point.height, point.width, self.character);
    attroff(COLOR_PAIR(fcolor + bcolor * 10));
#endif
}

@end
