//
//  AVPlayerControlView.m
//  AVPlayerView
//
//  Created by ChoJaehyun on 2016. 8. 1..
//  Copyright © 2016년 com.skswhwo. All rights reserved.
//

#import "AVPlayerControlView.h"

@interface AVPlayerControlView ()
{
    NSTimer *hideTimer;
}
@property (weak, nonatomic) IBOutlet UIButton *controlButton;
@property (weak, nonatomic) IBOutlet UIButton *viewModeButton;

@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UISlider *timeSlider;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end

@implementation AVPlayerControlView

+ (AVPlayerControlView *)getControlView
{
    AVPlayerControlView *view = [[[NSBundle mainBundle] loadNibNamed:@"AVPlayerControlView" owner:nil options:nil] objectAtIndex:0];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    return view;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    [[UISlider appearance] setThumbImage:[UIImage imageNamed:@"video_circle_default"] forState:UIControlStateNormal];
    [[UISlider appearance] setThumbImage:[UIImage imageNamed:@"video_circle_pressed"] forState:UIControlStateHighlighted];
}

#pragma mark - Content
- (void)reloadControlView
{
    float endTime = [self.delegate totalDurationForControlView:self];
    self.endTimeLabel.text = [self getFormattedTime:endTime];
    if (!isnan(endTime)) {
        self.timeSlider.maximumValue = endTime;
    }
    
    AVPlayerState state = [self.delegate currentControlStateForControlView:self];
    [self.controlButton setImage:[self getImageForState:state] forState:UIControlStateNormal];
    
    AVPlayerViewMode viewMode = [self.delegate currentViewModeForControlView:self];
    switch (viewMode) {
        case AVPlayerViewModeNormal:
            self.viewModeButton.selected = NO;
            break;
        case AVPlayerViewModeFullSize:
            self.viewModeButton.selected = YES;
            break;
    }
}

- (void)updateProgress:(float)time
{
    self.timeSlider.value = time;
    self.currentTimeLabel.text = [self getFormattedTime:time];
}

#pragma mark - IBAction
- (IBAction)controlButtonClicked:(UIButton *)controlButton
{
    [self.delegate controlButtonClickedAtControlView:self];
    [self runHideControlViewTimer];
}

- (IBAction)touchDownSlider:(UISlider *)slider
{
    if ([self.delegate respondsToSelector:@selector(controlView:beginValueChanged:)]) {
        [self.delegate controlView:self beginValueChanged:slider.value];
    }
    [self runHideControlViewTimer];
}

- (IBAction)sliderValueChanged:(UISlider *)slider
{
    if ([self.delegate respondsToSelector:@selector(controlView:timeValueChanged:)]) {
        [self.delegate controlView:self timeValueChanged:slider.value];
    }
    [self runHideControlViewTimer];
}

- (IBAction)sliderDragFinished:(UISlider *)slider
{
    if ([self.delegate respondsToSelector:@selector(controlView:finishValueChanged:)]) {
        [self.delegate controlView:self finishValueChanged:slider.value];
    }
    [self runHideControlViewTimer];
}

- (IBAction)viewModeButtonClicked:(UIButton *)viewModeButton
{
    if ([self.delegate respondsToSelector:@selector(controlView:currentViewMode:)]) {
        if (viewModeButton.selected) {
            [self.delegate controlView:self currentViewMode:AVPlayerViewModeFullSize];
        } else {
            [self.delegate controlView:self currentViewMode:AVPlayerViewModeNormal];
        }
    }
    [self runHideControlViewTimer];
}

- (IBAction)controlViewTapped:(id)sender
{
    [self hideControlView];
}

#pragma mark - Visibility
- (void)runHideControlViewTimer
{
    if (hideTimer) {
        [hideTimer invalidate];
        hideTimer = nil;
    }
    hideTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoHideControlView) userInfo:nil repeats:NO];
}

- (void)showControlView
{
    [self runHideControlViewTimer];
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
    }];
}

- (void)autoHideControlView
{
    AVPlayerState state = [self.delegate currentControlStateForControlView:self];
    if (state == AVPlayerStatePlay) {
        [self hideControlView];
    }
}
- (void)hideControlView
{
    [hideTimer invalidate];
    hideTimer = nil;

    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    }];
}

#pragma mark - Private
- (UIImage *)getImageForState:(AVPlayerState)state
{
    switch (state) {
        case AVPlayerStatePlay:
            return [UIImage imageNamed:@"video_pause_white"];
        case AVPlayerStatePause:
            return [UIImage imageNamed:@"video_play_white"];
        case AVPlayerStateFinish:
            return [UIImage imageNamed:@"video_replay_white"];
    }
}

- (NSString *)getFormattedTime:(float)time
{
    NSDateComponentsFormatter *dcFormatter = [[NSDateComponentsFormatter alloc] init];
    dcFormatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorNone;
    dcFormatter.allowedUnits = NSCalendarUnitMinute | NSCalendarUnitSecond;
    if (time >= 60*60) {
        dcFormatter.allowedUnits |= NSCalendarUnitHour;
    }
    dcFormatter.unitsStyle = NSDateComponentsFormatterUnitsStylePositional;
    return [dcFormatter stringFromTimeInterval:time];
}

@end
