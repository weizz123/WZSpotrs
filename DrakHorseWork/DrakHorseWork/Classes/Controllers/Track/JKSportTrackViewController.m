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
#import "JKSportPopOverViewViewController.h"
#import "JKSportPopOverViewViewController.h"
@interface JKSportTrackViewController ()<UIPopoverPresentationControllerDelegate>
@property (nonatomic,strong)JKMapViewController *mapView;
@property (nonatomic,strong)JKAnimation *animation;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

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
    // 接收距离.时间改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTimeAndDistance) name:@"reloadTimeNot" object:nil];
    
    
}

- (void)changeTimeAndDistance {
    
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f",self.model.totalDistance];
    self.timeLabel.text = self.model.timeStr;
    
    
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
//    [self.view addSubview:self.mapView.view];
    [self.view insertSubview:self.mapView.view atIndex:0];
    
    [self.mapView didMoveToParentViewController:self];
    
}

- (IBAction)showMapViewStyleBtn:(id)sender {
    JKSportPopOverViewViewController *popVc = [[JKSportPopOverViewViewController alloc] initWithMapStyle:^(JKMapType type) {
        self.mapView.type = type;
    }];
    
    popVc.mapType = self.mapView.type;
    popVc.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *popVer = popVc.popoverPresentationController;
    popVer.delegate = self;
    popVer.sourceView = sender;
    popVc.preferredContentSize = CGSizeMake(300, 120);
    popVer.permittedArrowDirections = UIPopoverArrowDirectionDown;
    [self presentViewController:popVc animated:YES completion:nil];
    
    
}





- (IBAction)disMissViewController:(id)sender {
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}


@end
