//
//  VisitResViewController.m
//  DXWingGate
//
//  Created by coder on 2018/8/24.
//  Copyright © 2018年 com.Transfar. All rights reserved.
//

#import "VisitResViewController.h"
#import "WSDatePickerView.h"
#import "HistoryVistorViewController.h"
#import "YZDatePickerView.h"
#import "Utils.h"
#import "VisitReasonModel.h"
#import "VisitHistoryModel.h"
#import "InputKeyBoardView.h"
#import "NumInputView.h"
#import "UITextField+Position.h"

@interface VisitResViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,YZPickerDateDelegate>
{
    NSInteger sexSelectIndex;
    NSInteger reasonSelectIndex;
    NSInteger tableSelectIndex;
    __weak IBOutlet UITextField *visitNameTex;
    __weak IBOutlet UILabel *visitSexLab;
    __weak IBOutlet UITextField *visitPhoneNumTex;
    __weak IBOutlet UITextField *togetherPeopleTex;
    __weak IBOutlet UITextField *carTex;
    __weak IBOutlet UILabel *reasonLab;
    __weak IBOutlet UILabel *arriveTimeLab;
    __weak IBOutlet UILabel *beginTimeLab;
    __weak IBOutlet UILabel *endTimeLab;
    
    NSString *beginTime;
    NSString *endTime;
    
    InputKeyBoardView *keyBoardView;
    NumInputView *numInputView;
}

@property (nonatomic,retain) UIPickerView *sexPikerView;
@property (nonatomic,retain) UIView *sexDateView;
@property (nonatomic,retain) UIPickerView *reasonPikerView;
@property (nonatomic,retain) UIView *reasonDateView;
@property (nonatomic,retain) NSMutableArray *dataArr;
//来访事由
@property (nonatomic,retain) NSMutableArray *reasonArr;

@end

@implementation VisitResViewController

-(NSMutableArray *)reasonArr
{
    if (_reasonArr == nil) {
        _reasonArr = @[].mutableCopy;
    }
    return _reasonArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    arriveTimeLab.text = [NSString stringWithFormat:@"%@ 上午",[self getCurrentTime]];
    beginTimeLab.text = [NSString stringWithFormat:@"%@ 09:00:00",[self getCurrentTime]];
    endTimeLab.text = [NSString stringWithFormat:@"%@ 12:00:00",[self getCurrentTime]];
    
    beginTime = [NSString stringWithFormat:@"%@ %@",[self getCurrentTime],@"09:00:00"];
    endTime = [NSString stringWithFormat:@"%@ %@",[self getCurrentTime],@"12:00:00"];
    
    [self initView];
    
    [self loadVisitReason];
}

//获取当地时间
- (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

-(void)loadVisitReason
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/getDataDictItem",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:@"visit_reasion" forKey:@"dictCode"];
    
    NSString *jsonStr = [Utils convertToJsonData:params];
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setObject:jsonStr forKey:@"param"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
        if (![responseObject[@"code"] isKindOfClass:[NSNull class]]&&[responseObject[@"code"] isEqualToString:@"1"]) {
            NSDictionary *dic = responseObject[@"responseData"];
            NSArray *arr = dic[@"rows"];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                VisitReasonModel *model = [[VisitReasonModel alloc] initWithDataDic:obj];
                [self.reasonArr addObject:model];
            }];
            
            VisitReasonModel *model = self.reasonArr.firstObject;
            self->reasonLab.text = [NSString stringWithFormat:@"%@",model.dictItemCode];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)initView{
    [self initSexPickView];
    
    [self initReasonPickView];
    
    // 设置自定义键盘
    int verticalCount = 5;
    CGFloat kheight = KScreenWidth/10 + 8;
    
    numInputView = [[NumInputView alloc] initWithFrame:CGRectMake(0, KScreenHeight - kheight * verticalCount, KScreenWidth, kheight * verticalCount) withClickKeyBoard:^(NSString *character) {
        carTex.text = [carTex.text stringByAppendingString:character];
        
    } withDelete:^{
        if(carTex.text.length > 0){
//            carTex.text = [carTex.text substringWithRange:NSMakeRange(0, carTex.text.length - 1)];
            // 删除光标位置字符
            [carTex positionDelete];
            
            [self judgementKeyBorad:carTex.text];
        }
        
    } withConfirm:^{
        [self.view endEditing:YES];
    } withChangeKeyBoard:^{
        
        carTex.inputView = keyBoardView;
        [carTex reloadInputViews];
        
    }];
    [numInputView setNeedsDisplay];
    carTex.inputView = numInputView;
    
    keyBoardView = [[InputKeyBoardView alloc] initWithFrame:CGRectMake(0, KScreenHeight - kheight * verticalCount, KScreenWidth, kheight * verticalCount) withClickKeyBoard:^(NSString *character) {
        carTex.text = [carTex.text stringByAppendingString:character];
        
        carTex.inputView = numInputView;
        [carTex reloadInputViews];
        
    } withDelete:^{
        if(carTex.text.length > 0){
//            carTex.text = [carTex.text substringWithRange:NSMakeRange(0, carTex.text.length - 1)];
            // 删除光标位置字符
            [carTex positionDelete];
            
            [self judgementKeyBorad:carTex.text];
        }
    } withConfirm:^{
        [self.view endEditing:YES];
    } withChangeKeyBoard:^{
        
        carTex.inputView = numInputView;
        [carTex reloadInputViews];
        
    }];
    [keyBoardView setNeedsDisplay];
    carTex.inputView = keyBoardView;
}

