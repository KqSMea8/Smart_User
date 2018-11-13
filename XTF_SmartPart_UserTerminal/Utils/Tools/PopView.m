//
//  PopView.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/19.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "PopView.h"
#import "UIView+frameAdjust.h"

@interface PopView ()<UITextViewDelegate,UITextFieldDelegate>
{
    UILabel *smallPayLab;
    
    UIButton *forgetPwdBtn;
    
    UILabel *_messageLab;
    
    UIImageView *humanFaceView;
    
    UILabel *locationLab;
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

@property (nonatomic,retain) UIButton *closeBtn;

@end

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@implementation PopView{
    UILabel *label;
}

#pragma mark - 构造方法
/**
 
 @param title 弹窗标题
 @param message 弹窗message
 @param delegate 确定代理方
 @param leftButtonTitle 左边按钮的title
 @param rightButtonTitle 右边按钮的title
 @return 111
 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle type:(PopViewType)type{
    if (self = [super init]) {
        self.title = title;
        self.message = message;
        self.delegate = delegate;
        self.leftButtonTitle = leftButtonTitle;
        self.rightButtonTitle = rightButtonTitle;
        self.type = type;
        
        // 接收键盘显示隐藏的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
        
        // UI搭建
        [self setUpUI];
    }
    return self;
}

-(void)tapAction
{
    [_importPwdTex resignFirstResponder];
    [_surePayPwdTex resignFirstResponder];
    [_payPwdTex resignFirstResponder];
    
//    [self dismiss];
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
    //设置阴影的颜色
    self.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    //设置阴影的透明度
    self.contentView.layer.shadowOpacity = 0.76;
    //设置阴影的偏移量
    self.contentView.layer.shadowOffset = CGSizeMake(1, 1);
    //设置阴影的圆角
    self.contentView.layer.shadowRadius = 6;
    [self addSubview:self.contentView];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 6;
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, self.contentView.width, 21)];
    [self.contentView addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:22];
    titleLabel.textColor = [UIColor colorWithHexString:@"#4DAEF8"];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = self.title;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame)+15, _contentView.width, 3)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#4DAEF8"];
    [self.contentView addSubview:lineView];
    
    if (_type == payPwdPopView) {
        
        _importPwdTex = [[UITextField alloc] initWithFrame:CGRectMake(7, CGRectGetMaxY(lineView.frame)+10, _contentView.width-14, 50)];
        _importPwdTex.placeholder = @"请输入支付密码";
        _importPwdTex.backgroundColor = [UIColor colorWithHexString:@"#E2E2E2"];
        _importPwdTex.secureTextEntry = YES;
        _importPwdTex.keyboardType = UIKeyboardTypeNumberPad;
        [self.contentView addSubview:_importPwdTex];
        
        UIView *importPwdLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 5)];
        _importPwdTex.leftView = importPwdLeftView;
        _importPwdTex.leftViewMode = UITextFieldViewModeAlways;
        
        forgetPwdBtn = [[UIButton alloc] initWithFrame:CGRectMake(_contentView.width-85, CGRectGetMaxY(_importPwdTex.frame)+15, 80, 18)];
//        [forgetPwdBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        [forgetPwdBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [forgetPwdBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [forgetPwdBtn addTarget:self action:@selector(forgetBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:forgetPwdBtn];
        // 加下划线
        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"忘记密码"];
        NSRange titleRange = {0,[title length]};
        [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
        [forgetPwdBtn setAttributedTitle:title
                              forState:UIControlStateNormal];
        
    }else if(_type == setPayPwdPopView){
        
        UILabel *messageLab = [[UILabel alloc] initWithFrame:CGRectMake(9, CGRectGetMaxY(lineView.frame)+10, _contentView.width-18, 38)];
        messageLab.textColor = [UIColor blackColor];
        messageLab.text = @"首次进行一卡通线上支付,为了保证账户安全,请设置一卡通线上支付密码";
        messageLab.numberOfLines = 0;
        messageLab.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:messageLab];
        
        _payPwdTex = [[UITextField alloc] initWithFrame:CGRectMake(7, CGRectGetMaxY(messageLab.frame)+10, _contentView.width-14, 50)];
        _payPwdTex.placeholder = @"设置一卡通6位支付密码";
        _payPwdTex.backgroundColor = [UIColor colorWithHexString:@"#E2E2E2"];
        _payPwdTex.secureTextEntry = YES;
        _payPwdTex.keyboardType = UIKeyboardTypeNumberPad;
        [self.contentView addSubview:_payPwdTex];
        
        
        UIView *payPwdLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 5)];
        _payPwdTex.leftView = payPwdLeftView;
        _payPwdTex.leftViewMode = UITextFieldViewModeAlways;
        
        _surePayPwdTex = [[UITextField alloc] initWithFrame:CGRectMake(7, CGRectGetMaxY(_payPwdTex.frame)+5, _contentView.width-14, 50)];
        _surePayPwdTex.placeholder = @"确认支付密码";
        _surePayPwdTex.backgroundColor = [UIColor colorWithHexString:@"#E2E2E2"];
        _surePayPwdTex.secureTextEntry = YES;
        _surePayPwdTex.keyboardType = UIKeyboardTypeNumberPad;
        [self.contentView addSubview:_surePayPwdTex];
        
        UIView *surePayPwdTexLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 5)];
        _surePayPwdTex.leftView = surePayPwdTexLeftView;
        _surePayPwdTex.leftViewMode = UITextFieldViewModeAlways;
        
        smallPayLab = [[UILabel alloc] initWithFrame:CGRectMake(7, CGRectGetMaxY(_surePayPwdTex.frame)+20, 140, 18)];
        smallPayLab.textAlignment = NSTextAlignmentLeft;
        smallPayLab.text = @"小额免密(50元内)";
        smallPayLab.textColor = [UIColor blackColor];
        smallPayLab.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:smallPayLab];
        
        _paySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(_contentView.width-60, 0, 60, 30)];
        _paySwitch.centerY = smallPayLab.centerY;
        [_paySwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];   // 开关事件切换通知
        [self.contentView addSubview:_paySwitch];
    }else if(_type == verPayPwdPopView){
        UILabel *messageLab = [[UILabel alloc] initWithFrame:CGRectMake(9, CGRectGetMaxY(lineView.frame)+10, _contentView.width-18, 16)];
        messageLab.textColor = [UIColor blackColor];
        messageLab.text = @"请输入支付密码,开启一卡通线上小额免密";
        messageLab.numberOfLines = 0;
        messageLab.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:messageLab];
        
        _importPwdTex = [[UITextField alloc] initWithFrame:CGRectMake(7, CGRectGetMaxY(messageLab.frame)+10, _contentView.width-14, 50)];
        _importPwdTex.placeholder = @"请输入支付密码";
        _importPwdTex.backgroundColor = [UIColor colorWithHexString:@"#E2E2E2"];
        _importPwdTex.secureTextEntry = YES;
        _importPwdTex.keyboardType = UIKeyboardTypeNumberPad;
        [self.contentView addSubview:_importPwdTex];
        
        UIView *importPwdLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 5)];
        _importPwdTex.leftView = importPwdLeftView;
        _importPwdTex.leftViewMode = UITextFieldViewModeAlways;
        
        forgetPwdBtn = [[UIButton alloc] initWithFrame:CGRectMake(_contentView.width-85, CGRectGetMaxY(_importPwdTex.frame)+15, 80, 18)];
        //        [forgetPwdBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        [forgetPwdBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [forgetPwdBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [forgetPwdBtn addTarget:self action:@selector(forgetBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:forgetPwdBtn];
        // 加下划线
        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"忘记密码"];
        NSRange titleRange = {0,[title length]};
        [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
        [forgetPwdBtn setAttributedTitle:title
                                forState:UIControlStateNormal];
        
    }else if(_type == normalPopView){
        _messageLab = [[UILabel alloc] initWithFrame:CGRectMake(14, lineView.bottom+19.5, self.contentView.width-28, 55)];
        _messageLab.textAlignment = NSTextAlignmentLeft;
        _messageLab.font = [UIFont systemFontOfSize:17];
        _messageLab.numberOfLines = 0;
        NSString *str = _message;
        NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:str];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:10];//调整行间距
        [attriStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
        _messageLab.attributedText = attriStr;
        [self.contentView addSubview:_messageLab];
    }else{
        UIImageView *typeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(12.5, lineView.bottom+30, 25, 25)];
        typeImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_leftButtonTitle]];
        [self.contentView addSubview:typeImgView];
        
        UILabel *dkTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(typeImgView.right + 13, lineView.bottom+25, 80, 14)];
        dkTimeLab.textColor = [UIColor blackColor];
        dkTimeLab.textAlignment = NSTextAlignmentLeft;
        dkTimeLab.font = [UIFont systemFontOfSize:17];
        dkTimeLab.text = _message;
        [self.contentView addSubview:dkTimeLab];
        
        UIImageView *outSideView = [[UIImageView alloc] initWithFrame:CGRectMake(_contentView.width - 15 - 32.5, lineView.bottom+23, 32.5, 17.5)];
        if ([_rightButtonTitle isEqualToString:@"1"]) {
            outSideView.hidden = NO;
        }else{
            outSideView.hidden = YES;
        }
        outSideView.image = [UIImage imageNamed:@"kq_wq"];
        [self.contentView addSubview:outSideView];
        
        UIImageView *locationView = [[UIImageView alloc] initWithFrame:CGRectMake(dkTimeLab.left, dkTimeLab.bottom+9, 15, 15)];
        locationView.image = [UIImage imageNamed:@"kqlocation"];
        [self.contentView addSubview:locationView];
        
        locationLab = [[UILabel alloc] initWithFrame:CGRectMake(locationView.right+5, locationView.top, _contentView.width-locationView.left-15, 15)];
        locationLab.textColor = [UIColor colorWithHexString:@"#1B82D1"];
        locationLab.textAlignment = NSTextAlignmentLeft;
        locationLab.font = [UIFont systemFontOfSize:13];
        locationLab.text = @"-";
        [self.contentView addSubview:locationLab];
        
        humanFaceView = [[UIImageView alloc] initWithFrame:CGRectMake((_contentView.width - 105)/2, locationLab.bottom + 15, 105, 140)];
        humanFaceView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:humanFaceView];
        
    }

    if (_type != kqDetailPopView) {
        // 取消按钮
        UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(smallPayLab.frame)+20, self.contentView.frame.size.width/2, 59)];
        [self.contentView addSubview:leftButton];
        leftButton.backgroundColor = [UIColor whiteColor];
        [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [leftButton setTitle:_leftButtonTitle forState:UIControlStateNormal];
        [leftButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [leftButton addTarget:self action:@selector(leftButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        leftButton.layer.cornerRadius = 6;
        leftButton.clipsToBounds = YES;
        
        // 确认按钮
        UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width/2, leftButton.frame.origin.y, self.contentView.frame.size.width/2, 59)];
        [self.contentView addSubview:rightButton];
        [rightButton setTitle:_rightButtonTitle forState:UIControlStateNormal];
        rightButton.backgroundColor = [UIColor whiteColor];
        if (_type == normalPopView) {
            [rightButton setTitleColor:[UIColor colorWithHexString:@"#1B82D1"] forState:UIControlStateNormal];
        }else{
            [rightButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        [rightButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [rightButton addTarget:self action:@selector(rightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        rightButton.layer.cornerRadius = 6;
        rightButton.clipsToBounds = YES;
        
        if (_type == payPwdPopView) {
            leftButton.frame = CGRectMake(0, CGRectGetMaxY(forgetPwdBtn.frame)+15,self.contentView.frame.size.width/2, 59);
            rightButton.frame = CGRectMake(self.contentView.frame.size.width/2, leftButton.frame.origin.y, self.contentView.frame.size.width/2, 59);
        }else if (_type == verPayPwdPopView){
            leftButton.frame = CGRectMake(0, CGRectGetMaxY(forgetPwdBtn.frame)+15,self.contentView.frame.size.width/2, 59);
            rightButton.frame = CGRectMake(self.contentView.frame.size.width/2, leftButton.frame.origin.y, self.contentView.frame.size.width/2, 59);
        }else if(_type == normalPopView)
        {
            leftButton.frame = CGRectMake(0, CGRectGetMaxY(_messageLab.frame)+27,self.contentView.frame.size.width/2, 59);
            rightButton.frame = CGRectMake(self.contentView.frame.size.width/2, leftButton.frame.origin.y, self.contentView.frame.size.width/2, 59);
        }
        
        UIView *verLinView = [[UIView alloc] initWithFrame:CGRectMake(0, leftButton.y, _contentView.width, 0.5)];
        verLinView.backgroundColor = [UIColor colorWithHexString:@"#E2E2E2"];
        [self.contentView addSubview:verLinView];
        
        UIView *hLinView = [[UIView alloc] initWithFrame:CGRectMake(_contentView.width/2, leftButton.y, 0.5, leftButton.height)];
        hLinView.backgroundColor = [UIColor colorWithHexString:@"#E2E2E2"];
        [self.contentView addSubview:hLinView];
        
        //------- 调整弹窗高度和中心 -------//
        self.contentView.height = rightButton.maxY;
        self.contentView.center = self.center;
    }else{
        //------- 调整弹窗高度和中心 -------//
        self.contentView.height = humanFaceView.maxY+19;
        self.contentView.center = self.center;
        
        //关闭按钮
        self.closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.contentView.bottom+26, 40, 40)];
        self.closeBtn.centerX = self.contentView.centerX;
        [self.closeBtn setBackgroundImage:[UIImage imageNamed:@"kqclose"] forState:UIControlStateNormal];
        [self.closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.closeBtn];
    }
    
    
    [_importPwdTex addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_surePayPwdTex addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_payPwdTex addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

-(void)setSignImageUrl:(NSString *)signImageUrl
{
    _signImageUrl = signImageUrl;
    
    [humanFaceView sd_setImageWithURL:[NSURL URLWithString:signImageUrl] placeholderImage:[UIImage imageNamed:@"dkHumanFace_placeholder"]];
}

-(void)setAddressStr:(NSString *)addressStr
{
    _addressStr = addressStr;
    
    locationLab.text = addressStr;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == _importPwdTex||textField == _surePayPwdTex||textField == _payPwdTex) {
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
        }
    }
}

#pragma mark 开关小额支付
-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    
    if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(openSmallPaySwtichAction:)]) {
        [self.delegate openSmallPaySwtichAction:switchButton];
    }
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
    if ([self.delegate respondsToSelector:@selector(declareAlertView:clickedButtonAtIndex:)]) {
        [self.delegate declareAlertView:self clickedButtonAtIndex:AlertButtonLeft];
    }
    [self dismiss];
}

-(void)closeBtnAction:(id)sender
{
    [self dismiss];
}

#pragma mark - 右边按钮点击
/** 右边按钮点击 */
- (void)rightButtonClicked{
    if ([self.delegate respondsToSelector:@selector(declareAlertView:clickedButtonAtIndex:)]) {
        [self.delegate declareAlertView:self clickedButtonAtIndex:AlertButtonRight];
    }
//    [self dismiss];
}

/** 忘记密码按钮点击 */
-(void)forgetBtnAction
{
    if (self.delegate !=nil && [self.delegate respondsToSelector:@selector(forgetPwdClickAction)]) {
        [self.delegate forgetPwdClickAction];
    }
}

/**
 *  键盘将要显示
 *
 *  @param notification 通知
 */
-(void)keyboardWillShow:(NSNotification *)notification
{
    // 获取到了键盘frame
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = frame.size.height;
    
    self.contentView.maxY = SCREEN_HEIGHT - keyboardHeight - 10;
}
/**
 *  键盘将要隐藏
 *
 *  @param notification 通知
 */
-(void)keyboardWillHidden:(NSNotification *)notification
{
    // 弹窗回到屏幕正中
    self.contentView.centerY = SCREEN_HEIGHT / 2;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

@end

