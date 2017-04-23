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

@interface JKSportModel : NSObject

// 起点大头针模型
@property (nonatomic,strong)MAPointAnnotation *startAnno;
// 运动类型
@property (nonatomic,assign)HMSportType spotrType;
// 运动类型图片名称
@property (nonatomic,copy) NSString *sportImageName;


- (instancetype)initWithSpotrType:(HMSportType)type;


- (MAPolyline *)appendPolyLineWithDest:(CLLocation *)dest;



@end
