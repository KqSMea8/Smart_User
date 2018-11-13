//
//  YZDatePickerView.m
//  DXWingGate
//
//  Created by coder on 2018/9/4.
//  Copyright © 2018年 com.Transfar. All rights reserved.
//

#import "YZDatePickerView.h"
#import "NSCalendar+picker.h"
#import "YZPickerToolBar.h"

static CGFloat const PickerViewHeight = 240;
static CGFloat const PickerViewLabelWeight = 40;

static NSInteger const yearMin = 1900;
static NSInteger const yearSum = 200;

#define kPickerSize self.pickerView.frame.size

// home indicator
#define bottom_height (kDevice_Is_iPhoneX ? 34.f : 10.f)

#define MAXYEAR 2099
#define MINYEAR 2000

@interface YZDatePickerView()<UIPickerViewDataSource, UIPickerViewDelegate>

/** 1.选择器 */
@property (nonatomic, strong)UIPickerView *pickerView;
/** 2.工具器 */
@property (nonatomic, strong)YZPickerToolBar *toolbar;
/** 3.边线 */
@property (nonatomic, strong)UIView *lineView;

/** 4.年 */
@property (nonatomic, assign)NSInteger year;
/** 5.月 */
@property (nonatomic, assign)NSInteger month;
/** 6.日 */
@property (nonatomic, assign)NSInteger day;
//时段
@property (nonatomic, assign)NSInteger index;
@property (nonatomic,strong)UIColor *dateLabelColor;
@property (nonatomic,retain) NSMutableArray *dataArr;

@end

@implementation YZDatePickerView

#pragma mark - --- init 视图初始化 ---

- (instancetype)initWithDelegate:(id)delegate
{
    self = [self init];
    self.delegate = delegate;
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
        [self loadData];
    }
    return self;
}

- (void)setupUI
{
    self.bounds = [UIScreen mainScreen].bounds;
    self.backgroundColor = RGBA(0, 0, 0, 102.0/255);
    [self.layer setOpaque:0.0];
    [self addSubview:self.pickerView];
    [self.pickerView addSubview:self.lineView];
    [self addSubview:self.toolbar];
    [self addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
}

- (void)loadData
{
    _year  = [NSCalendar currentYear];
    _month = [NSCalendar currentMonth];
    _day   = [NSCalendar currentDay];
    _index = 0;
    
    _dataArr = [NSMutableArray arrayWithObjects:@"上午(09:00-12:00)",@"下午(14:00-18:00)",@"全天(09:00-18:00)", nil];
    
    [self.pickerView selectRow:(_year - yearMin) inComponent:0 animated:NO];
    [self.pickerView selectRow:(_month - 1) inComponent:1 animated:NO];
    [self.pickerView selectRow:(_day - 1) inComponent:2 animated:NO];
    [self.pickerView selectRow:0 inComponent:3 animated:NO];
}

#pragma mark - --- delegate 视图委托 ---

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    [self addLabelWithName:@[@"年",@"月",@"日",@""]];
    return 4;
}

-(void)addLabelWithName:(NSArray *)nameArr {
    for (id subView in self.pickerView.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            [subView removeFromSuperview];
        }
    }
    
    if (!_dateLabelColor) {
        _dateLabelColor = [UIColor colorWithHexString:@"#1B82D1"];
    }
    
    for (int i=0; i<nameArr.count; i++) {
//        CGFloat labelX = kPickerSize.width/(4*2)+kPickerSize.width/4*i;
        CGFloat labelX;
        if (i == 0) {
            labelX = kPickerSize.width*0.2-5;
        }else if (i == 1){
            labelX = kPickerSize.width*0.35-5;
        }else{
            labelX = kPickerSize.width*0.5;
        }
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(labelX, self.pickerView.frame.size.height/2-15/2.0, 15, 15)];
        label.text = nameArr[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor =  _dateLabelColor;
        label.backgroundColor = [UIColor clearColor];
        [self.pickerView addSubview:label];
    }
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return yearSum;
    }else if(component == 1) {
        return 12;
    }else if(component == 2){
        NSInteger yearSelected = [pickerView selectedRowInComponent:0] + yearMin;
        NSInteger monthSelected = [pickerView selectedRowInComponent:1] + 1;
        return  [NSCalendar getDaysWithYear:yearSelected month:monthSelected];
    }else{
        return _dataArr.count;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return PickerViewLabelWeight;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    CGFloat height;
    if (component == 0) {
        height = pickerView.width*0.2;
    }else if (component == 3){
        height = pickerView.width*0.5;
    }else{
        height = pickerView.width*0.15;
    }
    return height;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
            break;
        case 1:
            [pickerView reloadComponent:2];
        default:
            break;
    }
    
    [self reloadData];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    
    NSString *text;
    if (component == 0) {
        text =  [NSString stringWithFormat:@"%ld",row + 1900];
    }else if (component == 1){
        text =  [NSString stringWithFormat:@"%ld", row + 1];
    }else if (component == 2){
        text = [NSString stringWithFormat:@"%ld", row + 1];
    }else{
        text = _dataArr[row];
        _index = row;
    }
    
    UILabel *label = [[UILabel alloc]init];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:17]];
    [label setText:text];
    return label;
}
#pragma mark - --- event response 事件相应 ---

