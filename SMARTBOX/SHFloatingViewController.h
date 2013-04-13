//
//  SHFloatingViewController.h
//  test
//
//  Created by macadmin on 4/13/13.
//  Copyright (c) 2013 Salmonhands. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SHMultiTableViewController;

@interface SHFloatingViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIViewController* innerViewController;
@property (nonatomic, weak) SHMultiTableViewController* multiTableController;


- (id)initWithURL:(NSURL *)url;

@end
