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

@property (strong, nonatomic) AVPlayerContentView *playerContentView;
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;

@end


@implementation AVPlayerView
- (void)initialize{
    
    self.backgroundColor = [UIColor clearColor];
    
    [self registerPlayer];
    
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

#pragma mark - Register
- (void)registerPlayer
{
    _playerContentView = [[AVPlayerContentView alloc] init];
    [_playerContentView setTranslatesAutoresizingMaskIntoConstraints:NO];
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
- (void)setTapCallBack:(AVPlayerViewTapCallback)tapCallBack
{
    _tapCallBack = tapCallBack;
    
    if (_tapGesture == nil) {
        _tapGesture  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playerTapped:)];
        [self.playerContentView addGestureRecognizer:_tapGesture];
    }
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

#pragma mark - IBAction
- (IBAction)playButtonClicked
{
    [self.playerContentView playVideo];
}

- (IBAction)pauseButtonClicked
{
    [self.playerContentView pauseVideo];
}

#pragma mark - Mode
- (void)normalSizeMode
{
    self.isFullSize = NO;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
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
    CGRect rect = [self.superview convertRect:self.frame toView:window];
    self.playerContentView.frame = rect;
    [window addSubview:self.playerContentView];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.playerContentView.frame = window.bounds;
        self.playerContentView.center = window.center;
        
        if (self.dimmedEffect) {
            self.playerContentView.backgroundColor = [UIColor blackColor];
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
