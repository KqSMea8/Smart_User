//
//  BindCarTableViewController.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/3.
//  Copyright © 2017年 焦平. All rights reserved.
//

@protocol BindCarSuccessDelegate <NSObject>

- (void)bindCarSuc;

@end

#import "BaseTableViewController.h"

@interface BindCarTableViewController : BaseTableViewController

@property (nonatomic,assign) id<BindCarSuccessDelegate> bindSucDelegate;

@end
