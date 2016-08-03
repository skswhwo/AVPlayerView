//
//  AVPlayerControlView.h
//  AVPlayerView
//
//  Created by ChoJaehyun on 2016. 8. 1..
//  Copyright © 2016년 com.skswhwo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVPlayerViewEnum.h"
#import <AVFoundation/AVFoundation.h>

@protocol AVPlayerControlViewDelegate;

@interface AVPlayerControlView : UIView

@property (nonatomic, weak) id <AVPlayerControlViewDelegate> delegate;
@property (nonatomic, assign) BOOL needToAutoPlay;
@property (nonatomic, strong) AVPlayerItem *playerItem;

+ (AVPlayerControlView *)getControlView;

- (void)setGradientColorsAtBottom:(NSArray *)colors;

#pragma mark - Data
- (void)reloadControlView;
- (void)updateProgress:(float)time;

#pragma mark - View
- (void)showControlView;
- (void)hideControlView;

@end

@protocol AVPlayerControlViewDelegate <NSObject>

@required
- (AVPlayerState)currentControlStateForControlView:(AVPlayerControlView *)controlView;
- (AVPlayerViewMode)currentViewModeForControlView:(AVPlayerControlView *)controlView;
- (void)actionButtonClickedAtControlView:(AVPlayerControlView *)controlView;
- (void)controlViewClicked:(AVPlayerControlView *)controlView;

@optional
- (void)controlView:(AVPlayerControlView *)controlView beginValueChanged:(float)time;
- (void)controlView:(AVPlayerControlView *)controlView timeValueChanged:(float)time;
- (void)controlView:(AVPlayerControlView *)controlView finishValueChanged:(float)time;

- (void)controlView:(AVPlayerControlView *)controlView viewModeClicked:(AVPlayerViewMode)viewMode;

@end
