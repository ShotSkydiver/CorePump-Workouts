//
//  VibrantTextField.m
//  CorePump Workouts
//
//  Created by Conner Owen on 6/15/16.
//  Copyright © 2016 CorePump. All rights reserved.
//

#import "VibrantTextField.h"

#define kAYVibrantButtonDefaultAnimationDuration 0.15
#define kAYVibrantButtonDefaultAlpha 1.0
#define kAYVibrantButtonDefaultInvertAlphaHighlighted 1.0
#define kAYVibrantButtonDefaultTranslucencyAlphaNormal 1.0
#define kAYVibrantButtonDefaultTranslucencyAlphaHighlighted 0.5
#define kAYVibrantButtonDefaultCornerRadius 4.0
#define kAYVibrantButtonDefaultRoundingCorners UIRectCornerAllCorners
#define kAYVibrantButtonDefaultBorderWidth 0.6
#define kAYVibrantButtonDefaultFontSize 14.0
#define kAYVibrantButtonDefaultTintColor [UIColor whiteColor]

/** VibrantTextField **/

@interface VibrantTextField () {
    
    __strong UIColor *_tintColor;
}

@property (nonatomic, assign) VibrantTextFieldStyle style;

#ifdef __IPHONE_8_0
@property (nonatomic, strong) UIVisualEffectView *visualEffectView;
#endif

@property (nonatomic, strong) TextVibrantOverlay *normalOverlay;
@property (nonatomic, strong) TextVibrantOverlay *highlightedOverlay;

@property (nonatomic, assign) BOOL activeTouch;
@property (nonatomic, assign) BOOL hideRightBorder;

- (void)createOverlays;
- (void)updateOverlayAlpha;

@end

/** TextVibrantOverlay **/

@interface TextVibrantOverlay () {
    
    __strong UIFont *_font;
    __strong UIColor *_tintColor;
}

@property (nonatomic, assign) TextVibrantOverlayStyle style;
@property (nonatomic, assign) CGFloat textHeight;
@property (nonatomic, assign) CGFloat placeholderHeight;
@property (nonatomic, assign) BOOL hideRightBorder;

- (void)_updateTextHeight;
- (void)_updatePlaceholderHeight;

@end


/** VibrantTextField **/

@implementation VibrantTextField

@dynamic delegate;

@synthesize text = _text;
@synthesize placeholder = _placeholder;
@synthesize font = _font;
//@synthesize tintColor = _tintColor;



- (instancetype)init {
    NSLog(@"must be initialized with initWithFrame:style:");
    return nil;
}


- (instancetype)initWithFrame:(CGRect)frame style:(VibrantTextFieldStyle)style {
    if (self = [super initWithFrame:frame]) {
        
        self.style = style;
        self.opaque = NO;
        self.userInteractionEnabled = YES;
        self.clipsToBounds = YES;
        
        self.delegate = self;
        
        
        // default values
        _animated = YES;
        _animationDuration = kAYVibrantButtonDefaultAnimationDuration;
        _cornerRadius = kAYVibrantButtonDefaultCornerRadius;
        _roundingCorners = kAYVibrantButtonDefaultRoundingCorners;
        _borderWidth = kAYVibrantButtonDefaultBorderWidth;
        _invertAlphaHighlighted = kAYVibrantButtonDefaultInvertAlphaHighlighted;
        _translucencyAlphaNormal = kAYVibrantButtonDefaultTranslucencyAlphaNormal;
        _translucencyAlphaHighlighted = kAYVibrantButtonDefaultTranslucencyAlphaHighlighted;
        _alpha = kAYVibrantButtonDefaultAlpha;
        _activeTouch = NO;
        
        // create overlay views
        [self createOverlays];
        
#ifdef __IPHONE_8_0
        // add the default vibrancy effect
        self.vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
#endif
        
        [self addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragInside | UIControlEventEditingDidBegin];
        [self addTarget:self action:@selector(touchUp) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchDragOutside | UIControlEventEditingDidEndOnExit | UIControlEventEditingDidEnd];
    }
    return self;
}

- (void)textViewDidChange:(VibrantTextField *)textView {
    NSLog(@"textFieldDidChange");
    
    
}

- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    NSLog(@"vibranttextfield drawRect ");
    
}

- (void)layoutSubviews {
#ifdef __IPHONE_8_0
    self.visualEffectView.frame = self.bounds;
#endif
    self.normalOverlay.frame = self.bounds;
    self.highlightedOverlay.frame = self.bounds;
}

