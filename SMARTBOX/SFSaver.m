//
//  SFSaver.m
//  jsonTest
//
//  Created by macadmin on 4/5/13.
//  Copyright (c) 2013 Salmonhands. All rights reserved.
//

#import "SFSaver.h"

@interface SFSaver ()

@end

@implementation SFSaver

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Save Location";
    
    // Set up the add folder button
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                  target:self
                                  action:@selector(save)];
    
    [[self navigationItem] setRightBarButtonItem:barButton];
}


- (void)save {
    DLog(@"SAVE");
}

- (void)saveWithName:(NSString*)name {
    DLog(@"SAVEWITHNAME");
}

#pragma mark -
#pragma mark UITableViewDataSource Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    NSDictionary* element = [self.list objectAtIndex:indexPath.row];
    if ([((NSString*)element[@"mime"]) compare:@"application/x-directory"] != NSOrderedSame) {
        cell.textLabel.hidden = YES;
        return cell;
    }
    
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark -
#pragma mark UITableViewDelegate Methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary* element = [self.list objectAtIndex:indexPath.row];
    NSString* newDirectory = [NSString stringWithFormat:@"%@%@%@", self.directory, element[@"name"], @"/"];
    SFSaver* pushController = [[SFSaver alloc] initWithDirectory:newDirectory];
    [self.navigationController pushViewController:pushController animated:YES];
}

// Only folders selectable (because others are hidden)
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary* element = [self.list objectAtIndex:indexPath.row];
    if ([((NSString*)element[@"mime"]) compare:@"application/x-directory"] != NSOrderedSame) {
        return nil;
    }
    
    return indexPath;
}

@end
