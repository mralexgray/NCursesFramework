//
//  NCNavigationController.m
//  NCursesLibrary
//
//  Created by Christer on 2014-06-18.
//  Copyright (c) 2014 None. All rights reserved.
//

#import "NCNavigationController.h"

@interface NCNavigationController ()
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, assign) CGRect rect;
@end

@implementation NCNavigationController

- (id) init
{
    self = [super init];
    if(self) {
        self.viewControllers = [NSMutableArray array];
    }
    return self;
}

- (id) initWithRootViewController:(NCViewController *)rootViewController
{
    self = [self init];
    if(self) {
        [self setRootViewController:rootViewController];
    }
    return self;
}

- (void) setRootViewController:(NCViewController *)rootViewController
{
    if(rootViewController) {
        [self.viewControllers removeAllObjects];
        [self pushViewController:rootViewController];
    }
}

- (void)keyPress:(NCKey *)key
{
    if(self.viewControllers && self.viewControllers.count > 0) {
        NCViewController *viewController = [self.viewControllers lastObject];
        [viewController keyPress:key];
    }
}

- (void) popViewController
{
    if(self.viewControllers.count > 1) {
        NCViewController *old = [self.viewControllers lastObject];
        [old viewDidDissapear];
        [self.viewControllers removeLastObject];
        NCViewController *n = [self.viewControllers lastObject];
        [n viewDidAppear];
    }
}

- (void) pushViewController:(NCViewController*)viewController
{
    if(viewController) {
        viewController.navigationController = self;
        [self.viewControllers addObject:viewController];
        
        if(!CGRectIsEmpty(self.rect)) {
            [viewController.view setFrame:self.rect];
        }
        
        if(!viewController.didLoad && !CGRectIsEmpty(viewController.view.frame)) {
            [viewController viewDidLoad];
            [viewController viewDidAppear];
        }
    }
}

- (NCView*) view
{
    if(self.viewControllers && self.viewControllers.count > 0) {
        NCViewController *viewController = [self.viewControllers lastObject];
        if(CGRectIsEmpty(self.rect) && !CGRectIsEmpty(viewController.view.frame)) {
            self.rect = viewController.view.frame;
        }
        
        if(!viewController.didLoad && !CGRectIsEmpty(viewController.view.frame)) {
            [viewController viewDidLoad];
            [viewController viewDidAppear];
        }
        
        return viewController.view;
    } else {
        return self.view;
    }
}

@end
