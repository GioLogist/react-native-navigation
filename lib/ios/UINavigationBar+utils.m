#import "UINavigationBar+utils.h"
#import "RNNFontAttributesCreator.h"


@implementation UINavigationBar (utils)

- (void)rnn_setBackIndicatorImage:(UIImage *)image {
    if (@available(iOS 13.0, *)) {
        [[self getNavigaitonBarStandardAppearance] setBackIndicatorImage:image transitionMaskImage:image];
        [[self getNavigaitonBarCompactAppearance] setBackIndicatorImage:image transitionMaskImage:image];
        [[self getNavigaitonBarScrollEdgeAppearance] setBackIndicatorImage:image transitionMaskImage:image];
    } else {
        [self setBackIndicatorImage:image];
        [self setBackIndicatorTransitionMaskImage:image];
    }
}

- (void)rnn_setBackgroundColor:(UIColor *)color {
    CGFloat bgColorAlpha = CGColorGetAlpha(color.CGColor);
    
    if (color && bgColorAlpha == 0.0) {
        self.translucent = YES;
        [self setBackgroundColorTransparent];
    } else {
        self.translucent = NO;
        [self setBackgroundColor:color];
    }
}

- (void)rnn_setNavigationBarLargeTitleFontFamily:(NSString *)fontFamily fontSize:(NSNumber *)fontSize fontWeight:(NSString *)fontWeight color:(UIColor *)color {
    NSDictionary* fontAttributes;
    if (@available(iOS 13.0, *)) {
        fontAttributes = [RNNFontAttributesCreator createFromDictionary:self.standardAppearance.largeTitleTextAttributes fontFamily:fontFamily fontSize:fontSize defaultFontSize:nil fontWeight:fontWeight color:color defaultColor:nil];
        [[self getNavigaitonBarStandardAppearance] setLargeTitleTextAttributes:fontAttributes];
        [[self getNavigaitonBarCompactAppearance] setLargeTitleTextAttributes:fontAttributes];
        [[self getNavigaitonBarScrollEdgeAppearance] setLargeTitleTextAttributes:fontAttributes];
    } else if (@available(iOS 11.0, *)) {
        fontAttributes = [RNNFontAttributesCreator createFromDictionary:self.largeTitleTextAttributes fontFamily:fontFamily fontSize:fontSize defaultFontSize:nil fontWeight:fontWeight color:color defaultColor:nil];
        self.largeTitleTextAttributes = fontAttributes;
    }
}

- (void)rnn_setNavigationBarTitleFontFamily:(NSString *)fontFamily fontSize:(NSNumber *)fontSize fontWeight:(NSString *)fontWeight color:(UIColor *)color {
    NSDictionary* fontAttributes;
    if (@available(iOS 13.0, *)) {
        fontAttributes = [RNNFontAttributesCreator createFromDictionary:self.standardAppearance.titleTextAttributes fontFamily:fontFamily fontSize:fontSize defaultFontSize:nil fontWeight:fontWeight color:color defaultColor:nil];
        [[self getNavigaitonBarStandardAppearance] setTitleTextAttributes:fontAttributes];
        [[self getNavigaitonBarCompactAppearance] setTitleTextAttributes:fontAttributes];
        [[self getNavigaitonBarScrollEdgeAppearance] setTitleTextAttributes:fontAttributes];
    } else if (@available(iOS 11.0, *)) {
        fontAttributes = [RNNFontAttributesCreator createFromDictionary:self.titleTextAttributes fontFamily:fontFamily fontSize:fontSize defaultFontSize:nil fontWeight:fontWeight color:color defaultColor:nil];
        self.titleTextAttributes = fontAttributes;
    }
}

- (void)rnn_showBorder:(BOOL)showBorder {
    if (@available(iOS 13.0, *)) {
        UIColor* shadowColor = showBorder ? [[UINavigationBarAppearance new] shadowColor] : nil;
        [[self getNavigaitonBarStandardAppearance] setShadowColor:shadowColor];
        [[self getNavigaitonBarCompactAppearance] setShadowColor:shadowColor];
        [[self getNavigaitonBarScrollEdgeAppearance] setShadowColor:shadowColor];
    } else {
        [self setShadowImage:showBorder ? nil : [UIImage new]];
    }
}

- (void)setBackgroundColor:(UIColor *)color {
    if (@available(iOS 13.0, *)) {
        [self getNavigaitonBarStandardAppearance].backgroundColor = color;
        [self getNavigaitonBarCompactAppearance].backgroundColor = color;
        [self getNavigaitonBarScrollEdgeAppearance].backgroundColor = color;
    } else {
        [super setBackgroundColor:color];
        self.barTintColor = color;
    }
}

- (void)setBackgroundColorTransparent {
    if (@available(iOS 13.0, *)) {
        UIColor* clearColor = [UIColor clearColor];
        [self getNavigaitonBarStandardAppearance].backgroundColor = clearColor;
        [self getNavigaitonBarCompactAppearance].backgroundColor = clearColor;
        [self getNavigaitonBarScrollEdgeAppearance].backgroundColor = clearColor;
        [self getNavigaitonBarStandardAppearance].backgroundEffect = nil;
        [self getNavigaitonBarCompactAppearance].backgroundEffect = nil;
        [self getNavigaitonBarScrollEdgeAppearance].backgroundEffect = nil;
        
    } else {
        [self setBackgroundColor:[UIColor clearColor]];
        self.shadowImage = [UIImage new];
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)configureWithTransparentBackground {
    if (@available(iOS 13.0, *)) {
        [[self getNavigaitonBarStandardAppearance] configureWithTransparentBackground];
        [[self getNavigaitonBarCompactAppearance] configureWithTransparentBackground];
        [[self getNavigaitonBarScrollEdgeAppearance] configureWithTransparentBackground];
    }
}

- (void)configureWithDefaultBackground {
    if (@available(iOS 13.0, *)) {
        [[self getNavigaitonBarStandardAppearance] configureWithDefaultBackground];
        [[self getNavigaitonBarCompactAppearance] configureWithDefaultBackground];
        [[self getNavigaitonBarScrollEdgeAppearance] configureWithDefaultBackground];
    }
}

- (UINavigationBarAppearance*)getNavigaitonBarStandardAppearance  API_AVAILABLE(ios(13.0)) {
    if (!self.standardAppearance) {
        self.standardAppearance = [UINavigationBarAppearance new];
    }
    return self.standardAppearance;
}

- (UINavigationBarAppearance*)getNavigaitonBarCompactAppearance  API_AVAILABLE(ios(13.0)) {
    if (!self.compactAppearance) {
        self.compactAppearance = [UINavigationBarAppearance new];
    }
    return self.compactAppearance;
}

- (UINavigationBarAppearance*)getNavigaitonBarScrollEdgeAppearance  API_AVAILABLE(ios(13.0)) {
    if (!self.scrollEdgeAppearance) {
        self.scrollEdgeAppearance = [UINavigationBarAppearance new];
    }
    return self.scrollEdgeAppearance;
}

@end
