//
//  JKSportModel.h
//  DrakHorseWork
//
//  Created by Jokin on 2017/4/21.
//  Copyright © 2017年 Jokin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import "JKSportPoleLine.h"

typedef enum : NSUInteger {
    HMSportTypeRunning,  //跑步
    HMSportTypeRiding,  //骑行
    HMSportTypeWalking, //步行
} HMSportType;  //运动类型

typedef enum : NSUInteger {
    HMSportStateContinue, //继续
    HMSportStatePause,  //暂停
    HMSportStateFinish,  //结束
} JKSportState;
@interface JKSportModel : NSObject

// 起点大头针模型
@property (nonatomic,strong)MAPointAnnotation *startAnno;
// 运动类型
@property (nonatomic,assign)HMSportType spotrType;
// 运动类型图片名称
@property (nonatomic,copy) NSString *sportImageName;

//运动状态
@property (nonatomic, assign) JKSportState sportState;
//总距离  km
@property (nonatomic, assign, readonly) CGFloat totalDistance;
//总时长  s
@property (nonatomic, assign, readonly) CGFloat totalTime;

//最大速度  km/hour
@property (nonatomic, assign, readonly) CGFloat maxSpeed;
//平均速度  km/hour
@property (nonatomic, assign, readonly) CGFloat avgSpeed;

- (instancetype)initWithSportType:(HMSportType)sportType withSportState:(JKSportState)state;


- (JKSportPoleLine *)appendPolylineWithDest:(CLLocation *)dest;



@end
