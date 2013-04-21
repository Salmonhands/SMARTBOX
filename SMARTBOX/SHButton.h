//
//  SHButton.h
//  SMARTBOX
//
//  Created by macadmin on 4/21/13.
//  Copyright (c) 2013 Salmonhands. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>


@interface SHButton : UIButton
{
    
}

// These button methods for color changing originally by github user ayanok
// https://github.com/ayanok/AYUIButton
// Updated for ARC
- (void) setBackgroundColor:(UIColor *) _backgroundColor forState:(UIControlState) _state;
- (UIColor*) backgroundColorForState:(UIControlState) _state;

@end