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
}

@property (nonatomic, strong) NSString* displayText;
@property (nonatomic, strong) NSIndexPath* selected;

@end

@implementation SFBrowser


#pragma mark -
#pragma mark Accessors and Mutators

- (void)setShowFoldersOnly:(BOOL)showFoldersOnly {
    // Only need to reload if there is a change
    if (_showFoldersOnly != showFoldersOnly) {
        _showFoldersOnly = showFoldersOnly;
        [self.tableView reloadData];
    }
}

#pragma mark - 
#pragma mark Initializers
- (id)initWithDirectory:(NSString *)directory {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (!self) { return self; }
    
    _directory = directory;
    self.showAddFolderRow = YES;
    return self;
}

#pragma mark -
#pragma mark View Lifecycle

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


- (void)removeObjectWithName:(NSString*) name
{
    int i = 0;
    for (NSDictionary* element in self.list) {
        if ( [name compare:[element objectForKey:@"name"]] == NSOrderedSame) {
            [self tableView:self.tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        }
        i++;
    }
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

- (void)pull {
    [self refreshList];
}

#pragma mark -
#pragma mark UITableViewDataSource Methods
const int selectSection = 0;
const int filesSection = 1;
const int addSection = 2;
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == addSection) { return 1; }
    if (section == selectSection && self.showFoldersOnly) { return 1; }
    
    if (section == filesSection) {
        if (self.showFoldersOnly == NO) { return [_list count]; }
        
        int i = 0;
        for (NSDictionary* e in _list) {
            NSString* mime = [e objectForKey:@"mime"];
            if ([mime compare:@"application/x-directory"] == NSOrderedSame) {
                i++;
            }
        }
        return i;
    }
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == selectSection) {
        return 40.0f;
    }
    if (indexPath.section == filesSection) {
        return 55.0f;
    }
    if (indexPath.section == addSection) {
        return 40.0f;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellID = @"simpleCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    // Configure the cell
    if (indexPath.section == selectSection) {
        cell.textLabel.text = @"Select this folder";
        cell.textLabel.font = [UIFont boldSystemFontOfSize:21.0f];
        cell.textLabel.alpha = 1.0f;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.imageView.image = nil;
        
    }
    else if (indexPath.section == filesSection) {
        NSDictionary* element;
        if (self.showFoldersOnly) {
            int i = 0;
            for (NSDictionary* e in _list) {
                NSString* mime = [e objectForKey:@"mime"];
                if ([mime compare:@"application/x-directory"] == NSOrderedSame) {
                    if (i == indexPath.row) {
                        element = e;
                        break;
                    }
                    i++;
                }
            }
        } else {
            element = _list[indexPath.row];
        }
        
        NSString* display = [NSString stringWithFormat:@"%@", [element objectForKey:@"name"]];
        
        cell.textLabel.text = display;
        cell.textLabel.alpha = 1.0f;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:21.0f];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        
        NSString* image = @"UNK.png";
        
        if ([@"application/x-directory" compare:[element objectForKey:@"mime"]] == NSOrderedSame) {
            image = @"Folder.png";
        }
        else if ([@"application/msword" compare:[element objectForKey:@"mime"]] == NSOrderedSame) {
            image = @"DOC.png";
        }
        else if ([@"application/word" compare:[element objectForKey:@"mime"]] == NSOrderedSame) {
            image = @"DOC.png";
        }
        else if ([@"application/x-msword" compare:[element objectForKey:@"mime"]] == NSOrderedSame) {
            image = @"DOC.png";
        }
        else if ([@"application/vnd.ms-word" compare:[element objectForKey:@"mime"]] == NSOrderedSame) {
            image = @"DOC.png";
        }
        else if ([@"application/vnd.openxmlformats-officedocument.wordprocessingml.document" compare:[element objectForKey:@"mime"]] == NSOrderedSame) {
            image = @"DOC.png";
        }
        else if ([@"image/jpeg" compare:[element objectForKey:@"mime"]] == NSOrderedSame) {
            image = @"JPG.png";
        }
        else if ([@"image/pjpeg" compare:[element objectForKey:@"mime"]] == NSOrderedSame) {
            image = @"JPG.png";
        }
        else if ([@"video/quicktime" compare:[element objectForKey:@"mime"]] == NSOrderedSame) {
            image = @"MOV.png";
        }
        else if ([@"application/pdf" compare:[element objectForKey:@"mime"]] == NSOrderedSame) {
            image = @"PDF.png";
        }
        else if ([@"application/mspowerpoint" compare:[element objectForKey:@"mime"]] == NSOrderedSame) {
            image = @"PPT.png";
        }
        else if ([@"application/powerpoint" compare:[element objectForKey:@"mime"]] == NSOrderedSame) {
            image = @"PPT.png";
        }
        else if ([@"application/x-mspowerpoint" compare:[element objectForKey:@"mime"]] == NSOrderedSame) {
            image = @"PPT.png";
        }
        else if ([@"application/vnd.ms-powerpoint" compare:[element objectForKey:@"mime"]] == NSOrderedSame) {
            image = @"PPT.png";
        }
        else if ([@"application/vnd.openxmlformats-officedocument.presentationml.presentation" compare:[element objectForKey:@"mime"]] == NSOrderedSame) {
            image = @"PPT.png";
        }
        else if ([@"application/octet-stream" compare:[element objectForKey:@"mime"]] == NSOrderedSame) {
            image = @"PSD.png";
        }
        else if ([@"application/x-excel" compare:[element objectForKey:@"mime"]] == NSOrderedSame) {
            image = @"XLS.png";
        }
        else if ([@"application/vnd.ms-excel" compare:[element objectForKey:@"mime"]] == NSOrderedSame) {
            image = @"XLS.png";
        }
        else if ([@"application/excel" compare:[element objectForKey:@"mime"]] == NSOrderedSame) {
            image = @"XLS.png";
        }
        else if ([@"application/x-msexcel" compare:[element objectForKey:@"mime"]] == NSOrderedSame) {
            image = @"XLS.png";
        }
        else if ([@"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" compare:[element objectForKey:@"mime"]] == NSOrderedSame) {
            image = @"XLS.png";
        }
        else if ([@"application/x-compressed" compare:[element objectForKey:@"mime"]] == NSOrderedSame) {
            image = @"ZIP.png";
        }
        else if ([@"application/x-zip-compressed" compare:[element objectForKey:@"mime"]] == NSOrderedSame) {
            image = @"ZIP.png";
        }
        else if ([@"application/zip" compare:[element objectForKey:@"mime"]] == NSOrderedSame) {
            image = @"ZIP.png";
        }
        else if ([@"multipart/x-zip" compare:[element objectForKey:@"mime"]] == NSOrderedSame) {
            image = @"ZIP.png";
        }
        cell.imageView.image = [UIImage imageNamed:image];
        
    }
    else if (indexPath.section == addSection) {
        cell.textLabel.text = @"Add Folder";
        cell.textLabel.alpha = 0.6f;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.imageView.image = [UIImage imageNamed:@"addFolder.png"];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.opaque = NO;
    cell.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7f];
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section == filesSection);
}

