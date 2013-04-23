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
#import "SHLoginViewController.h"
#import "GTMOAuthViewControllerTouch.h"
#import "GTMOAuthAuthentication.h"
#import "UIImage+Rotate.h"

static NSString *const kKeychainItemName = @"OAuth2 - SmartFile";

@interface SHAppDelegate ()
{
    SmartFileEngine* _SFEngine;
    
    GTMOAuthViewControllerTouch* viewController;
    GTMOAuthAuthentication* _auth;
}

@property (nonatomic, readonly) BOOL requiresLogin;
@property (nonatomic, strong) SHLoginViewController* loginVC;
@property (nonatomic) GTMOAuthAuthentication* auth;
@property (nonatomic, readonly) NSString* clientID;
@property (nonatomic, readonly) NSString* clientSecret;
@property (nonatomic, readonly) NSURL* requestURL;
@property (nonatomic, readonly) NSURL* accessURL;
@property (nonatomic, readonly) NSURL* authorizeURL;
@property (nonatomic, readonly) NSString* scope;

@end

@implementation SHAppDelegate

// For testing
- (BOOL)requiresLogin {
    return NO;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    SFBrowser* rootView = [[SFBrowser alloc] initWithDirectory:@"/"];
    self.multiTableController = [[SHMultiTableViewController alloc] initWithBaseController:rootView];\
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.multiTableController];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    if (self.requiresLogin) {
        //self.loginVC = [[SHLoginViewController alloc] init];
        //[self.navigationController.view addSubview:self.loginVC.view];
        if (![self.auth canAuthorize]) {
            [self signInToCustomService];
        }
        
    }
    
    [self.window setRootViewController:self.navigationController];
    [self.window makeKeyAndVisible];
    //[self.loginVC animateLoginView];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    SHFloatingViewController* f = [[SHFloatingViewController alloc] initWithURL:url];
    [self.multiTableController addFloatingView:f withSender:nil];
    
    return YES;
}

- (NSString *)clientID {
    return kCLIENTTOKEN;
}

- (NSString *)clientSecret {
    return kCLIENTSECRET;
}

- (GTMOAuthAuthentication *)auth {
    if (!_auth ) {        
        _auth = [[GTMOAuthAuthentication alloc] initWithSignatureMethod:kGTMOAuthSignatureMethodHMAC_SHA1
                                                            consumerKey:self.clientID
                                                             privateKey:self.clientSecret];
        
        // setting the service name lets us inspect the auth object later to know
        // what service it is for
        _auth.serviceProvider = @"Custom Auth Service - SMARTBOX";
    }
    
    if (![_auth canAuthorize]) {
        // Attempt to login from keychain
        DLog(@"i tried to authorize!");
        if ([GTMOAuthViewControllerTouch authorizeFromKeychainForName:@"SMARTBOX.SMARTFILE"
                                                       authentication:_auth]) {
            DLog(@"and i succeeded");
        } else { DLog(@" and i failed"); }
    }
    
    return _auth;
}

- (NSURL *)requestURL {
    return [NSURL URLWithString:@"https://app.smartfile.com/oauth/request_token"];
}

- (NSURL *)accessURL {
    return [NSURL URLWithString:@"https://app.smartfile.com/oauth/access_token"];
}

- (NSURL *)authorizeURL {
    return [NSURL URLWithString:@"https://app.smartfile.com/oauth/authorize"];
}

- (NSString *)scope {
    //return nil;
    return @"https://app.smartfile.com";
}

- (SmartFileEngine *)SFEngine {
    if (_SFEngine) { return _SFEngine; }
    
   _SFEngine = [[SmartFileEngine alloc] initWithDefaultSettings];
    return _SFEngine;
}

- (void)signInToCustomService {
    
    GTMOAuthAuthentication *auth = self.auth;
    
    // set the callback URL to which the site should redirect, and for which
    // the OAuth controller should look to determine when sign-in has
    // finished or been canceled
    //
    // This URL does not need to be for an actual web page
    [auth setCallback:@"http://www.google.com"];
    
    // Display the autentication view
    GTMOAuthViewControllerTouch *_viewController;
    _viewController = [[GTMOAuthViewControllerTouch alloc] initWithScope:self.scope
                                                                  language:nil
                                                           requestTokenURL:self.requestURL
                                                         authorizeTokenURL:self.authorizeURL
                                                            accessTokenURL:self.accessURL
                                                            authentication:self.auth
                                                            appServiceName:@"SMARTBOX.SMARTFILE"
                                                       completionHandler:^(GTMOAuthViewControllerTouch *viewController, GTMOAuthAuthentication *auth, NSError *error) {
                                                           if (!error) {
                                                               self.auth = auth;
                                                               DLog(@"FADSFA");
                                                               [self.navigationController popViewControllerAnimated:YES];
                                                           } else {
                                                               DLog(@"ERROR: %@", [error localizedDescription]);
                                                           }
                                                       }];
    
    [self.navigationController pushViewController:_viewController
                                           animated:YES];
}

@end
