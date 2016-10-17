//
//  AVPlayerView.h
//  CrVideoPlayer
//
//  Created by ChoJaehyun on 2016. 7. 29..
//  Copyright © 2016년 com.skswhwo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AVPlayerViewEnum.h"

@class AVPlayerView;

typedef void (^AVPlayerViewCallback) (AVPlayerView *playerView);

@interface AVPlayerView : UIView

@property (nonatomic, assign) BOOL loop;
@property (nonatomic, assign) BOOL autoplay;
@property (nonatomic, assign) BOOL showControl;
@property (nonatomic, assign) BOOL dimmedEffect;
@property (nonatomic, assign) BOOL pauseWhenDisappear;  //default: true

@property (nonatomic, strong) UIColor *backgroundColorForFullSize; //default: black
@property (strong, nonatomic) NSURL *itemURL;

@property (nonatomic, strong) AVPlayerViewCallback tapCallBack;
@property (nonatomic, strong) AVPlayerViewCallback didAppear;
@property (nonatomic, strong) AVPlayerViewCallback didDisappear;
@property (nonatomic, strong) AVPlayerViewCallback failure;

- (void)playerWithContentURL:(NSURL *)url;
- (void)setTapCallBack:(AVPlayerViewCallback)tapCallBack;
- (void)setDidAppear:(AVPlayerViewCallback)didAppear;
- (void)setDidDisappear:(AVPlayerViewCallback)didDisappear;

- (void)setGradientColorsAtBottom:(NSArray *)colors;

#pragma mark - Condition
- (BOOL)isFullSize;

#pragma mark - Interface
- (void)play;
- (void)pause;
- (void)normalSizeMode;
- (void)fullSizeMode;

@end

