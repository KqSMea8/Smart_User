//
//  UIView+Add.h
//  DXWingGate
//
//  Created by coder on 2018/8/13.
//  Copyright © 2018年 com.Transfar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Add)

@property (nonatomic) CGFloat left;        ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat top;         ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat width;       ///< Shortcut for frame.size.width.
@property (nonatomic) CGFloat height;      ///< Shortcut for frame.size.height.
@property (nonatomic) CGFloat centerX;     ///< Shortcut for center.x
@property (nonatomic) CGFloat centerY;     ///< Shortcut for center.y
@property (nonatomic) CGPoint origin;      ///< Shortcut for frame.origin.
@property (nonatomic) CGSize  size;        ///< Shortcut for frame.size.

/**
 *  6.添加边框
 *
 *  @param color <#color description#>
 */
- (void)addBorderColor:(UIColor *)color;

/**
 继承于UIView的视图切圆角
 
 @param cornerType 圆角类型， 可看系统自带类型
 @param radius 圆角角度
 */
- (void)ff_setCornerType:(UIRectCorner)cornerType
            cornerRadius:(CGFloat)radius;


/**
 继承于UIView的视图切圆角
 
 @param cornerType 圆角类型， 可看系统自带类型
 @param resize CGSize类型剪切
 */
- (void)ff_setCornerType:(UIRectCorner)cornerType
        cornerSizeRadius:(CGSize)resize;


/**
 @warning 用于特殊需求
 继承于UIView的视图切圆角
 
 @param rect 当前控件frame
 @param cornerType 剪切类型
 @param resize size大小
 */
- (void)ff_setRoundedRect:(CGRect)rect
               CornerType:(UIRectCorner)cornerType
         cornerSizeRadius:(CGSize)resize;

@end
