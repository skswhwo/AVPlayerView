//
//  AVPlayerView.m
//  CrVideoPlayer
//
//  Created by ChoJaehyun on 2016. 7. 29..
//  Copyright © 2016년 com.skswhwo. All rights reserved.
//

#import "AVPlayerView.h"
#import "AVPlayerContentView.h"
#import "AVPlayerControlView.h"

@interface AVPlayerView ()
<AVPlayerContentViewDelegate>
{
    BOOL didAppearFlag;
    dispatch_once_t thumbnail_once;
    UIWindowLevel previousWindowLevel;
}
@property (strong, nonatomic) AVPlayerContentView *playerContentView;
@property (strong, nonatomic) UIView *fullScreenBackgroundView;

@end


@implementation AVPlayerView
- (void)initialize
{
    [self initializeProperties];
    [self initializePlayer];
    [self normalSizeMode];
}

- (id)initWithCoder:(NSCoder *)aCoder{
    if(self = [super initWithCoder:aCoder]){
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)rect{
    if(self = [super initWithFrame:rect]){
        [self initialize];
    }
    return self;
}

#pragma mark - Initialize
- (void)initializeProperties
{
    self.clipsToBounds      = YES;
    self.backgroundColor    = [UIColor blackColor];
    previousWindowLevel     = [[UIApplication sharedApplication] keyWindow].windowLevel;
    self.dimmedEffect       = true;
    self.pauseWhenDisappear = true;
    self.backgroundColorForFullSize = [UIColor blackColor];
}
- (void)initializePlayer
{
    _fullScreenBackgroundView = [[UIView alloc] init];
    _fullScreenBackgroundView.backgroundColor = [UIColor blackColor];
    [_fullScreenBackgroundView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    _playerContentView = [[AVPlayerContentView alloc] init];
    _playerContentView.delegate = self;
    [_playerContentView setTranslatesAutoresizingMaskIntoConstraints:NO];

    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:imageView toSuperView:_playerContentView edge:UIEdgeInsetsZero];
    _playerContentView.thumbnailView = imageView;

    AVPlayerControlView *controlView = [AVPlayerControlView getControlView];
    [self addSubview:controlView toSuperView:_playerContentView edge:UIEdgeInsetsZero];
    _playerContentView.controlView = controlView;
}

#pragma mark - Notifiation
- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)unregisterNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}
- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    if (self.didAppear) {
        self.didAppear(self);
    }
    if (self.autoplay) {
        [self.playerContentView playVideo];
    }
}
- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    if (self.didDisappear) {
        self.didDisappear(self);
    }
    if (self.pauseWhenDisappear) {
        [self.playerContentView pauseVideo];
    }
}

#pragma mark - Trigger
#pragma mark - Trigger
- (void)setItemURL:(NSURL *)itemURL
{
    _itemURL = itemURL;
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    
    AVPlayerItem *playerItem =[AVPlayerItem playerItemWithURL:itemURL];
    [self.playerContentView playerWithPlayerItem:playerItem time:kCMTimeZero];
    
    if (self.autoplay) {
        [self.playerContentView playVideo];
    } else if ([[itemURL scheme] hasPrefix:@"http"]) {
        [self.playerContentView stopVideo];
    }
}
- (void)playerWithContentURL:(NSURL *)url
{
    [self setItemURL:url];
}

#pragma mark - Setter
- (void)setLoop:(BOOL)loop {
    _loop = loop;
    self.playerContentView.loop = loop;
}

- (void)setAutoplay:(BOOL)autoplay {
    _autoplay = autoplay;
    if (autoplay) {
        [self.playerContentView playVideo];
    }
}

- (void)setShowControl:(BOOL)showControl {
    _showControl = showControl;
    [self.playerContentView setShowControl:showControl];
}

- (void)setGradientColorsAtBottom:(NSArray *)colors {
    [self.playerContentView setGradientColorsAtBottom:colors];
}

#pragma mark - View Callback
- (void)didMoveToWindow
{
    if (self.window)
    {
        didAppearFlag = true;
        [self registerNotification];
        [self performSelector:@selector(afterDidMoveToWindow) withObject:nil afterDelay:0.5];
    }
    else
    {
        didAppearFlag = false;
        [self unregisterNotification];
        if (self.didDisappear) {
            self.didDisappear(self);
        }
        if (self.pauseWhenDisappear) {
            [self.playerContentView stopVideo];
        }
    }
}

- (void)afterDidMoveToWindow
{
    if (didAppearFlag) {
        if (self.didAppear) {
            self.didAppear(self);
        }
        if (self.autoplay) {
            [self.playerContentView playVideo];
        }
    }
}

#pragma mark - AVPlayerView Delegate
- (void)playerViewClicked
{
    if (self.tapCallBack) {
        self.tapCallBack(self);
    }
}
- (void)playerViewChangeToFullScreen
{
    [self fullSizeMode];
}
- (void)playerViewChangeToNormalScreen
{
    [self normalSizeMode];
}
- (void)playerViewFailed
{
    self.failure(self);
}
- (void)playerViewCannotLoadThumbnail
{
    dispatch_once(&thumbnail_once, ^{
        self.failure(self);
    });
}
#pragma mark - Action
- (void)play
{
    [self.playerContentView playVideo];
}
- (void)pause
{
    [self.playerContentView pauseVideo];
}
- (void)normalSizeMode
{
    self.playerContentView.isFullSize = NO;
    
    [self.fullScreenBackgroundView removeFromSuperview];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    window.windowLevel = previousWindowLevel;
    [window layoutIfNeeded];
    
    CGRect targetRect = [self.superview convertRect:self.frame toView:window];
    self.playerContentView.controlView.alpha = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.playerContentView.frame = targetRect;
        if (self.dimmedEffect) {
            self.playerContentView.backgroundColor = [UIColor clearColor];
        }
        self.playerContentView.transform = CGAffineTransformMakeRotation(0);
        
    } completion:^(BOOL finished) {
        
        self.playerContentView.backgroundColor = [UIColor clearColor];
        self.playerContentView.controlView.alpha = 1;
        [self addSubview:self.playerContentView toSuperView:self edge:UIEdgeInsetsZero];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    }];
}

