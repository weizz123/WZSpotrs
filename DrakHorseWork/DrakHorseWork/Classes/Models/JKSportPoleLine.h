//
//  JKSportPoleLine.h
//  DrakHorseWork
//
//  Created by Jokin on 2017/4/21.
//  Copyright © 2017年 Jokin. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface JKSportPoleLine : MAPolyline

@property (nonatomic,assign) CGFloat speed;

@property (nonatomic,strong)UIColor *storkeColor;

//折线距离   km
@property (nonatomic, assign, readonly) CGFloat distance;

//折线时长   s
@property (nonatomic, assign, readonly) CGFloat time;



+ (instancetype)polylineWithSourceLocation:(CLLocation *)source andDestLocation:(CLLocation *)dest;


@end
