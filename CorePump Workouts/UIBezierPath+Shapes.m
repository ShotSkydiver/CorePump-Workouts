//
//  UIBezierPath+Shapes.m
//  CBZSplashView
//
//  Created by Mazyad Alabduljaleel on 8/8/14.
//  Copyright (c) 2014 Callum Boddy. All rights reserved.
//

#import "UIBezierPath+Shapes.h"

@implementation UIBezierPath (Shapes)

+ (instancetype)corepumpShape
{
    //// Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(73.13, 86.01)];
    [bezierPath addLineToPoint: CGPointMake(26.7, 86.01)];
    [bezierPath addLineToPoint: CGPointMake(49.96, 54.34)];
    [bezierPath addLineToPoint: CGPointMake(73.13, 86.01)];
    [bezierPath closePath];
    [bezierPath moveToPoint: CGPointMake(88.6, 87.1)];
    [bezierPath addLineToPoint: CGPointMake(57.26, 44.33)];
    [bezierPath addLineToPoint: CGPointMake(80.9, 12.08)];
    [bezierPath addCurveToPoint: CGPointMake(81.66, 4.92) controlPoint1: CGPointMake(82.46, 9.9) controlPoint2: CGPointMake(82.74, 7.23)];
    [bezierPath addCurveToPoint: CGPointMake(75.56, 1.25) controlPoint1: CGPointMake(80.58, 2.66) controlPoint2: CGPointMake(78.25, 1.25)];
    [bezierPath addLineToPoint: CGPointMake(58.26, 1.25)];
    [bezierPath addCurveToPoint: CGPointMake(52.39, 7.22) controlPoint1: CGPointMake(54.97, 1.25) controlPoint2: CGPointMake(52.39, 3.87)];
    [bezierPath addCurveToPoint: CGPointMake(58.26, 13.16) controlPoint1: CGPointMake(52.39, 10.49) controlPoint2: CGPointMake(55.03, 13.16)];
    [bezierPath addLineToPoint: CGPointMake(65.51, 13.16)];
    [bezierPath addLineToPoint: CGPointMake(49.88, 34.39)];
    [bezierPath addLineToPoint: CGPointMake(34.32, 13.16)];
    [bezierPath addLineToPoint: CGPointMake(41.59, 13.16)];
    [bezierPath addCurveToPoint: CGPointMake(47.44, 7.22) controlPoint1: CGPointMake(44.76, 13.16) controlPoint2: CGPointMake(47.44, 10.44)];
    [bezierPath addCurveToPoint: CGPointMake(41.59, 1.25) controlPoint1: CGPointMake(47.44, 3.93) controlPoint2: CGPointMake(44.81, 1.25)];
    [bezierPath addLineToPoint: CGPointMake(24.28, 1.25)];
    [bezierPath addCurveToPoint: CGPointMake(18.19, 4.92) controlPoint1: CGPointMake(21.58, 1.25) controlPoint2: CGPointMake(19.25, 2.66)];
    [bezierPath addCurveToPoint: CGPointMake(18.94, 12.06) controlPoint1: CGPointMake(17.11, 7.23) controlPoint2: CGPointMake(17.39, 9.9)];
    [bezierPath addLineToPoint: CGPointMake(41.59, 42.89)];
    [bezierPath addLineToPoint: CGPointMake(41.58, 42.89)];
    [bezierPath addLineToPoint: CGPointMake(42.05, 43.52)];
    [bezierPath addLineToPoint: CGPointMake(42.65, 44.33)];
    [bezierPath addLineToPoint: CGPointMake(11.26, 87.09)];
    [bezierPath addCurveToPoint: CGPointMake(10.49, 94.26) controlPoint1: CGPointMake(9.69, 89.28) controlPoint2: CGPointMake(9.41, 91.95)];
    [bezierPath addCurveToPoint: CGPointMake(16.66, 98) controlPoint1: CGPointMake(11.7, 96.62) controlPoint2: CGPointMake(14, 98)];
    [bezierPath addLineToPoint: CGPointMake(83.18, 97.91)];
    [bezierPath addCurveToPoint: CGPointMake(89.33, 94.31) controlPoint1: CGPointMake(85.9, 97.91) controlPoint2: CGPointMake(88.14, 96.6)];
    [bezierPath addCurveToPoint: CGPointMake(88.6, 87.1) controlPoint1: CGPointMake(90.44, 91.94) controlPoint2: CGPointMake(90.16, 89.27)];
    [bezierPath closePath];
    
    return bezierPath;
}

@end