- (void)fullSizeMode
{
    self.playerContentView.isFullSize = YES;

    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    window.windowLevel = UIWindowLevelStatusBar;
    [self addSubview:self.playerContentView toSuperView:window edge:UIEdgeInsetsZero];
    [window layoutIfNeeded];

    CGRect rect = [self.superview convertRect:self.frame toView:window];
    self.playerContentView.frame = rect;
    self.playerContentView.controlView.alpha = 0;

    if (self.dimmedEffect == false) {
        self.playerContentView.backgroundColor = self.backgroundColorForFullSize;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.playerContentView.frame = window.bounds;
        
        if (self.dimmedEffect) {
            self.playerContentView.backgroundColor = self.backgroundColorForFullSize;
        }
        
    } completion:^(BOOL finished) {
        self.playerContentView.controlView.alpha = 1;
        [self addSubview:self.fullScreenBackgroundView toSuperView:window edge:UIEdgeInsetsZero];
        [window insertSubview:self.fullScreenBackgroundView belowSubview:self.playerContentView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }];
}

- (void)orientationChanged:(NSNotification *)notification
{
    if ([self needToForceChangeOrientation] == false) {
        [self rallbackScreenIfNeeded];
        return;
    }
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    UIView *superView = [self.playerContentView superview];
    if (orientation == UIDeviceOrientationPortrait) {

        [self addSubview:self.playerContentView toSuperView:superView edge:UIEdgeInsetsZero];
        self.playerContentView.controlView.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{

            self.playerContentView.bounds = superView.bounds;
            self.playerContentView.transform = CGAffineTransformMakeRotation(0);
            
        } completion:^(BOOL finished) {
            self.playerContentView.controlView.alpha = 1;
        }];

    } else if (orientation == UIDeviceOrientationLandscapeRight) {
        
        float margin = (superView.frame.size.height - superView.frame.size.width)/2;
        UIEdgeInsets edge = UIEdgeInsetsMake(margin, -margin, -margin, margin);
        [self addSubview:self.playerContentView toSuperView:superView edge:edge];
        self.playerContentView.controlView.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{
            
            self.playerContentView.bounds = CGRectMake(0, 0, superView.frame.size.height, superView.frame.size.width);
            self.playerContentView.transform = CGAffineTransformMakeRotation(-M_PI_2);
            
        } completion:^(BOOL finished) {
            self.playerContentView.controlView.alpha = 1;
        }];

    } else if (orientation == UIDeviceOrientationLandscapeLeft) {
        
        float margin = (superView.frame.size.height - superView.frame.size.width)/2;
        UIEdgeInsets edge = UIEdgeInsetsMake(margin, -margin, -margin, margin);
        [self addSubview:self.playerContentView toSuperView:superView edge:edge];
        self.playerContentView.controlView.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{
            
            self.playerContentView.bounds = CGRectMake(0, 0, superView.frame.size.height, superView.frame.size.width);
            self.playerContentView.transform = CGAffineTransformMakeRotation(M_PI_2);
            
        } completion:^(BOOL finished) {
            self.playerContentView.controlView.alpha = 1;
        }];
    }
}

#pragma mark - Condition
- (BOOL)isFullSize
{
    return self.playerContentView.isFullSize;
}

#pragma mark - Private
- (void)addSubview:(UIView *)subView toSuperView:(UIView *)superView edge:(UIEdgeInsets)edge
{
    if (subView == nil) {
        return;
    }
    [subView removeFromSuperview];
    [superView addSubview:subView];
    [superView addConstraint:[NSLayoutConstraint constraintWithItem:subView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:edge.top]];
    
    [superView addConstraint:[NSLayoutConstraint constraintWithItem:subView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:edge.bottom]];
    [superView addConstraint:[NSLayoutConstraint constraintWithItem:subView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superView
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1
                                                           constant:edge.left]];
    
    [superView addConstraint:[NSLayoutConstraint constraintWithItem:subView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superView
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1
                                                           constant:edge.right]];
}

- (void)rallbackScreenIfNeeded
{
    CGFloat angle = [self getViewAngle];
    if (angle != 0) {
        UIView *superView = [self.playerContentView superview];
        [self addSubview:self.playerContentView toSuperView:superView edge:UIEdgeInsetsZero];
        self.playerContentView.transform = CGAffineTransformMakeRotation(0);
    }
}

- (BOOL)needToForceChangeOrientation
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (orientation == UIDeviceOrientationPortrait) {
        CGFloat angle = [self getViewAngle];
        if (angle == 0) {
            return false;
        } else {
            return true;
        }
    } else {
        if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait) {
            return true;
        } else {
            return false;
        }
    }
}

- (CGFloat)getViewAngle
{
    CGFloat radians = atan2f(self.playerContentView.transform.b, self.playerContentView.transform.a);
    return radians * (180 / M_PI);
}

//- (void)addAnimationInLayer:(CALayer *)layer
//{
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.3;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionFade;
//    [layer addAnimation:transition forKey:nil];
//}
//
//- (UIViewController *)getVisibleController
//{
//    UIViewController *vc = [UIApplication sharedApplication].windows.firstObject.rootViewController;
//    while (true) {
//        if (vc.presentedViewController) {
//            vc = vc.presentedViewController;
//        } else {
//            return vc;
//        }
//    }
//}
@end
