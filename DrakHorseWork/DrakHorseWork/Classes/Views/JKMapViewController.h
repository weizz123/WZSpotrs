//
//  JKMapViewController.h
//  DrakHorseWork
//
//  Created by Jokin on 2017/4/21.
//  Copyright © 2017年 Jokin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import "JKSportModel.h"

typedef NS_ENUM(NSUInteger, JKMapType) {
    JKMapTypeStandard, //标准地图
    JKMapTypeSatellite, //卫星地图
    JKMapTypeMix, //混合地图
};


@interface JKMapViewController : UIViewController
    
@property (nonatomic,strong)MAMapView *mapView;

@property (nonatomic,strong)JKSportModel *track;

@property (nonatomic,assign)CGPoint btnCenter;
    
@property (nonatomic,assign)JKMapType type;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
@end
