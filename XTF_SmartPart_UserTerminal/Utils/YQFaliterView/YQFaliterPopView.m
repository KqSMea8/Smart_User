//
//  YQFaliterPopView.m
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/9/14.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "YQFaliterPopView.h"
#import "PopContentView.h"

#define kATTR_VIEW_HEIGHT 375
///******* 屏幕尺寸 *******/
#define     kWidth      [UIScreen mainScreen].bounds.size.width
#define     kHeight     [UIScreen mainScreen].bounds.size.height

@interface YQFaliterPopView () <UIGestureRecognizerDelegate,PopContentDelegate>

@property (nonatomic, weak) PopContentView *contentView;

@end

@implementation YQFaliterPopView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

#pragma mark - setupViews
/**
 *  设置视图的基本内容
 */
- (void)setupViews {
    // 添加手势，点击背景视图消失
    UITapGestureRecognizer *tapBackGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView)];
    tapBackGesture.delegate = self;
    [self addGestureRecognizer:tapBackGesture];
    
    PopContentView *contentView = [[[NSBundle mainBundle]loadNibNamed:@"PopContentView" owner:self options:nil]lastObject];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.delegate = self;
    [self addSubview:contentView];
    self.contentView = contentView;
    
}

#pragma mark - PopContentDelegate
-(void)resetBtnCallBackAction
{
    _visitName = nil;
    _visitCarNum = nil;
    _arriveTime = nil;
    _leaveTime = nil;
    if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(resetCallBackAction)]) {
        [self.delegate resetCallBackAction];
    }
    [self removeView];
}

-(void)completeBtnCallBackAction
{
    _visitName = self.contentView.visitNameTex.text;
    _visitCarNum = self.contentView.visitCarNumTex.text;
    _arriveTime = self.contentView.arriveTimeLab.text;
    _leaveTime = self.contentView.leaveTimeLab.text;
    if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(completeCallBackAction)]) {
        [self.delegate completeCallBackAction];
    }
    [self removeView];
}

#pragma mark - UIGestureRecognizerDelegate
//确定点击范围
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:self.contentView]) {
        return NO;
    }
    return YES;
}


#pragma mark - public
/**
 *  显示属性选择视图
 *
 *  @param view 要在哪个视图中显示
 */
- (void)showInView:(UIView *)view {
    _isShow = YES;
    [view addSubview:self];
    __weak typeof(self) _weakSelf = self;
    self.contentView.frame = CGRectMake(0, -kATTR_VIEW_HEIGHT, kWidth, kATTR_VIEW_HEIGHT);
    
    [UIView animateWithDuration:0.3 animations:^{
        _weakSelf.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _weakSelf.contentView.frame = CGRectMake(0, 0, kWidth, kATTR_VIEW_HEIGHT);
    }];
}

/**
 *  属性视图的消失
 */
- (void)removeView {
    _isShow = NO;
    __weak typeof(self) _weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        _weakSelf.backgroundColor = [UIColor clearColor];
        _weakSelf.contentView.frame = CGRectMake(0, -kATTR_VIEW_HEIGHT, kWidth, kATTR_VIEW_HEIGHT);
    } completion:^(BOOL finished) {
        [_weakSelf removeFromSuperview];
    }];
}

@end
