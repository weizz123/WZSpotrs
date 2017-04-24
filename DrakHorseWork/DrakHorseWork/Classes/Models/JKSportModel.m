//
//  JKSportModel.m
//  DrakHorseWork
//
//  Created by Jokin on 2017/4/21.
//  Copyright © 2017年 Jokin. All rights reserved.
//

#import "JKSportModel.h"

@implementation JKSportModel
{
    
    CLLocation *source;
    NSMutableArray <JKSportPoleLine *> *_polylines;

}

@synthesize totalTime = _totalTime;
@synthesize totalDistance = _totalDistance;
@synthesize avgSpeed = _avgSpeed;
@synthesize maxSpeed = _maxSpeed;

- (instancetype)initWithSportType:(HMSportType)sportType withSportState:(JKSportState)state {
    self = [super init];
    if (self) {
        
    
    _spotrType = sportType;
    NSString *sportImageName;
    switch (_spotrType) {
        case HMSportTypeRunning:
            sportImageName = @"map_annotation_run";
            break;
        case HMSportTypeRiding:
            sportImageName = @"map_annotation_bike";
            break;
        case HMSportTypeWalking:
            sportImageName = @"map_annotation_walk";
            break;
        default:
            break;
    }
    _sportImageName = sportImageName;
        _sportState = state;
        _polylines = [NSMutableArray array];
        
    }

    return self;
    
}


- (JKSportPoleLine *)appendPolylineWithDest:(CLLocation *)dest{
    
    //判断运动状态
    if (self.sportState != HMSportStateContinue) {
        //暂停/结束运动时,停止生成折线
        //清空记录的折线起点
        source = nil;
        return nil;
    }
    
    //判断是否移动 速度=0   当手机在室内时,speed为负值,表明室内GPS被干扰,速度无效
    if (dest.speed <= 0) {
        
        return nil;
    }
    
    //排除已经"过期"的定位数据  计算当前时间和定位时间戳的差值  2秒以内的数据可用
    if ([[NSDate date] timeIntervalSinceDate:dest.timestamp] >= 2) {
        
        return nil;
    }
    
    
    //判断首次调用
    if (source == nil) {
        
        //记录起点
        source = dest;
        //生成起点大头针模型
        _startAnno = [[MAPointAnnotation alloc] init];
        _startAnno.coordinate = dest.coordinate;
        
        return nil;
    }
    
    //创建折线
    JKSportPoleLine *polyline = [JKSportPoleLine polylineWithSourceLocation:source andDestLocation:dest];
    //将折线模型进行记录
    [_polylines addObject:polyline];
    
    //记录下一段的起点
    source = dest;
    
    return polyline;
}

- (CGFloat)totalTime {
 
    _totalTime = [[_polylines valueForKeyPath:@"@sum.time"] floatValue];
    return _totalTime;
    
}

- (CGFloat)maxSpeed{
    //求集合中元素的某个属性的和 可以使用kvc来进行运算
  
    _maxSpeed = [[_polylines valueForKeyPath:@"@max.speed"] floatValue];
    return _maxSpeed;
}


- (CGFloat)avgSpeed{
    //求集合中元素的某个属性的和 可以使用kvc来进行运算
 
    _avgSpeed = [[_polylines valueForKeyPath:@"@avg.speed"] floatValue];
    return _avgSpeed;
}

- (CGFloat)totalDistance{
 
    //求集合中元素的某个属性的和 可以使用kvc来进行运算
    _totalDistance = [[_polylines valueForKeyPath:@"@sum.distance"] floatValue];
    return _totalDistance;
}



@end
