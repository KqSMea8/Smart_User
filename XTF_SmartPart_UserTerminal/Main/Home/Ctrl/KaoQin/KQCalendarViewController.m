//
//  KQCalendarViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/13.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "KQCalendarViewController.h"
#import "Utils.h"
#import "DIYCalendarCell.h"

@interface KQCalendarViewController ()<FSCalendarDataSource,FSCalendarDelegate>
{
    UIView *_titleBgView;
    
    UIView *_detailMsgView;
    //上班
    UILabel *_onWorkLab;
    UILabel *_onWorkDetailLab;
    UIImageView *_onWorkSignView;
    
    //下班
    UILabel *_offWorkLab;
    UILabel *_offWorkDetailLab;
    UIImageView *_offWorkSignView;
    
    //旷工
    UILabel *_absenteeismLab;
    
    NSString *statusStr;
    
    NSString *currentMonthStr;
    NSString *currentDateStr;
    NSDate *currentDate;
    
    UILabel *_monthTitleLab;
    
    UIView *_headerView;
    UILabel *_restLab;
    UILabel *_overtimeLab;
    BOOL _onWorkIsLack;
}

@property (strong, nonatomic) UILabel *titleLab;
@property (weak, nonatomic) FSCalendar *calendar;
@property (retain, nonatomic) UIButton *previousButton;
@property (retain, nonatomic) UIButton *nextButton;
@property (nonatomic,retain) UIButton *currentMonthBtn;

@property (strong, nonatomic) NSDictionary *fillDefaultColors;
@property (strong, nonatomic) NSDictionary *titleDefaultColors;

@property (strong, nonatomic) NSCalendar *gregorian;

@property (nonatomic,strong) NSMutableArray *dataArr;

- (void)previousClicked:(id)sender;
- (void)nextClicked:(id)sender;

@end

