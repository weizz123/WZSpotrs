//
//  JKSportPopOverViewViewController.h
//  DrakHorseWork
//
//  Created by Jokin on 2017/4/24.
//  Copyright © 2017年 Jokin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKMapViewController.h"
@interface JKSportPopOverViewViewController : UIViewController

@property (nonatomic,assign)JKMapType mapType;

- (instancetype)initWithMapStyle:(void (^)(JKMapType type))selectBlock;


@end
