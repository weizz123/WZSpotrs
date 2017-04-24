//
//  JKSportTrackViewController.m
//  DrakHorseWork
//
//  Created by Jokin on 2017/4/23.
//  Copyright © 2017年 Jokin. All rights reserved.
//

#import "JKSportTrackViewController.h"
#import "JKMapViewController.h"
#import "JKAnimation.h"
@interface JKSportTrackViewController ()
@property (nonatomic,strong)JKMapViewController *mapView;
@property (nonatomic,strong)JKAnimation *animation;

@end

@implementation JKSportTrackViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self creatTrackView];
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.animation = [JKAnimation new];
        self.transitioningDelegate = self.animation;

    }
    return self;
}


- (void)setCenter:(CGPoint)center {
    
    _center = center;
    self.mapView.btnCenter = center;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setModel:(JKSportModel *)model {
    _model = model;
    
    self.mapView.track = self.model;
    
}

- (void)creatTrackView {
    self.mapView = [[JKMapViewController alloc] init];
    [self addChildViewController:self.mapView];
    self.mapView.view.frame = self.view.bounds;
    self.mapView.btnCenter = self.center;
    [self.view addSubview:self.mapView.view];
    
    [self.mapView didMoveToParentViewController:self];
    
}

@end