- (void)judgementKeyBorad:(NSString *)textStr {
    dispatch_async(dispatch_get_main_queue(), ^{
        if(textStr.length > 0){
            carTex.inputView = numInputView;
            [carTex reloadInputViews];
        }else{
            carTex.inputView = keyBoardView;
            [carTex reloadInputViews];
        }
    });
}

-(void)initSexPickView
{
    _sexDateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kTopHeight)];
    _sexDateView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.1];
    _sexDateView.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dateCancel)];
    _sexDateView.userInteractionEnabled = YES;
    [_sexDateView addGestureRecognizer:tap];
    [self.view addSubview:_sexDateView];
    
    _sexPikerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, _sexDateView.height-200-49, KScreenWidth, 200)];
    _sexPikerView.delegate = self;
    _sexPikerView.dataSource = self;
    _sexPikerView.tag = 100001;
    _sexPikerView.backgroundColor = [UIColor whiteColor];
    [_sexDateView addSubview:_sexPikerView];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, _sexPikerView.top - 40, _sexDateView.width, 40)];
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    toolbar.barTintColor = [UIColor colorWithHexString:@"#efefef"];
    toolbar.translucent = YES;
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dateCancel)];
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:      UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [spaceButtonItem setWidth:KScreenWidth - 110];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(dateDone)];
    toolbar.items = @[cancelItem,spaceButtonItem, doneItem];
    [_sexDateView addSubview:toolbar];
}

-(void)initReasonPickView
{
    _reasonDateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kTopHeight)];
    _reasonDateView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.1];
    _reasonDateView.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dateCancel)];
    _reasonDateView.userInteractionEnabled = YES;
    [_reasonDateView addGestureRecognizer:tap];
    [self.view addSubview:_reasonDateView];
    
    _reasonPikerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, _reasonDateView.height-200-49, KScreenWidth, 200)];
    _reasonPikerView.delegate = self;
    _reasonPikerView.dataSource = self;
    _reasonPikerView.tag = 100005;
    _reasonPikerView.backgroundColor = [UIColor whiteColor];
    [_reasonDateView addSubview:_reasonPikerView];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, _reasonPikerView.top - 40, _reasonDateView.width, 40)];
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    toolbar.barTintColor = [UIColor colorWithHexString:@"#efefef"];
    toolbar.translucent = YES;
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dateCancel)];
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:      UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [spaceButtonItem setWidth:KScreenWidth - 110];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(dateDone)];
    toolbar.items = @[cancelItem,spaceButtonItem, doneItem];
    [_reasonDateView addSubview:toolbar];
}

-(void)dateCancel
{
    _sexDateView.hidden = YES;
    _reasonDateView.hidden = YES;
}

-(void)dateDone
{
    _sexDateView.hidden = YES;
    _reasonDateView.hidden = YES;
    if (tableSelectIndex == 1) {
        visitSexLab.text = _dataArr[sexSelectIndex];
    }else if(tableSelectIndex == 5){
        reasonLab.text = _dataArr[reasonSelectIndex];
    }
}

#pragma mark - Picker view data source

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return _dataArr.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return self.view.bounds.size.width;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    if (!view) {
        view = [[UIView alloc] init];
    }
    UILabel *textlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    textlabel.textAlignment = NSTextAlignmentCenter;
    textlabel.text = _dataArr[row];
    textlabel.font = [UIFont systemFontOfSize:19];
    [view addSubview:textlabel];
    return view;
}