@implementation KQCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArr = @[].mutableCopy;
    
    YYReachability *rech = [YYReachability reachability];
    if (!rech.reachable) {
        [self showHint:@"网络不给力,请重试!"];
    }
    
    [self _initNavItems];
    
    [self _initView];
    
    [self _loadData];
    
    currentDateStr = [Utils getCurrentTime];
    
    [self _loadTodayKqData];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 75)];
        _headerView.backgroundColor = [UIColor colorWithHexString:@"#252E44"];
        [self.view addSubview:_headerView];
    }
    return self;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view = view;
    
    // 450 for iPad and 300 for iPhone
    CGFloat height = [[UIDevice currentDevice].model hasPrefix:@"iPad"] ? 375 : 365*wScale;
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 75, view.frame.size.width, height)];
    calendar.scrollEnabled = NO;
    calendar.headerHeight = 0;
    calendar.weekdayHeight = 40;
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.firstWeekday = 1;
    calendar.appearance.weekdayFont = [UIFont systemFontOfSize:17];
    calendar.appearance.weekdayTextColor = [UIColor blackColor];
    calendar.calendarHeaderView.backgroundColor = [UIColor colorWithHexString:@"#252E44"];
    calendar.calendarWeekdayView.backgroundColor = [UIColor colorWithHexString:@"#E8E8E8"];
    calendar.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    [calendar registerClass:[DIYCalendarCell class] forCellReuseIdentifier:@"cell"];
    
    calendar.appearance.headerMinimumDissolvedAlpha = 0;
    calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase;
    [self.view addSubview:calendar];
    self.calendar = calendar;
    
    UIButton *previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
    previousButton.frame = CGRectMake(10, (67.5-30)/2 + (75-67.5), 60, 30);
    previousButton.backgroundColor = [UIColor colorWithHexString:@"#3699FF"];
    previousButton.layer.cornerRadius = 5;
    previousButton.clipsToBounds = YES;
    previousButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [previousButton setTitle:@"上一月" forState:UIControlStateNormal];
    [previousButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [previousButton addTarget:self action:@selector(previousClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:previousButton];
    self.previousButton = previousButton;
    
    _monthTitleLab = [[UILabel alloc] init];
    _monthTitleLab.font = [UIFont systemFontOfSize:17];
    _monthTitleLab.textColor = [UIColor whiteColor];
    _monthTitleLab.frame = CGRectMake(0, (67.5-30)/2 + (75-67.5), 120, 30);
    _monthTitleLab.centerX = self.view.centerX*1.2;
    _monthTitleLab.textAlignment = NSTextAlignmentCenter;
    [_headerView addSubview:_monthTitleLab];
    
    UIButton *currentMonthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    currentMonthBtn.frame = CGRectMake(CGRectGetMaxX(previousButton.frame)+10, (67.5-30)/2 + (75-67.5), 50, 30);
    currentMonthBtn.backgroundColor = [UIColor colorWithHexString:@"#3699FF"];
    currentMonthBtn.layer.cornerRadius = 5;
    currentMonthBtn.clipsToBounds = YES;
    [currentMonthBtn setTitle:@"本月" forState:UIControlStateNormal];
    [currentMonthBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    currentMonthBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [currentMonthBtn addTarget:self action:@selector(currentMonthBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:currentMonthBtn];
    self.currentMonthBtn = currentMonthBtn;
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(CGRectGetWidth(self.view.frame)-70, (67.5-30)/2 + (75-67.5), 60, 30);
    nextButton.backgroundColor = [UIColor colorWithHexString:@"#3699FF"];
    nextButton.layer.cornerRadius = 5;
    nextButton.clipsToBounds = YES;
    [nextButton setTitle:@"下一月" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [nextButton addTarget:self action:@selector(nextClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:nextButton];
    self.nextButton = nextButton;
    
}

- (void)previousClicked:(id)sender
{
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *previousMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:currentMonth options:0];
    [self.calendar setCurrentPage:previousMonth animated:YES];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM";
    NSString *key = [dateFormatter stringFromDate:previousMonth];
    
    NSDateFormatter *dateForMatter2 = [[NSDateFormatter alloc] init];
    dateForMatter2.dateFormat = @"yyyy年MM月";
    NSString *titleDate = [dateForMatter2 stringFromDate:previousMonth];
    _monthTitleLab.text = titleDate;
    
    currentMonthStr = key;
    [self _loadData];
}

-(void)currentMonthBtnClicked:(id)sender
{
    NSDate *currentMonth = self.calendar.today;
    NSDate *nextMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:0 toDate:currentMonth options:0];
    [self.calendar setCurrentPage:nextMonth animated:YES];
    
    NSDateFormatter *dateForMatter2 = [[NSDateFormatter alloc] init];
    dateForMatter2.dateFormat = @"yyyy年MM月";
    NSString *titleDate = [dateForMatter2 stringFromDate:[NSDate date]];
    _monthTitleLab.text = titleDate;
    
    currentMonthStr = [Utils getCurrentMouth];
    [self _loadData];
}

- (void)nextClicked:(id)sender
{
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *nextMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:currentMonth options:0];
    [self.calendar setCurrentPage:nextMonth animated:YES];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM";
    NSString *key = [dateFormatter stringFromDate:nextMonth];
    
    NSDateFormatter *dateForMatter2 = [[NSDateFormatter alloc] init];
    dateForMatter2.dateFormat = @"yyyy年MM月";
    NSString *titleDate = [dateForMatter2 stringFromDate:nextMonth];
    _monthTitleLab.text = titleDate;
    
    currentMonthStr = key;
    
    [self _loadData];
}

- (NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date
{
    if ([self.gregorian isDateInToday:date]) {
        currentDate = date;
        return @"今";
    }
    return nil;
}

- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    dateFormatter1.dateFormat = @"yyyy-MM-dd";
    NSString *key = [dateFormatter1 stringFromDate:date];
    if ([_titleDefaultColors.allKeys containsObject:key]) {
        return _titleDefaultColors[key];
    }
    return nil;
}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    dateFormatter1.dateFormat = @"yyyy-MM-dd";
    NSString *key = [dateFormatter1 stringFromDate:date];
    if ([_fillDefaultColors.allKeys containsObject:key]) {
        return _fillDefaultColors[key];
    }
    return nil;
}

-(void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    dateFormatter1.dateFormat = @"yyyy年MM月dd日";
    NSString *key1 = [dateFormatter1 stringFromDate:date];
    _titleLab.text = key1;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *key = [dateFormatter stringFromDate:date];
    currentDateStr = key;
    
    currentDate = date;
    
    [self _loadTodayKqData];
}

- (FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    DIYCalendarCell *cell = [calendar dequeueReusableCellWithIdentifier:@"cell" forDate:date atMonthPosition:monthPosition];
    
    return cell;
}

-(void)_initNavItems
{
    self.title = @"考勤月历";
    
    UIButton *leftBtn = [[UIButton alloc] init];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [leftBtn setImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(_leftBarBtnItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

-(void)_leftBarBtnItemClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)_initView
{
    currentMonthStr = [Utils getCurrentMouth];
    
    NSDateFormatter *dateForMatter2 = [[NSDateFormatter alloc] init];
    dateForMatter2.dateFormat = @"yyyy年MM月";
    NSString *titleDate = [dateForMatter2 stringFromDate:[NSDate date]];
    _monthTitleLab.text = titleDate;
    
    _titleBgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_calendar.frame), KScreenWidth, 50*wScale)];
    _titleBgView.backgroundColor = [UIColor colorWithHexString:@"#E8E8E8"];
    [self.view addSubview:_titleBgView];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateString = [format stringFromDate:[NSDate date]];
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 180, 20)];
    _titleLab.textAlignment = NSTextAlignmentLeft;
    _titleLab.textColor = [UIColor blackColor];
    _titleLab.centerY = _titleBgView.height/2;
    _titleLab.text = dateString;
    _titleLab.font = [UIFont systemFontOfSize:18];
    [_titleBgView addSubview:_titleLab];
    
    _detailMsgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleBgView.frame), KScreenWidth, KScreenHeight-CGRectGetMaxY(_titleBgView.frame)-kTopHeight)];
    _detailMsgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_detailMsgView];
    
    NSString *str = @"上班";
    CGSize size = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
    
    _onWorkLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 18*wScale, size.width, size.height)];
    _onWorkLab.text = @"上班";
    if (iPhone5) {
        _onWorkLab.frame = CGRectMake(10, 10, size.width, size.height);
    }
    _onWorkLab.textAlignment = NSTextAlignmentLeft;
    _onWorkLab.textColor = [UIColor blackColor];
    _onWorkLab.font = [UIFont systemFontOfSize:17];
    [_detailMsgView addSubview:_onWorkLab];
    
    _onWorkDetailLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_onWorkLab.frame) + 12, 0, 120, size.height)];
    _onWorkDetailLab.centerY = _onWorkLab.centerY;
    _onWorkDetailLab.text = @"08:19";
    _onWorkDetailLab.textAlignment = NSTextAlignmentLeft;
    _onWorkDetailLab.textColor = [UIColor blackColor];
    _onWorkDetailLab.font = [UIFont systemFontOfSize:17];
    [_detailMsgView addSubview:_onWorkDetailLab];
    
    _offWorkLab = [[UILabel alloc] initWithFrame:CGRectMake(10, _onWorkLab.bottom+15*wScale, size.width, size.height)];
    _offWorkLab.text = @"下班";
    if (iPhone5) {
        _offWorkLab.frame = CGRectMake(10, _onWorkLab.bottom+12*wScale, size.width, size.height);
    }
    _offWorkLab.textAlignment = NSTextAlignmentLeft;
    _offWorkLab.textColor = [UIColor blackColor];
    _offWorkLab.font = [UIFont systemFontOfSize:17];
    [_detailMsgView addSubview:_offWorkLab];
    
    _offWorkDetailLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_onWorkLab.frame) + 12, 0, 110, size.height)];
    _offWorkDetailLab.centerY = _offWorkLab.centerY;
    _offWorkDetailLab.text = @"18:19";
    _offWorkDetailLab.textAlignment = NSTextAlignmentLeft;
    _offWorkDetailLab.textColor = [UIColor blackColor];
    _offWorkDetailLab.font = [UIFont systemFontOfSize:17];
    [_detailMsgView addSubview:_offWorkDetailLab];
    
    _onWorkSignView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_onWorkDetailLab.frame), 0, 32, 17)];
    _onWorkSignView.centerY = _onWorkLab.centerY;
    _onWorkSignView.image = [UIImage imageNamed:@"normal"];
    [_detailMsgView addSubview:_onWorkSignView];
    
    _offWorkSignView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_offWorkDetailLab.frame)+10, 0, 32, 17)];
    _offWorkSignView.centerY = _offWorkLab.centerY;
    _offWorkSignView.image = [UIImage imageNamed:@"kq_leaveEarly"];
    [_detailMsgView addSubview:_offWorkSignView];
    
    _restLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, _detailMsgView.width-20, _detailMsgView.height-20)];
    _restLab.text = @"休息日";
    _restLab.font = [UIFont systemFontOfSize:17];
    _restLab.backgroundColor = [UIColor whiteColor];
    [_detailMsgView addSubview:_restLab];
    _restLab.hidden = YES;
    
    _overtimeLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_offWorkDetailLab.frame), 0, 135, _offWorkDetailLab.height)];
    _overtimeLab.centerY = _offWorkDetailLab.centerY;
    _overtimeLab.text = @"";
    _overtimeLab.backgroundColor = [UIColor whiteColor];
    _overtimeLab.textColor = [UIColor colorWithHexString:@"#189517"];
    _overtimeLab.font = [UIFont systemFontOfSize:17];
    [_detailMsgView addSubview:_overtimeLab];
    _overtimeLab.hidden = YES;
    
    _absenteeismLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, _detailMsgView.width-20, _detailMsgView.height-20)];
    _absenteeismLab.text = @"缺卡一天";
    _absenteeismLab.font = [UIFont systemFontOfSize:17];
    _absenteeismLab.backgroundColor = [UIColor whiteColor];
    _absenteeismLab.textColor = [UIColor colorWithHexString:@"#FF4359"];
    [_detailMsgView addSubview:_absenteeismLab];
    _absenteeismLab.hidden = YES;
}

