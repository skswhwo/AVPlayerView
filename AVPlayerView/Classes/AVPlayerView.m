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
<AVPlayerControlViewDelegate,
AVPlayerContentViewDelegate>
{
    BOOL didAppearFlag;
    
    UIWindowLevel previousWindowLevel;
}
@property (strong, nonatomic) AVPlayerContentView *playerContentView;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (strong, nonatomic) AVPlayerControlView *playerControlView;
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
    self.clipsToBounds      = YES;
    self.backgroundColor    = [UIColor blackColor];
    previousWindowLevel     = [[UIApplication sharedApplication] keyWindow].windowLevel;
    self.dimmedEffect       = true;
    self.pauseWhenDisappear = true;
    self.playWhenAppear     = true;
    self.backgroundColorForFullSize = [UIColor blackColor];
}
- (void)initializePlayer
{
    _playerContentView = [[AVPlayerContentView alloc] init];
    _playerContentView.delegate = self;
    [_playerContentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    self.playerControlView = [AVPlayerControlView getControlView];
    self.playerControlView.delegate = self;
    [self setShowControl:YES];
    [self.playerControlView updateProgress:0];
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
    self.playerItem =[AVPlayerItem playerItemWithURL:url];
    [self.playerContentView playerWithPlayerItem:[AVPlayerItem playerItemWithURL:url] time:kCMTimeZero];
    if (self.showControl) {
        [self.playerControlView reloadControlView];
        [self.playerControlView updateProgress:0];
    }
}

#pragma mark - Setter
- (void)setLoop:(BOOL)loop
{
    _loop = loop;
    self.playerContentView.loop = loop;
}

- (void)setAutoplay:(BOOL)autoplay
{
    _autoplay = autoplay;
    self.playerContentView.autoplay = autoplay;
    if (autoplay) {
        [self.playerContentView playVideo];
    }
}

- (void)setShowControl:(BOOL)showControl
{
    _showControl = showControl;
    [self.playerControlView setHidden:!showControl];
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

#pragma mark - AVContentView Delegate
- (void)playerContentView:(AVPlayerContentView *)contentView stateChanged:(AVPlayerState)state
{
    [self.playerControlView reloadControlView];
    if (self.showControl && state == AVPlayerStateFinish) {
        [self.playerControlView showControlView];
    }
}
- (void)playerContentView:(AVPlayerContentView *)contentView progressChanged:(float)timeValue
{
    [self.playerControlView updateProgress:timeValue];
}

#pragma mark - AVControlView Delegate
- (AVPlayerState)currentControlStateForControlView:(AVPlayerControlView *)controlView
{
    if ([self.playerContentView isPlaying]) {
        return AVPlayerStatePlay;
    } else if ([self.playerContentView isFinished]) {
        return AVPlayerStateFinish;
    } else {
        return AVPlayerStatePause;
    }
}

- (AVPlayerViewMode)currentViewModeForControlView:(AVPlayerControlView *)controlView
{
    return (self.isFullSize?AVPlayerViewModeFullSize:AVPlayerViewModeNormal);

}

- (float)totalDurationForControlView:(AVPlayerControlView *)controlView
{
    AVAsset *asset = [self.playerItem asset];
    return CMTimeGetSeconds(asset.duration);
}

- (void)controlViewClicked:(AVPlayerControlView *)controlView
{
    if (self.tapCallBack) {
        self.tapCallBack(self);
    }
}

- (void)controlView:(AVPlayerControlView *)controlView beginValueChanged:(float)time
{
    if ([self.playerContentView isPlaying]) {
        [self.playerContentView pauseVideo];
        controlView.needToAutoPlay = true;
    } else {
        controlView.needToAutoPlay = false;
        [controlView reloadControlView];
    }
}

- (void)controlView:(AVPlayerControlView *)controlView timeValueChanged:(float)time
{
    [self.playerContentView seekToTime:time];
}

- (void)controlView:(AVPlayerControlView *)controlView finishValueChanged:(float)time
{
    [self.playerContentView seekToTime:time];
    if (controlView.needToAutoPlay) {
        [self.playerContentView playVideo];
    }
}

- (void)actionButtonClickedAtControlView:(AVPlayerControlView *)controlView
{
    if ([self.playerContentView isPlaying]) {
        [self.playerContentView pauseVideo];
    } else if ([self.playerContentView isFinished]) {
        [self.playerContentView playVideo];
    } else {
        [self.playerContentView playVideo];
    }
    [controlView reloadControlView];
}

- (void)controlView:(AVPlayerControlView *)controlView viewModeClicked:(AVPlayerViewMode)viewMode
{
    if (AVPlayerViewModeNormal == viewMode) {
        [self fullSizeMode];
    } else {
        [self normalSizeMode];
    }
    [controlView reloadControlView];
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
    [self.playerControlView removeFromSuperview];
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    window.windowLevel = previousWindowLevel;
    [window layoutIfNeeded];
    CGRect rect = [self.superview convertRect:self.frame toView:window];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.playerContentView.frame = rect;
        if (self.dimmedEffect) {
            self.playerContentView.backgroundColor = [UIColor clearColor];
        }
    } completion:^(BOOL finished) {
        self.playerContentView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.playerContentView toSuperView:self];
        [self addSubview:self.playerControlView toSuperView:self];
    }];
}

- (void)fullSizeMode
{
    self.isFullSize = YES;
    [self.playerControlView removeFromSuperview];
    
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
        [self addSubview:self.playerControlView toSuperView:window];
    }];
}

#pragma mark - Private
- (void)addSubview:(UIView *)subView toSuperView:(UIView *)superView
{
    if (subView == nil) {
        return;
    }
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
