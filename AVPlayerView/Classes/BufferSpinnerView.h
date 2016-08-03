//
//  BufferSpinnerView.h
//  AVPlayerView
//
//  Created by ChoJaehyun on 2016. 8. 3..
//  Copyright © 2016년 com.skswhwo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BufferSpinnerView : UIView

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (nonatomic, strong, readonly) CAShapeLayer *layer;
#pragma clang diagnostic pop

- (void)startAnimating;
- (void)stopAnimating;

@end
