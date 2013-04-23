//
//  UIImage+Rotate.m
//  SMARTBOX
//
//  Created by macadmin on 4/21/13.
//  Copyright (c) 2013 Salmonhands. All rights reserved.
//

#import "UIImage+Rotate.h"

@implementation UIImage (Rotate)

+(UIImage*)imageByRotatingImage:(UIImage*) src degrees:(float) degrees {
    UIView* rotatedViewBox = [[UIView alloc] initWithFrame: CGRectMake(0, 0, src.size.width, src.size.height)];
    float angleRadians = degrees * ((float)M_PI / 180.0f);
    CGAffineTransform t = CGAffineTransformMakeRotation(angleRadians);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    rotatedViewBox = nil;
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap, angleRadians);
    
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-src.size.width / 2, -src.size.height / 2, src.size.width, src.size.height), [src CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


@end
