//
//  AControlTableViewCell.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/21.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenDoorModel.h"

@protocol OpenDoorDelegate <NSObject>

-(void)openDoorWithData:(OpenDoorModel *)model withAnimationView:(UIImageView *)view;

@end

@interface AControlTableViewCell : UITableViewCell

@property (nonatomic,strong) OpenDoorModel *model;

@property (nonatomic,weak) id<OpenDoorDelegate> delegate;

@end
