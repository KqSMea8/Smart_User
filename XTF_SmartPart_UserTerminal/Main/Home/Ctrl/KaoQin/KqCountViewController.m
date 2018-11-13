//
//  KqCountViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/4.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "KqCountViewController.h"
#import "Utils.h"
#import "WSDatePickerView.h"
#import "KQCalendarViewController.h"
#import "HumanFaceViewController.h"
#import "MyInfomatnTabViewController.h"
#import "PopoverView.h"
#import <PNChart/PNPieChart.h>
#import <CoreGraphics/CoreGraphics.h>

@interface KqCountViewController ()<PNChartDelegate>
{
    
    __weak IBOutlet UILabel *typeLab;
    __weak IBOutlet UILabel *cqNunLab;
    
    __weak IBOutlet UIView *pieBgView;
    __weak IBOutlet UILabel *expLab;
    __weak IBOutlet UILabel *normalNumLab;
    __weak IBOutlet UILabel *leaveEarlyLab;
    __weak IBOutlet UILabel *missingCardNumLab;
    __weak IBOutlet UILabel *laterNumLab;
    __weak IBOutlet UILabel *absenteeismNumLab;
    __weak IBOutlet UILabel *overtimeNumLab;
    __weak IBOutlet UILabel *restNumLab;
    __weak IBOutlet UILabel *askforleaveLab;
    __weak IBOutlet UILabel *wqLab;
    __weak IBOutlet UILabel *mouthLab;
    
    __weak IBOutlet UIImageView *dateView;
    
    UIImageView *_kqCalendarView;
    
    NSString *currentDateStr;
    
    __weak IBOutlet UIButton *normalExplBtn;
    
    __weak IBOutlet UIButton *absenteeismExpBtn;
    __weak IBOutlet UIButton *restExpBtn;
    __weak IBOutlet UIButton *outExpBtn;
    
    NSInteger monthDays;
    NSInteger workDays;
    NSInteger okCount;
    NSInteger restDays;
    NSString *isOutStatus;
    __weak IBOutlet UIButton *kqKcaBtn;
}

@property (nonatomic,retain) PNPieChart *pieChart;
@property (nonatomic,retain) PNPieChart *pieChart1;
@property (nonatomic,retain) PNPieChart *pieChart2;

@end

@implementation KqCountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isOutStatus = @"1";
    
    [self _initView];
    
    currentDateStr = [Utils getCurrentMouth];
    
    [self _loadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [kNotificationCenter postNotificationName:@"tabbarDidSelectItemNotification" object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    YYReachability *rech = [YYReachability reachability];
    if (!rech.reachable) {
        [self showHint:@"网络不给力,请重试!"];
    }
    
    NSString *faceimageid = [kUserDefaults objectForKey:KFACE_IMAGE_ID];
    NSString *companyId = [kUserDefaults objectForKey:companyID];
    NSString *orgId = [kUserDefaults objectForKey:OrgId];
    if ([faceimageid isKindOfClass:[NSNull class]]||faceimageid == nil||faceimageid.length == 0) {
        [self showHint:@"请先录入人像信息!" yOffset:-120];
        [self performSelector:@selector(presentHumanFaceVC) withObject:nil afterDelay:0];
    }else if([companyId isKindOfClass:[NSNull class]]||companyId == nil||companyId.length == 0||[orgId isKindOfClass:[NSNull class]]||orgId == nil||orgId.length == 0){
        [self showHint:@"请先绑定公司和部门!" yOffset:-120];
        [self performSelector:@selector(presentPersonInfoVC) withObject:nil afterDelay:0];
    }
}

//人像录入
-(void)presentHumanFaceVC{
    HumanFaceViewController *humanVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"HumanFaceViewController"];
    humanVC.type = @"1";
    [self.navigationController pushViewController:humanVC animated:YES];
}
//个人信息
-(void)presentPersonInfoVC
{
    MyInfomatnTabViewController *myInfoVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"MyInfomatnTabViewController"];
    myInfoVC.type = @"1";
    [self.navigationController pushViewController:myInfoVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    if(indexPath.row == 0){
        height = 50;
    }else if (indexPath.row == 1) {
        height = 250* hScale;
    }else{
        height = 87.5 *hScale;
    }
    return height;
}

