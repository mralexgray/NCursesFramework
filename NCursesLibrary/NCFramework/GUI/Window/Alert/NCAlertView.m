//
//  NCAlertView.m
//  NCursesLibrary
//
//  Created by Christer on 2014-06-19.
//  Copyright (c) 2014 None. All rights reserved.
//

#import "NCAlertView.h"
#import "NCAlertView_Protected.h"
#import "NCAlertViewController.h"
#import "NCApplication.h"
#import "NCWindow.h"
#import "NCScreen.h"

@interface NCAlertView ()
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *message;

@property (nonatomic, assign) int currentIndex;

@property (nonatomic, strong) NSMutableArray *buttonTitles;
@property (nonatomic, strong) NSMutableArray *buttonBlocks;
@end

@implementation NCAlertView

- (id) initWithTitle:(NSString *)title
          andMessage:(NSString *)message
{
    self = [super initWithFrame:[NCScreen bounds]];
    if(self) {
        self.title = title;
        self.message = message;
        
        self.buttonBlocks = [NSMutableArray array];
        self.buttonTitles = [NSMutableArray array];
    }
    return self;
}

- (void)addButton:(NSString *)title
        withBlock:(void (^)())block
{
    [self.buttonTitles addObject:title ? title : @""];
    [self.buttonBlocks addObject:block ? [block copy] : [NSNull null]];
}

- (void)moveLeft
{
    if(self.currentIndex > 0) {
        self.currentIndex--;
    }
}

- (void)moveRight
{
    if(self.currentIndex+1 < self.buttonTitles.count) {
        self.currentIndex++;
    }
}

- (void)select
{
    if(self.currentIndex >= 0 && self.currentIndex < self.buttonTitles.count) {
        if(![[self.buttonBlocks objectAtIndex:self.currentIndex] isKindOfClass:[NSNull class]]) {
            id obj = [self.buttonBlocks objectAtIndex:self.currentIndex];
            ((void (^)())obj)();
        }
    }
}

- (void)drawRect:(CGRect)rect
       inContext:(NCRenderContext *)context
{
    for(int x = rect.origin.x; x < rect.size.width; x++) {
        [context drawText:@"="
                   inRect:CGRectMake(x, rect.origin.y, 1, 1)
           withForeground:[NCColor whiteColor]
           withBackground:[NCColor blackColor]
           withColorRange:nil
                breakMode:NCLineBreakByNoWrapping
             truncateMode:NCLineTruncationByClipping
            alignmentMode:NCLineAlignmentLeft];
        
        [context drawText:@"="
                   inRect:CGRectMake(x, rect.origin.y + rect.size.height - 1, 1, 1)
           withForeground:[NCColor whiteColor]
           withBackground:[NCColor blackColor]
           withColorRange:nil
                breakMode:NCLineBreakByNoWrapping
             truncateMode:NCLineTruncationByClipping
            alignmentMode:NCLineAlignmentLeft];
    }
    
    for(int y = rect.origin.y; y < rect.size.height; y++) {
        [context drawText:@"|"
                   inRect:CGRectMake(rect.origin.x, y, 1, 1)
           withForeground:[NCColor whiteColor]
           withBackground:[NCColor blackColor]
           withColorRange:nil
                breakMode:NCLineBreakByNoWrapping
             truncateMode:NCLineTruncationByClipping
            alignmentMode:NCLineAlignmentLeft];
        
        [context drawText:@"|"
                   inRect:CGRectMake(rect.origin.x + rect.size.width - 1, y, 1, 1)
           withForeground:[NCColor whiteColor]
           withBackground:[NCColor blackColor]
           withColorRange:nil
                breakMode:NCLineBreakByNoWrapping
             truncateMode:NCLineTruncationByClipping
            alignmentMode:NCLineAlignmentLeft];
    }
    
    if(rect.size.height > 3 && rect.size.width > 2) {
        [context drawText:self.title
                   inRect:CGRectMake(rect.origin.x + 1, rect.origin.y + 1, rect.size.width - 2, 1)
           withForeground:[NCColor whiteColor]
           withBackground:[NCColor blackColor]
           withColorRange:nil
                breakMode:NCLineBreakByNoWrapping
             truncateMode:NCLineTruncationByTruncationTail
            alignmentMode:NCLineAlignmentCenter];
    }
    
    if(rect.size.height > 4 && rect.size.width > 2) {
        [context drawText:self.message
                   inRect:CGRectMake(rect.origin.x + 1, rect.origin.y + 2, rect.size.width - 2, rect.size.height - 4)
           withForeground:[NCColor whiteColor]
           withBackground:[NCColor blackColor]
           withColorRange:nil
                breakMode:NCLineBreakByWordWrapping
             truncateMode:NCLineTruncationByTruncationTail
            alignmentMode:NCLineAlignmentLeft];
    }
    
    if(rect.size.height > 2 && rect.size.width > 2) {
        int totalWidth = 0;
        for(int i = 0; i < self.buttonTitles.count && totalWidth < rect.size.width; i++) {
            NSString *title = [NSString stringWithFormat:@"[%@]",[self.buttonTitles objectAtIndex:i]];
            
            int w = MIN(title.length, rect.size.width - 2 - totalWidth);
            
            [context drawText:title
                       inRect:CGRectMake(1+totalWidth, rect.origin.y + rect.size.height - 1, w, 1)
               withForeground:self.currentIndex == i ? [NCColor blackColor] : [NCColor whiteColor]
               withBackground:self.currentIndex == i ? [NCColor whiteColor] : [NCColor blackColor]
               withColorRange:nil
                    breakMode:NCLineBreakByNoWrapping
                 truncateMode:NCLineTruncationByClipping
                alignmentMode:NCLineAlignmentLeft];
            
            totalWidth += w;
        }
    }

    [super drawRect:rect inContext:context];
}

- (void) show
{
    NCWindow *window = [[NCWindow alloc] initWithFrame:[NCScreen bounds]];
    NCAlertViewController *viewController = [[NCAlertViewController alloc] init];
    viewController.alertView = self;
    viewController.window = window;
    [window setRootViewController:viewController];
    [[NCApplication sharedApplication] addWindow:window];
}

@end
