//
//  JKHomeViewController.m
//  DrakHorseWork
//
//  Created by Jokin on 2017/4/21.
//  Copyright © 2017年 Jokin. All rights reserved.
//

#import "JKHomeViewController.h"
#import "JKSportViewController.h"


@interface JKHomeViewController ()
    
@property (strong, nonatomic) IBOutlet UIButton *runBtn;
@property (strong, nonatomic) IBOutlet UIButton *buyCarBtn;

@property (strong, nonatomic) IBOutlet UIButton *workBtn;

@end

@implementation JKHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self creatMapView];
    
 
    
}
- (IBAction)runBtn:(UIButton *)sender {
    
    JKSportViewController *sportVc = [[JKSportViewController alloc] init];
    JKSportModel *model = [[JKSportModel alloc] initWithSpotrType:sender.tag];
    sportVc.model = model;
    [self presentViewController:sportVc animated:YES completion:nil];
    
    
}
    



    

@end
