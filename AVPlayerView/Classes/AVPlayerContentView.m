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
    BOOL needToPlay;
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
    }
}

#pragma mark - Action
- (void)playVideoAfterTimeinterval:(NSTimeInterval)timeinterval
{
    needToPlay = YES;
    [self performSelector:@selector(playVideoIfNeeded) withObject:nil afterDelay:timeinterval];
}
- (void)playVideoIfNeeded
{
    if (needToPlay) {
        needToPlay = NO;
        [self playVideo];
    }
}
- (void)playVideo
{
    if (isFinished) {
        [self.avPlayer seekToTime:kCMTimeZero];
        isFinished = NO;
    }
    [self.avPlayer play];
}

- (void)pauseVideo
{
    needToPlay = NO;
    if ([self isPlaying]) {
        [self.avPlayer pause];
    }
}

#pragma mark - Private
- (BOOL)isPlaying
{
    return (self.avPlayer.rate != 0 && self.avPlayer.error == nil);
}

@end
