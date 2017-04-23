//
//  JKSportModel.m
//  DrakHorseWork
//
//  Created by Jokin on 2017/4/21.
//  Copyright © 2017年 Jokin. All rights reserved.
//

#import "JKSportModel.h"
#import "JKSportPoleLine.h"
@implementation JKSportModel
{
    
    CLLocation *source;
}



- (instancetype)initWithSpotrType:(HMSportType)type {
    
    if (self) {
        
    
    _spotrType = type;
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
    }
    return self;
    
}

- (JKSportPoleLine *)appendPolyLineWithDest:(CLLocation *)dest {
    
    if (dest.speed <= 0) {
        return nil;
    }
    
    if ([[NSDate date] timeIntervalSinceDate:dest.timestamp] >= 2) {
        return nil;
    }
    
    if (source == nil) {
        source = dest;
        _startAnno = [[MAPointAnnotation alloc] init];
        _startAnno.coordinate = dest.coordinate;
        return nil;
    }
    
    
    JKSportPoleLine *polyLine = [JKSportPoleLine polylineWithSourceLocation:source andDestLocation:dest];
    source = dest;
    return polyLine;
    
    
}








@end
