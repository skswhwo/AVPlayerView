//
//  AVPlayerView.h
//  CrVideoPlayer
//
//  Created by ChoJaehyun on 2016. 7. 29..
//  Copyright © 2016년 com.skswhwo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef void (^AVPlayerViewTapCallback) (AVPlayer *player);

@interface AVPlayerView : UIView

@property (nonatomic, assign) BOOL loop;
@property (nonatomic, assign) BOOL autoplay;
@property (nonatomic, strong) AVPlayerViewTapCallback tapCallBack;

@property (nonatomic, assign) BOOL dimmedEffect;

- (void)playerWithContentURL:(NSURL *)url;

@end

