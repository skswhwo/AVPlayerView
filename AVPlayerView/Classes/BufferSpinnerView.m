//
//  BufferSpinnerView.m
//  AVPlayerView
//
//  Created by ChoJaehyun on 2016. 8. 3..
//  Copyright © 2016년 com.skswhwo. All rights reserved.
//

#import "BufferSpinnerView.h"


static NSString *SpinnerViewAnimationKey = @"SpinnerViewAnimationKey";

@implementation BufferSpinnerView
+ (Class)layerClass {
    return [CAShapeLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self initializer];
    return self;
    
}

- (void)initializer
{
    self.tintColor          = [UIColor whiteColor];
    self.layer.strokeColor  = self.tintColor.CGColor;
    self.layer.fillColor    = nil;
    self.layer.lineWidth    = 4;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setPath];
}

#pragma mark - External Function
- (void)startAnimating
{
    self.hidden = NO;
    if ([self isAnimating] == false) {
        CABasicAnimation *animation = [CABasicAnimation animation];
        animation.keyPath           = @"transform.rotation";
        animation.duration          = 1.0f;
        animation.fromValue         = @(0.0f);
        animation.toValue           = @(2 * M_PI);
        animation.repeatCount       = INFINITY;
        animation.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [self.layer addAnimation:animation forKey:SpinnerViewAnimationKey];
    }
}

- (void)stopAnimating
{
    self.hidden = YES;
    if ([self isAnimating]) {
        [self.layer removeAnimationForKey:SpinnerViewAnimationKey];
    }
}

#pragma mark - Private
- (BOOL)isAnimating
{
    return [self.layer animationForKey:SpinnerViewAnimationKey] != nil;
}

- (void)setPath
{
    CGPoint center      = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat radius      = MIN(CGRectGetWidth(self.bounds)/3, CGRectGetHeight(self.bounds)/3) - self.layer.lineWidth/2;
    UIBezierPath *path  = [UIBezierPath bezierPathWithArcCenter:center
                                                         radius:radius
                                                     startAngle:-M_PI_4
                                                       endAngle:3 * M_PI_2
                                                      clockwise:YES];
    self.layer.path     = path.CGPath;
}

@end