- (void)createOverlays {
    
    if (self.style == VibrantTextFieldStyleFill) {
        self.normalOverlay = [[TextVibrantOverlay alloc] initWithStyle:TextVibrantOverlayStyleInvert];
    } else {
        self.normalOverlay = [[TextVibrantOverlay alloc] initWithStyle:TextVibrantOverlayStyleNormal];
    }
    
    if (self.style == VibrantTextFieldStyleInvert) {
        self.highlightedOverlay = [[TextVibrantOverlay alloc] initWithStyle:TextVibrantOverlayStyleInvert];
        self.highlightedOverlay.alpha = 0.0;
    } else if (self.style == VibrantTextFieldStyleTranslucent || self.style == VibrantTextFieldStyleFill) {
        self.normalOverlay.alpha = self.translucencyAlphaNormal * self.alpha;
    }
    
#ifndef __IPHONE_8_0
    // for iOS 8, these two overlay views will be added as subviews in setVibrancyEffect:
    [self addSubview:self.normalOverlay];
    [self addSubview:self.highlightedOverlay];
#endif
}

- (void)updateOverlayAlpha {
    
    if (self.activeTouch) {
        NSLog(@"VibrantTextField updateOverlayAlpha activetouch");
        if (self.style == VibrantTextFieldStyleInvert) {
            self.normalOverlay.alpha = 0.0;
            self.highlightedOverlay.alpha = self.invertAlphaHighlighted * self.alpha;
        } else if (self.style == VibrantTextFieldStyleTranslucent || self.style == VibrantTextFieldStyleFill) {
            self.normalOverlay.alpha = self.translucencyAlphaHighlighted * self.alpha;
        }
    } else {
        NSLog(@"VibrantTextField updateOverlayAlpha notouch");
        if (self.style == VibrantTextFieldStyleInvert) {
            self.normalOverlay.alpha = self.alpha;
            self.highlightedOverlay.alpha = 0.0;
        } else if (self.style == VibrantTextFieldStyleTranslucent || self.style == VibrantTextFieldStyleFill) {
            self.normalOverlay.alpha = self.translucencyAlphaNormal * self.alpha;
        }
    }
}



#pragma mark - Control Event Handlers

- (void)touchDown {
    NSLog(@"VibrantTextField touchdown");
    self.activeTouch = YES;
    
    void(^update)(void) = ^(void) {
        if (self.style == VibrantTextFieldStyleInvert) {
            self.normalOverlay.alpha = 0.0;
            self.highlightedOverlay.alpha = self.alpha;
        } else if (self.style == VibrantTextFieldStyleTranslucent || self.style == VibrantTextFieldStyleFill) {
            self.normalOverlay.alpha = self.translucencyAlphaHighlighted * self.alpha;
        }
    };

    if (self.animated) {
        [UIView animateWithDuration:self.animationDuration animations:update];
    } else {
        update();
    }
}

- (void)touchUp {
    NSLog(@"VibrantTextField end editing");
    self.activeTouch = NO;

    void(^update)(void) = ^(void) {
        if (self.style == VibrantTextFieldStyleInvert) {
            self.normalOverlay.alpha = self.alpha;
            self.highlightedOverlay.alpha = 0.0;
        } else if (self.style == VibrantTextFieldStyleTranslucent || self.style == VibrantTextFieldStyleFill) {
            self.normalOverlay.alpha = self.translucencyAlphaNormal * self.alpha;
        }
    };
    
    if (self.animated) {
        [UIView animateWithDuration:self.animationDuration animations:update];
    } else {
        update();
    }
}

-(void) tintColorDidChange {
    NSLog(@"tintColorDidChange");
    self.textColor = self.tintColor;
}

#pragma mark - Override Getters

- (UIColor *)tintColor {
    return _tintColor == nil ? kAYVibrantButtonDefaultTintColor : _tintColor;
}

#pragma mark - Override Setters

- (void)setAlpha:(CGFloat)alpha {
    _alpha = alpha;
    [self updateOverlayAlpha];
}

- (void)setInvertAlphaHighlighted:(CGFloat)invertAlphaHighlighted {
    _invertAlphaHighlighted = invertAlphaHighlighted;
    [self updateOverlayAlpha];
}

- (void)setTranslucencyAlphaNormal:(CGFloat)translucencyAlphaNormal {
    _translucencyAlphaNormal = translucencyAlphaNormal;
    [self updateOverlayAlpha];
}

