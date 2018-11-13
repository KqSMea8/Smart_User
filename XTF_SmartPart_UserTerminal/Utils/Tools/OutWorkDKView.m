//
//  OutWorkDKView.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2018/4/9.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "OutWorkDKView.h"
#import "UIView+frameAdjust.h"
#import "YQPlaceHolderTextView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface OutWorkDKView()<UITextViewDelegate>

@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UIView *topSepLineView;
@property (nonatomic,strong) UILabel *kqTimeLab;
@property (nonatomic,strong) UILabel *kqLocationLab;
@property (nonatomic,strong) YQPlaceHolderTextView *textView;
@property (nonatomic,strong) UIImageView *humanFaceView;
@property (nonatomic,strong) UIView *bottomSepLineView;
@property (nonatomic,strong) UIButton *dkBtn;
@property (nonatomic,strong) UIButton *closeBtn;
@property (nonatomic,strong) UILabel *stirngLenghLabel;
@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,retain) UIImage *image;
@property (nonatomic, assign) CGRect lastFrame;
@property (nonatomic, weak) UIImageView *imagView;

@end

@implementation OutWorkDKView

-(instancetype)initWithimage:(UIImage *)image signTime:(NSString *)time signAddr:(NSString *)addr
{
    if (self = [super init]) {
        self.image = image;
        self.time = time;
        self.addr = addr;
        
        // 接收键盘显示隐藏的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
        
        [self configUI];
    }
    return self;
}

-(void)configUI
{
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.45];
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 1;
    }];
    
    //------- 弹窗主内容 -------//
    self.contentView = [[UIView alloc]init];
    self.contentView.frame = CGRectMake(35, (SCREEN_HEIGHT - 360) / 2, KScreenWidth-70, 360);
    self.contentView.center = self.center;
    [self addSubview:self.contentView];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 4;
    
    //关闭按钮
    self.closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.contentView.bottom+26, 40, 40)];
    self.closeBtn.centerX = self.contentView.centerX;
    [self.closeBtn setBackgroundImage:[UIImage imageNamed:@"kqclose"] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.closeBtn];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, self.contentView.width, 21)];
    [self.contentView addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:22];
    titleLabel.textColor = [UIColor colorWithHexString:@"#4DAEF8"];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = @"外勤打卡备注";
    
    self.topSepLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame)+15, _contentView.width, 3)];
    _topSepLineView.backgroundColor = [UIColor colorWithHexString:@"#4DAEF8"];
    [self.contentView addSubview:_topSepLineView];

    self.kqTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(6.5, _topSepLineView.bottom+20, self.contentView.width-13, 17)];
    _kqTimeLab.text = [NSString stringWithFormat:@"打卡时间：%@",self.time];
//    @"打卡时间：";
    _kqTimeLab.font = [UIFont systemFontOfSize:17];
    _kqTimeLab.textAlignment = NSTextAlignmentLeft;
    _kqTimeLab.textColor = [UIColor blackColor];
    [self.contentView addSubview:_kqTimeLab];
    
    self.kqLocationLab = [[UILabel alloc] initWithFrame:CGRectMake(6.5, _kqTimeLab.bottom+10, self.contentView.width-13, 17)];
    _kqLocationLab.text = [NSString stringWithFormat:@"打卡地点：%@",self.addr];
//    @"打卡地点：天园培训基地";
    _kqLocationLab.font = [UIFont systemFontOfSize:17];
    _kqLocationLab.textAlignment = NSTextAlignmentLeft;
    _kqLocationLab.textColor = [UIColor blackColor];
    [self.contentView addSubview:_kqLocationLab];
    
    self.textView = [[YQPlaceHolderTextView alloc] initWithFrame:CGRectMake(6.5, _kqLocationLab.bottom+11.5, self.contentView.width-13, 128)];
    self.textView.placeholder = @"请填写外勤打卡备注";
    self.textView.delegate = self;
    [self.textView setPlaceholderFont:[UIFont systemFontOfSize:17]];
    self.textView.font = [UIFont systemFontOfSize:17];
    self.textView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    [self.contentView addSubview:self.textView];
    
    self.humanFaceView = [[UIImageView alloc] initWithFrame:CGRectMake(6.5, self.textView.bottom+10, 26, 22)];
    self.humanFaceView.image = _image;
    [self.contentView addSubview:self.humanFaceView];
    self.humanFaceView.userInteractionEnabled = YES;
    //给人像添加单击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookHumanFaceBigImage:)];
    [self.humanFaceView addGestureRecognizer:tap];
    
    self.bottomSepLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.humanFaceView.bottom + 13, self.contentView.width, 0.5)];
    self.bottomSepLineView.backgroundColor = [UIColor colorWithHexString:@"#E2E2E2"];
    [self.contentView addSubview:self.bottomSepLineView];
    
    self.dkBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.bottomSepLineView.bottom, self.contentView.width, self.contentView.height - self.bottomSepLineView.bottom)];
    [self.dkBtn addTarget:self action:@selector(dkBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.dkBtn setTitle:@"打卡" forState:UIControlStateNormal];
    [self.dkBtn.titleLabel setFont:[UIFont systemFontOfSize:22]];
    [self.dkBtn setTitleColor:[UIColor colorWithHexString:@"#4DAEF8"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.dkBtn];
    
    self.stirngLenghLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.textView.width- 100, self.textView.height - 20, 100, 20)];
    self.stirngLenghLabel.font = [UIFont systemFontOfSize:15];
    self.stirngLenghLabel.textColor = [UIColor blackColor];
    self.stirngLenghLabel.text = @"0/40";
    self.stirngLenghLabel.textAlignment = NSTextAlignmentRight;
    [self.textView addSubview:self.stirngLenghLabel];
    
    //------- 调整弹窗高度和中心 -------//
    self.contentView.height = self.dkBtn.maxY;
    self.contentView.center = self.center;
}