-(void)_initView
{
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 69, 0);
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    dateView.userInteractionEnabled = YES;
    mouthLab.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *selectDateTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectDateTapAction)];
    [dateView addGestureRecognizer:selectDateTap];
    
    UITapGestureRecognizer *datePickTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectDateTapAction)];
    [mouthLab addGestureRecognizer:datePickTap];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    mouthLab.text = [NSString stringWithFormat:@"%@月",dateTime];

}

-(void)_loadData
{
    [self showHudInView:self.view hint:@"加载中~"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/attendance/attendanceReport/month",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:[kUserDefaults objectForKey:KUserCertId] forKey:@"certIds"];
    [params setObject:currentDateStr forKey:@"monthId"];

    [[NetworkClient sharedInstance] GET:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            
            NSDictionary *dic = responseObject[@"responseData"];
            NSDictionary *dataDic = dic[@"item"];
            
            if (![dic[@"okCount"] isKindOfClass:[NSNull class]]&&dic[@"okCount"] !=nil) {
                normalNumLab.text = [NSString stringWithFormat:@"%@天",dic[@"okCount"]];
                okCount = [dic[@"okCount"] integerValue];
            }else{
                normalNumLab.text = [NSString stringWithFormat:@"0天"];
                okCount = 0;
            }
            
            if (![dataDic[@"OUTSIDE_COUNT_SUM"] isKindOfClass:[NSNull class]]&&dataDic[@"OUTSIDE_COUNT_SUM"] !=nil) {
                wqLab.text = [NSString stringWithFormat:@"%@次",dataDic[@"OUTSIDE_COUNT_SUM"]];
            }else{
                wqLab.text = [NSString stringWithFormat:@"0次"];
            }
            
            if (![dataDic[@"VACATION_TIME_SUM"] isKindOfClass:[NSNull class]]&&dataDic[@"VACATION_TIME_SUM"] !=nil) {
                askforleaveLab.text = [NSString stringWithFormat:@"%@天",dataDic[@"VACATION_TIME_SUM"]];
            }else{
                askforleaveLab.text = [NSString stringWithFormat:@"0天"];
            }
            
            if (![dataDic[@"OVER_TIME_SUM"] isKindOfClass:[NSNull class]]&&dataDic[@"OVER_TIME_SUM"] != nil) {
                overtimeNumLab.text = [NSString stringWithFormat:@"%@小时",dataDic[@"OVER_TIME_SUM"]];
            }else{
                overtimeNumLab.text = [NSString stringWithFormat:@"0小时"];
            }
            
            if (![dataDic[@"LATE_COUNT"] isKindOfClass:[NSNull class]]&&dataDic[@"LATE_COUNT"] != nil) {
                laterNumLab.text = [NSString stringWithFormat:@"%@次",dataDic[@"LATE_COUNT"]];
            }else{
                laterNumLab.text = [NSString stringWithFormat:@"0次"];
            }
            
            if (![dataDic[@"LEAVE_COUNT"] isKindOfClass:[NSNull class]]&&dataDic[@"LEAVE_COUNT"] != nil) {
                leaveEarlyLab.text = [NSString stringWithFormat:@"%@次",dataDic[@"LEAVE_COUNT"]];
            }else{
                leaveEarlyLab.text = [NSString stringWithFormat:@"0次"];
            }
            
            if (![dataDic[@"OUT_COUNT"] isKindOfClass:[NSNull class]]&&dataDic[@"OUT_COUNT"] != nil) {
                absenteeismNumLab.text = [NSString stringWithFormat:@"%@天",dataDic[@"OUT_COUNT"]];
            }else{
                absenteeismNumLab.text = [NSString stringWithFormat:@"0天"];
            }
            
            if (![dic[@"lackCount"] isKindOfClass:[NSNull class]]&&dic[@"lackCount"] != nil) {
                missingCardNumLab.text = [NSString stringWithFormat:@"%@次",dic[@"lackCount"]];
            }else{
                missingCardNumLab.text = [NSString stringWithFormat:@"0次"];
            }
            
            if (![dic[@"restDays"] isKindOfClass:[NSNull class]]&&dic[@"restDays"] != nil) {
                restNumLab.text = [NSString stringWithFormat:@"%@天",dic[@"restDays"]];
                restDays = [dic[@"restDays"] integerValue];
            }else{
                restNumLab.text = [NSString stringWithFormat:@"-天"];
                restDays = 0;
            }
            
            if (![dic[@"workDays"] isKindOfClass:[NSNull class]]&&dic[@"workDays"] != nil) {
                cqNunLab.text = [NSString stringWithFormat:@"%@",dic[@"workDays"]];
                workDays = [dic[@"workDays"] integerValue];
            }else{
                cqNunLab.text = [NSString stringWithFormat:@"0"];
                workDays = 0;
            }
            
            if(![dic[@"monthDays"] isKindOfClass:[NSNull class]]&&dic[@"monthDays"] != nil){
                monthDays = [dic[@"monthDays"] integerValue];
            }else{
                monthDays = 30;
            }
            
            typeLab.text = [NSString stringWithFormat:@"%@",@"正常打卡"];
            typeLab.textColor = [UIColor colorWithHexString:@"#32B9FF"];
            normalNumLab.textColor = [UIColor colorWithHexString:@"#32B9FF"];
//            [self.pieChart touchAtPoint:CGPointMake(191.5, 28)];
            if (![dic[@"isOutStatus"] isKindOfClass:[NSNull class]]&&dic[@"isOutStatus"] !=nil&&[[dic[@"isOutStatus"] stringValue] isEqualToString:@"0"]) {
                expLab.text = [NSString stringWithFormat:@"考勤数据截止%@",dic[@"endDate"]];
                expLab.hidden = NO;
                isOutStatus = @"0";
            }else{
                monthDays = 0;
                workDays = 0;
                okCount = 0;
                expLab.hidden = YES;
                isOutStatus = @"1";
            }
            if (self.pieChart) {
                [self.pieChart removeFromSuperview];
            }
            if (self.pieChart1) {
                [self.pieChart1 removeFromSuperview];
            }
            if (self.pieChart2) {
                [self.pieChart2 removeFromSuperview];
            }
            [self createPie];
        }
    } failure:^(NSError *error) {
        [self hideHud];
    }];
}

