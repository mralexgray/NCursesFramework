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

@interface MainViewController ()
@property (nonatomic, assign) BOOL commandMode;

@property (nonatomic, strong) TextEditorView *textEditorView;
@property (nonatomic, strong) TabMenuView *tabMenuView;
@end

@implementation MainViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.tabMenuView = [[TabMenuView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    [self.tabMenuView setOutput:self];
    [self.view addSubview:self.tabMenuView];
    
    self.textEditorView = [[TextEditorView alloc] initWithFrame:CGRectMake(0, 1, self.view.frame.size.width, self.view.frame.size.height-1)];
    self.textEditorView.output = self;
    [self.view addSubview:self.textEditorView];
}

- (void)keyPress:(NCKey *)key
{
    if([key isEqualTo:[NCKey NCKEY_ESC]]) {
        self.commandMode = !self.commandMode;
    } else {
        if(self.commandMode) {
            if([key isEqualTo:[NCKey NCKEY_ENTER]]) {
                FileSelectorViewController *vc = [[FileSelectorViewController alloc] initWithPath:@"/"];
                vc.output = self;
                [self.navigationController pushViewController:vc];
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
