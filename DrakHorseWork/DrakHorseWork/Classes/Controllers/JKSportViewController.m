//
//  JKSportViewController.m
//  DrakHorseWork
//
//  Created by Jokin on 2017/4/21.
//  Copyright © 2017年 Jokin. All rights reserved.
//

#import "JKSportViewController.h"
#import "JKMapViewController.h"


@interface JKSportViewController ()
@property (strong, nonatomic) IBOutlet UIView *trackView;
@property (strong, nonatomic) IBOutlet UIView *controlView;

@end

@implementation JKSportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatTrackView];
}

- (void)creatTrackView {
    JKMapViewController *mapView = [[JKMapViewController alloc] init];
    [self addChildViewController:mapView];
    mapView.view.frame = self.trackView.bounds;
    [self.trackView addSubview:mapView.view];
    mapView.track = self.model;
    [mapView didMoveToParentViewController:self];
    
    
    
    
}

@end
