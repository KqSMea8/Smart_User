//
//  YQIndoorMapTransfer.h
//  ZHYQ
//
//  Created by 焦平 on 2017/11/15.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapArea.h"

@protocol DidSelPopDelegate <NSObject>

- (void)selPopWithIdentity:(NSString *)identity;

@end

@interface YQIndoorMapTransfer : NSObject

+(void)initWithCoordinate:(NSString*)inStrCoordinate InPoint:(CGPoint)point Inview:(UIView*)view WithIdentity:(NSString*)identity delegate:(id<DidSelPopDelegate>)delegate;

@end
