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
self.avPlayerView.autoplay      = self.autoplaySwitch.on;
self.avPlayerView.loop          = self.loopSwitch.on;
self.avPlayerView.dimmedEffect  = self.dimmedEffectSwitch.on;
[self.avPlayerView setTapCallBack:^(AVPlayerView *playerView) {
    if (playerView.isFullSize) {
        [playerView normalSizeMode];
    } else {
        [playerView fullSizeMode];
    } ;
}];

```

## Author

skswhwo, skswhwo@gmail.com

## License

AVPlayerView is available under the MIT license. See the LICENSE file for more info.
