//
//  SFJSONtest.m
//  jsonTest
//
//  Created by macadmin on 3/4/13.
//  Copyright (c) 2013 Salmonhands. All rights reserved.
//

#import "SFBrowser.h"
#import "NSData+Additions.h"
#import "SHFloatingViewController.h"

@interface SFBrowser () <UIAlertViewDelegate> {
    
    UITextView* _textView;
    SmartFileEngine* engine;
    NSURL* _previewItemURL;
}

@property (nonatomic, strong) NSString* displayText;
@property (nonatomic, strong) NSIndexPath* selected;

@end

@implementation SFBrowser

@synthesize directory = _directory;

- (void)setDisplayText:(NSString *)displayText {
    _textView.text = displayText;
}

- (NSString*)displayText {
    return _textView.text;
}

- (id)initWithDirectory:(NSString *)directory {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (!self) { return self; }
    
    self.directory = directory;
    self.showAddFolderRow = YES;
    return self;
}

- (void)viewDidLoad {
    self.tableView.opaque = NO;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    
    NSMutableDictionary* headerFields = [NSMutableDictionary dictionary];
    [headerFields setValue:@"Basic ODM4a05MY0JJME5OSk5mc0hIc25KdTZ2MFZkRFlvOk9iaHpJYWRPRUh5ZjVlZHVYMTRBQWFTTnN4MWxTcg=="
                    forKey:@"Authorization"];
    
    engine = [[SmartFileEngine alloc] initWithHostName:@"app.smartfile.com"
                                               apiPath:@"api/2"
                                    customHeaderFields:headerFields];
    
    [engine listFilesFor:self.directory
            onCompletion:^(NSArray* list) {
                _list = list;
                [self.tableView reloadData];
            }onError:^(MKNetworkOperation* op, NSError* error) {
                DLog(@"%@\t%@\t%@\t%@", [error localizedDescription], [error localizedFailureReason],
                     [error localizedRecoveryOptions], [error localizedRecoverySuggestion]);
            }];
    
    // Set up the pull to refresh
    UIRefreshControl* refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshList) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}

- (void)makeDirectory
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Create Directory" message:@"Enter a name for the new folder" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Create", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert setTag:0];
    [alert show];
}

- (void)makeDirectoryWithName:(NSString*) name {
    NSString* fullName = [self.directory stringByAppendingString:name];
    [engine mkdir:fullName onCompletion:^(NSDictionary* meta) {
        DLog(@"Created directory with data: %@", meta);
        NSDictionary* newDir = [NSDictionary dictionaryWithObjects:@[[meta valueForKey:@"mime"], [meta valueForKey:@"name"]]
                                                           forKeys:@[@"mime", @"name"]];
        
        _list = [_list arrayByAddingObject:newDir];
        _list = [_list sortedArrayUsingComparator:^(id obj1, id obj2) {
            NSDictionary* d1 = (NSDictionary*) obj1;
            NSDictionary* d2 = (NSDictionary*) obj2;
            NSString* m1 = [d1 valueForKey:@"mime"];
            NSString* m2 = [d2 valueForKey:@"mime"];
            if ([m1 compare:@"application/x-directory"] != NSOrderedSame) { return (NSComparisonResult)NSOrderedSame; }
            if ([m2 compare:@"application/x-directory"] != NSOrderedSame) { return (NSComparisonResult)NSOrderedSame; }
            NSString* n1 = [d1 valueForKey:@"name"];
            NSString* n2 = [d2 valueForKey:@"name"];
            return (NSComparisonResult)[n1 compare:n2];
        }];
        
        [self.tableView reloadData];
        self.selected = self.tableView.indexPathForSelectedRow;
    }onError:^(MKNetworkOperation* op, NSError* error) {
        DLog(@"%@\t%@\t%@\t%@", [error localizedDescription], [error localizedFailureReason],
             [error localizedRecoveryOptions], [error localizedRecoverySuggestion]);
    }];
}

