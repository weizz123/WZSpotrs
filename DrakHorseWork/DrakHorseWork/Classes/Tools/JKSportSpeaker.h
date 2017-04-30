//
//  JKSportSpeaker.h
//  DrakHorseWork
//
//  Created by Jokin on 2017/4/27.
//  Copyright © 2017年 Jokin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKSportModel.h"

@interface JKSportSpeaker : NSObject

- (void)startSportWithSportType:(HMSportType)sportType;


- (void)changeSportState:(JKSportState)sportState;

- (void)reportSportWithDistance:(double)distance andTime:(double)time andAvgSpeed:(double)avgSpeed;

@end
