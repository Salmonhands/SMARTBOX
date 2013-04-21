//
//  SHLoginViewController.m
//  SMARTBOX
//
//  Created by macadmin on 4/20/13.
//  Copyright (c) 2013 Salmonhands. All rights reserved.
//

#import "SHLoginViewController.h"

@interface SHLoginViewController ()

@property (nonatomic, strong) UIView* loginWindow;
@property (nonatomic, strong) UIView* backgroundColorView;

@end

@implementation SHLoginViewController

- (UIView *)loginWindow {
    if (_loginWindow) { return _loginWindow; }
    
    CGFloat w = 270.0f;
    CGFloat h = 350.0f;
    _loginWindow = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - w)/2, self.view.frame.size.height + h, w, h)];
    
    // Add the background image
    UIImageView* bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detailLayoutBlank.png"]];
    bgImage.frame = CGRectMake(0.0f, 0.0f, 270.0f, 350.0f);
    [_loginWindow addSubview:bgImage];
    
    return _loginWindow;
}

- (UIView *)backgroundColorView {
    if (_backgroundColorView) { return _backgroundColorView; }
    
    _backgroundColorView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
    _backgroundColorView.backgroundColor = [UIColor colorWithRed:0.3f green:0.3f blue:0.3f alpha:0.9f];
    return _backgroundColorView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.backgroundColorView];
    [self.view addSubview:self.loginWindow];
}


- (void)animateLoginView {
    [UIView animateWithDuration:0.5f animations:^{
        CGFloat x = self.loginWindow.frame.origin.x;
        CGFloat y = self.loginWindow.frame.size.height / 4;
        CGFloat w = self.loginWindow.frame.size.width;
        CGFloat h = self.loginWindow.frame.size.height;
        self.loginWindow.frame = CGRectMake(x, y, w, h);
    } completion:^(BOOL finished) {
        //done
    }];
}

@end
