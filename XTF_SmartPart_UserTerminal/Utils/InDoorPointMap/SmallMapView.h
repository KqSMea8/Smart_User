//
//  SmallMapView.h
//  GameMap
//
//  Created by 魏唯隆 on 2017/11/27.
//  Copyright © 2017年 魏唯隆. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol TouchMoveDelegate <NSObject>

- (void)layerTouchMove:(CGPoint)point;

@end

@interface SmallMapView : UIView

//标示窗口位置的浮动矩形
@property (nonatomic,retain,readonly)CALayer *rectangleLayer;

@property (nonatomic,assign, readonly)float scaling;  // 根据点位图缩放设置

//内容
@property (nonatomic,retain,readonly)CALayer *contentLayer;

//被模拟的UIScrollView
@property (nonatomic,retain )UIScrollView *scrollView;

//缩放比例

@property (nonatomic, assign) BOOL isTouchMove;

@property (nonatomic, assign) id<TouchMoveDelegate> touchMoveDelegate;

//init
- (id)initWithUIScrollView:(UIScrollView *)scrollView frame:(CGRect)frame;

//在UIScrollView的scrollViewDidScroll委托方法中调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

//重绘View内容(需要注意。如果在调用reloadSmallMapView 方法的时候，需要更新的内容内有动画。如按钮变色等)
//请用[self performSelector:@selector(reloadSmallMapView:) withObject:nil afterDelay:0.2];
- (void)reloadSmallMapView;
@end
