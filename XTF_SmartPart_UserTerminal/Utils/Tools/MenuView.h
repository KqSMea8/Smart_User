//
//  MenuView.h
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/6/26.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenDoorModel.h"

@protocol NormalMenuDelegate <NSObject>

- (void)menuOpenDoorWithModel:(OpenDoorModel *)model withView:(UIImageView *)view withType:(NSString *)type;

- (void)closeMenu;

@end

@interface MenuView : UIView

/** show出这个弹窗 */
- (void)showInView:(UIView *)view;

- (void)disMissView;

@property (nonatomic,retain) OpenDoorModel *model;
@property (nonatomic,weak) id<NormalMenuDelegate> delegate;
@property (nonatomic,retain) UIImageView *view;
@property (nonatomic,retain) UIView *contentView;
@property (nonatomic,copy) NSString *specialTag;

@end