-(void)_loadData
{
    NSString *cerdIds = [kUserDefaults objectForKey:KUserCertId];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/attendance/attendanceReport/day",MainUrl];
    
    NSString *timeStr = [Utils getMonthBeginAndEndWith:currentMonthStr];
    
    NSArray *arr = [timeStr componentsSeparatedByString:@","];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:cerdIds forKey:@"certIds"];
    [params setObject:arr[0] forKey:@"startDate"];
    [params setObject:arr[1] forKey:@"endDate"];
    
    [[NetworkClient sharedInstance] GET:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        
        NSMutableDictionary *dateDic = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *titleDateDic = [[NSMutableDictionary alloc] init];
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            
            NSDictionary *dic = responseObject[@"responseData"];
            NSArray *dataArr = dic[@"items"];
            [dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = (NSDictionary *)obj;
                NSString *status = dic[@"status"];
                NSString *isWorkDay = dic[@"isWorkDay"];
                if ([isWorkDay isEqualToString:@"1"]) {
                    if (![status isEqualToString:@"1"]) {
                        if ([status isEqualToString:@"4"]) {
                            NSString *dateStr = dic[@"repDate"];
                            [dateDic setObject:[UIColor colorWithHexString:@"#df6f73"] forKey:dateStr];
                            [titleDateDic setObject:[UIColor whiteColor] forKey:dateStr];
                        }else{
                            NSString *dateStr = dic[@"repDate"];
                            [dateDic setObject:[UIColor colorWithHexString:@"#e2a3a1"] forKey:dateStr];
                            [titleDateDic setObject:[UIColor whiteColor] forKey:dateStr];
                        }
                        
                    }else{
                        NSString *dateStr = dic[@"repDate"];
                        [dateDic setObject:[UIColor colorWithHexString:@"#8fcdf3"] forKey:dateStr];
                        [titleDateDic setObject:[UIColor whiteColor] forKey:dateStr];
                    }
                }else{
                    if ([status isEqualToString:@"6"]) {
                        NSString *dateStr = dic[@"repDate"];
                        [dateDic setObject:[UIColor colorWithHexString:@"#46b1f3"] forKey:dateStr];
                        [titleDateDic setObject:[UIColor whiteColor] forKey:dateStr];
                    }
                }
            }];
        }
        self.fillDefaultColors = [NSDictionary dictionaryWithDictionary:dateDic];
        self.titleDefaultColors = [NSDictionary dictionaryWithDictionary:titleDateDic];
        [self.calendar reloadData];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 加载今日考勤数据
