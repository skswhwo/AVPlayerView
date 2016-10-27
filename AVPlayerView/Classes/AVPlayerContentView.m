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
    BOOL playbackStalled;
    BOOL isFinished;
    NSInteger loopCount;
    
    NSInteger bufferCount;
}
@property (strong, nonatomic) AVPlayerItem *playerItem;
@end


@implementation AVPlayerContentView
+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (void)dealloc {
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    self.controlView = [AVPlayerControlView getControlView];
    self.controlView.delegate = self;
}

- (void)setControlView:(AVPlayerControlView *)controlView
{
    _controlView = controlView;
    _controlView.delegate = self;
}
- (void)setGradientColorsAtBottom:(NSArray *)colors
{
    [self.controlView setGradientColorsAtBottom:colors];
}

- (void)playerWithPlayerItem:(AVPlayerItem *)playerItem time:(CMTime)startTime
{
    loopCount = 0;
    [self setPlayerItem:playerItem];
    self.avPlayer = [AVPlayer playerWithPlayerItem:self.playerItem];
    [self.avPlayer seekToTime:startTime];
    [self.layer setPlayer:self.avPlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerFinishedPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackStalledNotification:) name:AVPlayerItemPlaybackStalledNotification object:self.playerItem];
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:NULL];


    __weak AVPlayerContentView *weakSelf = self;
    [self.avPlayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1.0 / 60.0, NSEC_PER_SEC)
                                          queue:NULL
                                     usingBlock:^(CMTime time){
                                         
                                         [weakSelf.controlView updateProgress:CMTimeGetSeconds(weakSelf.avPlayer.currentTime)];
                                         
                                     }];
    
    [self.controlView setPlayerItem:self.playerItem];
    [self.controlView reloadControlView];
    [self.controlView updateProgress:0];
}

- (void)playbackStalledNotification:(NSNotification *)notification
{
    [self bufferingVideo];
}

#pragma mark - Observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        if (self.avPlayer.currentItem.status == AVPlayerStatusFailed) {
            [self playerFailed];
        }
    }
}

- (void)playerFinishedPlaying:(NSNotification *)notification
{
    isFinished = YES;
    if (self.loop) {
        loopCount++;
        if (self.MAX_LOOP_COUNT > loopCount) {
            [self playVideo];
        }
    } else {
        [self stateChanged:AVPlayerStateFinish];
    }
}

#pragma mark - Action
- (void)seekToTime:(float)time
{
    [self.avPlayer seekToTime:CMTimeMake(time*1000, 1000)];
    isFinished = NO;
}

- (void)stopVideo
{
    [self pauseVideo];

    AVURLAsset *asset = (AVURLAsset *)self.playerItem.asset;
    if ([[asset.URL scheme] hasPrefix:@"http"]) {
        [self.avPlayer replaceCurrentItemWithPlayerItem:nil];
        [self addRemoteThumbnail];
    }
}

- (void)prepareVideo
{
    if (self.avPlayer.currentItem == nil) {
        [self.avPlayer replaceCurrentItemWithPlayerItem:self.playerItem];
        self.thumbnailView.image = nil;
    }
}

- (void)playVideo
{
    [self prepareVideo];
    
    playbackStalled = false;
    if (isFinished) {
        isFinished = NO;
        [self.avPlayer seekToTime:kCMTimeZero];
    }
    [self.avPlayer play];
    [self stateChanged:AVPlayerStatePlay];
    
    if (CMTimeGetSeconds(self.avPlayer.currentItem.currentTime) != 0) {
        if ([self canPlayImmediately]) {
            bufferCount = 0;
        } else {
            if (bufferCount == 3) {
                bufferCount = 0;
                [self playerFailed];
            } else {
                bufferCount++;
                [self bufferingVideo];
            }
        }
    }
    
    if (self.avPlayer.currentItem.status == AVPlayerStatusFailed) {
        [self playerFailed];
    }
}

- (void)playerFailed
{
    [self.avPlayer pause];
    [self stateChanged:AVPlayerStatePause];
    [self.delegate playerViewFailed];
}

- (void)pauseVideo
{
    if ([self isPlaying]) {
        [self.avPlayer pause];
    }
    [self stateChanged:AVPlayerStatePause];
}

