//
//  AVPlayerView.h
//  CrVideoPlayer
//
//  Created by ChoJaehyun on 2016. 7. 29..
//  Copyright © 2016년 com.skswhwo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class AVPlayerView;

typedef void (^AVPlayerViewTapCallback) (AVPlayerView *playerView);

@interface AVPlayerView : UIView

@property (nonatomic, assign) BOOL loop;
@property (nonatomic, assign) BOOL autoplay;
@property (nonatomic, assign) BOOL dimmedEffect;
@property (nonatomic, strong) AVPlayerViewTapCallback tapCallBack;

@property (nonatomic, assign) BOOL isFullSize;

- (void)playerWithContentURL:(NSURL *)url;
- (void)setTapCallBack:(AVPlayerViewTapCallback)tapCallBack;

- (void)normalSizeMode;
- (void)fullSizeMode;

@end

