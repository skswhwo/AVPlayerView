//
//  Test3ViewController.m
//  AVPlayerView
//
//  Created by ChoJaehyun on 2016. 8. 2..
//  Copyright © 2016년 com.skswhwo. All rights reserved.
//

#import "Test3ViewController.h"
#import "CrAVPlayerView.h"

@interface Test3ViewController ()
@property (weak, nonatomic) IBOutlet CrAVPlayerView *avPlayerView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UISwitch *autoplaySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *loopSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *dimmedEffectSwitch;
@end

@implementation Test3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
    [self.avPlayerView playerWithContentURL:[NSURL fileURLWithPath:path]];
    [self valueChanged:nil];
    [self.avPlayerView setTapCallBack:^(CrAVPlayerView *playerView) {
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
