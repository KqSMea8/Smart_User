//
//  LocationManager.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2018/4/12.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "LocationManager.h"

#define isIOS(version) ([[UIDevice currentDevice].systemVersion floatValue] >= version)

@interface LocationManager ()<CLLocationManagerDelegate>

@property (strong, nonatomic)CLLocationManager *locManager;

@end

@implementation LocationManager

+ (instancetype)sharedGpsManager
{
    static id Location;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!Location) {
            Location = [[LocationManager alloc] init];
        }
    });
    return Location;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self getCurrentLocation];
    }
    return self;
}

- (void)getCurrentLocation
{
    self.locManager = [[CLLocationManager alloc] init];
    self.locManager.delegate = self;
    self.locManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locManager.distanceFilter = 30.0;
    [self.locManager requestWhenInUseAuthorization];
    [self.locManager startUpdatingLocation];
}

- (void)getGps:(void (^)(CLLocation*))gps
{
    if ([CLLocationManager locationServicesEnabled] == FALSE) {
        return;
    }
    saveGpsCallBack = [gps copy];
    [self.locManager stopUpdatingLocation];
    [self.locManager startUpdatingLocation];
}

+ (void)getGps:(void (^)(CLLocation*))block
{
    [[LocationManager sharedGpsManager] getGps:block];
}

- (void)stop
{
    [self.locManager stopUpdatingLocation];
}

+ (void)stop
{
    [[LocationManager sharedGpsManager] stop];
}

#pragma mark - locationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
//    double latitude = newLocation.coordinate.latitude;
//    double longitude = newLocation.coordinate.longitude;
    if (saveGpsCallBack) {
        saveGpsCallBack(newLocation);
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
}

@end
