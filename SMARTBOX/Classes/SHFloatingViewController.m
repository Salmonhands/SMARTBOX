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

#import "SHFloatingViewController.h"
#import "SHMultiTableViewController.h"
#import "SHTableViewController.h"
#import "SmartFileEngine.h"
#import <QuartzCore/QuartzCore.h>

@interface SHFloatingViewController ()  <UIGestureRecognizerDelegate, QLPreviewControllerDataSource, QLPreviewControllerDelegate>
{
}

@property (nonatomic, strong) UILongPressGestureRecognizer* longPressRecognizer;
@property (nonatomic) CGPoint longPressPoint;

@property (nonatomic) BOOL noteViewHidden;

@property (nonatomic, strong) UIImageView* bgImage;
@property (nonatomic, strong, readonly) UIButton* clipboardShareButton;
@property (nonatomic, strong, readonly) UIButton* deleteButton;
@property (nonatomic, strong, readonly) UIButton* exitButton;
@property (nonatomic, strong, readonly) UIButton* moveButton;
@property (nonatomic, strong, readonly) UIButton* noteButton;
@property (nonatomic, strong, readonly) UIButton* viewButton;

@property (nonatomic, strong) UIDocumentInteractionController* docInteractionController;

@property (nonatomic, readonly) CGRect innerFrame;

@property (nonatomic, strong) UIViewController* revealableView;
@property (nonatomic, strong) UITextField* revealableTextField;
@property (nonatomic, strong) UILabel* headerLabel;

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
        _viewButton.frame = CGRectMake(35.0f, 372.5f, 35.0f, 25.0f);
        [_viewButton addTarget:self action:@selector(buttonTouchUpInsideView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _viewButton;
    
}

- (CGRect)innerFrame {
    return CGRectMake(22.0f, 60.0f, self.view.frame.size.width - 40.0f, self.view.frame.size.height - 120.0f);
}

- (UIViewController *)innerViewController {
    if (_innerViewController != nil) { return _innerViewController; }
    
    _innerViewController = [[QLPreviewController alloc] init];
    _innerViewController.dataSource = self;
    _innerViewController.delegate = self;
    _innerViewController.currentPreviewItemIndex = 0;
    _innerViewController.view.frame = self.innerFrame;
    
    _innerViewController.title = self.fileName;
    
    UIBarButtonItem* b = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonSelected:)];
    _innerViewController.navigationItem.leftBarButtonItem = b;
    
    return _innerViewController;
}

-(UIImageView *)bgImage {
    if (_bgImage) { return _bgImage; }
    
    _bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detailLayoutBlank.png"]];
    _bgImage.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    return _bgImage;
}

-(UILongPressGestureRecognizer *)longPressRecognizer {
    if (_longPressRecognizer) { return  _longPressRecognizer; }
    
    _longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    _longPressRecognizer.minimumPressDuration = .1;
    _longPressRecognizer.delegate = self;
    return _longPressRecognizer;
}

- (NSString *)fileName {
    return [[[[self.previewItemURL absoluteString] componentsSeparatedByString:@"/"] lastObject] stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
}

- (UITextField*)revealableTextField {
    if (_revealableTextField) { return _revealableTextField; }
    
    _revealableTextField = [[UITextField alloc] init];
    _revealableTextField.borderStyle = UITextBorderStyleRoundedRect;
    
    return _revealableTextField;
}

- (UIViewController *)revealableView {
    if (_revealableView) { return _revealableView; }
    
    _revealableView = [[UIViewController alloc] init];
    
    CGFloat boxWidth = self.view.frame.size.width - 12.0f;
    CGFloat yCoord = (self.noteButton.frame.origin.y + self.noteButton.frame.size.height) - 300.0f - 10.0f;
    CGFloat xCoord = (self.noteButton.frame.origin.x + (self.noteButton.frame.size.width/2)) - (boxWidth/2) - 2.25f;
    CGRect oldCoord = CGRectMake(xCoord, yCoord, boxWidth, 300.0f);
    
    _revealableView.view.frame = oldCoord;
    _revealableView.view.backgroundColor = [UIColor blackColor];
    [_revealableView.view.layer setMasksToBounds:YES];
    [_revealableView.view.layer setCornerRadius:5.0f];
    
    self.revealableTextField.frame = CGRectMake(10.0f, 60.0f, boxWidth - 20.0f, 300.0f - 100.0f);
    [_revealableView.view addSubview:self.revealableTextField];
    return _revealableView;
}

-(UIDocumentInteractionController *)docInteractionController {
    if (_docInteractionController) { return _docInteractionController; }
    
    _docInteractionController = [UIDocumentInteractionController interactionControllerWithURL:self.previewItemURL];
    return _docInteractionController;
}

-(UILabel *)headerLabel {
    if (_headerLabel) { return _headerLabel; }
    
    CGRect frame = CGRectMake(40.0f, 10.0f, self.view.frame.size.width - 80.0f, 40.0f);
    _headerLabel = [[UILabel alloc] initWithFrame:frame];
    _headerLabel.text = self.fileName;
    _headerLabel.textAlignment = NSTextAlignmentCenter;
    _headerLabel.font = [UIFont boldSystemFontOfSize:21.0f];
    _headerLabel.textColor = [UIColor whiteColor];
    _headerLabel.backgroundColor = [UIColor clearColor];
    return _headerLabel;
}

#pragma mark -
#pragma mark Initializers
- (id)initWithURL:(NSURL *)url {
    self = [super init];
    if (self) {
        self.previewItemURL = url;
        self.noteViewHidden = YES;
    }
    return self;
}
#pragma mark -
#pragma mark view lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(10.0f, 10.0f, 320.0f, 425.0f);
    self.view.backgroundColor = [UIColor clearColor];
    self.view.autoresizesSubviews = NO;
    
    // Add views
    [self.view addSubview:self.bgImage];
    [self.view addSubview:self.innerViewController.view];
    [self.view addSubview:self.headerLabel];
    
    // Add buttons
    [self.view addSubview:self.clipboardShareButton];
    [self.view addSubview:self.deleteButton];
    [self.view addSubview:self.exitButton];
    [self.view addSubview:self.moveButton];
    [self.view addSubview:self.noteButton];
    [self.view addSubview:self.viewButton];
    
    // Add gesture recognizers
    [self.view addGestureRecognizer:self.longPressRecognizer];
}

