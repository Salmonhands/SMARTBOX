//
//  SHTableViewController.m
//  SMARTBOX
//
//  Created by macadmin on 4/13/13.
//  Copyright (c) 2013 Salmonhands. All rights reserved.
//

#import "SHTableViewController.h"

@interface SHTableViewController ()

@end

@implementation SHTableViewController

-(void)pop {
    if (self.child) {
        [self.child pop];
        self.child = nil;
    }
    
    [self.multiTableController popViewController];
}

@end
