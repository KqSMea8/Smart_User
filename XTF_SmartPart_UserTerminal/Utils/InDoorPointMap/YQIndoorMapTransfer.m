//
//  YQIndoorMapTransfer.m
//  ZHYQ
//
//  Created by 焦平 on 2017/11/15.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "YQIndoorMapTransfer.h"

@implementation YQIndoorMapTransfer

+(void)initWithCoordinate:(NSString*)inStrCoordinate InPoint:(CGPoint)point Inview:(UIView*)view WithIdentity:(NSString*)identity delegate:(id<DidSelPopDelegate>)delegate
{
    MapArea*_mapArea= [[MapArea alloc]initWithCoordinate:inStrCoordinate];
    if ([_mapArea isAreaSelected:point] && delegate != nil) {
        [delegate selPopWithIdentity:identity];
    }
}

@end
