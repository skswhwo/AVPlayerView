//
//  AVPlayerContentView.h
//  CrVideoPlayer
//
//  Created by ChoJaehyun on 2016. 7. 30..
//  Copyright © 2016년 com.skswhwo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AVPlayerViewEnum.h"

@protocol AVPlayerContentViewDelegate;

@interface AVPlayerContentView : UIView

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (nonatomic, strong, readonly) AVPlayerLayer *layer;
#pragma clang diagnostic pop

@property (nonatomic, weak) id <AVPlayerContentViewDelegate> delegate;
@property (strong, nonatomic) AVPlayer *avPlayer;

@property (nonatomic, assign) BOOL loop;
@property (nonatomic, assign) BOOL autoplay;
@property (nonatomic, assign) NSInteger MAX_LOOP_COUNT;

- (void)playerWithPlayerItem:(AVPlayerItem *)playerItem time:(CMTime)startTime;

- (void)seekToTime:(float)time;
- (void)playVideo;
- (void)pauseVideo;

#pragma mark - Condition
- (BOOL)isPlaying;
- (BOOL)isFinished;

@end


@protocol AVPlayerContentViewDelegate <NSObject>

@required
- (void)playerContentView:(AVPlayerContentView *)contentView stateChanged:(AVPlayerState)state;
- (void)playerContentView:(AVPlayerContentView *)contentView progressChanged:(float)timeValue;

@end