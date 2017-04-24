//
//  JKAnimation.m
//  DrakHorseWork
//
//  Created by Jokin on 2017/4/23.
//  Copyright © 2017年 Jokin. All rights reserved.
//

#import "JKAnimation.h"

@implementation JKAnimation

{
    
    __weak id <UIViewControllerContextTransitioning> _transitionContext;
    BOOL _hasPresented;
    
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    _hasPresented = NO;
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    _hasPresented = YES;
    return self;
    
}


- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 1.0f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    _transitionContext = transitionContext;
    // 获取目标控制器视图
    UIView *destView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *sourceView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    // 获取转场容器视图
    UIView *contaiinerView = [transitionContext containerView];
    
    if (!_hasPresented) {
        [contaiinerView addSubview:destView];
        destView.frame = contaiinerView.bounds;
    }
    UIView *contentView = _hasPresented ? sourceView : destView;
    [self custemAnimInView:contentView];
    
}

- (void)custemAnimInView:(UIView *)view {
    
    // 创建形状图层
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    // 起始位置
    CGFloat topMargin = 33;
    CGFloat rightMargin = 21;
    CGFloat radius = 15;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    CGRect sourceRect = CGRectMake(screenW - rightMargin - 2 * radius, topMargin, 2 * radius, 2 * radius);
    CGPathRef sourcePath = [UIBezierPath bezierPathWithOvalInRect:sourceRect].CGPath;
    CGFloat endRadius = sqrt((screenW * screenW) + (screenH * screenH));
    
    CGRect endRect = CGRectInset(sourceRect, - endRadius, -endRadius);
    
    CGPathRef endPath = [UIBezierPath bezierPathWithOvalInRect:endRect].CGPath;
    
    view.layer.mask = shapeLayer;
    
    CABasicAnimation *basicAnim = [CABasicAnimation animationWithKeyPath:@"path"];
    
    if (_hasPresented) {
        basicAnim.toValue = (__bridge id _Nullable)(sourcePath);
        basicAnim.fromValue = (__bridge id _Nullable)(endPath);
    }else {
        basicAnim.toValue = (__bridge id _Nullable)(endPath);
        basicAnim.fromValue = (__bridge id _Nullable)(sourcePath);
    }
    basicAnim.duration = 1.0f;
    basicAnim.removedOnCompletion = NO;
    basicAnim.fillMode = kCAFillModeForwards;
    basicAnim.delegate = self;
    [shapeLayer addAnimation:basicAnim forKey:nil];
    
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    [_transitionContext completeTransition:YES];
}




@end
