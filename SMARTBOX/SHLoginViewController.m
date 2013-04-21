//
//  SHLoginViewController.m
//  SMARTBOX
//
//  Created by macadmin on 4/20/13.
//  Copyright (c) 2013 Salmonhands. All rights reserved.
//

#import "SHLoginViewController.h"
#import "SHButton.h"
#import <QuartzCore/QuartzCore.h>

@interface SHLoginViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UIView* loginWindow;
@property (nonatomic, strong) UIImageView* bgImage;
@property (nonatomic, strong) UITextField* usernameField;
@property (nonatomic, strong) UITextField* passwordField;
@property (nonatomic, strong) SHButton* submitButton;

@property (nonatomic, strong) UIView* backgroundColorView;

@property (nonatomic, readonly) float width;
@property (nonatomic, readonly) float height;

- (void)submitButtonPressed:(id) sender;

@end

@implementation SHLoginViewController

- (float)width {
    return 270.0f;
}

- (float)height {
    return 350.0f;
}

- (UIView *)loginWindow {
    if (_loginWindow) { return _loginWindow; }
    
    CGFloat w = self.width;
    CGFloat h = self.height;
    _loginWindow = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - w)/2, self.view.frame.size.height + h, w, h)];
    
    // Add the background image and fields
    [_loginWindow addSubview:self.bgImage];
    [_loginWindow addSubview:self.usernameField];
    [_loginWindow addSubview:self.passwordField];
    [_loginWindow addSubview:self.submitButton];
    
    return _loginWindow;
}

- (UIImageView *)bgImage {
    if (_bgImage) { return _bgImage; }
    
    _bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detailLayoutBlank.png"]];
    _bgImage.frame = CGRectMake(0.0f, 0.0f, self.width, self.height);
    return _bgImage;
}

- (UITextField *)usernameField {
    if (_usernameField) { return _usernameField; }
    
    CGFloat x = 40.0f;
    CGFloat y = 30.0f;
    CGFloat w = self.width - x*2;
    CGFloat h = 40.0f;
    _usernameField = [[UITextField alloc] initWithFrame:CGRectMake(x, y, w, h)];
    

    _usernameField.text = @"Username";
    _usernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _usernameField.delegate = self;
    _usernameField.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    _usernameField.layer.borderColor = [[UIColor grayColor] CGColor];
    _usernameField.layer.borderWidth = 1;
    _usernameField.layer.cornerRadius = 5;
    _usernameField.clipsToBounds = YES;
    _usernameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, h)];
    _usernameField.leftView = paddingView;
    _usernameField.leftViewMode = UITextFieldViewModeAlways;
    
    return _usernameField;
}

- (UITextField *)passwordField {
    if (_passwordField) { return _passwordField; }
    
    CGFloat x = 40.0f;
    CGFloat y = 80.0f;
    CGFloat w = self.width - x*2;
    CGFloat h = 40.0f;
    _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(x, y, w, h)];
    
    _passwordField.secureTextEntry = YES;
    _passwordField.text = @"Password";
    _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordField.delegate = self;
    _passwordField.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    _passwordField.layer.borderColor = [[UIColor grayColor] CGColor];
    _passwordField.layer.borderWidth = 1;
    _passwordField.layer.cornerRadius = 5;
    _passwordField.clipsToBounds = YES;
    _passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, h)];
    _passwordField.leftView = paddingView;
    _passwordField.leftViewMode = UITextFieldViewModeAlways;
    
    return _passwordField;
}

- (SHButton *)submitButton {
    if (_submitButton) { return _submitButton; }
    
    CGFloat x = 40.0f;
    CGFloat y = 140.0f;
    CGFloat w = self.width - x*2;
    CGFloat h = 40.0f;
    
    _submitButton = [[SHButton alloc] init];
    _submitButton.frame = CGRectMake(x, y, w, h);
    
    [_submitButton setTitle:@"Login" forState:UIControlStateNormal];
    [_submitButton setTitle:@"Login" forState:UIControlStateSelected];
    [_submitButton setTitle:@"Login" forState:UIControlStateHighlighted];
    [_submitButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    _submitButton.titleLabel.font = [UIFont boldSystemFontOfSize:19.0f];
    
    [_submitButton addTarget:self action:@selector(submitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_submitButton setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitButton setBackgroundColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_submitButton setBackgroundColor:[UIColor grayColor] forState:UIControlStateSelected];
    
    // Round the corners
    [_submitButton.layer setMasksToBounds:YES];
    [_submitButton.layer setCornerRadius:5.0f];
    
    // Apply a border
    [_submitButton.layer setBorderWidth:1.0f];
    [_submitButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
    
    // Give it a shadow
    // From UIButton+Glossy: https://github.com/GeorgeMcMullen/UIButton-Glossy
    if ([_submitButton.layer respondsToSelector:@selector(shadowOpacity)])
    {
        _submitButton.layer.shadowOpacity = 0.7;
        _submitButton.layer.shadowColor = [[UIColor blackColor] CGColor];
        _submitButton.layer.shadowOffset = CGSizeMake(0.0, 3.0);
        
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2)
        {
            _submitButton.layer.rasterizationScale=2.0;
        }
        _submitButton.layer.shouldRasterize = YES;
    }
    
    
    return _submitButton;
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
    CGFloat x = self.loginWindow.frame.origin.x;
    CGFloat y = self.loginWindow.frame.size.height / 4;
    CGFloat w = self.loginWindow.frame.size.width;
    CGFloat h = self.loginWindow.frame.size.height;
    
    [UIView animateWithDuration:0.5f animations:^{
        self.loginWindow.frame = CGRectMake(x, y, w, h);
    } completion:^(BOOL finished) {
        //done
    }];
}

- (void) submitButtonPressed:(id)sender {
    DLog(@"HERE");
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.usernameField) {
        if ([textField.text compare:@"Username"] == NSOrderedSame) {
            textField.text = @"";
        }
    }
    if (textField == self.passwordField) {
        if ([textField.text compare:@"Password"] == NSOrderedSame) {
            textField.text = @"";
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField.text compare: @""] == NSOrderedSame) {
        if (textField == self.usernameField) {
            self.usernameField.text = @"Username";
        } else if(textField == self.passwordField) {
            self.passwordField.text = @"Password";
        }
    }

}

@end
