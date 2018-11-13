//
//  MineFooterView.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2018/2/5.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol mineFuctionDelegate <NSObject>

-(void)mineFuctionTapAtIndex:(NSInteger)index;

@end

@interface MineFooterView : UIView

@property (nonatomic,weak) id<mineFuctionDelegate> delegate;

@end
