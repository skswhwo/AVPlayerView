//
//  Test1ViewController.m
//  AVPlayerView
//
//  Created by ChoJaehyun on 2016. 7. 30..
//  Copyright © 2016년 com.skswhwo. All rights reserved.
//

#import "Test1ViewController.h"
#import "CrAVPlayerView.h"

@interface Test1ViewController ()
@property (weak, nonatomic) IBOutlet CrAVPlayerView *avPlayerView;

@property (weak, nonatomic) IBOutlet UISwitch *autoplaySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *loopSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *dimmedEffectSwitch;

@end

@implementation Test1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"short" ofType:@"mp4"];
    [self.avPlayerView playerWithContentURL:[NSURL fileURLWithPath:path]];
    [self valueChanged:nil];
    self.avPlayerView.showControl = NO;
    [self.avPlayerView setTapCallBack:^(CrAVPlayerView *playerView) {
        if ([playerView isFullSize]) {
            [playerView normalSizeMode];
        } else {
            [playerView fullSizeMode];
        } ;
    }];
    [self.avPlayerView setDidAppear:^(CrAVPlayerView *playerView) {
        //do something;
    }];
    [self.avPlayerView setDidDisappear:^(CrAVPlayerView *playerView) {
        //do something;
    }];
    [self.avPlayerView setFailure:^(CrAVPlayerView *playerView) {
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
