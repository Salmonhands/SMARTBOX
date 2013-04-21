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
@class SmartFileEngine;

@interface SHMultiTableViewController : UIViewController 

- (id)initWithBaseController:(SHTableViewController *) base;
- (void)pushViewController:(UIViewController *)controller asChildOf:(SHTableViewController *)parent animated:(BOOL)animated;
- (void)popViewController;
- (void)reloadAllTableViews;

- (void)addFloatingView:(SHFloatingViewController *) floatingViewController withSender:(SHTableViewController *) parent;
- (void)bringToFrontFloatingView:(SHFloatingViewController *) floatingViewController;
- (void)removeFloatingView:(SHFloatingViewController *) floatingViewController;
- (void)removeFloatingView:(SHFloatingViewController *) floatingViewController refresh:(BOOL)flag;

- (void)selectFolderForFloatingView:(SHFloatingViewController*) fv;
- (void)hideAllFloatingViews;
- (void)showAllFloatingViews;

- (void)folderSelected:(NSString*)folder;

@property (nonatomic) BOOL foldersOnly;
@property (nonatomic, strong) UIImageView* bgImageView;
@property (nonatomic, strong, readonly) SmartFileEngine* engine;

@end