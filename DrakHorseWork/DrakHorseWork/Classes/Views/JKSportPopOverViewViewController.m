//
//  JKSportPopOverViewViewController.m
//  DrakHorseWork
//
//  Created by Jokin on 2017/4/24.
//  Copyright © 2017年 Jokin. All rights reserved.
//

#import "JKSportPopOverViewViewController.h"

@interface JKSportPopOverViewViewController ()

@property (nonatomic,copy) void (^selectBl)(JKMapType type);
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *mapBtnArray;

@end

@implementation JKSportPopOverViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = self.mapBtnArray[self.mapType];
    btn.selected = YES;
}

- (instancetype)initWithMapStyle:(void (^)(JKMapType))selectBlock {
    self = [super init];
    if (self) {
        self.selectBl = selectBlock;
    }
    return self;
    
}


- (IBAction)touchMapStyleBtn:(UIButton *)sender {
    
    for (UIButton *btn in self.mapBtnArray) {
        if (!sender.selected) {
            if (self.selectBl) {
                self.selectBl(sender.tag);
            }
        }
        btn.selected = (btn == sender)? YES : NO;
    }
    
    
    
}




@end
