//
//  ZComBoxView.m
//  DemoDPSDK
//
//  Created by mac on 15/4/22.
//  Copyright (c) 2015年 chen_zhongbo. All rights reserved.
//
#import "ZComBoxView.h"

@implementation ZComBoxView
//初始化设置回放开始和结束时间弹出的对话框
-(id) initFrameSetBeginTime:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Transparent background
        self.opaque = NO;
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.6];
        self.alpha      = 1.0f;
        
        self.pDatePicker = [[UIDatePicker alloc] init];
        self.pDatePicker.datePickerMode = UIDatePickerModeDate;
        self.pDatePicker.backgroundColor = [UIColor clearColor];
        self.pDatePicker.maximumDate = [NSDate date];
        CGRect rect = self.pDatePicker.frame;
        rect.size.height = rect.size.height-40;;
        rect.size.width = rect.size.width-40;
        self.pDatePicker.frame = rect;
        [self addSubview:self.pDatePicker];
        
        [self addBtnOkWithAction:@selector(btnSetBeginTime:)];
        [self addBtnCancelWithAction:@selector(cencelAction:)];

        [self setlayout:self.pDatePicker];
    }
    return self;
}
-(id) initFrameSetEndTime:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Transparent background
        self.opaque = NO;
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.6];
        self.alpha      = 1.0f;
        
        self.pDatePicker = [[UIDatePicker alloc] init];
        self.pDatePicker.datePickerMode = UIDatePickerModeDate;
        self.pDatePicker.backgroundColor = [UIColor clearColor];
        self.pDatePicker.maximumDate = [NSDate date];
        CGRect rect = self.pDatePicker.frame;
        rect.size.height = rect.size.height-40;;
        rect.size.width = rect.size.width-40;
        self.pDatePicker.frame = rect;
        [self addSubview:self.pDatePicker];
        
        [self addBtnOkWithAction:@selector(btnSetEndTime:)];
        [self addBtnCancelWithAction:@selector(cencelAction:)];
        
        [self setlayout:self.pDatePicker];
    }
    return self;
}
//初始化设置录像类型弹出的对话框
-(id) initFrameSetRecordType:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self initPickerFrameWithPath:@"recordType"];
        [self addBtnOkWithAction:@selector(btnSetRecordType:)];
        [self addBtnCancelWithAction:@selector(cencelAction:)];
        [self setlayout:self.pPicker];
    }
    return self;
}
//初始化设置录像来源类型弹出的对话框
-(id) initFrameSetRecordResource:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self initPickerFrameWithPath:@"recordResource"];
        [self addBtnOkWithAction:@selector(btnSetRecordResource:)];
        [self addBtnCancelWithAction:@selector(cencelAction:)];
        [self setlayout:self.pPicker];
    }
    return self;
}
//初始化回放类型弹出的对话框
-(id) initFrameSetPlaybackType:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self initPickerFrameWithPath:@"playbackType"];
        [self addSubview:self.pPicker];
        [self addBtnOkWithAction:@selector(btnSetPlaybackType:)];
        [self addBtnCancelWithAction:@selector(cencelAction:)];
        [self setlayout:self.pPicker];
    }
    return self;
}

//初始化设置播放速度弹出的对话框
-(id) initFrameSetPlaybackSpeed:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self initPickerFrameWithPath:@"playbackSpeed"];
        [self addBtnOkWithAction:@selector(btnSetPlaybackSpeed:)];
        [self addBtnCancelWithAction:@selector(cencelAction:)];
        [self setlayout:self.pPicker];
    }
    return self;
}

//初始化picker框架，并获取picker所需的数据
-(void) initPickerFrameWithPath:(NSString*)pathString
{
    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.6];
    self.pPicker = [[UIPickerView alloc] init];
    self.pPicker.dataSource = self;
    self.pPicker.delegate = self;
    self.pPicker.backgroundColor = [UIColor clearColor];
    CGRect rect = self.pPicker.frame;
    rect.size.height = rect.size.height-40;;
    rect.size.width = rect.size.width-40;
    self.pPicker.frame = rect;
    [self addSubview:self.pPicker];
    NSBundle* bundle = [NSBundle mainBundle];
    NSArray* array;
    if ([pathString isEqualToString:@"recordResource"]) {
        array = [[NSArray alloc] initWithObjects:@"所有录像",@"设备录像",@"平台录像", nil];
    } else if ([pathString isEqualToString:@"playbackSpeed"]) {
         array = [[NSArray alloc] initWithObjects:@"1/8X",@"1/4X",@"1/2X",@"1X",@"2X",@"4X",@"8X", nil];
    }
    
    self.arrPicker = array;
}