#pragma mark -
#pragma mark UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == selectSection) {
        [self.multiTableController folderSelected:self.directory];
    }
    else if (indexPath.section == filesSection) {
        if (indexPath.row >= [_list count]) { return; }
        
        NSDictionary* element = [_list objectAtIndex:indexPath.row];
        if ([element[@"mime"] isEqual: @"application/x-directory"]) {
            NSString* newDirectory = [NSString stringWithFormat:@"%@%@%@", self.directory, element[@"name"], @"/"];
            SFBrowser* pushController = [[SFBrowser alloc] initWithDirectory:newDirectory];
            pushController.showFoldersOnly = self.showFoldersOnly;
            self.child = pushController;
            [self.multiTableController pushViewController:pushController asChildOf:self animated:YES];
        }
        else {
            NSString* file = [NSString stringWithFormat:@"%@%@", self.directory, element[@"name"]];
            [engine downloadFile:file
                onProgressChange:nil
                    onCompletion:^(NSData* downFile) {
                        // Save the file to the local cache
                        NSString* path = [[self cacheDirectoryName] stringByAppendingPathComponent:element[@"name"]];
                        NSError* error;
                        [downFile writeToFile:path options:NSDataWritingAtomic error:&error];
                        if (error) {
                            DLog(@"%@", [error localizedDescription]);
                        }
                        
                        SHFloatingViewController* floatingView = [[SHFloatingViewController alloc] initWithURL:[NSURL fileURLWithPath:path isDirectory:NO]];
                        floatingView.HTTPpath = file;
                        floatingView.engine = engine;
                        [self.multiTableController addFloatingView:floatingView withSender:self];
                    }
                         onError:^(MKNetworkOperation* op, NSError* error) {
                             DLog(@"%@\t%@\t%@\t%@", [error localizedDescription], [error localizedFailureReason],
                                  [error localizedRecoveryOptions], [error localizedRecoverySuggestion]);
                         }];
        }
    }
    else if (indexPath.section == addSection) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self makeDirectory];
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
             [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:indexPath.row inSection:filesSection]] withRowAnimation:UITableViewRowAnimationAutomatic];
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