// didSelectRow
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 100001) {
        sexSelectIndex = row;
    }else{
        reasonSelectIndex = row;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-kTopHeight-49);
    [kNotificationCenter postNotificationName:@"VisittabbarDidSelectItemNotification" object:nil];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView endEditing:YES];
    NSInteger index = indexPath.row;
    tableSelectIndex = index;
    [_dataArr removeAllObjects];
    switch (index) {
        case 1:
            {
                NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"男",@"女",@"未知", nil];
                _dataArr = arr;
                _sexDateView.hidden = NO;
//                tableView.scrollEnabled = NO;
                [_sexPikerView reloadAllComponents];
            }
            break;
        case 5:
            {
                if (self.reasonArr.count == 0||self.reasonArr == nil) {
                    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"商务洽谈",@"拜访", nil];
                    _dataArr = arr;
                }else{
                    NSMutableArray *arr = @[].mutableCopy;
                    [self.reasonArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        VisitReasonModel *model = obj;
                        [arr addObject:model.dictItemCode];
                    }];
                    _dataArr = arr;
                }
                
                _reasonDateView.hidden = NO;
//                tableView.scrollEnabled = NO;
                [_reasonPikerView reloadAllComponents];
            }
            break;
        case 6:
            {
                YZDatePickerView *datePicker = [[YZDatePickerView alloc] initWithDelegate:self];
                [datePicker show];
            }
            break;
        default:
            break;
    }
}

#pragma mark YZPickerDateDelegate

- (void)pickerDate:(YZDatePickerView *)pickerDate year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day timeRange:(NSString *)timerange
{
    NSString *timeRange = [timerange substringWithRange:NSMakeRange(0, 2)];
    arriveTimeLab.text = [NSString stringWithFormat:@"%ld/%ld/%ld %@",year,month,day,timeRange];
    
    if ([timeRange isEqualToString:@"上午"]) {
        beginTimeLab.text = [NSString stringWithFormat:@"%ld/%ld/%ld %@",year,month,day,@"09:00:00"];
        endTimeLab.text = [NSString stringWithFormat:@"%ld/%ld/%ld %@",year,month,day,@"12:00:00"];
        if (month < 10) {
            if (day < 10) {
                beginTime = [NSString stringWithFormat:@"%ld-%@%ld-%@%ld %@",year,@"0",month,@"0",day,@"09:00:00"];
                endTime = [NSString stringWithFormat:@"%ld-%@%ld-%@%ld %@",year,@"0",month,@"0",day,@"12:00:00"];
            }else{
                beginTime = [NSString stringWithFormat:@"%ld-%@%ld-%ld %@",year,@"0",month,day,@"09:00:00"];
                endTime = [NSString stringWithFormat:@"%ld-%@%ld-%ld %@",year,@"0",month,day,@"12:00:00"];
            }
        }else{
            beginTime = [NSString stringWithFormat:@"%ld-%ld-%ld %@",year,month,day,@"09:00:00"];
            endTime = [NSString stringWithFormat:@"%ld-%ld-%ld %@",year,month,day,@"12:00:00"];
        }
        
    }else if ([timeRange isEqualToString:@"下午"]){
        beginTimeLab.text = [NSString stringWithFormat:@"%ld/%ld/%ld %@",year,month,day,@"14:00:00"];
        endTimeLab.text = [NSString stringWithFormat:@"%ld/%ld/%ld %@",year,month,day,@"18:00:00"];
        if (month < 10) {
            if (day < 10) {
                beginTime = [NSString stringWithFormat:@"%ld-%@%ld-%@%ld %@",year,@"0",month,@"0",day,@"14:00:00"];
                endTime = [NSString stringWithFormat:@"%ld-%@%ld-%@%ld %@",year,@"0",month,@"0",day,@"18:00:00"];
            }else{
                beginTime = [NSString stringWithFormat:@"%ld-%@%ld-%ld %@",year,@"0",month,day,@"14:00:00"];
                endTime = [NSString stringWithFormat:@"%ld-%@%ld-%ld %@",year,@"0",month,day,@"18:00:00"];
            }
        }else{
            beginTime = [NSString stringWithFormat:@"%ld-%ld-%ld %@",year,month,day,@"14:00:00"];
            endTime = [NSString stringWithFormat:@"%ld-%ld-%ld %@",year,month,day,@"18:00:00"];
        }
    }else if([timeRange isEqualToString:@"全天"]){
        beginTimeLab.text = [NSString stringWithFormat:@"%ld/%ld/%ld %@",year,month,day,@"09:00:00"];
        endTimeLab.text = [NSString stringWithFormat:@"%ld/%ld/%ld %@",year,month,day,@"18:00:00"];
        if (month < 10) {
            if (day < 10) {
                beginTime = [NSString stringWithFormat:@"%ld-%@%ld-%@%ld %@",year,@"0",month,@"0",day,@"09:00:00"];
                endTime = [NSString stringWithFormat:@"%ld-%@%ld-%@%ld %@",year,@"0",month,@"0",day,@"18:00:00"];
            }else{
                beginTime = [NSString stringWithFormat:@"%ld-%@%ld-%ld %@",year,@"0",month,day,@"09:00:00"];
                endTime = [NSString stringWithFormat:@"%ld-%@%ld-%ld %@",year,@"0",month,day,@"18:00:00"];
            }
        }else{
            beginTime = [NSString stringWithFormat:@"%ld-%ld-%ld %@",year,month,day,@"09:00:00"];
            endTime = [NSString stringWithFormat:@"%ld-%ld-%ld %@",year,month,day,@"18:00:00"];
        }
    }else{
        
    }
}

