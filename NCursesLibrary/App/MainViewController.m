//
//  DetailViewController.m
//  NCursesLibrary
//
//  Created by Christer on 2014-06-18.
//  Copyright (c) 2014 None. All rights reserved.
//

#import "MainViewController.h"

#import "NCNavigationController.h"
#import "NCAlertView.h"
#import "NCLabel.h"

@interface MainViewController ()
@property (nonatomic, assign) BOOL commandMode;

@property (nonatomic, strong) TextEditorView *textEditorView;
@property (nonatomic, strong) TabMenuView *tabMenuView;
@property (nonatomic, strong) NCLabel *modeLabel;
@end

@implementation MainViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.tabMenuView = [[TabMenuView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    [self.tabMenuView setOutput:self];
    [self.tabMenuView setBackgroundColor:[NCColor whiteColor]];
    [self.tabMenuView setActiveColor:[NCColor blackColor]];
    [self.tabMenuView setPassiveColor:[NCColor whiteColor]];
    [self.view addSubview:self.tabMenuView];
    
    self.textEditorView = [[TextEditorView alloc] initWithFrame:CGRectMake(0, 1, self.view.frame.size.width, self.view.frame.size.height-2)];
    self.textEditorView.output = self;
    [self.view addSubview:self.textEditorView];
    
    self.modeLabel = [[NCLabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 1, self.view.frame.size.width, 1)];
    [self.modeLabel setText:self.commandMode ? @"COMMAND MODE" : @"INPUT MODE"];
    [self.modeLabel setForegroundColor:[NCColor blackColor]];
    [self.modeLabel setBackgroundColor:[NCColor whiteColor]];
    [self.view addSubview:self.modeLabel];
}

- (void)keyPress:(NCKey *)key
{
    if([key isEqualTo:[NCKey NCKEY_ESC]]) {
        self.commandMode = !self.commandMode;
    } else {
        if(self.commandMode) {
            if([key isEqualTo:[NCKey NCKEY_l]] || [key isEqualTo:[NCKey NCKEY_L]]) {
                FileSelectorViewController *vc = [[FileSelectorViewController alloc] initWithPath:[[NSBundle mainBundle] bundlePath]];
                vc.output = self;
                [self.navigationController pushViewController:vc];
            }
            else if([key isEqualTo:[NCKey NCKEY_ARROW_LEFT]]) {
                [self.tabMenuView moveLeft];
            }
            else if([key isEqualTo:[NCKey NCKEY_ARROW_RIGHT]]) {
                [self.tabMenuView moveRight];
            }
            self.commandMode = NO;
        } else {
            if([key isEqualTo:[NCKey NCKEY_ARROW_LEFT]]) {
                [self.textEditorView moveLeft];
            } else if([key isEqualTo:[NCKey NCKEY_ARROW_UP]]) {
                [self.textEditorView moveUp];
            } else if([key isEqualTo:[NCKey NCKEY_ARROW_RIGHT]]) {
                [self.textEditorView moveRight];
            } else if([key isEqualTo:[NCKey NCKEY_ARROW_DOWN]]) {
                [self.textEditorView moveDown];
            } else if([key isEqualTo:[NCKey NCKEY_BACK_SPACE]]) {
                [self.textEditorView backspace];
            } else if([key isEqualTo:[NCKey NCKEY_ENTER]]) {
                [self.textEditorView addNewLine];
            } else {
                [self.textEditorView addCharacter:[key getCharacter]];
            }
        }
    }
    
    // Update modeLabel
    [self.modeLabel setText:self.commandMode ? @"COMMAND MODE" : @"INPUT MODE"];
}

#pragma mark TabMenuViewOutput

- (void)didSelectItem:(TabMenuItem *)item
{
    if(item.tag) {
        [self.textEditorView openBuffer:(FileBuffer*)item.tag];
    }
}

#pragma mark TextEditorViewOutput

- (void)failedToOpenFile:(NSString *)filePath
{
    NCAlertView *alert = [[NCAlertView alloc] initWithTitle:@"Failed to open"
                                                 andMessage:[NSString stringWithFormat:@"Could not open '%@'.",filePath]];
    [alert addButton:@"OK" withBlock:nil];
    [alert show];
}

#pragma mark FileSelectorViewControllerDelegate

- (void) didSelectFile:(NSString*)file
{
    FileBuffer *buffer = [FileBuffer fileBufferFromFilePath:file];
    if(buffer) {
        [self.tabMenuView addMenuItem:[file lastPathComponent] tag:buffer];
    } else {
        [self failedToOpenFile:file];
    }
}

@end