-(void)_loadTodayKqData
{
    NSString *certId = [kUserDefaults objectForKey:KUserCertId];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/attendance/attendanceRecord/valid",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:certId forKey:@"certIds"];
    [params setObject:currentDateStr forKey:@"recordDate"];
    
    [[NetworkClient sharedInstance] GET:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            
            _onWorkIsLack = NO;
            
            NSDictionary *dic = responseObject[@"responseData"];
            NSDictionary *outDic = dic[@"OUT"];
            NSDictionary *inDic = dic[@"IN"];
            NSString *isWorkDay = dic[@"isWorkDay"];
            
            if ([isWorkDay isEqualToString:@"1"]) {
                _restLab.hidden = YES;
                _overtimeLab.hidden = YES;
                _absenteeismLab.hidden = YES;
                
                if (![inDic isKindOfClass:[NSNull class]]&&inDic != nil&&[inDic allKeys].count != 0) {
                    _onWorkSignView.hidden = NO;
                    _onWorkDetailLab.textColor = [UIColor blackColor];
                    _onWorkDetailLab.text = [NSString stringWithFormat:@"%@",inDic[@"trunSignTime"]];
                    NSString *status = inDic[@"signStatus"];
                    NSString *isOutside = inDic[@"isOutside"];
                    if ([status isEqualToString:@"1"]) {
                        if ([isOutside isEqualToString:@"1"]) {
                            _onWorkSignView.image = [UIImage imageNamed:@"kq_wq"];
                        }else{
                            _onWorkSignView.image = [UIImage imageNamed:@"normal"];
                        }
                    }else if([status isEqualToString:@"2"]){
                        if ([isOutside isEqualToString:@"1"]) {
                            _onWorkSignView.image = [UIImage imageNamed:@"kq_wq"];
                        }else{
                            _onWorkSignView.image = [UIImage imageNamed:@"later"];
                        }
                    }else{
                        if ([isOutside isEqualToString:@"1"]) {
                            _onWorkSignView.image = [UIImage imageNamed:@"kq_wq"];
                        }else{
                            _onWorkSignView.image = [UIImage imageNamed:@"kq_leaveEarly"];
                        }
                    }
                }else{
                    _onWorkSignView.hidden = YES;
                    _onWorkSignView.image = [UIImage imageNamed:@""];
                    
                    if ([self getUTCFormateDate:currentDate]) {
                        if ([dic[@"isInLack"] isEqualToString:@"1"]) {
                            _onWorkDetailLab.textColor = [UIColor colorWithHexString:@"#FF4359"];
                            _onWorkDetailLab.text = @"迟到(缺卡)";
                        }else{
                            _onWorkDetailLab.text = @"-";
                        }
                    }else if ([self compareOneDay:[NSDate date] withAnotherDay:currentDate]){
                        _onWorkDetailLab.textColor = [UIColor blackColor];
                        _onWorkDetailLab.text = @"-";
                    }else{
                        _onWorkDetailLab.textColor = [UIColor colorWithHexString:@"#FF4359"];
                        _onWorkDetailLab.text = @"迟到(缺卡)";
                        _onWorkIsLack = YES;
                    }
                }
                
                if (![outDic isKindOfClass:[NSNull class]]&&outDic != nil&&[outDic allKeys].count != 0) {
                    _offWorkSignView.hidden = NO;
                    NSString *timeStr = outDic[@"trunSignTime"];
                    _offWorkDetailLab.textColor = [UIColor blackColor];
                    if (![timeStr isKindOfClass:[NSNull class]]&&timeStr.length != 0) {
                        _offWorkDetailLab.text = [NSString stringWithFormat:@"%@",outDic[@"trunSignTime"]];
                    }else{
                        _offWorkDetailLab.text = @"-";
                    }
                    
                    NSString *status = outDic[@"signStatus"];
                    NSString *wqisOutside = outDic[@"isOutside"];
                    if ([status isEqualToString:@"1"]) {
                        if ([wqisOutside isEqualToString:@"1"]) {
                            _offWorkSignView.image = [UIImage imageNamed:@"kq_wq"];
                        }else{
                            _offWorkSignView.image = [UIImage imageNamed:@"normal"];
                        }
                    }else if([status isEqualToString:@"2"]){
                        if ([wqisOutside isEqualToString:@"1"]) {
                            _offWorkSignView.image = [UIImage imageNamed:@"kq_wq"];
                        }else{
                            _offWorkSignView.image = [UIImage imageNamed:@"later"];
                        }
                    }else{
                        if ([wqisOutside isEqualToString:@"1"]) {
                            _offWorkSignView.image = [UIImage imageNamed:@"kq_wq"];
                        }else{
                            _offWorkSignView.image = [UIImage imageNamed:@"kq_leaveEarly"];
                        }
                    }
                }else{
                    _offWorkSignView.hidden = YES;
                    
                    if ([self getUTCFormateDate:currentDate]) {
                        _offWorkDetailLab.textColor = [UIColor blackColor];
                        _offWorkDetailLab.text = @"-";
                    }else if ([self compareOneDay:[NSDate date] withAnotherDay:currentDate]){
                        _offWorkDetailLab.textColor = [UIColor blackColor];
                        _offWorkDetailLab.text = @"-";
                    }else{
                        _offWorkDetailLab.textColor = [UIColor colorWithHexString:@"#FF4359"];
                        _offWorkDetailLab.text = @"早退(缺卡)";
                        if (_onWorkIsLack) {
                            _absenteeismLab.hidden = NO;
                        }else{
                            _absenteeismLab.hidden = YES;
                        }
                    }
                }
            }else{
                _offWorkSignView.hidden = YES;
                _onWorkSignView.hidden = YES;
                _overtimeLab.hidden = YES;
                _absenteeismLab.hidden = YES;
                
                if (([inDic isKindOfClass:[NSNull class]]||inDic == nil||[inDic allKeys].count == 0)&&([outDic isKindOfClass:[NSNull class]]||outDic == nil||[outDic allKeys].count == 0)) {
                    _restLab.hidden = NO;
                }else{
                    _restLab.hidden = YES;
                    if (![inDic isKindOfClass:[NSNull class]]&&inDic != nil&&[inDic allKeys].count != 0) {
                        _onWorkDetailLab.textColor = [UIColor blackColor];
                        _onWorkDetailLab.text = [NSString stringWithFormat:@"%@",inDic[@"trunSignTime"]];
                    }else{
                        _onWorkDetailLab.textColor = [UIColor blackColor];
                        _onWorkDetailLab.text = @"-";
                    }
                    
                    if (![outDic isKindOfClass:[NSNull class]]&&outDic != nil&&[outDic allKeys].count != 0) {
                        NSString *timeStr = outDic[@"trunSignTime"];
                        _offWorkDetailLab.textColor = [UIColor blackColor];
                        if (![timeStr isKindOfClass:[NSNull class]]&&timeStr.length != 0) {
                            _offWorkDetailLab.text = [NSString stringWithFormat:@"%@",outDic[@"trunSignTime"]];
                        }else{
                            _offWorkDetailLab.text = @"-";
                        }
                    }else{
                        _offWorkDetailLab.textColor = [UIColor blackColor];
                        _offWorkDetailLab.text = @"-";
                    }
                    
                    if (inDic.allKeys.count != 0&&outDic.allKeys.count != 0) {
                        NSString *onWorkTime = inDic[@"trunSignTime"];
                        NSString *offWorkTime = outDic[@"trunSignTime"];
                        NSString *time = [Utils pleaseInsertStarTimeo:onWorkTime andInsertEndTime:offWorkTime];
                        _overtimeLab.text = [NSString stringWithFormat:@"加班%@",time];
                        _overtimeLab.hidden = NO;
                    }

                }
            }
            
        }
    } failure:^(NSError *error) {
        
    }];
}

