//
//  LocationManager.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2018/4/12.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationManager : NSObject
{
    void (^saveGpsCallBack)(CLLocation *location);
}
+ (void)getGps:(void(^)(CLLocation *location))block;

+ (void)stop;

@end
