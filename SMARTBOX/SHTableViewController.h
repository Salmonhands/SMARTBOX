//
//  SHTableViewController.h
//  SMARTBOX
//
//  Created by macadmin on 4/13/13.
//  Copyright (c) 2013 Salmonhands. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHMultiTableViewController.h"

@interface SHTableViewController : UITableViewController

@property (nonatomic, weak) SHMultiTableViewController* multiTableController;
@property (nonatomic, weak) SHTableViewController* child;
@property (nonatomic) uint depth;

- (void)pop;
- (void)pull;
- (void)removeObjectWithName:(NSString*) name;

@end