-(BOOL)getUTCFormateDate:(NSDate *)newsDate
{
    BOOL isToday;
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today=[[NSDate alloc] init];
    NSDate *yearsterDay =  [[NSDate alloc] initWithTimeIntervalSinceNow:-secondsPerDay];
    NSDate *qianToday =  [[NSDate alloc] initWithTimeIntervalSinceNow:-2*secondsPerDay];
    //日历
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:newsDate];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:yearsterDay];
    NSDateComponents* comp3 = [calendar components:unitFlags fromDate:qianToday];
    NSDateComponents* comp4 = [calendar components:unitFlags fromDate:today];
    
    if ( comp1.year == comp2.year && comp1.month == comp2.month && comp1.day == comp2.day) {
        isToday = NO;
    }else if (comp1.year == comp3.year && comp1.month == comp3.month && comp1.day == comp3.day)
    {
        isToday = NO;
    }else if (comp1.year == comp4.year && comp1.month == comp4.month && comp1.day == comp4.day)
    {
        isToday = YES;
    }else{
        isToday = NO;
    }
    return isToday;
}

- (BOOL)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    BOOL isFuture;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy-HHmmss"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    
    if (result == NSOrderedDescending) {
        isFuture = NO;
    }else{
        isFuture = YES;
    }
    return isFuture;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
