//
//  SKSplashIcon.h
//  SKSplashView
//
//  Created by Sachin Kesiraju on 10/25/14.
//  Copyright (c) 2014 Sachin Kesiraju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSplashView.h"

@protocol SKSplashIconDelegate <NSObject>
@optional
- (void) splashIconView: (SKSplashIcon *) splashIconView didBeginAnimatingWithDuration: (float) duration;
- (void) splashIconViewDidEndAnimating: (SKSplashIcon *) splashIconView;

@end

typedef NS_ENUM(NSInteger, SKIconAnimationType)
{
    SKIconAnimationTypeBounce,
    SKIconAnimationTypeGrow,
    SKIconAnimationTypeShrink,
    SKIconAnimationTypeFade,
    SKIconAnimationTypePing, //supports network dependent animation
    SKIconAnimationTypeBlink, //supports network dependent animation
    SKIconAnimationTypeNone,
    SKIconAnimationTypeCustom
};

@interface SKSplashIcon : UIImageView

@property (strong, nonatomic) UIColor *iconColor; //Default: white
@property (nonatomic, assign) CGSize iconSize; //Default: 60x60
@property (strong, nonatomic) SKSplashView *splashView;


@property (weak, nonatomic) id <SKSplashIconDelegate> delegate;

- (instancetype) initWithImage: (UIImage *) iconImage;

- (instancetype) initWithImage: (UIImage *) iconImage animationType: (SKIconAnimationType) animationType;

- (void) setIconAnimationType: (SKIconAnimationType) animationType;
- (void) setCustomAnimation: (CAAnimation *) animation;
- (void) addObserverForAnimationNotification;
- (void) startAnimation;

@end