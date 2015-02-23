//
//  NCAlertView.h
//  NCursesLibrary
//
//  Created by Christer on 2014-06-19.
//  Copyright (c) 2014 None. All rights reserved.
//

#import "NCView.h"

@interface NCAlertView : NCView

- (id) initWithTitle:(NSString*)title
          andMessage:(NSString*)message;

- (void) addButton:(NSString*)title
         withBlock:(void (^)())block;

- (void) show;

@end
