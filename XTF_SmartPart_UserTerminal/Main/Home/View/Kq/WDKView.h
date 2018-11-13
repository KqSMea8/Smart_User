//
//  WDKView.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/3.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol dkSuccessDelegate <NSObject>

-(void)dkSuccessMsg:(id)object;

@end

@interface WDKView : UIView

@property (nonatomic,weak) id <dkSuccessDelegate> delegate;

@end