- (void)bufferingVideo
{
    playbackStalled = true;
    [self.avPlayer pause];
    [self stateChanged:AVPlayerStateBuffering];
    [self performSelector:@selector(playVideo) withObject:nil afterDelay:2];
}

#pragma mark - Function
- (void)addRemoteThumbnail
{
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:self.playerItem.asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:self.playerItem.currentTime actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    if (thumbnail) {
        [self.thumbnailView setImage:thumbnail];
    } else {
        [self.delegate playerViewCannotLoadThumbnail];
    }
}

#pragma mark - Callback
- (void)stateChanged:(AVPlayerState)state
{
    [self.controlView reloadControlView];
    if (self.showControl && state == AVPlayerStateFinish) {
        [self.controlView showControlView];
    } else if (state == AVPlayerStateBuffering) {
        [self.controlView showControlView];
    }
}

#pragma mark - Setter
- (void)setShowControl:(BOOL)showControl
{
    _showControl = showControl;
    [self.controlView setHidden:!showControl];
}

#pragma mark - AVControlView Delegate
- (AVPlayerState)currentControlStateForControlView:(AVPlayerControlView *)controlView
{
    return [self getCurrentState];
}

- (AVPlayerViewMode)currentViewModeForControlView:(AVPlayerControlView *)controlView
{
    return (self.isFullSize?AVPlayerViewModeFullSize:AVPlayerViewModeNormal);
}

- (void)controlViewClicked:(AVPlayerControlView *)controlView
{
    [self.delegate playerViewClicked];
}

- (void)controlView:(AVPlayerControlView *)controlView beginValueChanged:(float)time
{
    [self prepareVideo];
    
    AVPlayerState state = [self getCurrentState];
    switch (state) {
        case AVPlayerStatePlay:
        case AVPlayerStateBuffering:
            [self pauseVideo];
            controlView.needToAutoPlay = true;
            break;
        case AVPlayerStatePause:
        case AVPlayerStateFinish:
            controlView.needToAutoPlay = false;
            [controlView reloadControlView];
            break;
    }
}

- (void)controlView:(AVPlayerControlView *)controlView timeValueChanged:(float)time
{
    [self seekToTime:time];
}

- (void)controlView:(AVPlayerControlView *)controlView finishValueChanged:(float)time
{
    [self seekToTime:time];
    if (controlView.needToAutoPlay) {
        [self playVideo];
        [controlView reloadControlView];
    }
}

- (void)actionButtonClickedAtControlView:(AVPlayerControlView *)controlView
{
    AVPlayerState state = [self getCurrentState];
    switch (state) {
        case AVPlayerStatePlay:
        case AVPlayerStateBuffering:
            [self pauseVideo];
            break;
        case AVPlayerStatePause:
        case AVPlayerStateFinish:
            [self playVideo];
            break;
    }
    [controlView reloadControlView];
}

- (void)controlView:(AVPlayerControlView *)controlView viewModeClicked:(AVPlayerViewMode)viewMode
{
    if (AVPlayerViewModeNormal == viewMode) {
        [self.delegate playerViewChangeToFullScreen];
    } else {
        [self.delegate playerViewChangeToNormalScreen];
    }
    [controlView reloadControlView];
}

#pragma mark - Condition
- (AVPlayerState)getCurrentState
{
    if ([self isPlaying]) {
        return AVPlayerStatePlay;
    } else if ([self isFinished]) {
        return AVPlayerStateFinish;
    } else if (playbackStalled) {
        return AVPlayerStateBuffering;
    } else {
        return AVPlayerStatePause;
    }
}

- (BOOL)canPlayImmediately
{
    NSValue *range = self.avPlayer.currentItem.loadedTimeRanges.firstObject;
    if (range != nil){
        float availableTime = CMTimeGetSeconds(CMTimeRangeGetEnd(range.CMTimeRangeValue));
        float bufferTime    = availableTime - CMTimeGetSeconds(self.avPlayer.currentTime);
        float totalTime     = CMTimeGetSeconds(self.avPlayer.currentItem.duration);
        if (bufferTime > 2 || (totalTime - availableTime) < 2) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Pirvate
- (BOOL)isPlaying
{
    return (self.avPlayer.rate != 0 && self.avPlayer.error == nil);
}
- (BOOL)isFinished
{
    return isFinished;
}

@end
