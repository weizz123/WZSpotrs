//
//  JKSpotrCameraViewController.m
//  DrakHorseWork
//
//  Created by Jokin on 2017/4/29.
//  Copyright © 2017年 Jokin. All rights reserved.
//

#import "JKSpotrCameraViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface JKSpotrCameraViewController ()
@property (strong, nonatomic) IBOutlet UIButton *revolveBtn;
@property (strong, nonatomic) IBOutlet UIButton *shareBtn;
@property (strong, nonatomic) IBOutlet UILabel *imageSeaveLabel;

@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *cameraConstraints;
@property (strong, nonatomic) IBOutlet UIButton *cameraBtn;

// 输入设备
@property (nonatomic,strong) AVCaptureDeviceInput *input;
// 输出设备
@property (nonatomic,strong) AVCaptureStillImageOutput *outPut;
// 会话
@property (nonatomic,strong) AVCaptureSession *session;
// 预览视图
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (strong, nonatomic) IBOutlet UIImageView *sportImgV;

@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UIView *cameraView;

@end

@implementation JKSpotrCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCamera];
    // 设置距离水印内容
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f KM",self.track.totalDistance];
    
}
// 设置相机
- (void)setupCamera {
    // 输入设备,摄像头
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    // 输出设备
    self.outPut = [[AVCaptureStillImageOutput alloc] init];
    // 会话
    self.session = [[AVCaptureSession alloc] init];
    // 添加输入输出设备
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.outPut]) {
        [self.session addOutput:self.outPut];
    }
    // 预览视图
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    [self.cameraView.layer insertSublayer:self.previewLayer atIndex:0];
    
    // 设置预览视图样式,否则就会按照设备的尺寸按比例缩放
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    // 开始会话
    [self.session startRunning];
    
    
    
}
- (IBAction)changeCameraBtnAction:(UIButton *)sender {
    
    [self.session stopRunning];
    sender.selected = !sender.selected;
    
    AVCaptureDevice *device = [self getChangeDevice];
    [self.session removeInput:self.input];
    
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    [self.session startRunning];
    
    
    
}

// 点击拍照
- (IBAction)cameraBtnAction:(id)sender {
    if (self.session.isRunning == NO) {// 照片模式
        // 翻转动画
        [self rotateAnim];
        [self.session startRunning];
        return;
    }
    // 关闭快门
    [self camearWithClose:YES];
    
    // 执行拍照
    [self takePicture];
    
}

- (void)takePicture {
    
    // 执行拍照
    [self.outPut captureStillImageAsynchronouslyFromConnection:self.outPut.connections.firstObject completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
       
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *image = [UIImage imageWithData:imageData];
        
        // 裁切图片
        CGFloat offset = ([UIScreen mainScreen].bounds.size.height - self.cameraView.frame.size.height) * .5;
        
        UIGraphicsBeginImageContextWithOptions(self.cameraView.frame.size, YES, 0);
        
        [image drawInRect:CGRectMake(0, -offset, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [self.distanceLabel.attributedText drawInRect:self.distanceLabel.frame];
        
        [self.sportImgV.image drawInRect:self.sportImgV.frame];
        
        UIImage *editedImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImageWriteToSavedPhotosAlbum(editedImg, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        
    }];
    
 
}

//保存图片后的回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo{
    
    [self rotateAnim];
    [self.session stopRunning];
    [self camearWithClose:NO];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.imageSeaveLabel.alpha = 1.0;
        self.imageSeaveLabel.text = (error == nil) ? @"图片保存成功" : @"图片保存失败";
        [UIView animateWithDuration:1 animations:^{
            self.imageSeaveLabel.alpha = 0;
        }];
        
    });
    
    
}

- (BOOL)prefersStatusBarHidden {
    
    return YES;
}
- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    self.previewLayer.frame = self.cameraView.bounds;
}

// 执行快门操作
- (void)camearWithClose:(BOOL)close {
    
    if (close) {
        [NSLayoutConstraint deactivateConstraints:self.cameraConstraints];
    }else {
        
        [NSLayoutConstraint activateConstraints:self.cameraConstraints];
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    
}

- (AVCaptureDevice *)getChangeDevice {
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDevicePosition position = self.revolveBtn.selected ?  AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return devices.firstObject;
}


- (void)rotateAnim {
    
    NSString *title = self.session.isRunning ? @"✓" : nil;
    [self.cameraBtn setTitle:title forState:UIControlStateNormal];
    // 设置翻转动画
    UIViewAnimationOptions option = self.session.isRunning ? UIViewAnimationOptionTransitionFlipFromRight : UIViewAnimationOptionTransitionFlipFromLeft;
    [UIView transitionWithView:self.cameraBtn duration:0.25 options:option animations:nil completion:nil];
    [UIView transitionWithView:self.revolveBtn duration:0.25 options:option animations:nil completion:nil];
    // 切换图片
    NSString *imageName = self.session.isRunning ? @"ic_waterprint_share" : @"ic_waterprint_revolve";
    [self.revolveBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
   
    
}


- (IBAction)closeBtnAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
