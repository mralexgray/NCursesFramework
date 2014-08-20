//
//  NCColorRange.h
//  NCursesLibrary
//
//  Created by Christer on 2014-08-15.
//  Copyright (c) 2014 None. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NCColor.h"

@interface NCColorRange : NSObject
- (id)initWithForeground:(NCColor*)foreground
          withBackground:(NCColor*)background
               withRange:(NSRange)range;
@property (nonatomic, strong) NCColor *foreground;
@property (nonatomic, strong) NCColor *background;
@property (nonatomic, assign) NSRange range;
@end
