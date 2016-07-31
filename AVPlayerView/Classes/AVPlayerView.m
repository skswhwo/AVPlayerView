//
//  AVPlayerView.m
//  CrVideoPlayer
//
//  Created by ChoJaehyun on 2016. 7. 29..
//  Copyright © 2016년 com.skswhwo. All rights reserved.
//

#import "AVPlayerView.h"
#import "AVPlayerContentView.h"

@interface AVPlayerView ()
{
    BOOL didAppearFlag;
    
    UIWindowLevel previousWindowLevel;
}
@property (strong, nonatomic) AVPlayerContentView *playerContentView;
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;
@property (nonatomic, assign) BOOL isFullSize;

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
    self.backgroundColor    = [UIColor clearColor];
    previousWindowLevel     = [[UIApplication sharedApplication] keyWindow].windowLevel;
    self.dimmedEffect       = true;
    self.pauseWhenDisappear = true;
    self.playWhenAppear     = true;
    self.backgroundColorForFullSize = [UIColor blackColor];
}
- (void)initializePlayer
{
    _playerContentView = [[AVPlayerContentView alloc] init];
    [_playerContentView setTranslatesAutoresizingMaskIntoConstraints:NO];
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
    if (self.playWhenAppear) {
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
- (void)playerWithContentURL:(NSURL *)url
{
    [self.playerContentView playerWithPlayerItem:[AVPlayerItem playerItemWithURL:url] time:kCMTimeZero];
}

#pragma mark - UIGestureRecognizer Callback
- (void)playerTapped:(UIGestureRecognizer *)gesture
{
    if (self.tapCallBack) {
        self.tapCallBack(self);
    }
}

#pragma mark - Setter
- (void)setTapCallBack:(AVPlayerViewCallback)tapCallBack
{
    _tapCallBack = tapCallBack;
    
    if (_tapGesture == nil) {
        _tapGesture  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playerTapped:)];
        [self.playerContentView addGestureRecognizer:_tapGesture];
    }
}
- (void)setDidAppear:(AVPlayerViewCallback)didAppear
{
    _didAppear = didAppear;
}
- (void)setDidDisappear:(AVPlayerViewCallback)didDisappear
{
    _didDisappear = didDisappear;
}
- (void)setLoop:(BOOL)loop
{
    _loop = loop;
    self.playerContentView.loop = loop;
}

- (void)setAutoplay:(BOOL)autoplay
{
    _autoplay = autoplay;
    self.playerContentView.autoplay = autoplay;
    if (autoplay && self.playerContentView) {
        [self.playerContentView playVideo];
    }
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
            [self.playerContentView pauseVideo];
        }
    }
}

- (void)afterDidMoveToWindow
{
    if (didAppearFlag) {
        if (self.didAppear) {
            self.didAppear(self);
        }
        if (self.autoplay && self.playWhenAppear) {
            [self.playerContentView playVideo];
        }
    }
}

#pragma mark - IBAction
- (IBAction)playButtonClicked
{
    [self.playerContentView playVideo];
}

- (IBAction)pauseButtonClicked
{
    [self.playerContentView pauseVideo];
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
    self.isFullSize = NO;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    window.windowLevel = previousWindowLevel;
    CGRect rect = [self.superview convertRect:self.frame toView:window];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.playerContentView.frame = rect;
        self.playerContentView.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self addSubview:self.playerContentView toSuperView:self];
    }];
}

- (void)fullSizeMode
{
    self.isFullSize = YES;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    window.windowLevel = UIWindowLevelStatusBar;
    [window addSubview:self.playerContentView];
    [window layoutIfNeeded];

    CGRect rect = [self.superview convertRect:self.frame toView:window];
    self.playerContentView.frame = rect;
    CGRect targetRect = window.bounds;
    
    if (self.dimmedEffect == false) {
        self.playerContentView.backgroundColor = self.backgroundColorForFullSize;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.playerContentView.frame = targetRect;
        
        if (self.dimmedEffect) {
            self.playerContentView.backgroundColor = self.backgroundColorForFullSize;
        }
        
    } completion:^(BOOL finished) {
        [self addSubview:self.playerContentView toSuperView:window];
    }];
}

#pragma mark - Private
- (void)addSubview:(UIView *)subView toSuperView:(UIView *)superView
{
    [superView addSubview:subView];
    [superView addConstraint:[NSLayoutConstraint constraintWithItem:subView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:0]];
    
    [superView addConstraint:[NSLayoutConstraint constraintWithItem:subView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:0]];
    [superView addConstraint:[NSLayoutConstraint constraintWithItem:subView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superView
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1
                                                           constant:0]];
    
    [superView addConstraint:[NSLayoutConstraint constraintWithItem:subView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superView
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1
                                                           constant:0]];
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
