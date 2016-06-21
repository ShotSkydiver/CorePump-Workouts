//
//  VibrantTextField.h
//  CorePump Workouts
//
//  Created by Conner Owen on 6/15/16.
//  Copyright © 2016 CorePump. All rights reserved.
//

#import <UIKit/UIKit.h>

/** VibrantTextField **/

typedef enum {
    
    VibrantTextFieldStyleInvert,
    VibrantTextFieldStyleTranslucent,
    VibrantTextFieldStyleFill
    
} VibrantTextFieldStyle;

@interface VibrantTextField : UITextField <UITextFieldDelegate>

@property (nonatomic, assign) BOOL animated;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, assign) CGFloat alpha;
@property (nonatomic, assign) CGFloat invertAlphaHighlighted;
@property (nonatomic, assign) CGFloat translucencyAlphaNormal;
@property (nonatomic, assign) CGFloat translucencyAlphaHighlighted;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) UIRectCorner roundingCorners;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, copy)   NSString *text;
@property (nonatomic, copy)   NSString *placeholder;
@property (nonatomic, strong) UIFont *font;

@property (nonatomic, assign) id<UITextFieldDelegate> delegate;

#ifdef __IPHONE_8_0
// the vibrancy effect to be applied on the button
@property (nonatomic, strong) UIVibrancyEffect *vibrancyEffect;
#endif

// the deprecated background color
@property (nonatomic, strong) UIColor *backgroundColor DEPRECATED_MSG_ATTRIBUTE("Use tintColor instead.");

@property (nonatomic, strong) UIColor *tintColor;

// this is the only method to initialize a vibrant button
- (instancetype)initWithFrame:(CGRect)frame style:(VibrantTextFieldStyle)style;

@end


/** TextVibrantOverlay **/

typedef enum {
    
    TextVibrantOverlayStyleNormal,
    TextVibrantOverlayStyleInvert
    
} TextVibrantOverlayStyle;

@interface TextVibrantOverlay : UIView

// numeric configurations
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) UIRectCorner roundingCorners;
@property (nonatomic, assign) CGFloat borderWidth;

// icon image
@property (nonatomic, strong) UIImage *icon;

// display text
@property (nonatomic, copy)   NSString *text;
@property (nonatomic, copy)   NSString *placeholder;
@property (nonatomic, strong) UIFont *font;

// the deprecated background color
@property (nonatomic, strong) UIColor *backgroundColor DEPRECATED_MSG_ATTRIBUTE("Use tintColor instead.");

// tint color
@property (nonatomic, strong) UIColor *tintColor;

- (instancetype)initWithStyle:(TextVibrantOverlayStyle)style;

@end