-(void)createPie
{
    NSArray *items1;
    if ([isOutStatus isEqualToString:@"1"]) {
        items1 = @[[PNPieChartDataItem dataItemWithValue:1 color:[UIColor colorWithHexString:@"#32B9FF"]]];
        self.pieChart1 = [[PNPieChart alloc] initWithFrame:CGRectMake(0, 0, pieBgView.width, pieBgView.height) items:items1 inCor:100 outCor:100.5];
        self.pieChart1.hideValues = YES;
        self.pieChart1.showAbsoluteValues = NO;
        self.pieChart1.descriptionTextColor = [UIColor clearColor];
        [self.pieChart1 strokeChart];
        self.pieChart1.shouldHighlightSectorOnTouch = NO;
        [pieBgView addSubview:self.pieChart1];
    }else{
        items1 = @[[PNPieChartDataItem dataItemWithValue:workDays-okCount color:[UIColor colorWithHexString:@"#D5726D"]],[PNPieChartDataItem dataItemWithValue:monthDays-workDays+okCount color:[UIColor colorWithHexString:@"#32B9FF"]]];
        
        self.pieChart1 = [[PNPieChart alloc] initWithFrame:CGRectMake(0, 0, pieBgView.width, pieBgView.height) items:items1 inCor:100 outCor:100.5];
        self.pieChart1.hideValues = YES;
        self.pieChart1.showAbsoluteValues = NO;
        self.pieChart1.descriptionTextColor = [UIColor clearColor];
        [self.pieChart1 strokeChart];
        self.pieChart1.shouldHighlightSectorOnTouch = NO;
        [pieBgView addSubview:self.pieChart1];
        
        NSArray *items2 = @[[PNPieChartDataItem dataItemWithValue:workDays color:[UIColor colorWithHexString:@"#cae5f4"]],[PNPieChartDataItem dataItemWithValue:monthDays-workDays color:[UIColor whiteColor]]];
        
        self.pieChart2 = [[PNPieChart alloc] initWithFrame:CGRectMake(0, 0, pieBgView.width, pieBgView.height) items:items2 inCor:72 outCor:75];
        self.pieChart2.hideValues = YES;
        self.pieChart2.showAbsoluteValues = NO;
        self.pieChart2.descriptionTextColor = [UIColor clearColor];
        [self.pieChart2 strokeChart];
        self.pieChart2.shouldHighlightSectorOnTouch = NO;
        [pieBgView addSubview:self.pieChart2];
        
        NSArray *items = @[[PNPieChartDataItem dataItemWithValue:workDays-okCount color:[UIColor colorWithHexString:@"#D5726D"] description:@"异常打卡"],[PNPieChartDataItem dataItemWithValue:okCount color:[UIColor colorWithHexString:@"#32B9FF"] description:@"正常打卡"],[PNPieChartDataItem dataItemWithValue:monthDays-workDays color:[UIColor whiteColor]]
                           ];
        
        self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(0, 0, pieBgView.width, pieBgView.height) items:items inCor:85 outCor:100];
        self.pieChart.delegate = self;
        self.pieChart.hideValues = YES;
        self.pieChart.showAbsoluteValues = NO;
        self.pieChart.descriptionTextColor = [UIColor clearColor];
        [self.pieChart strokeChart];
        self.pieChart.shouldHighlightSectorOnTouch = NO;
        [pieBgView addSubview:self.pieChart];
    }
    
    [pieBgView bringSubviewToFront:kqKcaBtn];
}

