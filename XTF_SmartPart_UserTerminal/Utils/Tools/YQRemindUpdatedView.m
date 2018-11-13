//
//  YQRemindUpdatedView.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2018/2/1.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "YQRemindUpdatedView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface YQRemindUpdatedView ()
{
    UILabel *messageLab;
    
    UIButton *leftButton;
    UIButton *rightButton;
    UIView *verLinView;
    UIView *hLinView;
}

/** 弹窗主内容view */
@property (nonatomic,strong) UIView   *contentView;
/** 弹窗标题 */
@property (nonatomic,copy)   NSString *title;
/** 弹窗message */
@property (nonatomic,copy)   NSString *message;
/** 左边按钮title */
@property (nonatomic,copy)   NSString *leftButtonTitle;
/** 右边按钮title */
@property (nonatomic,copy)   NSString *rightButtonTitle;

@end

@implementation YQRemindUpdatedView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle{
    if (self = [super init]) {
        self.title = title;
        self.message = message;
        self.delegate = delegate;
        self.leftButtonTitle = leftButtonTitle;
        self.rightButtonTitle = rightButtonTitle;
        
        // UI搭建
        [self setUpUI];
    }
    return self;
}


#pragma mark - UI搭建
/** UI搭建 */
- (void)setUpUI{
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 1;
    }];
    
    //------- 弹窗主内容 -------//
    self.contentView = [[UIView alloc]init];
    self.contentView.frame = CGRectMake(35, (SCREEN_HEIGHT - 220) / 2, KScreenWidth-70, 220);
    self.contentView.center = self.center;
    [self addSubview:self.contentView];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 4;
    
    UIView *iconBgView = [[UIView alloc] initWithFrame:CGRectMake((_contentView.width-66)/2, -40, 66, 66)];
    iconBgView.backgroundColor = [UIColor whiteColor];
    iconBgView.layer.cornerRadius = 33;
    iconBgView.clipsToBounds = YES;
    [self.contentView addSubview:iconBgView];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.size = CGSizeMake(60, 60);
    imageView.center = iconBgView.center;
    imageView.layer.cornerRadius = 30;
    imageView.clipsToBounds = YES;
    imageView.image = [UIImage imageNamed:@"about_logo_user"];
    [self.contentView addSubview:imageView];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.bottom+12, self.contentView.width, 21)];
    [self.contentView addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor colorWithHexString:@"#1B82D1"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = [NSString stringWithFormat:@"%@",self.title];
    titleLabel.centerX = imageView.centerX;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame)+12, _contentView.width, 1)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EAEAEA"];
    [self.contentView addSubview:lineView];
    
    messageLab = [[UILabel alloc] init];
    messageLab.numberOfLines = 0;
    messageLab.font = [UIFont systemFontOfSize:16];
    messageLab.textColor = [UIColor blackColor];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_message];
    [str setLineSpacing:10];
    
    CGSize size = [self boundsWithFontSize:16 text:_message needWidth:self.contentView.width-32 lineSpacing:10].size;
    messageLab.attributedText = str;
//    CGSize size = [messageLab.text sizeForFont:[UIFont systemFontOfSize:16] size:CGSizeMake(self.contentView.width-32, MAXFLOAT) mode:NSLineBreakByCharWrapping];
    messageLab.frame = CGRectMake(16, lineView.bottom+20, self.contentView.width-32, size.height);
    [self.contentView addSubview:messageLab];
    
    // 取消按钮
    leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(messageLab.frame)+20, self.contentView.frame.size.width/2, 55)];
    [self.contentView addSubview:leftButton];
    leftButton.backgroundColor = [UIColor whiteColor];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton setTitle:_leftButtonTitle forState:UIControlStateNormal];
    [leftButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [leftButton addTarget:self action:@selector(leftButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    leftButton.layer.cornerRadius = 4;
    leftButton.clipsToBounds = YES;

    // 确认按钮
    rightButton = [[UIButton alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width/2, leftButton.frame.origin.y, self.contentView.frame.size.width/2, 55)];
    [self.contentView addSubview:rightButton];
    [rightButton setTitle:_rightButtonTitle forState:UIControlStateNormal];
    rightButton.backgroundColor = [UIColor whiteColor];
    [rightButton setTitleColor:[UIColor colorWithHexString:@"#FF4359"] forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [rightButton addTarget:self action:@selector(rightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    rightButton.layer.cornerRadius = 6;
    rightButton.clipsToBounds = YES;

    verLinView = [[UIView alloc] initWithFrame:CGRectMake(0, leftButton.ly_y, _contentView.width, 0.5)];
    verLinView.backgroundColor = [UIColor colorWithHexString:@"#E2E2E2"];
    [self.contentView addSubview:verLinView];

    hLinView = [[UIView alloc] initWithFrame:CGRectMake(_contentView.width/2, leftButton.ly_y, 0.5, leftButton.height)];
    hLinView.backgroundColor = [UIColor colorWithHexString:@"#E2E2E2"];
    [self.contentView addSubview:hLinView];
    
    //------- 调整弹窗高度和中心 -------//
    self.contentView.height = rightButton.ly_maxY;
    self.contentView.center = self.center;
    
}

#pragma mark - 弹出此弹窗
/** 弹出此弹窗 */
- (void)show{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
}

#pragma mark - 移除此弹窗
/** 移除此弹窗 */
- (void)dismiss{
    [self removeFromSuperview];
}

#pragma mark - 左边按钮点击
/** 左边按钮点击 */
- (void)leftButtonClicked{
    if ([self.delegate respondsToSelector:@selector(remaindViewBtnClick:)]) {
        [self.delegate remaindViewBtnClick:cancleButton];
    }
    [self dismiss];
}

#pragma mark - 右边按钮点击
/** 右边按钮点击 */
- (void)rightButtonClicked{
    if ([self.delegate respondsToSelector:@selector(remaindViewBtnClick:)]) {
        [self.delegate remaindViewBtnClick:sureButton];
    }
}

-(void)setIsMust:(NSString *)isMust
{
    _isMust = isMust;
    
    if ([_isMust isEqualToString:@"1"]) {
        hLinView.hidden = YES;
        leftButton.hidden = YES;
        rightButton.hidden = NO;
        rightButton.frame = CGRectMake(0, CGRectGetMaxY(messageLab.frame)+20, self.contentView.width, 55);
    }

}

- (CGRect)boundsWithFontSize:(CGFloat)fontSize text:(NSString *)text needWidth:(CGFloat)needWidth lineSpacing:(CGFloat )lineSpacing
{
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    
    style.lineSpacing = lineSpacing;
    
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    
    [attributeString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
    
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, text.length)];
    
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    CGRect rect = [attributeString boundingRectWithSize:CGSizeMake(needWidth, CGFLOAT_MAX) options:options context:nil];
    
    return rect;
    
}

@end
