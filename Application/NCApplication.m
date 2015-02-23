//
//  NCApplication.m
//  NCursesLibrary
//
//  Created by Christer on 2014-06-13.
//  Copyright (c) 2014 None. All rights reserved.
//

#import "NCApplication.h"
#import "NCScreen.h"

#import <curses.h>

@interface NCApplication ()
@property (nonatomic, strong) NSMutableArray *windows;
@end

@implementation NCApplication

static NCApplication *instance = nil;

- (id) init
{
    self = [super init];
    if(self) {
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
        
        instance = self;
        self.windows = [NSMutableArray array];
        [self applicationLaunched];
        while(self.windows && self.windows.count > 0) {
            char c = getch();
            if(self.windows && self.windows.count > 0) {
                [[self.windows lastObject] keyPress:[NCKey getKeyFromChar:c]];
            }
            if(self.windows && self.windows.count > 0) {
                [[self.windows lastObject] draw];
            }
        }
        
        endwin();
    }
    return self;
}

- (void)addWindow:(NCWindow *)window
{
    [self.windows addObject:window];
}

- (void)removeWindow:(NCWindow *)window
{
    [self.windows removeObject:window];
}

- (void) applicationLaunched
{
    
}

- (void) closeApplication
{
    [self.windows removeAllObjects];
}

+ (NCApplication*) sharedApplication
{
    return instance;
}

@end
