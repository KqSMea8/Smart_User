//
//  ParkCarNumTabCell.h
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/7/31.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CarParkModel;

@protocol selectNumDelegate <NSObject>

-(void)selectCarNum:(NSString *)carNum withIndex:(NSInteger)index;

-(void)selectParkArea:(CarParkModel *)model;

@end

@interface ParkCarNumTabCell : UITableViewCell

@property (nonatomic,retain) NSMutableArray *dataArr;
@property (nonatomic,retain) NSMutableArray *parkAreaArr;

@property (nonatomic,weak) id<selectNumDelegate> delegate;

@end
