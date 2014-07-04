//
//  TestViewController.h
//  NCursesLibrary
//
//  Created by Christer on 2014-06-13.
//  Copyright (c) 2014 None. All rights reserved.
//

#import "NCViewController.h"
#import "FSViewer.h"

@protocol FileSelectorViewControllerDelegate <NSObject>

- (void) didSelectFile:(NSString*)file;

@end

@interface FileSelectorViewController : NCViewController <FSViewerDelegate>

- (id) initWithPath:(NSString*) path;

@property (nonatomic, weak) id<FileSelectorViewControllerDelegate> output;

@end
