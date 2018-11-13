//
//  YZPickerToolBar.h
//  DXWingGate
//
//  Created by coder on 2018/9/4.
//  Copyright © 2018年 com.Transfar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZPickerToolBar : UIView

/** 1.标题*/
@property(nonatomic,copy) NSString *title;
/** 2.字体*/
@property(nonatomic,strong) UIFont *font;
/** 3.字体颜色*/
@property(nonatomic,strong) UIColor *titleColor;
/** 4.按钮边框颜色颜色*/
@property(nonatomic,strong) UIColor *borderButtonColor;

- (instancetype)initWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
                okButtonTitle:(NSString *)okButtonTitle
                    addTarget:(id)target
                 cancelAction:(SEL)cancelAction
                     okAction:(SEL)okAction;


@end
