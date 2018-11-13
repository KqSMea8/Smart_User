//
//  KqTableViewCell.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/4.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KqModel.h"
#import "DkModel.h"

@protocol dkSuccessAndRefreshDelegate <NSObject>

-(void)dkSuccessAndRefresh:(id)object;

@end

@interface KqTableViewCell : UITableViewCell

@property (nonatomic, strong) KqModel *model;

@property (nonatomic, strong) DkModel *dkModel;

@property (nonatomic, weak) id <dkSuccessAndRefreshDelegate> dkDelegate;

@end
