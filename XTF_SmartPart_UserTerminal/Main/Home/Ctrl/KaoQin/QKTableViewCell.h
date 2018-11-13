//
//  QKTableViewCell.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2018/3/23.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol reConfirmDKDelegate <NSObject>

-(void)reConfirmDKAction:(NSString *)type;

@end

@interface QKTableViewCell : UITableViewCell

@property (nonatomic,copy) NSString *onWorkTime;
@property (nonatomic,copy) NSString *signAddr;
@property (nonatomic,copy) NSString *isAllowReDk;

@property (nonatomic,weak) id<reConfirmDKDelegate> delegate;

@end