//确认按钮设置
-(void) addBtnOkWithAction:(SEL)action
{
    self.pBtnOk = [[UIButton alloc] init];
    self.pBtnOk.backgroundColor = [UIColor clearColor];
    [self.pBtnOk setTitleColor:[UIColor blackColor]
                       forState:UIControlStateNormal];
    self.pBtnOk.frame = CGRectMake(20, 100, 80, 20);
    [self.pBtnOk setTitle:@"OK" forState:UIControlStateNormal];
    [self addSubview:self.pBtnOk];
    [self.pBtnOk addTarget:self
                     action:action
           forControlEvents:UIControlEventTouchUpInside];
}
//取消按钮设置
-(void) addBtnCancelWithAction:(SEL)action
{
    self.pBtnCancel = [[UIButton alloc] init];
    self.pBtnCancel.backgroundColor = [UIColor clearColor];
    [self.pBtnCancel setTitleColor:[UIColor blackColor]
                      forState:UIControlStateNormal];
    self.pBtnCancel.frame = CGRectMake(20, 100, 80, 20);
    [self.pBtnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [self addSubview:self.pBtnCancel];
    [self.pBtnCancel addTarget:self
                    action:action
          forControlEvents:UIControlEventTouchUpInside];
}
//放置picker和按钮布局
-(void) setlayout:(UIView*) pPicker
{
    UIView *parent = self.superview;
    if (parent) {
        self.frame = parent.bounds;
    }
    CGRect bounds = self.bounds;
    
    CGRect pickerF;
    pickerF = pPicker.bounds;
    pickerF.origin.x = roundf((bounds.size.width - pickerF.size.width) / 2);
    pickerF.origin.y = roundf((bounds.size.height - pickerF.size.height-20-16) / 2);
    pPicker.frame = pickerF;
    
    self.pBtnOk.frame = CGRectMake(pickerF.origin.x, pickerF.size.height + pickerF.origin.y, pickerF.size.width/2, 36);
    self.pBtnCancel.frame = CGRectMake(pickerF.origin.x+pickerF.size.width/2, pickerF.size.height + pickerF.origin.y, pickerF.size.width/2, 36);
    
    m_Rect.origin = pickerF.origin;
    m_Rect.size.width = pickerF.size.width;
    m_Rect.size.height = pickerF.size.height+36;
}
//取消设置按钮事件
-(void) cencelAction:(id)sender
{
    [self removeFromSuperview];
}
//点击确认按钮事件
-(void) btnSetBeginTime:(id)sender{
   [self.delegate setBeginTime:self.pDatePicker.date];

    [self removeFromSuperview];
}
-(void) btnSetEndTime:(id)sender{
    [self.delegate setEndTime:self.pDatePicker.date];

    [self removeFromSuperview];
}
//点击录像类型按钮事件
-(void) btnSetRecordType:(id)sender{
    NSInteger row1 = [self.pPicker selectedRowInComponent:0];
    [self.delegate setRecordType:row1];
 
    [self removeFromSuperview];
}
//点击回录像来源按钮事件
-(void) btnSetRecordResource:(id)sender{
    NSInteger row1 = [self.pPicker selectedRowInComponent:0];
    [self.delegate setRecordResourc:row1];

    [self removeFromSuperview];
}
//点击回放类型按钮事件
-(void) btnSetPlaybackType:(id)sender{
    NSInteger row1 = [self.pPicker selectedRowInComponent:0];
    [self.delegate setPlaybackType:row1];
  
    [self removeFromSuperview];
}
-(void) btnSetPlaybackSpeed:(id)sender{
    NSInteger row1 = [self.pPicker selectedRowInComponent:0];
    [self.delegate setPlaybackSpeed:row1];
   
    [self removeFromSuperview];
}
//绘制背景
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    
    CGRect allRect = self.bounds;
    CGContextSetGrayFillColor(context, 1.0f, 1.0);

    CGRect boxRect = CGRectMake(roundf((allRect.size.width - m_Rect.size.width) / 2),
                                roundf((allRect.size.height - m_Rect.size.height) / 2), m_Rect.size.width, m_Rect.size.height);
    float radius = 10.0f;
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect));
    
    CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMinY(boxRect) + radius, radius, 3 * (float)M_PI / 2, 0, 0);
    CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMaxY(boxRect) - radius, radius, 0, (float)M_PI / 2, 0);
    CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMaxY(boxRect) - radius, radius, (float)M_PI / 2, (float)M_PI, 0);
    CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect) + radius, radius, (float)M_PI, 3 * (float)M_PI / 2, 0);
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    UIGraphicsPopContext();
}

//以下三个方法为pickerview的数据源实现
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.arrPicker count];
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.arrPicker objectAtIndex:row];
}

@end
