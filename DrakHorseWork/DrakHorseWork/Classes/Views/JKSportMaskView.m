//
//  JKSportMaskView.m
//  DrakHorseWork
//
//  Created by Jokin on 2017/4/29.
//  Copyright © 2017年 Jokin. All rights reserved.
//

#import "JKSportMaskView.h"
#import "UIColor+CZAddition.h"
@interface JKSportMaskView ()
@property (nonatomic, weak) IBOutlet UIImageView *shutterView;


@end

@implementation JKSportMaskView



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    // 设置背景色
    [[UIColor cz_colorWithHex:0x25282e] setFill];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    [path fill];
    
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    if (self.shutterView.frame.origin.x > 0) {
        [linePath moveToPoint:CGPointMake(rect.size.width, 0)];
        [linePath addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
        
    }else {
        [linePath moveToPoint:CGPointMake(0, 0)];
        [linePath addLineToPoint:CGPointMake(0, rect.size.height)];
        
    }
    [[UIColor cz_colorWithHex:0x1B1C1D] setStroke];
    [linePath stroke];
    
    
    
    
    
}


@end
