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
    if (self.autoplay) {
        [self playVideo];
    }
}

#pragma mark - Observer
- (void)playerFinishedPlaying:(NSNotification *)notification
{
    if (self.loop) {
        loopCount++;
        if (self.MAX_LOOP_COUNT > loopCount) {
            [self playVideo];
        }
    }
}

#pragma mark - Action
- (void)playVideo
{
    if ([self isFinished]) {
        [self.avPlayer seekToTime:kCMTimeZero];
    }
    [self.avPlayer play];
}

- (void)pauseVideo
{
    [self.avPlayer pause];
}

#pragma mark - Private
- (BOOL)isFinished
{
    return (self.avPlayer.currentTime.value == self.avPlayer.currentItem.duration.value);
}
@end
