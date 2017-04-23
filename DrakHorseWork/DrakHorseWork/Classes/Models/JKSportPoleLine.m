//
//  JKSportPoleLine.m
//  DrakHorseWork
//
//  Created by Jokin on 2017/4/21.
//  Copyright © 2017年 Jokin. All rights reserved.
//

#import "JKSportPoleLine.h"

@implementation JKSportPoleLine

+ (instancetype)polylineWithSourceLocation:(CLLocation *)source andDestLocation:(CLLocation *)dest {
    
    //构造折线数据对象
    CLLocationCoordinate2D commonPolylineCoords[2];
    //起点  上一次的终点
    commonPolylineCoords[0].latitude = source.coordinate.latitude;
    commonPolylineCoords[0].longitude = source.coordinate.longitude;
    //终点
    commonPolylineCoords[1].latitude = dest.coordinate.latitude;
    commonPolylineCoords[1].longitude = dest.coordinate.longitude;
    
    //构造折线对象
    JKSportPoleLine *commonPolyline = [JKSportPoleLine polylineWithCoordinates:commonPolylineCoords count:2];
    [commonPolyline calculateSpeedWithSoure:source andDest:dest];
    return commonPolyline;
}


- (void)calculateSpeedWithSoure:(CLLocation *)soure andDest:(CLLocation *)dest {
    
    _speed = (soure.speed + dest.speed) * 0.5 * 3.6;
    _storkeColor = [UIColor colorWithRed:(_speed * 0.033) green:1 blue:0 alpha:1];
    
    
}





@end
