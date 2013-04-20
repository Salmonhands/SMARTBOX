//
//  SHFloatingViewController.h
//  test
//
//  Created by macadmin on 4/13/13.
//  Copyright (c) 2013 Salmonhands. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>

@class SHMultiTableViewController;
@class SmartFileEngine;
@class SHTableViewController;

@interface SHFloatingViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, strong) QLPreviewController* innerViewController;
@property (nonatomic, weak) SHMultiTableViewController* multiTableController;
@property (nonatomic, strong) NSString* HTTPpath;
@property (nonatomic, strong) SmartFileEngine* engine;
@property (nonatomic, weak) SHTableViewController* parent;
@property (nonatomic, strong) UIViewController* revealableView;
@property (nonatomic, strong) NSURL* previewItemURL;
@property (nonatomic, strong) NSString* fileName;

- (id)initWithURL:(NSURL *)url;

- (void)exposeHiddenView;
- (void)hideExposedView;
- (void)swapNoteView;

@end
