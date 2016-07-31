# AVPlayerView

AVPlayer module that implemented by subclass of UIView class
- Support constraints and XIB implementation
- Support autoplay, loop mode
- Easy to use 

![alt text](https://github.com/skswhwo/AVPlayerView/blob/master/sample1.gif "demo")

## Installation

AVPlayerView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

`
pod "AVPlayerView"
`

And then run:

`
$ pod install
`

## Usage

```objective-c
NSString *path = [[NSBundle mainBundle] pathForResource:@"short" ofType:@"mp4"];
[self.avPlayerView playerWithContentURL:[NSURL fileURLWithPath:path]];
self.avPlayerView.autoplay      = YES;
self.avPlayerView.loop          = YES;
self.avPlayerView.dimmedEffect  = YES;                  //default: true
self.pauseWhenDisappear         = YES;                  //default: true
self.playWhenAppear             = YES;                  //default: true (require autoplay)
self.backgroundColorForFullSize = [UIColor blackColor]; //default: black

[self.avPlayerView setTapCallBack:^(AVPlayerView *playerView) {
    if (playerView.isFullSize) {
        [playerView normalSizeMode];
    } else {
        [playerView fullSizeMode];
    } ;
}];

[self.avPlayerView setDidAppear:^(AVPlayerView *playerView) {
    //do somthing;
}];

[self.avPlayerView setDidDisappear:^(AVPlayerView *playerView) {
    //do somthing;
}];

```

## Author

skswhwo, skswhwo@gmail.com

## License

AVPlayerView is available under the MIT license. See the LICENSE file for more info.
