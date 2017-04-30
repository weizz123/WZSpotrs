//
//  JKSportSpeaker.m
//  DrakHorseWork
//
//  Created by Jokin on 2017/4/27.
//  Copyright © 2017年 Jokin. All rights reserved.
//

#import "JKSportSpeaker.h"
#import <AVFoundation/AVFoundation.h>
#import "NSString+HMNumberConvert.h"
@implementation JKSportSpeaker{
    //运动类型字符串
    NSString *_typeStr;
    //播报次数
    NSInteger _reportCount;
    //语音解析器
    AVSpeechSynthesizer *_synthesizer;
    //音频播放器
    AVPlayer *_avPlayer;
    //音频索引缓存
    NSDictionary *_voiceDict;
    //音频文件路径集合
    NSMutableArray *_pathArr;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        //初始化语音解析器
        _synthesizer = [[AVSpeechSynthesizer alloc] init];
        //选用AVPlayer播放器,可以进行曲目切换
        _avPlayer = [[AVPlayer alloc] init];
        //解析音频索引表
        NSString *path = [[NSBundle mainBundle] pathForResource:@"voice.bundle/voice.json" ofType:nil];
        NSData *data = [NSData dataWithContentsOfFile:path];
        _voiceDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        _pathArr = [NSMutableArray array];
        
        //监听曲目播放完成  使用通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidPlayToEndTimeNote) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        //设置音乐会话类型  保证应用进入后台运行时可以继续播放,如果需要应用在挂起时也可以播放音乐,需要设置后台运行模式
        //设置音乐类型 还可以实现多个应用同时播放音乐 必须设置混音选项AVAudioSessionCategoryOptionMixWithOthers  或者AVAudioSessionCategoryOptionDuckOthers(混音并且压低其他音乐的声音,但是默认情况下压低的音乐不会再回到初始的音量)
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionDuckOthers error:nil];
    }
    return self;
}

//曲目播放完成后调用
- (void)itemDidPlayToEndTimeNote{
    
    //移除音频路径数组中的首个元素 removeObject方法会将内容相同的所有元素都移除
    [_pathArr removeObjectAtIndex:0];
    //判断数组越界
    if (_pathArr.count > 0) {
        
        //播放当前数组中的首个音频
        [self playVoiceWithPath:_pathArr.firstObject];
        
    } else {
        
        //如果希望其他应用的音量可以恢复 必须禁用音乐会话类型
        [[AVAudioSession sharedInstance] setActive:NO error:nil];
    }
}


- (void)startSportWithSportType:(HMSportType)sportType{
    
    NSString *typeStr;
    switch (sportType) {
        case HMSportTypeRiding:
            typeStr = @"骑行";
            break;
        case HMSportTypeWalking:
            typeStr = @"走路";
            break;
        case HMSportTypeRunning:
            typeStr = @"跑步";
            break;
        default:
            break;
    }
    _typeStr = typeStr;
    //播报内容
    [self reportContent:[NSString stringWithFormat:@"开始%@", typeStr]];
    
}

- (void)changeSportState:(JKSportState)sportState{
    
    NSString *stateStr;
    switch (sportState) {
        case HMSportStatePause:
            stateStr = @"运动已暂停";
            break;
        case HMSportStateContinue:
            stateStr = @"运动已恢复";
            break;
        case HMSportStateFinish:
            stateStr = @"放松一下吧";
            break;
        default:
            break;
    }
    
    //播报内容
    [self reportContent:stateStr];
    
}

- (void)reportSportWithDistance:(double)distance andTime:(double)time andAvgSpeed:(double)avgSpeed{
    
    //判断整距离  当前距离 > (播报次数 + 1) * 单位距离
    CGFloat unitDistance = 0.5f;
    
    if (distance >= (_reportCount + 1) * unitDistance) {
        
        //获取时间字符串
        NSString *timeStr = [NSString hm_timeStringWithTimeValue:(NSInteger)time];
        //获取数字字符串
        NSString *distanceStr = [NSString hm_numberStringWithNumber:distance hasDotNumber:YES];
        NSString *avgSpeedStr = [NSString hm_numberStringWithNumber:avgSpeed hasDotNumber:YES];
        
        NSString *content = [NSString stringWithFormat:@"你已经 %@ %@ 公里 用时 %@ 平均速度 %@ 公里每小时 太棒了", _typeStr, distanceStr, timeStr, avgSpeedStr];
        
        //播报内容
        [self reportContent:content];
        
        //累加播报次数
        _reportCount++;
    }
    
}

//播报内容
- (void)reportContent:(NSString *)content{
    //分割字符串
    NSArray *voiceNameArr = [content componentsSeparatedByString:@" "];
    
    for (NSString *voiceKey in voiceNameArr) {
        
        NSLog(@"%@", voiceKey);
        
        //获取内容对应的文件名
        NSString *voiceName = _voiceDict[voiceKey];
        //拼接路径
        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"voice.bundle/%@", voiceName] ofType:nil];
        //将转换出的音频文件路径保存到内存中
        [_pathArr addObject:path];
    }
    
    //播放声音  每次播放数组中一个声音(播放完,删除数组中的第一个声音,继续播放)
    [self playVoiceWithPath:_pathArr.firstObject];
}

- (void)playVoiceWithPath:(NSString *)path{
    //如果希望其他应用的音量可以恢复 必须禁用音乐会话类型
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    //创建曲目对象
    AVPlayerItem *currentItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:path]];
    //切换下一曲
    [_avPlayer replaceCurrentItemWithPlayerItem:currentItem];
    
    //播放曲目
    [_avPlayer play];
}


- (void)testSpeechWithContent:(NSString *)content{
    
    //播报新内容时,停止当前正在播放的内容
    [_synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    //创建声音对象
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:content];
    //设置语言
    //    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"fr-BE"];
    //播报内容
    [_synthesizer speakUtterance:utterance];
    
    NSLog(@"%@", content);
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
