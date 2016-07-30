//
//  Test1ViewController.m
//  AVPlayerView
//
//  Created by ChoJaehyun on 2016. 7. 30..
//  Copyright © 2016년 com.skswhwo. All rights reserved.
//

#import "Test1ViewController.h"
#import "AVPlayerView.h"

@interface Test1ViewController ()
@property (weak, nonatomic) IBOutlet AVPlayerView *avPlayerView;

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
}

- (IBAction)valueChanged:(id)sender
{
    self.avPlayerView.autoplay      = self.autoplaySwitch.on;
    self.avPlayerView.loop          = self.loopSwitch.on;
    self.avPlayerView.dimmedEffect  = self.dimmedEffectSwitch.on;
}

@end
