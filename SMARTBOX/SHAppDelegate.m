//
//  SHAppDelegate.m
//  jsonTest
//
//  Created by macadmin on 3/4/13.
//  Copyright (c) 2013 Salmonhands. All rights reserved.
//

#import "SHAppDelegate.h"
#import "SFBrowser.h"
#import "SHMultiTableViewController.h"
#import "SHFloatingViewController.h"

@implementation SHAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    SFBrowser* rootView = [[SFBrowser alloc] initWithDirectory:@"/"];
    self.multiTableController = [[SHMultiTableViewController alloc] initWithBaseController:rootView];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    imageView.frame = self.window.frame;
    self.multiTableController.bgImageView = imageView;
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.multiTableController];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    [self.window setRootViewController:self.navigationController];
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    SHFloatingViewController* f = [[SHFloatingViewController alloc] initWithURL:url];
    [self.multiTableController addFloatingView:f withSender:nil];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
