//
//  SHFloatingViewController.m
//  test
//
//  Created by macadmin on 4/13/13.
//  Copyright (c) 2013 Salmonhands. All rights reserved.
//

#import "SHFloatingViewController.h"
#import "SHMultiTableViewController.h"
#import <QuickLook/QuickLook.h>

@interface SHFloatingViewController ()  <UIGestureRecognizerDelegate, QLPreviewControllerDataSource, QLPreviewControllerDelegate>
{
    CGPoint _priorPoint;
}

@property (nonatomic, strong) UIImageView* bgImage;
@property (nonatomic, strong, readonly) UIButton* clipboardShareButton;
@property (nonatomic, strong, readonly) UIButton* deleteButton;
@property (nonatomic, strong, readonly) UIButton* exitButton;
@property (nonatomic, strong, readonly) UIButton* moveButton;
@property (nonatomic, strong, readonly) UIButton* noteButton;
@property (nonatomic, strong, readonly) UIButton* viewButton;

@property (nonatomic, strong) NSURL* previewItemURL;

@end

@implementation SHFloatingViewController

@synthesize clipboardShareButton = _clipboardShareButton;
@synthesize deleteButton = _deleteButton;
@synthesize exitButton = _exitButton;
@synthesize moveButton = _moveButton;
@synthesize noteButton = _noteButton;
@synthesize viewButton = _viewButton;

