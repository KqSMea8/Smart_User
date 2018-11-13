//
//  MapArea.m
//  TagImageView
//
//  Created by apple on 13-10-25.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "MapArea.h"
#import <UIKit/UIKit.h>

@implementation MapArea

@synthesize mapArea         = _mapArea;

-(id)initWithCoordinate:(NSString*)inStrCoordinate
{
    self = [super init];
    
    if(self != nil)
    {

        NSArray*    arrAreaCoordinates = \
        [inStrCoordinate componentsSeparatedByString:@","];
        
        NSUInteger  countTotal      = [arrAreaCoordinates count];
        NSUInteger  countCoord      = countTotal/2;
       
        BOOL        isFirstPoint    = YES;
        
        // add points to bezier path
        UIBezierPath  *path = [UIBezierPath new];
        
        for(NSUInteger i = 0; i < countCoord; i++)
        {
            NSUInteger index = i<<1;
            CGPoint aPoint = CGPointMake([[arrAreaCoordinates objectAtIndex:index] floatValue], [[arrAreaCoordinates objectAtIndex:index+1] floatValue]);
            
            if(isFirstPoint)
            {
                [path moveToPoint:aPoint];
                isFirstPoint = NO;
            }
            [path addLineToPoint:aPoint];
        }
        
        [path closePath];
        
        self.mapArea = path;
    }
    return self;
}

-(BOOL)isAreaSelected:(CGPoint)inPointTouch
{
    return CGPathContainsPoint(self.mapArea.CGPath,NULL,inPointTouch,false);
}

@end
