//
//  SHMultiTableViewController.m
//  SMARTBOX
//
//  Created by macadmin on 4/12/13.
//  Copyright (c) 2013 Salmonhands. All rights reserved.
//

#import "SHMultiTableViewController.h"
#import "SHTableViewController.h"
#import "SHFloatingViewController.h"
#import "SFBrowser.h"

@interface SHMultiTableViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) NSArray* tableViewStack;
@property (nonatomic, strong) NSNumber* singleTableViewWidth;
@property (nonatomic, strong) NSNumber* xOrigin;
@property (nonatomic, strong) NSArray* floatingViews;

@end

@implementation SHMultiTableViewController

- (id)initWithBaseController:(SFBrowser *)base {
    self = [super init];
    if (self) {
        base.multiTableController = self;
        self.tableViewStack = [NSArray arrayWithObject:base];
        self.singleTableViewWidth = @300;
        self.xOrigin = 0;
        self.floatingViews = [NSArray array];
    }
    
    return self;
}

- (void)viewDidLoad {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    SFBrowser* base = self.tableViewStack[0];
    base.depth = 0;
    base.view.frame = CGRectMake([self.xOrigin floatValue], 0.0f, [self.singleTableViewWidth floatValue], self.scrollView.frame.size.height);
    self.xOrigin = [NSNumber numberWithFloat:([self.xOrigin floatValue] + [self.singleTableViewWidth floatValue])];
    [self.scrollView addSubview:base.view];
    self.scrollView.contentSize = CGSizeMake([self.singleTableViewWidth floatValue], self.scrollView.frame.size.height);
    [self.view addSubview:self.scrollView];
}


- (void)pushViewController:(UIViewController*)controller asChildOf:(SHTableViewController *)parent animated:(BOOL)animated {
    if (([[self.tableViewStack lastObject] depth]) > [parent depth] && [self.tableViewStack count] > ([parent depth] + 1)) {
        [self.tableViewStack[[parent depth] + 1] pop];
    }
    
    SHTableViewController* c = (SHTableViewController *)controller;
    c.multiTableController = self;
    
    c.depth = [[self.tableViewStack lastObject] depth] + 1;
    [[self.tableViewStack lastObject] setChild:c];
    
    self.tableViewStack = [self.tableViewStack arrayByAddingObject:c];
    c.view.frame = CGRectMake([self.xOrigin floatValue], 0, [self.singleTableViewWidth floatValue], self.scrollView.frame.size.height);
    self.xOrigin = [NSNumber numberWithFloat:([self.xOrigin floatValue] + [self.singleTableViewWidth floatValue])];
    [self.scrollView addSubview:c.view];
    self.scrollView.contentSize = CGSizeMake([self.xOrigin floatValue], self.scrollView.frame.size.height);
    
    if (self.scrollView.contentSize.width > self.view.frame.size.width) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentSize.width - self.view.frame.size.width, self.scrollView.contentOffset.y) animated:YES];
    }
}


- (void)popViewController {
    if ([self.xOrigin floatValue] == 0.0f) {
        return;
    }
    
    
    [UIView animateWithDuration:.2 animations:^(void){
        [[[self.tableViewStack lastObject] view ]removeFromSuperview];
        self.scrollView.contentSize = CGSizeMake([self.xOrigin floatValue], self.scrollView.frame.size.height);
        self.xOrigin = [NSNumber numberWithFloat:([self.xOrigin floatValue] - [self.singleTableViewWidth floatValue])];
        self.tableViewStack = [self.tableViewStack subarrayWithRange:NSMakeRange(0, self.tableViewStack.count - 1)];
    }completion:^(BOOL finished){
    }];
    
}


- (void)addFloatingView:(SHFloatingViewController *) floatingViewController {
    floatingViewController.multiTableController = self;
    self.floatingViews = [self.floatingViews arrayByAddingObject:floatingViewController];
    [self.view addSubview:floatingViewController.view];
}


- (void)removeFloatingView:(SHFloatingViewController *) floatingViewController {
    for (int i = 0; i < [self.floatingViews count]; i++) {
        if (self.floatingViews[i] == floatingViewController) {
            NSMutableArray* mutable = [self.floatingViews mutableCopy];
            [mutable removeObject:floatingViewController];
            self.floatingViews = mutable;
            [floatingViewController.view removeFromSuperview];
            return;
        }
    }
}

@end


