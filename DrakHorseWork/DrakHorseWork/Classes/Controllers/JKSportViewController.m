//
//  JKSportViewController.m
//  DrakHorseWork
//
//  Created by Jokin on 2017/4/21.
//  Copyright © 2017年 Jokin. All rights reserved.
//

#import "JKSportViewController.h"
#import "JKSportTrackViewController.h"
#import "UIColor+CZAddition.h"
#import "JKSpotrCameraViewController.h"

@interface JKSportViewController ()
@property (strong, nonatomic) IBOutlet UIView *trackView;
@property (strong, nonatomic) IBOutlet UIView *controlView;
@property (nonatomic,strong)JKSportTrackViewController *trackVc;
@property (strong, nonatomic) IBOutlet UIButton *locationBtn;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *avgSpeedLabel;
@property (strong, nonatomic) IBOutlet UIButton *pauseBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *continueXConstraint;
@property (strong, nonatomic) IBOutlet UIButton *continueBtn;
@property (nonatomic,assign)BOOL isAnimation;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *finishXConstraint;
@end

@implementation JKSportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.trackVc = [[JKSportTrackViewController alloc] init];
    self.trackVc.model = self.model;
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationDidUpdateNote) name:@"reloadTimeNot" object:nil];
    
}
-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)locationDidUpdateNote{
    //设置数据
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f", self.model.totalDistance];
    self.timeLabel.text = self.model.timeStr;
    self.avgSpeedLabel.text = [NSString stringWithFormat:@"%.2f", self.model.avgSpeed];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.trackVc.center = self.locationBtn.center;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationDidUpdate:) name:@"JKSportLocationDidUpdateNote" object:nil];
    [self addBackGroundLayer];
}

- (void)addBackGroundLayer {
    
    CAGradientLayer *layer = [CAGradientLayer layer];
    
    layer.bounds = self.view.bounds;
    
    layer.position = self.view.center;
    
    //获取16进制颜色
    CGColorRef color1 = [UIColor cz_colorWithHex:0x0e1428].CGColor;
    CGColorRef color2 = [UIColor cz_colorWithHex:0x406479].CGColor;
    CGColorRef color3 = [UIColor cz_colorWithHex:0x406578].CGColor;
    
    layer.colors = @[(__bridge id)color1,(__bridge id)color2,(__bridge id)color3];
    
    layer.locations = @[@0,@(0.6),@1];
    
    [self.view.layer insertSublayer:layer atIndex:0];
    
}

- (IBAction)camearBtnAction:(id)sender {
    
    JKSpotrCameraViewController *cameraVC = [JKSpotrCameraViewController new];
    cameraVC.track = self.model;
    [self presentViewController:cameraVC animated:YES completion:nil];
    
}



- (void)locationDidUpdate:(NSNotification *)not {
    
    CLLocation *location = not.userInfo[@"JKSportLocationDidUpdateNoteLocationKey"];
    if (!_isAnimation) {
        
    
    if (location.speed == 0 && self.model.spotrType == HMSportStateContinue) {
        [self stateBtn:self.pauseBtn];
    }else if (location.speed > 0 && self.model.spotrType == HMSportStatePause) {
        
        [self stateBtn:self.continueBtn];
    }
    }
    
    
}

- (IBAction)touchLocationBtn:(UIButton *)sender {
    
    [self presentViewController:self.trackVc animated:YES completion:nil];
}

- (IBAction)stateBtn:(UIButton *)sender {
    self.isAnimation = YES;
    self.continueBtn.enabled = NO;
    self.pauseBtn.enabled = NO;
    self.model.spotrType = sender.tag;
    self.model.sportState = sender.tag;
    switch (sender.tag) {
        case HMSportStatePause:
        {
            //继续按钮左偏
            self.continueXConstraint.constant -= 90;
            //结束按钮右偏
            self.finishXConstraint.constant += 90;
            //隐藏暂停按钮
            self.pauseBtn.hidden = YES;
            [UIView animateWithDuration:0.25 animations:^{
                [self.view layoutIfNeeded];
            }completion:^(BOOL finished) {
                self.continueBtn.enabled = YES;
                self.pauseBtn.enabled = YES;
                self.isAnimation = NO;
            }];
            
        }
            break;
        case HMSportStateContinue:
        {
            //继续按钮右偏
            self.continueXConstraint.constant += 90;
            //结束按钮左偏
            self.finishXConstraint.constant -= 90;
            
            [UIView animateWithDuration:0.25 animations:^{
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                self.continueBtn.enabled = YES;
                self.pauseBtn.enabled = YES;
                //显示暂停按钮
                self.pauseBtn.hidden = NO;
                self.isAnimation = NO;
               
            }];
            
        }
            break;
            
        default:
            break;
    }
}

@end
