//
//  main.m
//  NCursesLibrary
//
//  Created by Christer on 2014-06-13.
//  Copyright (c) 2014 None. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestApplication.h"

#import <curses.h>

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
#ifdef USE_CURSES
        initscr();
        curs_set(0);
        start_color();
        raw();
        keypad(stdscr, TRUE);
        noecho();
        
        // init color pairs
        for(int f = 0; f <= 7; f++) {
            for(int b = 0; b <= 7; b++) {
                int colorCode = f + b * 10;
                init_pair(colorCode, f, b);
            }
        }
        
#endif
        
        TestApplication *application = [[TestApplication alloc] init];
        
        endwin();
        
    }
    return 0;
}

