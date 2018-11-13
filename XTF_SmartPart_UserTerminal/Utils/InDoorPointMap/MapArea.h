//
//  MapArea.h
//  ZHYQ
//
//  Created by 焦平 on 2017/11/15.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapArea : NSObject
{
    UIBezierPath *_mapArea;
}

@property (nonatomic, retain)   UIBezierPath        *mapArea;

-(id)initWithCoordinate:(NSString*)inStrCoordinate;

-(BOOL)isAreaSelected:(CGPoint)inPointTouch;


@end
