//
//  AVPlayerContentView.h
//  CrVideoPlayer
//
//  Created by ChoJaehyun on 2016. 7. 30..
//  Copyright © 2016년 com.skswhwo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AVPlayerContentView : UIView

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (nonatomic, strong, readonly) AVPlayerLayer *layer;
#pragma clang diagnostic pop

@property (strong, nonatomic) AVPlayer *avPlayer;

@property (nonatomic, assign) BOOL loop;
@property (nonatomic, assign) BOOL autoplay;
@property (nonatomic, assign) NSInteger MAX_LOOP_COUNT;

- (void)playerWithPlayerItem:(AVPlayerItem *)playerItem time:(CMTime)startTime;

- (void)playVideoAfterTimeinterval:(NSTimeInterval)timeinterval;
- (void)playVideo;
- (void)pauseVideo;

@end
