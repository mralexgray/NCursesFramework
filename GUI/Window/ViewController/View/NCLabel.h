//
//  NCLabel.h
//  NCursesLibrary
//
//  Created by Christer on 2014-07-07.
//  Copyright (c) 2014 None. All rights reserved.
//

#import "NCView.h"

@interface NCLabel : NCView

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NCColor *foregroundColor;
@property (nonatomic, strong) NCColor *backgroundColor;

@property (nonatomic, assign) NCLineAlignment lineAlignment;
@property (nonatomic, assign) NCLineBreakMode lineBreak;
@property (nonatomic, assign) NCLineTruncationMode lineTruncation;

@end
