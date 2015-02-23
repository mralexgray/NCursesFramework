//
//  NCView.h
//  NCursesLibrary
//
//  Created by Christer on 2014-06-13.
//  Copyright (c) 2014 None. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NCRenderContext.h"
#import "NCColor.h"

@interface NCView : NSObject

- (id) initWithFrame:(CGRect)frame;

@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign, readonly) CGRect bounds;
@property (nonatomic, assign) BOOL hidden;
@property (nonatomic, strong) NSArray *subviews;
@property (nonatomic, strong) NCColor *backgroundColor;

- (void) drawRect:(CGRect)rect
        inContext:(NCRenderContext*)context;
- (void) addSubview:(NCView*)view;
- (void) removeSubview:(NCView*)view;

@end