- (IBAction)commitVisitResAction:(id)sender {
    
    NSString *visitName = visitNameTex.text;
    if (visitName == nil||visitName.length == 0) {
        [self showHint:@"请填写姓名!"];
        return;
    }
    
    NSString *visitPhoneNum = visitPhoneNumTex.text;
    if (visitPhoneNum == nil||visitPhoneNum.length == 0) {
        [self showHint:@"请填写手机号码!"];
        return;
    }
    
    if (![Utils valiMobile:visitPhoneNumTex.text]) {
        [self showHint:@"请输入正确的手机号!"];
        return;
    }
    
    NSDate *oneDate = [NSDate date:endTime WithFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate *otherDate = [NSDate date];
    int i = [self compareOneDay:otherDate withAnotherDay:oneDate];
    if (i == 1) {
        [self showHint:@"预约时段必须在有效时段内！"];
        return;
    }else if(i == -1){
        
    }else{
        [self showHint:@"预约时段必须在有效时段内！"];
        return;
    }
    
    [self showHudInView:self.view hint:nil];
    VisitReasonModel *model = self.reasonArr[reasonSelectIndex];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/visitor/addAppointment",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:visitName forKey:@"visitorName"];
    if ([visitSexLab.text isEqualToString:@"男"]) {
        [params setObject:@"1" forKey:@"visitorSex"];
    }else if([visitSexLab.text isEqualToString:@"女"]){
        [params setObject:@"2" forKey:@"visitorSex"];
    }else{
        [params setObject:@"3" forKey:@"visitorSex"];
    }
    [params setObject:visitPhoneNum forKey:@"visitorPhone"];

    [params setObject:model.dictItemValue forKey:@"reasionId"];
    [params setObject:model.dictItemCode forKey:@"reasionDesc"];
    
    [params setObject:beginTime forKey:@"beginTime"];
    [params setObject:endTime forKey:@"endTime"];
    [params setObject:togetherPeopleTex.text forKey:@"persionWith"];
    [params setObject:carTex.text forKey:@"carNo"];
    
    NSString *jsonStr = [self convertToJsonData:params];
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setObject:jsonStr forKey:@"param"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if (![responseObject[@"code"] isKindOfClass:[NSNull class]]&&[responseObject[@"code"] isEqualToString:@"1"]) {
            [self showHint:@"访客预约成功!"];
            
            [self performSelector:@selector(back) withObject:nil afterDelay:0.5];
        }else{
            [self showHint:[NSString stringWithFormat:@"%@",responseObject[@"message"]]];
        }
    } failure:^(NSError *error) {
        [self hideHud];
        [self showHint:@"预约失败,请重试!"];
    }];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range];
    return mutStr;
}

//比较两个时间
- (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    
    if (result == NSOrderedDescending) {
        //在指定时间前面 过了指定时间 过期
        return 1;
    }
    else if (result == NSOrderedAscending){
        //没过指定时间 没过期
        return -1;
    }
    //刚好时间一样.
    return 0;
    
}

- (IBAction)selectHistoryVistorAction:(id)sender {
    HistoryVistorViewController *hisVistorVc = [[UIStoryboard storyboardWithName:@"Visit" bundle:nil] instantiateViewControllerWithIdentifier:@"HistoryVistorViewController"];
    hisVistorVc.historyValueBlock = ^(VisitHistoryModel *model) {
        visitNameTex.text = model.visitorName;
        visitPhoneNumTex.text = model.visitorPhone;
        if (![model.carNo isKindOfClass:[NSNull class]]&&model.carNo != nil&& model.carNo.length != 0) {
            carTex.text = model.carNo;
        }else{
            carTex.text = @"";
        }
        if ([model.visitorSex isEqualToString:@"1"]) {
            visitSexLab.text = @"男";
        }else if ([model.visitorSex isEqualToString:@"2"]){
            visitSexLab.text = @"女";
        }else{
            visitSexLab.text = @"未知";
        }
    };
    [self.navigationController pushViewController:hisVistorVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