#pragma mark -
#pragma mark Button Handlers
- (void)buttonTouchUpInsideClipboard:(id)sender {
    [self.docInteractionController presentOpenInMenuFromRect:CGRectMake(-15.0f, -10.0f, 50.0f, 50.0f)
                            inView:self.clipboardShareButton
                          animated:YES];
    
}
- (void)buttonTouchUpInsideDelete:(id)sender {
    if (self.HTTPpath) {
        [self.engine rm:self.HTTPpath
           onCompletion:^(NSDictionary *task) {
               NSArray *a = [self.HTTPpath componentsSeparatedByString:@"/"];
               [self.parent removeObjectWithName:[a lastObject]];
               [self.multiTableController removeFloatingView:self refresh:NO];
        }
                onError:^(MKNetworkOperation *completedOperation, NSError *error) {
                    DLog(@"%@\t%@\t%@\t%@", [error localizedDescription], [error localizedFailureReason], [error localizedRecoveryOptions], [error localizedRecoverySuggestion]);
        }];
    }
    
}
- (void)buttonTouchUpInsideExit:(id)sender {
    [self.multiTableController removeFloatingView:self refresh:NO];
}
- (void)buttonTouchUpInsideMove:(id)sender {
    [self.multiTableController selectFolderForFloatingView:self];
}
- (void)buttonTouchUpInsideNote:(id)sender {
    [self swapNoteView];
}

- (void)backButtonSelected:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^(void){}];
    self.innerViewController.view.frame = self.innerFrame;
    [self.view addSubview:self.innerViewController.view];
}
- (void)buttonTouchUpInsideView:(id)sender {
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:self.innerViewController];
    [self presentViewController:nav animated:YES completion:^(void){}];
}


#pragma mark -
#pragma mark Gesture Recognition
- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    [self.multiTableController bringToFrontFloatingView:self];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        self.longPressPoint = [gestureRecognizer locationInView:self.view.superview];
        return;
    }
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint point = [gestureRecognizer locationInView:self.view.superview];
        CGPoint center = self.view.center;
        center.x += point.x - self.longPressPoint.x;
        center.y += point.y - self.longPressPoint.y;
        self.view.center = center;
        self.longPressPoint = point;
        return;
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

- (void)exposeHiddenView {
    if (self.noteViewHidden == NO) { return; }

    CGFloat viewX = self.revealableView.view.frame.origin.x;
    CGFloat viewY = self.revealableView.view.frame.origin.y;
    CGFloat viewW = self.revealableView.view.frame.size.width;
    CGFloat viewH = self.revealableView.view.frame.size.height;
    CGRect newCoord = CGRectMake(viewX, viewY + viewH - 50.0f, viewW, viewH);
    
    CGRect buttonCoord = self.noteButton.frame;
    buttonCoord.origin.y = buttonCoord.origin.y + viewH - 50.0f;
    
    CGRect fullCoord = self.view.frame;
    fullCoord.size.height = fullCoord.size.height + viewH - 50.0f;
    
    // Frame now should be hidden behind the button
    [self.view addSubview:self.revealableView.view];
    [self.view sendSubviewToBack:self.revealableView.view];

    [UIView beginAnimations:nil context:NULL];
    self.revealableView.view.frame = newCoord;
    self.noteButton.frame = buttonCoord;
    self.view.frame = fullCoord;
    [UIView setAnimationDuration:0.5];
    [UIView commitAnimations];
    
    self.noteViewHidden = NO;
}
- (void)hideExposedView {
    if (self.noteViewHidden == YES) { return; }
    
    CGFloat w = self.revealableView.view.frame.size.width;
    CGFloat h = self.revealableView.view.frame.size.height;
    CGFloat y = self.revealableView.view.frame.origin.y - h + 50.0f;
    CGFloat x = self.revealableView.view.frame.origin.x;
    
    CGRect buttonCoord = self.noteButton.frame;
    buttonCoord.origin.y = buttonCoord.origin.y - h + 50.0f;
    
    CGRect fullCoord = self.view.frame;
    fullCoord.size.height = fullCoord.size.height -h + 50.0f;
    
    [UIView animateWithDuration:0.5
                     animations:^(void){
                         self.revealableView.view.frame = CGRectMake(x, y, w, h);
                         self.noteButton.frame = buttonCoord;
                         self.view.frame = fullCoord;
                     }completion:^(BOOL finished) {
                         [self.revealableView.view removeFromSuperview];
                         self.revealableView = nil;
                         self.noteViewHidden = YES;
                     }];
}
- (void)swapNoteView {
    if (self.noteViewHidden == YES) {
        [self exposeHiddenView];
    } else {
        [self hideExposedView];
    }
}

#pragma mark -
#pragma mark QLPreviewControllerDataSource

// Returns the number of items that the preview controller should preview
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController
{
    return 1;
}

// returns the item that the preview controller should preview
- (id)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx
{
    return self.previewItemURL;
}


@end
