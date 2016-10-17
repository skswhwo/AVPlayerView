//
//  Test4ViewController.m
//  AVPlayerView
//
//  Created by ChoJaehyun on 2016. 8. 3..
//  Copyright © 2016년 com.skswhwo. All rights reserved.
//

#import "Test4ViewController.h"
#import "AVPlayerView.h"

@interface Test4ViewController ()

@property (weak, nonatomic) IBOutlet AVPlayerView *avPlayerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UISwitch *autoplaySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *loopSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *dimmedEffectSwitch;

@end


@implementation Test4ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSString *urlString = @"https://s3.ap-northeast-2.amazonaws.com/skswhwo-video/test.mp4";  //small short
//    NSString *urlString = @"https://s3.ap-northeast-2.amazonaws.com/skswhwo-video/400mb.mp4";   //large short
//    NSString *urlString = @"https://s3.ap-northeast-2.amazonaws.com/skswhwo-video/test3.mp4";   //small long
    NSString *urlString = @"https://learningcard-files-stg.s3.amazonaws.com/uploads/videos/0d7de8c6-9718-478d-9b1c-118ef92a2d83/0d7de8c6-9718-478d-9b1c-118ef92a2d83-hls-600k.m3u8";        //HLS
    
//    AVPlayerView *playerView  = [[AVPlayerView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    NSURL *url = [NSURL URLWithString:urlString];
    [self.avPlayerView playerWithContentURL:url];
    [self valueChanged:nil];
    [self.avPlayerView setTapCallBack:^(AVPlayerView *playerView) {
    }];
    [self.avPlayerView setDidAppear:^(AVPlayerView *playerView) {
        //do something;
    }];
    [self.avPlayerView setDidDisappear:^(AVPlayerView *playerView) {
        //do something;
    }];
    [self.avPlayerView setFailure:^(AVPlayerView *playerView) {
        //do somthing;
    }];
}

- (IBAction)valueChanged:(id)sender
{
    self.avPlayerView.autoplay      = self.autoplaySwitch.on;
    self.avPlayerView.loop          = self.loopSwitch.on;
    self.avPlayerView.dimmedEffect  = self.dimmedEffectSwitch.on;
}

@end
