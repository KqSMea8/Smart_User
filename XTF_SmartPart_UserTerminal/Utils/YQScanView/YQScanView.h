//
//  YQScanView.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/21.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YQScanViewDelegate <NSObject>

-(void)getScanDataString:(NSString*)scanDataString;

@end


@interface YQScanView : UIView

@property (nonatomic,assign) id<YQScanViewDelegate> delegate;
@property (nonatomic,assign) int scanW; //扫描框的宽

@property (nonatomic,weak) UIView *noNetView;
@property (nonatomic,weak) UILabel *lab;

- (void)startRunning; //开始扫描
- (void)stopRunning; //停止扫描

@end
