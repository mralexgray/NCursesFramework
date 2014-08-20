//
//  NCApplication.h
//  NCursesLibrary
//
//  Created by Christer on 2014-06-13.
//  Copyright (c) 2014 None. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NCWindow.h"

@interface NCApplication : NSObject

- (void) addWindow:(NCWindow*)window;
- (void) removeWindow:(NCWindow*)window;

- (void) applicationLaunched;
- (void) closeApplication;

+ (NCApplication*) sharedApplication;

@end
