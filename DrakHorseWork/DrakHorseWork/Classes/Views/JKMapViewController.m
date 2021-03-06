//
//  JKMapViewController.m
//  DrakHorseWork
//
//  Created by Jokin on 2017/4/21.
//  Copyright © 2017年 Jokin. All rights reserved.
//

#import "JKMapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface JKMapViewController ()<MAMapViewDelegate>
@property (nonatomic,assign) BOOL hasSetStarAnnor;
@end

@implementation JKMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    ///初始化地图
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.showsScale = NO;
    ///把地图添加至view
    [self.view addSubview:_mapView];
    [self creartmapView];
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
}

- (void)creartmapView {
    
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    _mapView.rotateCameraEnabled = NO;
    _mapView.allowsBackgroundLocationUpdates = YES;
    _mapView.pausesLocationUpdatesAutomatically = NO;
    _mapView.delegate = self;
    
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.mapView.compassOrigin =  CGPointMake(_btnCenter.x - _mapView.compassSize.width * 0.5, _btnCenter.y - _mapView.compassSize.height * 0.5);
    
}

- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate {
    //构造折线数据对象
    CLLocationCoordinate2D commonPolylineCoords[2];
    commonPolylineCoords[0].latitude = _mapView.userLocation.location.coordinate.latitude;
    commonPolylineCoords[0].longitude =_mapView.userLocation.location.coordinate.longitude;
    
    commonPolylineCoords[1].latitude = coordinate.latitude;
    commonPolylineCoords[1].longitude = coordinate.longitude;
 
    
    //构造折线对象
    MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:2];
    
    //在地图上添加折线对象
    [_mapView addOverlay: commonPolyline];
    
    
    
}


- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    
    if (updatingLocation == NO) {
        return;
    }
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTimeNot" object:nil];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"JKSportLocationDidUpdateNote" object:nil userInfo:@{@"JKSportLocationDidUpdateNoteLocationKey": userLocation.location}];
    _mapView.centerCoordinate = userLocation.location.coordinate;
    
    if (_hasSetStarAnnor == NO && self.track.startAnno) {
        [_mapView addAnnotation:self.track.startAnno];
        _hasSetStarAnnor = YES;
    }
    
    
    JKSportPoleLine *newPolyline = [self.track appendPolylineWithDest:userLocation.location];
   
    [_mapView addOverlay:newPolyline];
    
   
    NSLog(@"总距离:%f, 总时长:%f, 最大速度:%f, 平均速度:%f", self.track.totalDistance, self.track.totalTime, self.track.maxSpeed, self.track.avgSpeed);
    
}
- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    
    //GPS断开
    //发送gps更新通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HMSportGPSStateDidChangeNote" object:nil userInfo:@{@"HMSportGPSStateDidChangeNoteGPSStateKey": @(HMSportGPSStateDisconnect)}];
}

- (void)setType:(JKMapType)type {
    _type = type;
    _mapView.mapType = (MAMapType)_type;
    
    
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.image = [UIImage imageNamed:self.track.sportImageName];
        annotationView.centerOffset = CGPointMake(0, -annotationView.image.size.height * 0.5);
        return annotationView;
    }
    return nil;
}


- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth    = 4.f;
        JKSportPoleLine *polyline = overlay;
        polylineRenderer.strokeColor  = polyline.storkeColor;
//        NSLog(@"%@",polyline.storkeColor);
        
        polylineRenderer.lineJoinType = kMALineJoinRound;
        polylineRenderer.lineCapType  = kMALineCapRound;
        
        return polylineRenderer;
    }
    
    return nil;
}





@end
