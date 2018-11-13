//
//  KqViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/1.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "KqViewController.h"

#import "KqModel.h"
#import "KqTableViewCell.h"
#import "Utils.h"
#import "YQLocationTool.h"
#import "DkModel.h"

@interface KqViewController ()<UITableViewDelegate,UITableViewDataSource,dkSuccessAndRefreshDelegate>
{
    NSDictionary *inDataDic;
    NSDictionary *outDataDic;
    KqModel *inModel;
    KqModel *outModel;
    
    DkModel *inDkModel;
    DkModel *outDkModel;
    //打卡类型
    NSString *signType;
    
    //定位地点
    NSString *signAddr;
    //定位经纬度
    NSString *latitude;
    NSString *longtitude;
}

@property (weak, nonatomic) IBOutlet UIView *topBgVIew;
@property (weak, nonatomic) IBOutlet UIView *bottomBgView;

@property (weak, nonatomic) IBOutlet UILabel *yearsWeakLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (nonatomic,strong) UITableView *tabView;
@property (nonatomic,strong) NSMutableArray *dataList;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) NSTimer *timeNow;

@end

@implementation KqViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataArr = [NSMutableArray array];
    
    //默认导航栏样式：黑字
    self.StatusBarStyle = UIStatusBarStyleLightContent;
    
    [self _initView];
    
    [self setData];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return _StatusBarStyle;
}

//动态更新状态栏颜色
-(void)setStatusBarStyle:(UIStatusBarStyle)StatusBarStyle{
    _StatusBarStyle=StatusBarStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

//数据
-(void)setData
{
    [self _loadData];
}

-(void)_loadData
{
    
    self.dataList = [NSMutableArray arrayWithCapacity:0];
    inDataDic = @{@"titleStr":@"上班考勤(08:40)",@"style":@"2"};
    inModel = [[KqModel alloc]initData:inDataDic];
    [self.dataList addObject:inModel];
    
    outDataDic = @{@"titleStr":@"下班考勤(17:30)",@"style":@"2"};
    outModel = [[KqModel alloc]initData:outDataDic];
    [self.dataList addObject:outModel];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/attendance/timeTable",MainUrl];
    
    [[NetworkClient sharedInstance] GET:urlStr dict:nil progressFloat:nil succeed:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            NSDictionary *dic = responseObject[@"responseData"];
            
            inModel.titleStr = [NSString stringWithFormat:@"上班考勤(%@)",dic[@"signinTime"]];
            outModel.titleStr = [NSString stringWithFormat:@"下班考勤(%@)",dic[@"signoutTime"]];
            
            //获取个人当天打卡记录
            [self _loadPersonTodayAttendanceRecord];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)_loadPersonTodayAttendanceRecord
{
    [self.dataArr removeAllObjects];
    NSString *timeStr = [Utils getCurrentTime];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/attendance/attendanceRecord/valid",MainUrl];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:@"123123" forKey:@"certIds"];
    [params setObject:timeStr forKey:@"recordDate"];
    
    [[NetworkClient sharedInstance] GET:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            NSDictionary *dic = responseObject[@"responseData"];
            NSDictionary *inDic = dic[@"IN"];
            NSDictionary *outDic = dic[@"OUT"];
            
            inDkModel = [[DkModel alloc] initWithDataDic:inDic];
            outDkModel = [[DkModel alloc] initWithDataDic:outDic];
            
            if (inDic != nil) {
                inModel.style = @"0";
            }else{
                inModel.style = @"1";
            }
            
            if (outDic != nil) {
                outModel.style = @"0";
            }else{
                outModel.style = @"1";
            }
            
        }
        [self.tabView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

-(void)_initView
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    self.tabView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth,_bottomBgView.height) style:UITableViewStylePlain];
    self.tabView.delegate = self;
    self.tabView.dataSource = self;
    [self.tabView registerClass:[KqTableViewCell class] forCellReuseIdentifier:@"KqTableViewCellId"];
    self.tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_bottomBgView addSubview:self.tabView];
    
    NSDate *currentDate = [NSDate date];//获取当前日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY年MM月dd日"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    _yearsWeakLab.text = [NSString stringWithFormat:@"%@",dateString];
    
    [_timeLab setText:[Utils weekdayStringFromDate:[NSDate date]]];//时间在变化的语句
    
}