- (void)selectedOk
{
    
    if ([self.delegate respondsToSelector:@selector(pickerDate:year:month:day:timeRange:)]) {
        [self.delegate pickerDate:self year:self.year month:self.month day:self.day timeRange:_dataArr[_index]];
    }
    
    [self remove];
}

- (void)selectedCancel
{
    [self remove];
}

#pragma mark - --- private methods 私有方法 ---

- (void)reloadData
{
    self.year  = [self.pickerView selectedRowInComponent:0] + yearMin;
    self.month = [self.pickerView selectedRowInComponent:1] + 1;
    self.day   = [self.pickerView selectedRowInComponent:2] + 1;
    
    self.toolbar.title = [NSString stringWithFormat:@"%ld-%ld-%ld %@", (long)self.year, self.month, self.day, _dataArr[_index]];
}

- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self setCenter:[UIApplication sharedApplication].keyWindow.center];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    
    CGRect frameTool = self.toolbar.frame;
    frameTool.origin.y = KScreenHeight - 54;
    
    CGRect framePicker = self.pickerView.frame;
    framePicker.origin.y -= PickerViewHeight+10;
    [UIView animateWithDuration:0.25 animations:^{
        [self.layer setOpacity:1];
        self.toolbar.frame = frameTool;
        self.pickerView.frame = framePicker;
    } completion:^(BOOL finished) {
    }];
}

- (void)remove
{
    CGRect frameTool = self.toolbar.frame;
    frameTool.origin.y += PickerViewHeight;
    
    CGRect framePicker =  self.pickerView.frame;
    framePicker.origin.y += PickerViewHeight;
    [UIView animateWithDuration:0.25 animations:^{
        [self.layer setOpacity:0];
        self.toolbar.frame = frameTool;
        self.pickerView.frame = framePicker;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - --- setters 属性 ---

#pragma mark - --- getters 属性 ---

- (UIPickerView *)pickerView
{
    if (!_pickerView) {
        CGFloat pickerW = KScreenWidth-20;
        CGFloat pickerH = PickerViewHeight - 44;
        CGFloat pickerX = 10;
        CGFloat pickerY = KScreenHeight;
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(pickerX, pickerY, pickerW, pickerH)];
        [_pickerView setBackgroundColor:[UIColor whiteColor]];
        [_pickerView ff_setCornerType:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadius:10];
        [_pickerView setDataSource:self];
        [_pickerView setDelegate:self];
    }
    return _pickerView;
}

- (YZPickerToolBar *)toolbar
{
    if (!_toolbar) {
        _toolbar = [[YZPickerToolBar alloc]initWithTitle:@"请选择日期"
                                       cancelButtonTitle:@"取消"
                                           okButtonTitle:@"确定"
                                               addTarget:self
                                            cancelAction:@selector(selectedCancel)
                                                okAction:@selector(selectedOk)];
        _toolbar.ly_x = 10;
        _toolbar.ly_y = KScreenHeight+44;
        _toolbar.titleColor = [UIColor whiteColor];
        _toolbar.backgroundColor = [UIColor colorWithHexString:@"#1B82D1"];
        [_toolbar ff_setCornerType:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadius:10];
    }
    return _toolbar;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth-20, 0.5)];
        [_lineView setBackgroundColor:[UIColor colorWithHexString:@"#1B82D1"]];
    }
    return _lineView;
}

@end
