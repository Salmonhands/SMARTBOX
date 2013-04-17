//
//  SHMultiTableViewController.h
//  SMARTBOX
//
//  Created by macadmin on 4/12/13.
//  Copyright (c) 2013 Salmonhands. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SHTableViewController;
@class SHFloatingViewController;

@interface SHMultiTableViewController : UIViewController 

- (id)initWithBaseController:(SHTableViewController *) base;
- (void)pushViewController:(UIViewController *)controller asChildOf:(SHTableViewController *)parent animated:(BOOL)animated;
- (void)popViewController;
- (void)addFloatingView:(SHFloatingViewController *) floatingViewController withSender:(SHTableViewController *) parent;
- (void)bringToFrontFloatingView:(SHFloatingViewController *) floatingViewController;
- (void)removeFloatingView:(SHFloatingViewController *) floatingViewController;
- (void)removeFloatingView:(SHFloatingViewController *) floatingViewController refresh:(BOOL)flag;

@end