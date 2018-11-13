//
//  ShowMenuView.h
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/5/29.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "OpenDoorModel.h"

@protocol menuDelegate <NSObject>

- (NSString *)titleForMenu:(int)index;

- (BOOL)isSwitch:(int)index;

- (void)switchState:(int)index withSwitch:(BOOL)isOn;

- (void)openDoorWithIndex:(int)index withView:(UIImageView *)view withType:(NSString *)type;

- (void)closeMenu;

@end

@interface ShowMenuView : UIView

- (instancetype)initWithIndex:(int)index;

/** show出这个弹窗 */
- (void)showInView:(UIView *)view;

- (void)disMissView;

//@property (nonatomic,retain) OpenDoorModel *model;

@property (nonatomic,weak) id<menuDelegate> delegate;

@property (nonatomic,retain) UIView *contentView;

@property (nonatomic,assign) BOOL isPortrait;

@property (nonatomic,copy) NSString *isGate;

@property (nonatomic,copy) NSString *specialTag;

-(void)reloadMenu;

@end
