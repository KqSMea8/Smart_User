//
//  ParkReservationAreaCell.h
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/6/11.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CarParkModel;

@protocol selectParkAreaDelegate<NSObject>

-(void)selectParkArea:(CarParkModel *)model;

@end

@interface ParkReservationAreaCell : UITableViewCell

@property (nonatomic,retain) NSMutableArray *dataArr;
@property (nonatomic,assign) id<selectParkAreaDelegate> delegate;

@end
