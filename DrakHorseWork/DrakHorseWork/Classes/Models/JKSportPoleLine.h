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




+ (instancetype)polylineWithSourceLocation:(CLLocation *)source andDestLocation:(CLLocation *)dest;


@end
