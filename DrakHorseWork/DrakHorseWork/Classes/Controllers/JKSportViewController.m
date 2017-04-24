//
//  JKSportViewController.m
//  DrakHorseWork
//
//  Created by Jokin on 2017/4/21.
//  Copyright © 2017年 Jokin. All rights reserved.
//

#import "JKSportViewController.h"
#import "JKSportTrackViewController.h"

@interface JKSportViewController ()
@property (strong, nonatomic) IBOutlet UIView *trackView;
@property (strong, nonatomic) IBOutlet UIView *controlView;
@property (nonatomic,strong)JKSportTrackViewController *trackVc;
@property (strong, nonatomic) IBOutlet UIButton *locationBtn;

@end

@implementation JKSportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.trackVc = [[JKSportTrackViewController alloc] init];
    self.trackVc.model = self.model;
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.trackVc.center = self.locationBtn.center;
    
}

- (IBAction)touchLocationBtn:(UIButton *)sender {
    
    [self presentViewController:self.trackVc animated:YES completion:nil];
}

- (IBAction)stateBtn:(UIButton *)sender {
    
    self.model.spotrType = sender.tag;
    
}

@end
