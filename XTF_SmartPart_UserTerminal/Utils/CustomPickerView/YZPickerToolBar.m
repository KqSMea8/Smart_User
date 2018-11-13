//
//  YZPickerToolBar.m
//  DXWingGate
//
//  Created by coder on 2018/9/4.
//  Copyright © 2018年 com.Transfar. All rights reserved.
//

#import "YZPickerToolBar.h"

@interface YZPickerToolBar()

@property (nonatomic, strong)UIButton *buttonLeft;
@property (nonatomic, strong)UILabel *labelTitle;
@property (nonatomic, strong)UIButton *buttonRight;

@end

@implementation YZPickerToolBar

#pragma mark - --- init 视图初始化 ---
- (instancetype)initWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
                okButtonTitle:(NSString *)okButtonTitle
                    addTarget:(id)target
                 cancelAction:(SEL)cancelAction
                     okAction:(SEL)okAction{
    
    self = [self init];
    
    [self.labelTitle setText:title];
    
    [self.buttonLeft setTitle:cancelButtonTitle forState:UIControlStateNormal];
    [self.buttonLeft addTarget:target action:cancelAction forControlEvents:UIControlEventTouchUpInside];
    
    [self.buttonRight setTitle:okButtonTitle forState:UIControlStateNormal];
    [self.buttonRight addTarget:target action:okAction forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}


- (void)setupUI
{
    _title = nil;
    _font = [UIFont systemFontOfSize:15];
    _titleColor = [UIColor blackColor];
    _borderButtonColor = RGBA(205, 205, 205,1.0f);
    
    self.bounds = CGRectMake(10, 0, KScreenWidth-20, 44);
    [self setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.labelTitle];
    [self addSubview:self.buttonLeft];
    [self addSubview:self.buttonRight];
}

#pragma mark - --- delegate 视图委托 ---

#pragma mark - --- event response 事件相应 ---

#pragma mark - --- private methods 私有方法 ---

#pragma mark - --- setters 属性 ---

- (void)setTitle:(NSString *)title
{
    _title = title;
    [self.labelTitle setText:title];
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    [self.buttonLeft.titleLabel setFont:font];
    [self.buttonRight.titleLabel setFont:font];
    [self.labelTitle setFont:font];
}

- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    [self.labelTitle setTextColor:titleColor];
    [self.buttonLeft setTitleColor:titleColor forState:UIControlStateNormal];
    [self.buttonRight setTitleColor:titleColor forState:UIControlStateNormal];
}

- (void)setBorderButtonColor:(UIColor *)borderButtonColor
{
    _borderButtonColor = borderButtonColor;
    [self.buttonLeft addBorderColor:borderButtonColor];
    [self.buttonRight addBorderColor:borderButtonColor];
}
#pragma mark - --- getters 属性 ---

- (UIButton *)buttonLeft
{
    if (!_buttonLeft) {
        CGFloat leftX = 16;
        CGFloat leftY = 5;
        CGFloat leftW = 44;
        CGFloat leftH = 34;
        _buttonLeft = [[UIButton alloc]initWithFrame:CGRectMake(leftX, leftY, leftW, leftH)];
        [_buttonLeft setTitleColor:self.titleColor forState:UIControlStateNormal];
        [_buttonLeft addBorderColor:self.borderButtonColor];
        [_buttonLeft.titleLabel setFont:self.font];
        _buttonLeft.hidden = YES;
    }
    return _buttonLeft;
}

- (UIButton *)buttonRight
{
    if (!_buttonRight) {
        CGFloat rightW = self.width - 10;
        CGFloat rightH = 44;
        CGFloat rightX = 5;
        CGFloat rightY = 0;
        _buttonRight = [[UIButton alloc]initWithFrame:CGRectMake(rightX, rightY, rightW, rightH)];
        [_buttonRight setTitleColor:self.titleColor forState:UIControlStateNormal];
        [_buttonRight addBorderColor:self.borderButtonColor];
        [_buttonRight.titleLabel setFont:self.font];
    }
    return _buttonRight;
}

- (UILabel *)labelTitle
{
    if (!_labelTitle) {
        CGFloat titleX = self.buttonLeft.right + 5;
        CGFloat titleY = 0;
        CGFloat titleW = KScreenWidth - titleX * 2;
        CGFloat titleH = 44;
        _labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(titleX, titleY, titleW, titleH)];
        [_labelTitle setTextAlignment:NSTextAlignmentCenter];
        [_labelTitle setTextColor:self.titleColor];
        [_labelTitle setFont:self.font];
        _labelTitle.adjustsFontSizeToFitWidth = YES;
        _labelTitle.hidden = YES;
    }
    return _labelTitle;
}

@end
