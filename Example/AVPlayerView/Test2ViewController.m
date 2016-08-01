//
//  Test2ViewController.m
//  AVPlayerView
//
//  Created by ChoJaehyun on 2016. 8. 1..
//  Copyright © 2016년 com.skswhwo. All rights reserved.
//

#import "Test2ViewController.h"
#import "AVPlayerView.h"

@interface Test2ViewController ()
@property (weak, nonatomic) IBOutlet AVPlayerView *avPlayerView;

@property (weak, nonatomic) IBOutlet UISwitch *autoplaySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *loopSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *dimmedEffectSwitch;
@end

@implementation Test2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
    [self.avPlayerView playerWithContentURL:[NSURL fileURLWithPath:path]];
    [self valueChanged:nil];
    [self.avPlayerView setTapCallBack:^(AVPlayerView *playerView) {
    }];
    [self.avPlayerView setDidAppear:^(AVPlayerView *playerView) {
        //do something;
    }];
    [self.avPlayerView setDidDisappear:^(AVPlayerView *playerView) {
        //do something;
    }];
}

- (IBAction)valueChanged:(id)sender
{
    self.avPlayerView.autoplay      = self.autoplaySwitch.on;
    self.avPlayerView.loop          = self.loopSwitch.on;
    self.avPlayerView.dimmedEffect  = self.dimmedEffectSwitch.on;
}

@end
