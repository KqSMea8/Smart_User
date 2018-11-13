//
//  MyCarTableViewCell.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/3.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarListModel.h"

@protocol RemoveBindCarDelegate <NSObject>

- (void)removeBind:(CarListModel *)carListModel;

@end

@interface MyCarTableViewCell : UITableViewCell

@property (nonatomic, retain) CarListModel *carListModel;
@property (nonatomic,assign) id<RemoveBindCarDelegate> removeBindDelegate;;

@end
