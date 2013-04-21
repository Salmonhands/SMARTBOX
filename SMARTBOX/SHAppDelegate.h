//
//  SHAppDelegate.h
//  jsonTest
//
//  Created by macadmin on 3/4/13.
//  Copyright (c) 2013 Salmonhands. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmartFileEngine.h"

#define ApplicationDelegate ((SHAppDelegate *)[[UIApplication sharedApplication] delegate])

@class SHMultiTableViewController;

@interface SHAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIView *backgroundDimmer;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) SHMultiTableViewController* multiTableController;

@property (nonatomic, strong, readonly) SmartFileEngine* SFEngine;

@end
