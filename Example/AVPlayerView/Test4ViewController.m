//
//  Test4ViewController.m
//  AVPlayerView
//
//  Created by ChoJaehyun on 2016. 8. 3..
//  Copyright © 2016년 com.skswhwo. All rights reserved.
//

#import "Test4ViewController.h"
#import "AVPlayerView.h"
#import "VideoDownloader.h"

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
    
    NSURL *url = [NSURL URLWithString:@"https://s3.ap-northeast-2.amazonaws.com/skswhwo-video/400mb.mp4"];
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
    
//    VideoDownloader *downloader = [VideoDownloader new];
//    [downloader checkHeader:url];

}

- (IBAction)valueChanged:(id)sender
{
    self.avPlayerView.autoplay      = self.autoplaySwitch.on;
    self.avPlayerView.loop          = self.loopSwitch.on;
    self.avPlayerView.dimmedEffect  = self.dimmedEffectSwitch.on;
}

@end