- (void)setTranslucencyAlphaHighlighted:(CGFloat)translucencyAlphaHighlighted {
    _translucencyAlphaHighlighted = translucencyAlphaHighlighted;
    [self updateOverlayAlpha];
}


- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.normalOverlay.cornerRadius = cornerRadius;
    self.highlightedOverlay.cornerRadius = cornerRadius;
}

- (void)setRoundingCorners:(UIRectCorner)roundingCorners {
    _roundingCorners = roundingCorners;
    self.normalOverlay.roundingCorners = roundingCorners;
    self.highlightedOverlay.roundingCorners = roundingCorners;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    self.normalOverlay.borderWidth = borderWidth;
    self.highlightedOverlay.borderWidth = borderWidth;
}

- (void)setIcon:(UIImage *)icon {
    _icon = icon;
    self.normalOverlay.icon = icon;
    self.highlightedOverlay.icon = icon;
}

- (void)setText:(NSString *)text {
    _text = [text copy];
    self.normalOverlay.text = text;
    self.highlightedOverlay.text = text;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = [placeholder copy];
    self.normalOverlay.placeholder = placeholder;
    self.highlightedOverlay.placeholder = placeholder;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    self.normalOverlay.font = font;
    self.highlightedOverlay.font = font;
}


#ifdef __IPHONE_8_0
- (void)setVibrancyEffect:(UIVibrancyEffect *)vibrancyEffect {
    
    _vibrancyEffect = vibrancyEffect;
    
    
    [self.normalOverlay removeFromSuperview];
    [self.highlightedOverlay removeFromSuperview];
    [self.visualEffectView removeFromSuperview];
    
    if (vibrancyEffect != nil) {
        self.visualEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
        self.visualEffectView.userInteractionEnabled = NO;
        [self.visualEffectView.contentView addSubview:self.normalOverlay];
        [self.visualEffectView.contentView addSubview:self.highlightedOverlay];
        [self addSubview:self.visualEffectView];
    } else {
        [self addSubview:self.normalOverlay];
        [self addSubview:self.highlightedOverlay];
    }
}
#endif

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    NSLog(@"AYVibrantButton: backgroundColor is deprecated and has no effect. Use tintColor instead.");
    //[super setBackgroundColor:backgroundColor];
    [self setTintColor:self.tintColor];
}

- (void)setTintColor:(UIColor *)tintColor {
    self.normalOverlay.tintColor = tintColor;
    self.highlightedOverlay.tintColor = tintColor;
}

- (void)setHideRightBorder:(BOOL)hideRightBorder {
    _hideRightBorder = hideRightBorder;
    self.normalOverlay.hideRightBorder = hideRightBorder;
    self.highlightedOverlay.hideRightBorder = hideRightBorder;
}


@end


/** TextVibrantOverlay **/

@implementation TextVibrantOverlay


