//
//  SFJSONtest.h
//  jsonTest
//
//  Created by macadmin on 3/4/13.
//  Copyright (c) 2013 Salmonhands. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>
#import "SmartFileEngine.h"
#import "SHTableViewController.h"

extern NSString* const kAPI_URL;
extern NSString* const kAPI_KEY;
extern NSString* const kAPI_PWD;
extern NSString* const kMIMEAPPLICATIONJSON;

@interface SFBrowser : SHTableViewController {
    
}

@property (strong, nonatomic) NSString* directory;
@property (nonatomic, strong) NSArray* list;
@property (nonatomic) BOOL showAddFolderRow;

- (id)initWithDirectory:(NSString*) directory;

- (void)makeDirectory;
- (void)makeDirectoryWithName:(NSString*) name;


@end
