//
//  AVPlayerContentView.m
//  CrVideoPlayer
//
//  Created by ChoJaehyun on 2016. 7. 30..
//  Copyright © 2016년 com.skswhwo. All rights reserved.
//

#import "AVPlayerContentView.h"

@interface AVPlayerContentView ()
{
    BOOL isFinished;
    NSInteger loopCount;
}
@end

@implementation AVPlayerContentView
+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (id)init {
    self = [super init];
    [self initializer];
    return self ;
}

- (void)initializer
{
    self.backgroundColor = [UIColor clearColor];
    self.MAX_LOOP_COUNT = 100;
}

- (void)playerWithPlayerItem:(AVPlayerItem *)playerItem time:(CMTime)startTime
{
    loopCount = 0;
    self.avPlayer = [AVPlayer playerWithPlayerItem:playerItem];
    [self.avPlayer seekToTime:startTime];
    [self.layer setPlayer:self.avPlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerFinishedPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];

    __weak AVPlayerContentView *weakSelf = self;
    [self.avPlayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1.0 / 60.0, NSEC_PER_SEC)
                                          queue:NULL
                                     usingBlock:^(CMTime time){
                                         if ([weakSelf.delegate respondsToSelector:@selector(playerContentView:progressChanged:)]) {
                                             [weakSelf.delegate playerContentView:weakSelf progressChanged:CMTimeGetSeconds(weakSelf.avPlayer.currentTime)];
                                         }
                                     }];
    if (self.autoplay) {
        [self playVideo];
    }
}

#pragma mark - Observer
- (void)playerFinishedPlaying:(NSNotification *)notification
{
    isFinished = YES;
    if (self.loop) {
        loopCount++;
        if (self.MAX_LOOP_COUNT > loopCount) {
            [self playVideo];
        }
    } else {
        [self.delegate playerContentView:self stateChanged:AVPlayerStateFinish];
    }
}

#pragma mark - Action
- (void)seekToTime:(float)time
{
    [self.avPlayer seekToTime:CMTimeMake(time*1000, 1000)];
    isFinished = NO;
}
- (void)playVideo
{
    if (isFinished) {
        isFinished = NO;
        [self.avPlayer seekToTime:kCMTimeZero];
    }
    [self.avPlayer play];
    [self.delegate playerContentView:self stateChanged:AVPlayerStatePlay];
}

- (void)pauseVideo
{
    if ([self isPlaying]) {
        [self.avPlayer pause];
    }
    [self.delegate playerContentView:self stateChanged:AVPlayerStatePause];
}

#pragma mark - Condition
- (BOOL)isPlaying
{
    return (self.avPlayer.rate != 0 && self.avPlayer.error == nil);
}
- (BOOL)isFinished
{
    return isFinished;
}
@end
