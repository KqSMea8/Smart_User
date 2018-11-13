//
//  ParkReservationTableViewCell.h
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/6/6.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol selectCarNumDelegate <NSObject>

-(void)selectCarNum:(NSString *)carNum withIndex:(NSInteger)index;

-(void)unfoldOrCloseCell:(NSString *)isOpen;

@end

@interface ParkReservationTableViewCell : UITableViewCell

@property (nonatomic,retain) NSMutableArray *dataArr;

@property (nonatomic,assign) id<selectCarNumDelegate> delegate;

@property (nonatomic,assign) BOOL isOverNeedHide;
@property (nonatomic,assign) NSInteger selectIndex;

@end
