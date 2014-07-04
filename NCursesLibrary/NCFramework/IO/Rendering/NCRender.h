//
//  NCRender.h
//  NCursesLibrary
//
//  Created by Christer on 2014-06-16.
//  Copyright (c) 2014 None. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NCColor.h"

@interface NCRender : NSObject

@property (nonatomic, strong) NCColor *backgroundColor;
@property (nonatomic, strong) NCColor *foregroundColor;
@property (nonatomic, assign) char character;

- (void) renderAt:(CGSize)point;

@end