#pragma mark -
#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { return; }
    
    if (buttonIndex == 1) {
        NSString* dName = [[alertView textFieldAtIndex:0] text];
        [self makeDirectoryWithName:dName];
    }
}

#pragma mark -
#pragma mark Other UITableView Methods
- (void)refreshList {
    [engine listFilesFor:self.directory
            onCompletion:^(NSArray* list) {
                _list = list;
                [self.tableView reloadData];
            }onError:^(MKNetworkOperation* op, NSError* error) {
                DLog(@"%@\t%@\t%@\t%@", [error localizedDescription], [error localizedFailureReason],
                     [error localizedRecoveryOptions], [error localizedRecoverySuggestion]);
            }];
    
    [self.refreshControl endRefreshing];
}

#pragma mark -
#pragma mark UITableViewDataSource Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 1;
    }
    
    return [_list count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 40.0f;
    }
    return 55.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellID = @"simpleCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    // Configure the cell
    if (indexPath.section == 0) {
        NSDictionary* element = _list[indexPath.row];
        NSString* display = [NSString stringWithFormat:@"%@", [element objectForKey:@"name"]];
        
        cell.textLabel.text = display;
        cell.textLabel.alpha = 1.0f;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:21.0f];
        cell.imageView.image = [UIImage imageNamed:@"Folder.png"];
    } else if (indexPath.section == 1) {
        cell.textLabel.text = @"Add Folder";
        cell.textLabel.alpha = 0.6f;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        cell.imageView.image = [UIImage imageNamed:@"addFolder.png"];
        
    }
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.opaque = NO;
    cell.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7f];
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section == 0);
}

#pragma mark -
#pragma mark UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self makeDirectory];
        return;
    }
    
    if (indexPath.section == 0 && indexPath.row >= [_list count]) { return; }

    NSDictionary* element = [_list objectAtIndex:indexPath.row];
    if ([element[@"mime"] isEqual: @"application/x-directory"]) {
        NSString* newDirectory = [NSString stringWithFormat:@"%@%@%@", self.directory, element[@"name"], @"/"];
        SFBrowser* pushController = [[SFBrowser alloc] initWithDirectory:newDirectory];
        self.child = pushController;
        [self.multiTableController pushViewController:pushController asChildOf:self animated:YES];
    }
    else {
        NSString* file = [NSString stringWithFormat:@"%@%@", self.directory, element[@"name"]];
        [engine downloadFile:file
            onProgressChange:nil
                onCompletion:^(NSData* file) {
                    // Save the file to the local cache
                    NSString* path = [[self cacheDirectoryName] stringByAppendingPathComponent:element[@"name"]];
                    DLog(@"%@", path);
                    NSError* error;
                    [file writeToFile:path options:NSDataWritingAtomic error:&error];
                    if (error) {
                        DLog(@"%@", [error localizedDescription]);
                    }
                    
                    [self.multiTableController addFloatingView:[[SHFloatingViewController alloc] initWithURL:[NSURL fileURLWithPath:path isDirectory:NO]]];
                }
                     onError:^(MKNetworkOperation* op, NSError* error) {
                         DLog(@"%@\t%@\t%@\t%@", [error localizedDescription], [error localizedFailureReason],
                              [error localizedRecoveryOptions], [error localizedRecoverySuggestion]);
                     }];
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString* rmDir = [self.directory stringByAppendingString:[_list[indexPath.row] objectForKey:@"name"]];
        [engine rmdir:rmDir
         onCompletion:^(NSDictionary* task) {
             NSMutableArray* a = [_list mutableCopy];
             [a removeObjectAtIndex:indexPath.row];
             _list = (NSArray*)a;
             [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
             [self.child pop];
         }onError:^(MKNetworkOperation* op, NSError* error) {
                  DLog(@"%@\t%@\t%@\t%@", [error localizedDescription], [error localizedFailureReason],
                       [error localizedRecoveryOptions], [error localizedRecoverySuggestion]);
         }];
    }
}

-(NSString*) cacheDirectoryName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    return documentsDirectory;
}





@end