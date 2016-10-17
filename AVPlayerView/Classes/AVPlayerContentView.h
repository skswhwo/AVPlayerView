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
#import "AVPlayerControlView.h"

@protocol AVPlayerContentViewDelegate;

@interface AVPlayerContentView : UIView
<AVPlayerControlViewDelegate>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (nonatomic, strong, readonly) AVPlayerLayer *layer;
#pragma clang diagnostic pop

@property (nonatomic, weak) id <AVPlayerContentViewDelegate> delegate;

@property (strong, nonatomic) AVPlayer *avPlayer;
@property (strong, nonatomic) AVPlayerControlView *controlView;
@property (strong, nonatomic) UIImageView *thumbnailView;

@property (nonatomic, assign) BOOL loop;
@property (nonatomic, assign) BOOL showControl;
@property (nonatomic, assign) BOOL isFullSize;
@property (nonatomic, assign) NSInteger MAX_LOOP_COUNT;


- (void)playerWithPlayerItem:(AVPlayerItem *)playerItem time:(CMTime)startTime;

#pragma mark - Playback
- (void)seekToTime:(float)time;
- (void)stopVideo;
- (void)playVideo;
- (void)pauseVideo;
- (void)bufferingVideo;

#pragma mark - Properties
- (void)setGradientColorsAtBottom:(NSArray *)colors;

@end

@protocol AVPlayerContentViewDelegate

@required
- (void)playerViewChangeToFullScreen;
- (void)playerViewChangeToNormalScreen;
- (void)playerViewClicked;
- (void)playerViewFailed;
- (void)playerViewCannotLoadThumbnail;

@end
