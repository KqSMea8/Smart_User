//
//  SmallMapView.m
//  GameMap
//
//  Created by 魏唯隆 on 2017/11/27.
//  Copyright © 2017年 魏唯隆. All rights reserved.
//

#import "SmallMapView.h"

@implementation SmallMapView

- (id)initWithUIScrollView:(UIScrollView *)scrollView frame:(CGRect)frame
{
    self = [super init];
    if (self) {
        _scrollView = scrollView;
        
        //设置缩略图View尺寸
        [self setFrame:frame];
        
        //设置缩略图缩放比例
        [self setScaling:_scrollView];
        
        //设置缩略图内容
        _contentLayer = [self drawContentView:_scrollView frame:frame];
        [self.layer addSublayer:_contentLayer];
        
        //初始化缩略移动视口
        _rectangleLayer = [[CALayer alloc] init];
        _rectangleLayer.opacity = 0.5;
        _rectangleLayer.shadowOffset = CGSizeMake(0, 3);
        _rectangleLayer.shadowRadius = 5.0;
        _rectangleLayer.shadowColor = [UIColor blackColor].CGColor;
        _rectangleLayer.shadowOpacity = 0.8;
        _rectangleLayer.backgroundColor = [UIColor colorWithHexString:@"#3a82cb"].CGColor;
        CGFloat width = scrollView.frame.size.width * _scaling;
        CGFloat height = scrollView.frame.size.height * _scaling;
        if(height > self.height){
            height = self.height;
        }
        if(width > self.width){
            width = self.width;
        }
        _rectangleLayer.frame = CGRectMake(0, 0, width, height);
        [self.layer addSublayer:_rectangleLayer];
    }
    return self;
}

- (void)dealloc
{

}

//------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self setScaling:scrollView];
    float x = scrollView.contentOffset.x;
    float y = scrollView.contentOffset.y;
    float h = scrollView.frame.size.height;
    float w = scrollView.frame.size.width;
    
//    if(h > self.height){
//        h = self.height;
//    }
//    if(w > self.width){
//        w = self.width;
//    }
    
    [self.rectangleLayer setFrame:CGRectMake(x * _scaling, y * _scaling, w * self.scaling, h * self.scaling)];
}

//重绘View内容
- (void)reloadSmallMapView
{
    [_contentLayer removeFromSuperlayer];
    _contentLayer = [self drawContentView:_scrollView frame:self.frame];
    [self.layer insertSublayer:_contentLayer atIndex:0];
}

//设置缩略图缩放比例
- (void)setScaling:(UIScrollView *)scrollView
{
    _scaling = self.frame.size.height / scrollView.contentSize.height;
}

//复制UIScrollView中内容
- (CALayer *)drawContentView:(UIScrollView *)scrollView frame:(CGRect)frame
{
    [self setScaling:scrollView];
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    for (UIView *view in scrollView.subviews)
    {
        UIGraphicsBeginImageContext(view.bounds.size);
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        CALayer *copyLayer = [CALayer layer];
        copyLayer.backgroundColor = [UIColor grayColor].CGColor;
        copyLayer.contents = (id)image.CGImage;
        float x = view.frame.origin.x;
//        float y = view.frame.origin.y;
        float y = 0;
        float h = view.frame.size.height;
        float w = view.frame.size.width;
        copyLayer.frame = CGRectMake(x * _scaling, y *_scaling, w * _scaling, h * _scaling);
        [layer addSublayer:copyLayer];
    }
    return layer;
}

// 缩放scrollView 重新计算缩放比例
- (void)setScrollView:(UIScrollView *)scrollView {
    _scrollView = scrollView;
    
    [self setScaling:scrollView];
    
    [self scrollViewDidScroll:scrollView];
}

/*
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _isTouchMove = YES;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    
    CGRect layerFrame = _rectangleLayer.frame;
    CGFloat layerOrX = point.x - layerFrame.size.width/2;
    CGFloat layerOrY = point.y - layerFrame.size.height/2;
    
    // 设置边界
    if(layerOrX < 0){
        layerOrX = 0;
    }
    if(layerOrY < 0){
        layerOrY = 0;
    }
    if(layerOrX + layerFrame.size.width > self.frame.size.width){
        layerOrX = self.frame.size.width - layerFrame.size.width;
    }
    if(layerOrY + layerFrame.size.height > self.frame.size.height) {
        layerOrY = self.frame.size.height - layerFrame.size.height;
    }
    
    _rectangleLayer.frame = CGRectMake(layerOrX, layerOrY, layerFrame.size.width, layerFrame.size.height);
    
    CGPoint mapPoint = CGPointMake(layerOrX, layerOrY);
    
    if(_touchMoveDelegate){
        [_touchMoveDelegate layerTouchMove:mapPoint];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    _isTouchMove = NO;
}
 */

@end 