#pragma mark - 
#pragma mark Propery Accessor/Mutators
-(UIButton *)clipboardShareButton {
    if (!_clipboardShareButton) {
        _clipboardShareButton = [[UIButton alloc] init];
        [_clipboardShareButton setImage:[UIImage imageNamed:@"clipboardshare.png"] forState:UIControlStateNormal];
        [_clipboardShareButton setImage:[UIImage imageNamed:@"clipboardshareT.png"] forState:UIControlStateSelected];
        [_clipboardShareButton setImage:[UIImage imageNamed:@"clipboardshareT.png"] forState:UIControlStateHighlighted];
        _clipboardShareButton.frame = CGRectMake(91, 370.0f, 35.0f, 35.0f);
        [_clipboardShareButton addTarget:self action:@selector(buttonTouchUpInsideClipboard:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clipboardShareButton;
}
-(UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [[UIButton alloc] init];
        [_deleteButton setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
        [_deleteButton setImage:[UIImage imageNamed:@"deleteT.png"] forState:UIControlStateSelected];
        [_deleteButton setImage:[UIImage imageNamed:@"deleteT.png"] forState:UIControlStateHighlighted];
        _deleteButton.frame = CGRectMake(260.0f, 370.0f, 35.0f, 35.0f);
        [_deleteButton addTarget:self action:@selector(buttonTouchUpInsideDelete:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
    
}
-(UIButton *)exitButton {
    if (!_exitButton) {
        _exitButton = [[UIButton alloc] init];
        [_exitButton setImage:[UIImage imageNamed:@"exit.png"] forState:UIControlStateNormal];
        [_exitButton setImage:[UIImage imageNamed:@"exitT.png"] forState:UIControlStateSelected];
        [_exitButton setImage:[UIImage imageNamed:@"exitT.png"] forState:UIControlStateHighlighted];
        _exitButton.frame = CGRectMake(2.0f, -6.0f, 35.0f, 35.0f);
        [_exitButton addTarget:self action:@selector(buttonTouchUpInsideExit:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exitButton;
    
}
- (UIButton *)moveButton {
    if (!_moveButton) {
        _moveButton = [[UIButton alloc] init];
        [_moveButton setImage:[UIImage imageNamed:@"moveFolder.png"] forState:UIControlStateNormal];
        [_moveButton setImage:[UIImage imageNamed:@"moveFolderT.png"] forState:UIControlStateSelected];
        [_moveButton setImage:[UIImage imageNamed:@"moveFolderT.png"] forState:UIControlStateHighlighted];
        _moveButton.frame = CGRectMake(203.0f, 370.0f, 35.0f, 35.0f);
        [_moveButton addTarget:self action:@selector(buttonTouchUpInsideMove:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moveButton;
    
}
- (UIButton *)noteButton {
    if (!_noteButton) {
        _noteButton = [[UIButton alloc] init];
        [_noteButton setImage:[UIImage imageNamed:@"note.png"] forState:UIControlStateNormal];
        [_noteButton setImage:[UIImage imageNamed:@"noteT.png"] forState:UIControlStateSelected];
        [_noteButton setImage:[UIImage imageNamed:@"noteT.png"] forState:UIControlStateHighlighted];
        _noteButton.frame = CGRectMake(147.0f, 395.0f, 35.0f, 35.0f);
        [_noteButton addTarget:self action:@selector(buttonTouchUpInsideNote:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _noteButton;
    
}
- (UIButton *)viewButton {
    if (!_viewButton) {
        _viewButton = [[UIButton alloc] init];
        [_viewButton setImage:[UIImage imageNamed:@"view.png"] forState:UIControlStateNormal];
        [_viewButton setImage:[UIImage imageNamed:@"viewT.png"] forState:UIControlStateSelected];
        [_viewButton setImage:[UIImage imageNamed:@"viewT.png"] forState:UIControlStateHighlighted];
        _viewButton.frame = CGRectMake(35.0f, 372.5f, 35.0f, 30.0f);
        [_viewButton addTarget:self action:@selector(buttonTouchUpInsideView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _viewButton;
    
}

#pragma mark -
#pragma mark Initializers
- (id)initWithURL:(NSURL *)url {
    self = [super init];
    if (self) {
        self.previewItemURL = url;
    }
    return self;
}

#pragma mark -
#pragma mark Button Handlers
- (void)buttonTouchUpInsideClipboard:(id)sender {
    
}
- (void)buttonTouchUpInsideDelete:(id)sender {
    
}
- (void)buttonTouchUpInsideExit:(id)sender {
    [self.multiTableController removeFloatingView:self];
}
- (void)buttonTouchUpInsideMove:(id)sender {
    
}
- (void)buttonTouchUpInsideNote:(id)sender {
    
}

- (void)backButtonSelected:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^(void){
    }];
    
    self.innerViewController.view.frame = CGRectMake(22.0f, 60.0f, self.view.frame.size.width - 40.0f, self.view.frame.size.height - 120.0f);
    [self.view addSubview:self.innerViewController.view];
}
- (void)buttonTouchUpInsideView:(id)sender {
    UIBarButtonItem* b = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonSelected:)];
    self.innerViewController.navigationItem.leftBarButtonItem = b;
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:self.innerViewController];
    
    [self presentViewController:nav animated:YES completion:^(void){}];
}


#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(10.0f, 10.0f, 320.0f, 425.0f);
    self.view.backgroundColor = [UIColor clearColor];

    if (self.previewItemURL) {
        QLPreviewController* preview = [[QLPreviewController alloc] init];
        preview.dataSource = self;
        preview.delegate = self;
        
        // start previewing the document at the current section index
        preview.currentPreviewItemIndex = 0;
        self.innerViewController = preview;
    }
    self.innerViewController.view.frame = CGRectMake(22.0f, 60.0f, self.view.frame.size.width - 40.0f, self.view.frame.size.height - 120.0f);
    
    self.bgImage =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detailLayoutBlank.png"]];
    self.bgImage.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view addSubview:self.bgImage];
    
    [self.view addSubview:self.innerViewController.view];
    
    [self.view addSubview:self.clipboardShareButton];
    [self.view addSubview:self.deleteButton];
    [self.view addSubview:self.exitButton];
    [self.view addSubview:self.moveButton];
    [self.view addSubview:self.noteButton];
    [self.view addSubview:self.viewButton];
    
    UILongPressGestureRecognizer* lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [lpgr setMinimumPressDuration:.1];
    [lpgr setDelegate:self];
    [self.view addGestureRecognizer:lpgr];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint point = [gestureRecognizer locationInView:self.view.superview];
        if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
            CGPoint center = self.view.center;
            center.x += point.x - _priorPoint.x;
            center.y += point.y - _priorPoint.y;
            self.view.center = center;
        }
        _priorPoint = point;
    }
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    // Disallow recognition of tap gestures in the buttons.
    if ((touch.view == self.clipboardShareButton)) { return NO; }
    if ((touch.view == self.deleteButton)) { return NO; }
    if ((touch.view == self.exitButton)) { return NO; }
    if ((touch.view == self.moveButton)) { return NO; }
    if ((touch.view == self.noteButton)) { return NO; }
    if ((touch.view == self.viewButton)) { return NO; }
    
    return YES;
}

#pragma mark -
#pragma mark QLPreviewControllerDataSource

// Returns the number of items that the preview controller should preview
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController
{
    NSInteger numToPreview = 1;
    
    return numToPreview;
}

- (void)previewControllerDidDismiss:(QLPreviewController *)controller
{
    // if the preview dismissed (done button touched), use this method to post-process previews
}

// returns the item that the preview controller should preview
- (id)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx
{
    return self.previewItemURL;
}


@end