- (instancetype)initWithStyle:(TextVibrantOverlayStyle)style {
    if (self = [self init]) {
        self.style = style;
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        
        _cornerRadius = kAYVibrantButtonDefaultCornerRadius;
        _roundingCorners = kAYVibrantButtonDefaultRoundingCorners;
        _borderWidth = kAYVibrantButtonDefaultBorderWidth;
        
        self.opaque = NO;
        self.userInteractionEnabled = NO;
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    NSLog(@"TextVibrantOverlay %u drawRect for: %@", self.style, self.text);
    CGSize size = self.bounds.size;
    if (size.width == 0 || size.height == 0) return;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds);
    
    [self.tintColor setStroke];
    [self.tintColor setFill];
    
    CGRect boxRect = CGRectInset(self.bounds, self.borderWidth / 2, self.borderWidth / 2);
    
    if (self.hideRightBorder) {
        boxRect.size.width += self.borderWidth * 2;
    }
    
    // draw background and border
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:boxRect byRoundingCorners:self.roundingCorners cornerRadii:CGSizeMake(self.cornerRadius, self.cornerRadius)];
    path.lineWidth = self.borderWidth;
    [path stroke];
    
    if (self.style == TextVibrantOverlayStyleInvert) {
        // fill the rounded rectangle area
        [path fill];
    }
    
    CGContextClipToRect(context, boxRect);
    
    // draw icon
    if (self.icon != nil) {
        NSLog(@"TextVibrantOverlay draw icon");
        CGSize iconSize = self.icon.size;
        CGRect iconRect = CGRectMake((size.width - iconSize.width) / 2,
                                     (size.height - iconSize.height) / 2,
                                     iconSize.width,
                                     iconSize.height);
        
        if (self.style == TextVibrantOverlayStyleNormal) {
            // ref: http://blog.alanyip.me/tint-transparent-images-on-ios/
            CGContextSetBlendMode(context, kCGBlendModeNormal);
            CGContextFillRect(context, iconRect);
            CGContextSetBlendMode(context, kCGBlendModeDestinationIn);
        } else if (self.style == TextVibrantOverlayStyleInvert) {
            // this will make the CGContextDrawImage below clear the image area
            CGContextSetBlendMode(context, kCGBlendModeDestinationOut);
        }
        
        CGContextTranslateCTM(context, 0, size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        
        // for some reason, drawInRect does not work here
        CGContextDrawImage(context, iconRect, self.icon.CGImage);
    }
    
    // draw text
    if ((self.text != nil) || (self.text.length > 0)) {
        NSLog(@"TextVibrantOverlay draw text: %@", self.text);
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.lineBreakMode = NSLineBreakByTruncatingTail;
        style.alignment = NSTextAlignmentLeft;
        
        if (self.style == TextVibrantOverlayStyleInvert) {
            // this will make the drawInRect below clear the text area
            CGContextSetBlendMode(context, kCGBlendModeClear);
            
        }
        
        //[self.text drawInRect:CGRectMake(2.0, (size.height - self.textHeight) / 2, size.width, self.textHeight) withAttributes:@{ NSFontAttributeName:self.font, NSForegroundColorAttributeName:self.tintColor, NSParagraphStyleAttributeName:style }];
        [self.text drawInRect:CGRectMake(5.0, (size.height - self.textHeight) / 2, size.width, self.textHeight) withAttributes:@{ NSFontAttributeName:self.font, NSForegroundColorAttributeName:self.tintColor, NSParagraphStyleAttributeName:style }];
    }
    
    // draw placeholder
    if ((self.placeholder != nil) && (self.text == nil)) {
        NSLog(@"TextVibrantOverlay draw placeholder: %@", self.placeholder);
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.lineBreakMode = NSLineBreakByTruncatingTail;
        style.alignment = NSTextAlignmentLeft;
        
        if (self.style == TextVibrantOverlayStyleInvert) {
            // this will make the drawInRect below clear the text area
            CGContextSetBlendMode(context, kCGBlendModeClear);
            [self setPlaceholder:@""];
        }
        
        
        [self.placeholder drawInRect:CGRectMake(5.0, (size.height - self.placeholderHeight) / 2, size.width, self.placeholderHeight) withAttributes:@{ NSFontAttributeName:self.font, NSForegroundColorAttributeName:self.tintColor, NSParagraphStyleAttributeName:style }];
    }
}


#pragma mark - Override Getters

- (UIFont *)font {
    return _font == nil ? [UIFont systemFontOfSize:kAYVibrantButtonDefaultFontSize] : _font;
}

- (UIColor *)tintColor {
    return _tintColor == nil ? kAYVibrantButtonDefaultTintColor : _tintColor;
}

#pragma mark - Override Setters

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self setNeedsDisplay];
}

- (void)setRoundingCorners:(UIRectCorner)roundingCorners {
    _roundingCorners = roundingCorners;
    [self setNeedsDisplay];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    [self setNeedsDisplay];
}

- (void)setIcon:(UIImage *)icon {
    _icon = icon;
    _text = nil;
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text {
    _icon = nil;
    _text = [text copy];
    [self _updateTextHeight];
    [self setNeedsDisplay];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _icon = nil;
    _placeholder = [placeholder copy];
    [self _updatePlaceholderHeight];
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font {
    _font = font;
    [self _updateTextHeight];
    [self setNeedsDisplay];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    NSLog(@"AYVibrantButtonOverlay: backgroundColor is deprecated and has no effect. Use tintColor instead.");
    [super setBackgroundColor:backgroundColor];
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    [self setNeedsDisplay];
}

- (void)setHideRightBorder:(BOOL)hideRightBorder {
    _hideRightBorder = hideRightBorder;
    [self setNeedsDisplay];
}

#pragma mark - Private Methods

- (void)_updateTextHeight {
    CGRect bounds = [self.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:self.font } context:nil];
    self.textHeight = bounds.size.height;
}

- (void)_updatePlaceholderHeight {
    CGRect bounds = [self.placeholder boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:self.font } context:nil];
    self.placeholderHeight = bounds.size.height;
}

@end