#pragma mark-----------------------------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KqTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KqTableViewCellId" forIndexPath:indexPath];
    
    KqModel *model = self.dataList[indexPath.row];
    cell.model = model;
    cell.dkDelegate = self;
    if (indexPath.row == 0) {
        cell.dkModel = inDkModel;
    }else{
        cell.dkModel = outDkModel;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KqModel *model = self.dataList[indexPath.row];
    if (indexPath.row == 0) {
        if ([model.style isEqualToString:@"0"]) {
            return 260;
        }else{
            return 120;
        }
    }else{
        KqModel *model1 = self.dataList[0];
        if ([model1.style isEqualToString:@"0"]) {
            return 260;
        }else{
            return 120;
        }
    }
}

#pragma mark 获取定位位置
-(void)locationSelf
{
    [[YQLocationTool sharedYQLocationTool] getCurrentLocation:^(CLLocation *location, CLPlacemark *pl, NSString *error) {
        [self hideHud];
        if (error) {
            [self showHint:@"定位失败,请重试！"];
        }else{
            signAddr = pl.thoroughfare;
            latitude = [NSString stringWithFormat:@"%lf",location.coordinate.latitude];
            longtitude = [NSString stringWithFormat:@"%lf",location.coordinate.longitude];
        }
    }];
}

#pragma mark 打卡
-(void)dkSuccessAndRefresh:(id)object
{
    UIView *view = (UIView *)object;
    
    NSInteger tag = view.tag-20000;
    if (tag == 0) {
        signType = @"IN";
    }else{
        signType = @"OUT";
    }
    
    [self showHudInView:self.view hint:@""];
    
    [self _saveAttendanceRecord:signAddr signLatitude:latitude signLongitude:longtitude signView:view];
    
}

-(void)_saveAttendanceRecord:(NSString *)signAddr signLatitude:(NSString *)latitude signLongitude:(NSString *)longtitude signView:(UIView *)view
{
//    获取设备uuid
    NSString *udid = [[UIDevice currentDevice] identifierForVendor].UUIDString;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/attendance/storage",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:@"123123" forKey:@"certIds"];
    [params setObject:udid forKey:@"macAddr"];
    [params setObject:signAddr forKey:@"signAddr"];
    [params setObject:latitude forKey:@"signLatitude"];
    [params setObject:longtitude forKey:@"signLongitude"];
    [params setObject:@"" forKey:@"signRemark"];
    [params setObject:signType forKey:@"signType"];
    [params setObject:[kUserDefaults objectForKey:kCustId] forKey:@"custId"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            
            NSDictionary *dic = responseObject[@"responseData"];
            
            if ([signType isEqualToString:@"IN"]) {
                KqModel *model = self.dataList[0];
                model.style = @"1";
                
                
//                DkModel *dkModel = self.dataArr[0];
                inDkModel.signAddr = dic[@"signAddr"];
                NSString *timeStr = [dic[@"signTime"] substringFromIndex:10];
                inDkModel.signTime = timeStr;
                inDkModel.signStatus = dic[@"signStatus"];
                
            }else{
                KqModel *model = self.dataList[1];
                model.style = @"1";
                
//                DkModel *dkModel = self.dataArr[1];
                outDkModel.signAddr = dic[@"signAddr"];
                NSString *timeStr = [dic[@"signTime"] substringFromIndex:10];
                outDkModel.signTime = timeStr;
                outDkModel.signStatus = dic[@"signStatus"];
            }
            
            [self.tabView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)dealloc
{
    [self.timeNow invalidate];
    self.timeNow = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
