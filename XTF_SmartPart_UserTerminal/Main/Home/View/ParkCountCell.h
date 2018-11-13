//
//  ParkCountCell.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 魏唯隆 on 2017/11/30.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParkAreasModel.h"

@protocol NavToParkDelegate <NSObject>

- (void)navPark:(CGFloat)latitude withLongitude:(CGFloat)longitude;

@end

@interface ParkCountCell : UITableViewCell

@property (nonatomic,strong) ParkAreasModel *model;
@property (nonatomic, assign) id<NavToParkDelegate> navDelegate;

@end
