//
//  TabMenuView.m
//  NCursesLibrary
//
//  Created by Christer on 2014-06-24.
//  Copyright (c) 2014 None. All rights reserved.
//

#import "TabMenuView.h"

@implementation TabMenuItem

@end

@interface TabMenuView ()
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, assign) int currentIndex;
@property (nonatomic, assign) int offsetX;
@end

@implementation TabMenuView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        self.items = [NSMutableArray array];
    }
    return self;
}

- (void)addMenuItem:(NSString *)name
                tag:(NSObject *)tag
{
    if(name) {
        TabMenuItem *item = [[TabMenuItem alloc] init];
        item.name = name;
        item.tag = tag;
        [self.items addObject:item];
        
        if(self.items.count == 1) {
            if(self.output && [self.output respondsToSelector:@selector(didSelectItem:)]) {
                [self.output didSelectItem:item];
            }
        }
    }
}

- (void)removeCurrentItem
{
    if(self.currentIndex >= 0 && self.currentIndex < self.items.count) {
        [self.items removeObjectAtIndex:self.currentIndex];
        if(self.currentIndex >= self.items.count && self.currentIndex != 0) {
            self.currentIndex--;
        }
    }
}

- (void)removeAllItems
{
    [self.items removeAllObjects];
    self.currentIndex = 0;
}

- (void) moveLeft
{
    if(self.currentIndex > 0) {
        self.currentIndex--;
    }
}

- (void) moveRight
{
    if(self.currentIndex + 1 < self.items.count) {
        self.currentIndex++;
    }
}

- (void)drawRect:(CGRect)rect
       inContext:(NCRenderContext *)context
{
    if(!self.hidden)
    {
        
    }
    
    [super drawRect:rect
          inContext:context];
}

@end
