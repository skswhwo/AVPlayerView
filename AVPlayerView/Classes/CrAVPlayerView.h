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

@class CrAVPlayerView;

typedef void (^CrAVPlayerViewCallback) (CrAVPlayerView *playerView);

@interface CrAVPlayerView : UIView

@property (nonatomic, assign) BOOL loop;
@property (nonatomic, assign) BOOL autoplay;
@property (nonatomic, assign) BOOL showControl;
@property (nonatomic, assign) BOOL dimmedEffect;
@property (nonatomic, assign) BOOL pauseWhenDisappear;  //default: true

@property (nonatomic, strong) UIColor *backgroundColorForFullSize; //default: black
@property (strong, nonatomic) NSURL *itemURL;

@property (nonatomic, strong) CrAVPlayerViewCallback tapCallBack;
@property (nonatomic, strong) CrAVPlayerViewCallback didAppear;
@property (nonatomic, strong) CrAVPlayerViewCallback didDisappear;
@property (nonatomic, strong) CrAVPlayerViewCallback failure;

- (void)playerWithContentURL:(NSURL *)url;
- (void)setTapCallBack:(CrAVPlayerViewCallback)tapCallBack;
- (void)setDidAppear:(CrAVPlayerViewCallback)didAppear;
- (void)setDidDisappear:(CrAVPlayerViewCallback)didDisappear;

- (void)setGradientColorsAtBottom:(NSArray *)colors;

#pragma mark - Condition
- (BOOL)isFullSize;

#pragma mark - Interface
- (void)play;
- (void)pause;
- (void)normalSizeMode;
- (void)fullSizeMode;

@end

