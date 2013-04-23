/*
 *  Smart BOX - Intelligent Management for your Smart Files.
 *  Copyright (C) 2013  Team Winnovation (Eric Lovelace and Levi Miller)
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

#import "SHMultiTableViewController.h"
#import "SHTableViewController.h"
#import "SHFloatingViewController.h"
#import "SFBrowser.h"
#import "SmartFileEngine.h"
#import "SHAppDelegate.h"
#import "UIImage+Rotate.h"

@interface SHMultiTableViewController () <UIScrollViewDelegate>
{
}

@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) NSArray* tableViewStack;
@property (nonatomic, strong) NSNumber* singleTableViewWidth;
@property (nonatomic, strong) NSNumber* xOrigin;
@property (nonatomic, strong) NSArray* floatingViews;
@property (nonatomic, strong) UIImageView* headerBG;
@property (nonatomic, strong) SHFloatingViewController* folderSelectionRecipient;

@property (nonatomic, strong) NSString* username;

- (void)setFoldersOnlyON;
- (void)setFoldersOnlyOFF;

@end

@implementation SHMultiTableViewController

@synthesize bgImageView = _bgImageView;

#pragma mark -
#pragma mark Accessors and Mutators

- (void)setFoldersOnly:(BOOL)foldersOnly {
    if (_foldersOnly == foldersOnly) { return; }
    _foldersOnly = foldersOnly;
    if (foldersOnly) {
        [self setFoldersOnlyON];
    } else {
        [self setFoldersOnlyOFF];
    }
}

- (void)setFoldersOnlyON {
    for (SFBrowser* table in self.tableViewStack) {
        [table setShowFoldersOnly:YES];
    }
    
}
- (void)setFoldersOnlyOFF {
    for (SFBrowser* table in self.tableViewStack) {
        [table setShowFoldersOnly:NO];
    }
}

- (UIImageView *)bgImageView {
    if (_bgImageView) { return _bgImageView; }
    
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageByRotatingImage:[UIImage imageNamed:@"background.png"] degrees:270.0f]];
        _bgImageView.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.height, self.view.frame.size.width);
    } else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageByRotatingImage:[UIImage imageNamed:@"background.png"] degrees:90.0f]];
        _bgImageView.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.height, self.view.frame.size.width);
    } else {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
        _bgImageView.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    }
    return _bgImageView;
}
- (void)setBgImageView:(UIImageView *)bgImageView {
    if (_bgImageView == bgImageView) {
        return;
    }
    if (_bgImageView) {
        [_bgImageView removeFromSuperview];
    }
    _bgImageView = bgImageView;
    [self.view addSubview:_bgImageView];
    [self.view sendSubviewToBack:_bgImageView];
}

- (SmartFileEngine *)engine {
    return ApplicationDelegate.SFEngine;
}

- (void)setUsername:(NSString *)username {
    if (!self.foldersOnly) {
        self.title = [username stringByAppendingString:@"'s Smart BOX"];
    }
    _username = username;
}

#pragma mark -
#pragma mark Initialize

- (id)initWithBaseController:(SFBrowser *)base {
    self = [super init];
    if (self) {
        base.multiTableController = self;
        self.tableViewStack = [NSArray arrayWithObject:base];
        self.singleTableViewWidth = @300;
        self.xOrigin = 0;
        self.floatingViews = [NSArray array];
        
        [self.engine getCurrentUserOnCompletion:^(NSString *user) {
            self.username = user;
        } onError:^(MKNetworkOperation *completedOperation, NSError *error) {
            DLog(@"%@\t%@\t%@\t%@", [error localizedDescription], [error localizedFailureReason],
                 [error localizedRecoveryOptions], [error localizedRecoverySuggestion]);
        }];
    }
    
    return self;
}

- (void)viewDidLoad {
    [self.view addSubview:self.bgImageView];
    [self.view sendSubviewToBack:self.bgImageView];

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    SFBrowser* base = self.tableViewStack[0];
    base.depth = 0;
    base.view.frame = CGRectMake([self.xOrigin floatValue], 0.0f, [self.singleTableViewWidth floatValue], self.scrollView.frame.size.height);
    self.xOrigin = [NSNumber numberWithFloat:([self.xOrigin floatValue] + [self.singleTableViewWidth floatValue])];
    [self.scrollView addSubview:base.view];
    self.scrollView.contentSize = CGSizeMake([self.singleTableViewWidth floatValue], self.scrollView.frame.size.height);
    [self.view addSubview:self.scrollView];
}


- (void)pushViewController:(UIViewController*)controller asChildOf:(SHTableViewController *)parent animated:(BOOL)animated {
    if (([[self.tableViewStack lastObject] depth]) > [parent depth] && [self.tableViewStack count] > ([parent depth] + 1)) {
        [self.tableViewStack[[parent depth] + 1] pop];
    }
    
    SHTableViewController* c = (SHTableViewController *)controller;
    c.multiTableController = self;
    
    c.depth = [[self.tableViewStack lastObject] depth] + 1;
    [[self.tableViewStack lastObject] setChild:c];
    
    self.tableViewStack = [self.tableViewStack arrayByAddingObject:c];
    c.view.frame = CGRectMake([self.xOrigin floatValue], 0, [self.singleTableViewWidth floatValue], self.scrollView.frame.size.height);
    self.xOrigin = [NSNumber numberWithFloat:([self.xOrigin floatValue] + [self.singleTableViewWidth floatValue])];
    [self.scrollView addSubview:c.view];
    self.scrollView.contentSize = CGSizeMake([self.xOrigin floatValue], self.scrollView.frame.size.height);
    
    if (self.scrollView.contentSize.width > self.view.frame.size.width) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentSize.width - self.view.frame.size.width, self.scrollView.contentOffset.y) animated:YES];
    }
}


- (void)popViewController {
    if ([self.xOrigin floatValue] == 0.0f) {
        return;
    }
    
    [UIView animateWithDuration:.2 animations:^(void){
        [[[self.tableViewStack lastObject] view ]removeFromSuperview];
        self.scrollView.contentSize = CGSizeMake([self.xOrigin floatValue], self.scrollView.frame.size.height);
        self.xOrigin = [NSNumber numberWithFloat:([self.xOrigin floatValue] - [self.singleTableViewWidth floatValue])];
        self.tableViewStack = [self.tableViewStack subarrayWithRange:NSMakeRange(0, self.tableViewStack.count - 1)];
    }completion:^(BOOL finished){
    }];
    
}

- (void)reloadAllTableViews {
    for (SHTableViewController* e in self.tableViewStack) {
        [e.tableView reloadData];
    }
}


- (void)addFloatingView:(SHFloatingViewController *) floatingViewController withSender:(SHTableViewController *)parent{
    floatingViewController.multiTableController = self;
    floatingViewController.parent = parent;
    self.floatingViews = [self.floatingViews arrayByAddingObject:floatingViewController];
    [self.view addSubview:floatingViewController.view];
}

- (void)bringToFrontFloatingView:(SHFloatingViewController *) floatingViewController {
    [self.view bringSubviewToFront:floatingViewController.view];
}


- (void)removeFloatingView:(SHFloatingViewController *) floatingViewController {
    [self removeFloatingView:floatingViewController refresh:NO];
}


- (void)removeFloatingView:(SHFloatingViewController *) floatingViewController refresh:(BOOL)flag {
    for (int i = 0; i < [self.floatingViews count]; i++) {
        if (self.floatingViews[i] == floatingViewController) {
            NSMutableArray* mutable = [self.floatingViews mutableCopy];
            [mutable removeObject:floatingViewController];
            self.floatingViews = mutable;
            if (flag) {[floatingViewController.parent pull];}
            [floatingViewController.view removeFromSuperview];
            
            return;
        }
    }
}


- (void)selectFolderForFloatingView:(SHFloatingViewController*) fv {
    [UIView animateWithDuration:0.5f animations:^{
        self.foldersOnly = YES;
        [self hideAllFloatingViews];
        self.title = @"Select a Destination Folder";
    } completion:^(BOOL finished) {
        self.folderSelectionRecipient = fv;
    }];
}

- (void)hideAllFloatingViews {
    for (SHFloatingViewController* e in _floatingViews) {
        e.view.hidden = YES;
    }
}

- (void)showAllFloatingViews {
    for (SHFloatingViewController* e in _floatingViews) {
        e.view.hidden = NO;
    }
}


- (void)folderSelected:(NSString*)folder {
    [UIView animateWithDuration:0.5f animations:^{
        self.foldersOnly = NO;
        [self showAllFloatingViews];
        self.title = [self.username stringByAppendingString:@"'s Smart BOX"];
    } completion:^(BOOL finished) {
        NSString* uploadDoc = [self.folderSelectionRecipient.previewItemURL absoluteString];
        if ([[uploadDoc substringToIndex:16] compare:@"file://localhost"] == NSOrderedSame) {
            uploadDoc = [uploadDoc substringFromIndex:16];
            uploadDoc = [uploadDoc stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
        }
        [self.engine upload: uploadDoc
                         to: folder
               onCompletion:^(NSString *task) {
        }
                    onError:^(MKNetworkOperation *completedOperation, NSError *error) {
                        DLog(@"%@\t%@\t%@\t%@", [error localizedDescription], [error localizedFailureReason], [error localizedRecoveryOptions], [error localizedRecoverySuggestion]);
                        
        }];
    }];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        self.bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageByRotatingImage:[UIImage imageNamed:@"background.png"] degrees:270.0f]];
    } else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        self.bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageByRotatingImage:[UIImage imageNamed:@"background.png"] degrees:90.0f]];
    } else {
        self.bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    }
    self.bgImageView.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.scrollView.autoresizesSubviews = NO;
    self.scrollView.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.view.frame.size.height);
}

@end