-(void)selectDateTapAction
{
    NSDateFormatter *minDateFormater = [[NSDateFormatter alloc] init];
    [minDateFormater setDateFormat:@"yyyy-MM"];
    NSDate *scrollToDate = [minDateFormater dateFromString:[Utils getCurrentMouth]];

    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonth scrollToDate:scrollToDate CompleteBlock:^(NSDate *selectDate) {
        NSString *date = [selectDate stringWithFormat:@"yyyy年MM"];
        NSString *date1 = [selectDate stringWithFormat:@"yyyy-MM"];
        mouthLab.text = [NSString stringWithFormat:@"%@月",date];
    
        currentDateStr = date1;
        [self _loadData];

    }];
    datepicker.dateLabelColor = [UIColor colorWithHexString:@"#1B82D1"];//年-月-日-时-分 颜色
    datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
    datepicker.doneButtonColor = [UIColor colorWithHexString:@"#1B82D1"];//确定按钮的颜色
    datepicker.yearLabelColor = [UIColor clearColor];//大号年份字体颜色
    [datepicker show];
    
}
- (IBAction)calendarTapAction:(id)sender {
    KQCalendarViewController *kqcaVC = [[KQCalendarViewController alloc] init];
    [self.navigationController pushViewController:kqcaVC animated:YES];
}

//缺卡天数
- (IBAction)outExpBtnAction:(id)sender {
    PopoverAction *action1 = [PopoverAction actionWithTitle:@"工作日当天上、下班都未打卡" handler:^(PopoverAction *action) {
    }];
    
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.style = PopoverViewStyleDark;
    [popoverView showToView:sender withActions:@[action1]];
}

//休息
- (IBAction)restExpBtnAction:(id)sender {
    PopoverAction *action1 = [PopoverAction actionWithTitle:@"周末或者法定节假日" handler:^(PopoverAction *action) {
    }];
    
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.style = PopoverViewStyleDark;
    [popoverView showToView:sender withActions:@[action1]];
}

//正常
- (IBAction)normalExpBtnAction:(id)sender {
    PopoverAction *action1 = [PopoverAction actionWithTitle:@"工作日，上、下班都在规定时间打卡" handler:^(PopoverAction *action) {
    }];
    
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.style = PopoverViewStyleDark;
    [popoverView showToView:sender withActions:@[action1]];
}

//外勤
- (IBAction)absteenExpAction:(id)sender {
    PopoverAction *action1 = [PopoverAction actionWithTitle:@"非工作范围打卡，暂未开启" handler:^(PopoverAction *action) {
    }];
    
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.style = PopoverViewStyleDark;
    [popoverView showToView:sender withActions:@[action1]];
}

-(void)userClickedOnPieIndexItem:(NSInteger)pieIndex
{
    switch (pieIndex) {
        case 0:
            typeLab.text = [NSString stringWithFormat:@"%@",@"异常打卡"];
            normalNumLab.text = [NSString stringWithFormat:@"%ld天",workDays-okCount];
            typeLab.textColor = [UIColor colorWithHexString:@"#D5726D"];
            normalNumLab.textColor = [UIColor colorWithHexString:@"#D5726D"];

            break;
        case 1:
            
            typeLab.text = [NSString stringWithFormat:@"%@",@"正常打卡"];
            typeLab.textColor = [UIColor colorWithHexString:@"#32B9FF"];
            normalNumLab.textColor = [UIColor colorWithHexString:@"#32B9FF"];
            normalNumLab.text = [NSString stringWithFormat:@"%ld天",okCount];
            
            break;
        default:
            break;
    }
}

-(void)didUnselectPieItem
{
    NSLog(@"123");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
