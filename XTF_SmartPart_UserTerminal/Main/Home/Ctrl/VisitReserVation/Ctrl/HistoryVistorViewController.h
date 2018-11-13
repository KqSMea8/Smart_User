//
//  HistoryVistorViewController.h
//  DXWingGate
//
//  Created by coder on 2018/9/4.
//  Copyright © 2018年 com.Transfar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VisitHistoryModel;

typedef void (^HistoryValueBlock) (VisitHistoryModel *model);

@interface HistoryVistorViewController : UIViewController

@property (nonatomic,copy) HistoryValueBlock historyValueBlock;

@end
