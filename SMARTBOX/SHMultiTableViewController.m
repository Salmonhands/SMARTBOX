//
//  SHMultiTableViewController.m
//  SMARTBOX
//
//  Created by macadmin on 4/12/13.
//  Copyright (c) 2013 Salmonhands. All rights reserved.
//

#import "SHMultiTableViewController.h"
#import "SHTableViewController.h"
#import "SHFloatingViewController.h"
#import "SFBrowser.h"
#import "SmartFileEngine.h"

@interface SHMultiTableViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UIView* headerView;
@property (nonatomic, strong) NSArray* tableViewStack;
@property (nonatomic, strong) NSNumber* singleTableViewWidth;
@property (nonatomic, strong) NSNumber* xOrigin;
@property (nonatomic, strong) NSArray* floatingViews;
@property (nonatomic, strong) UIImageView* headerBG;
@property (nonatomic, strong) UILabel* headerLabel;
@property (nonatomic, strong) SHFloatingViewController* folderSelectionRecipient;

- (void)setFoldersOnlyON;
- (void)setFoldersOnlyOFF;

- (void)exposeHeader;
- (void)hideHeader;

@end

@implementation SHMultiTableViewController

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
    if (_engine == nil) {
        NSMutableDictionary* headerFields = [NSMutableDictionary dictionary];
        [headerFields setValue:@"Basic ODM4a05MY0JJME5OSk5mc0hIc25KdTZ2MFZkRFlvOk9iaHpJYWRPRUh5ZjVlZHVYMTRBQWFTTnN4MWxTcg=="
                        forKey:@"Authorization"];
        
        _engine = [[SmartFileEngine alloc] initWithHostName:@"app.smartfile.com"
                                                   apiPath:@"api/2"
                                        customHeaderFields:headerFields];
    }
    return _engine;
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
    }
    
    return self;
}

- (void)viewDidLoad {
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, -51.0f, self.view.frame.size.width, 50.0f)];
    self.headerView.backgroundColor = [UIColor blackColor];
    
    self.headerBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gradient.png"]];
    self.headerBG.frame = CGRectMake(-self.view.frame.size.width/2, 0, self.view.frame.size.width*2, 50.0f);
    [self.headerView addSubview:self.headerBG];
    
    self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50.0f)];
    self.headerLabel.text = @"Select Folder to Save";
    self.headerLabel.textAlignment = NSTextAlignmentCenter;
    self.headerLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    self.headerLabel.textColor = [UIColor whiteColor];
    self.headerLabel.backgroundColor = [UIColor clearColor];
    [self.headerView addSubview:self.headerLabel];
    [self.headerView bringSubviewToFront:self.headerLabel];
    
    [self.view addSubview:self.headerView];
    
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
        [self exposeHeader];
        [self hideAllFloatingViews];
    } completion:^(BOOL finished) {
        self.folderSelectionRecipient = fv;
    }];
}
- (void)exposeHeader {
     float x = self.view.frame.origin.x;
     float y = self.view.frame.origin.y;
     float w = self.view.frame.size.width;
     float h = self.view.frame.size.height;
     self.view.frame = CGRectMake(x, y + 50.0f, w, h);
     
     w = self.scrollView.contentSize.width;
     h = self.scrollView.contentSize.height;
     self.scrollView.contentSize = CGSizeMake(w, h - 50.0f);
     
     x = self.bgImageView.frame.origin.x;
     y = self.bgImageView.frame.origin.y;
     w = self.bgImageView.frame.size.width;
     h = self.bgImageView.frame.size.height;
     self.bgImageView.frame = CGRectMake(x, y - 50.0f, w, h);
}
- (void)hideHeader {
    float x = self.view.frame.origin.x;
    float y = self.view.frame.origin.y;
    float w = self.view.frame.size.width;
    float h = self.view.frame.size.height;
    self.view.frame = CGRectMake(x, y - 50.0f, w, h);
    
    w = self.scrollView.contentSize.width;
    h = self.scrollView.contentSize.height;
    self.scrollView.contentSize = CGSizeMake(w, h + 50.0f);
    
    x = self.bgImageView.frame.origin.x;
    y = self.bgImageView.frame.origin.y;
    w = self.bgImageView.frame.size.width;
    h = self.bgImageView.frame.size.height;
    self.bgImageView.frame = CGRectMake(x, y + 50.0f, w, h);
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
        [self hideHeader];
        [self showAllFloatingViews];
    } completion:^(BOOL finished) {
        NSString* uploadDoc = [self.folderSelectionRecipient.previewItemURL absoluteString];
        if ([[uploadDoc substringToIndex:16] compare:@"file://localhost"] == NSOrderedSame) {
            uploadDoc = [uploadDoc substringFromIndex:16];
            uploadDoc = [uploadDoc stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
        }
        [self.engine upload: uploadDoc
                         to: folder
               onCompletion:^(NSString *task) {
                   DLog(@"blahg");
        }
                    onError:^(MKNetworkOperation *completedOperation, NSError *error) {
                        
        }];
    }];
}


@end


