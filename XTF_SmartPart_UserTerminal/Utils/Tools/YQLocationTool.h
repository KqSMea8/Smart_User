//
//  YQLocationTool.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/7.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^ResultBlock)(CLLocation *location, CLPlacemark *pl, NSString *error);

@interface YQLocationTool : NSObject

single_interface(YQLocationTool);

- (void)getCurrentLocation:(ResultBlock)block;

@end
