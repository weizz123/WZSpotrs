//
//  JKSportCPSButton.m
//  DrakHorseWork
//
//  Created by Jokin on 2017/4/24.
//  Copyright © 2017年 Jokin. All rights reserved.
//

#import "JKSportCPSButton.h"
#import "JKSportModel.h"
@implementation JKSportCPSButton

- (void)awakeFromNib {
    [super awakeFromNib];
    //监听GPS更新通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeGPSStateNote:) name:@"HMSportGPSStateDidChangeNote" object:nil];
    
}
//更新gps信息后调用
- (void)didChangeGPSStateNote:(NSNotification *)note{
    
    JKSportGPSState state = [note.userInfo[@"HMSportGPSStateDidChangeNoteGPSStateKey"] unsignedIntegerValue];
    
    NSString *content;
    NSString *imgName;
    
    switch (state) {
        case HMSportGPSStateDisconnect:{
            //设置图片
            imgName = _isTrackBtn ? @"ic_sport_gps_map_disconnect" : @"ic_sport_gps_disconnect";
            //设置文字
            content = @" GPS已断开 ";
        }
            break;
        case HMSportGPSStateBad:{
            //设置图片
            imgName = _isTrackBtn ? @"ic_sport_gps_map_connect_1" : @"ic_sport_gps_connect_1";
            //设置文字
            content = @" 请绕开高楼大厦 ";
        }
            break;
        case HMSportGPSStateNormal:{
            //设置图片
            imgName = _isTrackBtn ? @"ic_sport_gps_map_connect_2" : @"ic_sport_gps_connect_2";
            //设置文字
            content = nil;
        }
            break;
        case HMSportGPSStateGood:{
            //设置图片
            imgName = _isTrackBtn ? @"ic_sport_gps_map_connect_3" : @"ic_sport_gps_connect_3";
            content = nil;
        }
            break;
        default:
            break;
    }
    [self setTitle:content forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
}

@end
