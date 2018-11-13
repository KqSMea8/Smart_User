//
//  UIView+Add.m
//  DXWingGate
//
//  Created by coder on 2018/8/13.
//  Copyright © 2018年 com.Transfar. All rights reserved.
//

#import "UIView+Add.h"
#import <objc/runtime.h>

@implementation UIView (Add)

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)addBorderColor:(UIColor *)color{
    
    
}

- (void)ff_setCornerType:(UIRectCorner)cornerType
            cornerRadius:(CGFloat)radius{
    CGSize size = CGSizeMake(radius, radius);
    [self sign_cornerType:cornerType cornerSizeRadius:size];
}

- (void)ff_setCornerType:(UIRectCorner)cornerType
        cornerSizeRadius:(CGSize)resize{
    [self sign_cornerType:cornerType cornerSizeRadius:resize];
}

- (void)ff_setRoundedRect:(CGRect)rect
               CornerType:(UIRectCorner)cornerType
         cornerSizeRadius:(CGSize)resize{
    self.ff_bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                               byRoundingCorners:cornerType
                                                     cornerRadii:CGSizeMake(resize.width, resize.height)];
    self.ff_shapeLayer = [self get_shapeLayer];
    self.ff_shapeLayer.path = self.ff_bezierPath.CGPath;
    self.layer.mask = self.ff_shapeLayer;
}

- (void)sign_cornerType:(UIRectCorner)cornerType
       cornerSizeRadius:(CGSize)size{
    self.ff_bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
                                               byRoundingCorners:cornerType
                                                     cornerRadii:CGSizeMake(size.width, size.height)];
    self.ff_shapeLayer = [self get_shapeLayer];
    self.ff_shapeLayer.path = self.ff_bezierPath.CGPath;
    self.layer.mask = self.ff_shapeLayer;
}

- (CAShapeLayer *)get_shapeLayer{
    CAShapeLayer * layers = [CAShapeLayer layer];
    layers.frame = self.bounds;
    return layers;
}

#pragma mark - Associated Object

- (void)setFf_shapeLayer:(id)object{
    objc_setAssociatedObject(self, @selector(ff_shapeLayer), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CAShapeLayer *)ff_shapeLayer{
    return objc_getAssociatedObject(self, @selector(ff_shapeLayer));
}

- (void)setFf_bezierPath:(id)object{
    objc_setAssociatedObject(self, @selector(ff_bezierPath), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIBezierPath *)ff_bezierPath{
    return objc_getAssociatedObject(self, @selector(ff_bezierPath));
}

@end