//正在改变

- (void)textViewDidChange:(UITextView *)textView
{
    //实时显示字数
    self.stirngLenghLabel.text = [NSString stringWithFormat:@"%lu/40", (unsigned long)textView.text.length];
    //字数限制操作
    if (textView.text.length >= 40) {
        textView.text = [textView.text substringToIndex:40];
        self.stirngLenghLabel.text = @"40/40";
    }
}

-(void)setSignType:(NSString *)signType
{
    _signType = signType;
}

-(void)setTime:(NSString *)time
{
    _time = time;
    self.kqTimeLab.text = [NSString stringWithFormat:@"打卡时间：%@",time];
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
    self.closeBtn.maxY = self.contentView.bottom + 66;
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
    self.closeBtn.maxY = self.contentView.bottom + 66;
}

-(void)tapAction
{
    [self endEditing:YES];
}

#pragma mark 关闭按钮点击
-(void)closeBtnAction:(id)sender
{
    [self dismiss];
}

#pragma mark 打卡
-(void)dkBtnAction:(id)sender
{
    [self endEditing:YES];
    if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(wqDkSaveRecord:humanFace:signRemake:)]) {
        [self.delegate wqDkSaveRecord:_signType humanFace:self.image signRemake:self.textView.text];
    }
}

#pragma mark 外勤打卡查看人像信息大图
-(void)lookHumanFaceBigImage:(UITapGestureRecognizer *)tap
{
    [self endEditing:YES];
//    if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(wqLookHumanFaceBigImage:humanFace:)]) {
//        [self.delegate wqLookHumanFaceBigImage:_humanFaceView humanFace:self.image];
//    }
    [self tapImageView:tap];
}

- (void)tapImageView:(UITapGestureRecognizer *)recognizer
{
    //添加遮盖
    UIView *cover = [[UIView alloc] init];
    cover.frame = [UIScreen mainScreen].bounds;
    cover.backgroundColor = [UIColor clearColor];
    [cover addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCover:)]];
    [[UIApplication sharedApplication].keyWindow addSubview:cover];
    
    //添加图片到遮盖上
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.image];
    imageView.frame = [cover convertRect:recognizer.view.frame fromView:self.contentView];
    self.lastFrame = imageView.frame;
    [cover addSubview:imageView];
    self.imagView = imageView;
    
    //放大
    [UIView animateWithDuration:0.3f animations:^{
        cover.backgroundColor = [UIColor blackColor];
        CGRect frame = imageView.frame;
        frame.size.width = cover.frame.size.width;
        if (self.image == nil) {
            UIImage *image = [UIImage imageNamed:@"_member_icon"];
            frame.size.height = cover.frame.size.width * (image.size.height / image.size.width);
        }else{
            frame.size.height = cover.frame.size.width * (imageView.image.size.height / imageView.image.size.width);
        }
        
        frame.origin.x = 0;
        frame.origin.y = (cover.frame.size.height - frame.size.height) * 0.5;
        imageView.frame = frame;
    }];
}

- (void)tapCover:(UITapGestureRecognizer *)recognizer
{
    [UIView animateWithDuration:0.3f animations:^{
        recognizer.view.backgroundColor = [UIColor clearColor];
        self.imagView.frame = self.lastFrame;
        
    }completion:^(BOOL finished) {
        [recognizer.view removeFromSuperview];
        self.imagView = nil;
    }];
}


@end
