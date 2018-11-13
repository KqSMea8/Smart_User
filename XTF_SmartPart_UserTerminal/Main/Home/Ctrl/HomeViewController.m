//
//  HomeViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/11/30.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "HomeViewController.h"
#import "ParkHomeViewController.h"
#import "NoDataView.h"
#import "HomeHeaderView.h"
#import "HomeCollectionViewCell.h"
#import "HomeMoreCollectionViewCell.h"
#import "ParkHomeViewController.h"
#import "CancelReservViewController.h"
#import "RepairViewController.h"
#import "LoginViewController.h"
#import "FoodViewController.h"
#import "KqTabbarViewController.h"
#import "ParkRecordsViewController.h"
#import "FindCarViewController.h"
#import "QuickRechargeViewController.h"
#import "FirstMenuModel.h"
#import "BindTableViewController.h"
#import "WIFIListViewController.h"
#import "MealViewController.h"
#import "TrainViewController.h"
#import "NurseryViewController.h"
#import "SCLAlertView.h"
#import "PublicModel.h"
#import "UserModel.h"
#import "Utils.h"
#import "YQEmptyView.h"
#import "ParamDES.h"
#import "DES3Util.h"
#import "YQCollectionView.h"
#import "YQRemindUpdatedView.h"
#import "ChangePwdTableViewController.h"
#import "PersonMsgModel.h"
#import "ParkReservationViewController.h"
#import "CarListModel.h"
#import "BookDetailsViewController.h"
#import "BookRecordModel.h"
#import "BookRecordParkAreaModel.h"
#import "BookRecordParkSpaceModel.h"
#import "BookRecordDetailController.h"
#import "BindCarTableViewController.h"
#import "VisitTabbarViewController.h"

#import "HealthViewController.h"
#import "SmartLearnViewController.h"

#import "MonitorLogin.h"
#import "MonitorLoginInfoModel.h"

@interface HomeViewController ()<YQDragCellCollectionViewDelegate,YQDragCollectionViewDataSource,reloadDelegate,YQRemindUpdatedViewDelegate>
{
    NSMutableArray *_sectionTitleArr;
    NSInteger begainIndex;
    NSInteger endIndex;
    PublicModel *_model;
    // 更新提醒view是否显示
    YQRemindUpdatedView *_updatedView;
    BOOL _isShowingAlert;
    NSInteger _alertNum;
    NSInteger _appCodeDifVersion;
    NSMutableArray *bindCarDataArr;
    
    BOOL _isLogin;
}

@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSMutableArray *menuArr;
@property (nonatomic,strong) YQEmptyView *noNetworkView;
@property (nonatomic,strong) YQEmptyView *noDataView;
@property (nonatomic,strong) YQCollectionView *canDragCollectionView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _alertNum = 0;
    bindCarDataArr = @[].mutableCopy;
    
    [kNotificationCenter addObserver:self selector:@selector(bindSuccess) name:UserbindSuccess object:nil];
    [kNotificationCenter addObserver:self selector:@selector(ignorePwdExpired) name:@"ignorepwdexpired" object:nil];
    
    _sectionTitleArr = @[].mutableCopy;
    _menuArr = @[].mutableCopy;
    _dataArr = @[].mutableCopy;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#252E44"];
    
    [self _initCollectionView];
    [self monitorNetwork];
    [self.canDragCollectionView.mj_header beginRefreshing];
    [self showVersionAlert];
    
    // 从后台进入前台的提醒
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showVersionAlert) name:@"EnterForegroundAlert" object:nil];
    
    [kNotificationCenter addObserver:self selector:@selector(hunmanFaceComplete) name:@"humanFaceNotification" object:nil];
}

#pragma mark 监听网络变化
- (void)monitorNetwork {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                //                NSLog(@"未识别的网络");
                self.canDragCollectionView.ly_emptyView = self.noNetworkView;
                [self.canDragCollectionView reloadData];
                [self.canDragCollectionView ly_endLoading];
                // 发送无网络通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotNetworkNotification" object:nil];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                //                NSLog(@"不可达的网络(未连接)");
                self.canDragCollectionView.ly_emptyView = self.noNetworkView;
                [self.canDragCollectionView reloadData];
                [self.canDragCollectionView ly_endLoading];
                // 发送无网络通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotNetworkNotification" object:nil];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                //                NSLog(@"2G,3G,4G...的网络");
                if(self.dataArr == nil || self.dataArr.count <= 0){
                    if ([kUserDefaults objectForKey:KLoginStatus]) {
                        [self _loadData];
                    }
                }
                // 发送恢复网络通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ResumeNetworkNotification" object:nil];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                //                NSLog(@"wifi的网络");
                if(self.dataArr == nil || self.dataArr.count <= 0){
                    if ([kUserDefaults objectForKey:KLoginStatus]) {
                        [self _loadData];
                    }
                }
                // 发送恢复网络通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ResumeNetworkNotification" object:nil];
                break;
            default:
                break;
        }
    }];
    [manager startMonitoring];
}

#pragma mark 判断密码是否过期
- (void)verLoginOverdue {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/common/isCustPwdOverdue",MainUrl];
    NSString *custId = [[NSUserDefaults standardUserDefaults] objectForKey:kCustId];
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setObject:custId forKey:@"custId"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
        NSString *code = responseObject[@"code"];
        if(![code isKindOfClass:[NSNull class]]&&code != nil && [code isEqualToString:@"1"]){
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"密码修改" message:@"登录密码长时间未修改,为保证账户安全,建议进行密码修改." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"暂不修改" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self ignorePwdExpired];
            }];
            [cancel setValue:[UIColor lightGrayColor] forKey:@"_titleTextColor"];
            UIAlertAction *defult = [UIAlertAction actionWithTitle:@"立即修改" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // 已过期 跳转修改密码页面你
                ChangePwdTableViewController *changePwdVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"ChangePwdTableViewController"];
                changePwdVC.isOverdue = YES;
                changePwdVC.hidesBottomBarWhenPushed = YES;
                [self presentViewController:[[RootNavigationController alloc] initWithRootViewController:changePwdVC] animated:YES completion:nil];
            }];
            [alert addAction:cancel];
            [alert addAction:defult];
            
            [self presentViewController:alert animated:YES completion:nil];

        }
    } failure:^(NSError *error) {
    }];
}

//忽略此次密码修改提醒
-(void)ignorePwdExpired{
    NSString *custId = [kUserDefaults objectForKey:kCustId];
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/upCustPwdTime?custId=%@",MainUrl,custId];
    [[NetworkClient sharedInstance] GET:urlStr dict:nil progressFloat:nil succeed:^(id responseObject) {
        NSString *code = responseObject[@"code"];
        if ([code isEqualToString:@"1"]) {
            
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(!_isLogin){
        [self _loadMonitorLoginInfo];
    }
    
    //加载公共参数接口
    [self _loadPublicConfig];
    
    NSString *loginWay = [kUserDefaults objectForKey:KLoginWay];
    
    if ([loginWay isEqualToString:KLogin]) {
        [self verLogin];
    }
}

#pragma mark 加载大华sdk平台 登录信息
- (void)_loadMonitorLoginInfo {
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/getPublicConfig",MainUrl];
    
    NSMutableDictionary *pubParam = @{}.mutableCopy;
    [pubParam setObject:@"DSS" forKey:@"configCode"];
    NSString *jsonStr = [Utils convertToJsonData:pubParam];
    NSDictionary *param = @{@"param":jsonStr};
    
    [[NetworkClient sharedInstance] POST:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
        NSDictionary *data = responseObject;
        if ([data[@"code"] isEqualToString:@"1"]) {
            NSDictionary *responseData = responseObject[@"responseData"];
            if(responseData != nil && ![responseData isKindOfClass:[NSNull class]]){
                [[NSUserDefaults standardUserDefaults] setObject:responseData forKey:KMonitorInfo];
            }
            if(!_isLogin){
                [self loginDP];
            }
        }
    } failure:^(NSError *error) {
    }];
}

//登录大华平台
-(void)loginDP
{
    NSDictionary *monitorInfo = [[NSUserDefaults standardUserDefaults] objectForKey:KMonitorInfo];
    if(monitorInfo != nil){
        MonitorLoginInfoModel *model = [[MonitorLoginInfoModel alloc] initWithDataDic:monitorInfo];
        if(model.dssAddr != nil && ![model.dssAddr isKindOfClass:[NSNull class]] &&
           model.dssPort != nil && ![model.dssPort isKindOfClass:[NSNull class]] &&
           model.dssAdmin != nil && ![model.dssAdmin isKindOfClass:[NSNull class]] &&
           model.dssPasswd != nil && ![model.dssPasswd isKindOfClass:[NSNull class]]
           ){
            // 登录视频监控账号
            BOOL isSuc = [MonitorLogin loginWithAddress:model.dssAddr withPort:model.dssPort withName:model.dssAdmin withPsw:model.dssPasswd];
            if(isSuc){
                // 登录成功
                _isLogin = YES;
            }else {
            }
        }
    }
}

-(void)verLogin
{
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:KUserPhoneNum];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:KLoginPasword];
    if(username != nil && username.length > 0 && password != nil && password.length > 0){
        // 已重新登录验证，本地保存用户名密码。调用接口判断是否正确
        [self liginVer:username withPassword:password];
    }else {
        
        //        // 未重新登录验证，退出登录
        //        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:KLoginStatus];
        //
        //        [self clearLoginMessage];
        //
        //        UINavigationController *navVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginNavViewController"];
        //        [UIApplication sharedApplication].delegate.window.rootViewController = navVC;
    }
}

-(void)clearLoginMessage
{
    [kUserDefaults removeObjectForKey:KLoginStatus];
    [kUserDefaults removeObjectForKey:KUserCertId];
    [kUserDefaults removeObjectForKey:KAuthLogin];
    [kUserDefaults removeObjectForKey:KAuthType];
    [kUserDefaults removeObjectForKey:KAuthId];
    [kUserDefaults removeObjectForKey:KLoginWay];
    [kUserDefaults removeObjectForKey:kCustId];
    [kUserDefaults removeObjectForKey:KMemberId];
    [kUserDefaults removeObjectForKey:KUserCustName];
    [kUserDefaults removeObjectForKey:KAuthName];
    [kUserDefaults removeObjectForKey:KLoginPasword];
    [kUserDefaults removeObjectForKey:KUserPhoneNum];
    [kUserDefaults removeObjectForKey:KFACE_IMAGE_ID];
    [kUserDefaults removeObjectForKey:isBindCar];
    [kUserDefaults removeObjectForKey:companyID];
    [kUserDefaults removeObjectForKey:OrgId];
    [kUserDefaults removeObjectForKey:kUserBirthDay];
    [kUserDefaults removeObjectForKey:KUserSex];
}

- (void)liginVer:(NSString *)userName withPassword:(NSString *)password {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/appLogin",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:userName forKey:@"custMobile"];
    if ([[kUserDefaults objectForKey:KAuthType] isEqualToString:@"2"]||[[kUserDefaults objectForKey:KAuthType] isEqualToString:@"3"]||[[kUserDefaults objectForKey:KAuthType] isEqualToString:@"4"]) {
        [params setObject:password forKey:@"custPwd"];
    }else{
        [params setObject:[password md5String] forKey:@"custPwd"];
    }
    
    NSString *deviceModel = [kUserDefaults objectForKey:KDeviceModel];
    
    if(![deviceModel isKindOfClass:[NSNull class]]&&deviceModel != nil){
        [params setObject:deviceModel forKey:@"mobileModel"];
    }
    
    NSString *registerId = [kUserDefaults objectForKey:KPushRegisterId];
    
    if(![registerId isKindOfClass:[NSNull class]]&&registerId != nil){
        [params setObject:registerId forKey:@"equId"];
    }
    
    [params setObject:@"1" forKey:@"equIdType"];
    
    NSString *jsonStr = [Utils convertToJsonData:params];
    
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setObject:jsonStr forKey:@"param"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            
        }else{
            // 验证失败，和服务器密码对应不上
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:KLoginStatus];
            
            [self clearLoginMessage];
            
            UINavigationController *navVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginNavViewController"];
            [UIApplication sharedApplication].delegate.window.rootViewController = navVC;
        }
    } failure:^(NSError *error) {
        [self hideHud];
    }];
}

#pragma mark 加载更新信息
- (void)showVersionAlert {
    if(_isShowingAlert){
        return;
    }
    NSString *appVersionPath = [[NSBundle mainBundle] pathForResource:@"appVersion" ofType:@"plist"];
    NSDictionary *appVersionDic = [NSDictionary dictionaryWithContentsOfFile:appVersionPath];
    NSString *appVersion = appVersionDic[@"appVersion"];
    NSString *userName = [kUserDefaults objectForKey:KUserCustName];
    NSString *versionUrl;
    if ([userName isKindOfClass:[NSNull class]]||userName == nil) {
        versionUrl = [NSString stringWithFormat:@"%@/public/getVersion?appType=user&osType=ios&version=%@", MainUrl,appVersion];
    }else{
        versionUrl = [NSString stringWithFormat:@"%@/public/getVersion?appType=user&osType=ios&versionCust=%@&version=%@", MainUrl,userName,appVersion];
    }
    
    [[NetworkClient sharedInstance] GET:versionUrl dict:nil progressFloat:nil succeed:^(id responseObject) {
        if([responseObject[@"code"] isEqualToString:@"1"]){
            NSDictionary *responseData = responseObject[@"responseData"];
            if(responseData == nil || [responseData isKindOfClass:[NSNull class]]){
                return ;
            }
            PublicModel *model = [[PublicModel alloc] initWithDataDic:responseData];
            _model = model;
            if(![model.appCode isKindOfClass:[NSNull class]]&&model.appCode != nil && model.appCode.integerValue > appVersion.integerValue){
                [self showVisionAlert:model withDifferVersion:model.appCode.integerValue - appVersion.integerValue];
            }else {
                // 版本相同，同步当前时间为版本更新时间(作用：更新完成重置提醒时间)，并将版本相差数设置为0
                [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:KAlertTime];
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:0] forKey:KDifferVersion];
                
                [kNotificationCenter postNotificationName:@"isNeedRemaindNotification" object:@{@"isNeedRemaind":@"0"}];
                [kUserDefaults setBool:NO forKey:KNeedRemain];
                
                if ([[kUserDefaults objectForKey:KLoginWay] isEqualToString:KLogin]||([[kUserDefaults objectForKey:KLoginWay] isEqualToString:KAuthLoginMobile]&&[kUserDefaults objectForKey:KLoginPasword] != nil)) {
                    UIViewController *VC = [Utils getCurrentVC];
                    if ([VC isKindOfClass:[HomeViewController class]]) {
                        [self verLoginOverdue];
                    }
                }
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)showVisionAlert:(PublicModel *)model withDifferVersion:(NSInteger)appCodeDifferVersion{
    _isShowingAlert = YES;
    _appCodeDifVersion = appCodeDifferVersion;
    
    NSDate *alertTime = [[NSUserDefaults standardUserDefaults] objectForKey:KAlertTime];
    NSNumber *differVersion = [[NSUserDefaults standardUserDefaults] objectForKey:KDifferVersion];
    NSNumber *alertNum = [[NSUserDefaults standardUserDefaults] objectForKey:KAlertNum];
    
    if ([model.isMust isEqualToString:@"1"]) {
        _updatedView = [[YQRemindUpdatedView alloc] initWithTitle:[NSString stringWithFormat:@"V%@新版本上线", model.versionNum] message:model.versionInfo delegate:self leftButtonTitle:@"暂不更新" rightButtonTitle:@"立即更新"];
        _updatedView.delegate = self;
        _updatedView.isMust = @"1";
        [_updatedView show];
    }else {
        // 非必须更新，判断提醒次数和 上次更新提醒时间和相差版本
        if(differVersion == nil || appCodeDifferVersion > differVersion.integerValue){
            [self showNoMustAlert:model];
            _alertNum = 1;
            [kNotificationCenter postNotificationName:@"isNeedRemaindNotification" object:@{@"isNeedRemaind":@"1"}];
            [kUserDefaults setBool:YES forKey:KNeedRemain];
        }else if(alertNum == nil || alertNum.integerValue == 0){
            // 第一次提醒
            [self showNoMustAlert:model];
            _alertNum = 1;
            
        }else if (alertNum.integerValue == 1 && (alertTime == nil || [self getDifferenceByDate:alertTime] >= 7)) {
            [self showNoMustAlert:model];
            _alertNum = 2;
            
        }else {
            // 不提醒
            _isShowingAlert = NO;
            if ([[kUserDefaults objectForKey:KLoginWay] isEqualToString:KLogin]||([[kUserDefaults objectForKey:KLoginWay] isEqualToString:KAuthLoginMobile]&&[kUserDefaults objectForKey:KLoginPasword] != nil)) {
                UIViewController *VC = [Utils getCurrentVC];
                if ([VC isKindOfClass:[HomeViewController class]]) {
                    [self verLoginOverdue];
                }
            }
        }
    }
}
- (void)showNoMustAlert:(PublicModel *)model {
    _updatedView = [[YQRemindUpdatedView alloc] initWithTitle:[NSString stringWithFormat:@"V%@新版本上线", model.versionNum] message:model.versionInfo delegate:self leftButtonTitle:@"暂不更新" rightButtonTitle:@"立即更新"];
    _updatedView.delegate = self;
    _updatedView.isMust = @"0";
    [_updatedView show];
}

#pragma mark YQRemindUpdatedView Delegate
-(void)remaindViewBtnClick:(buttonType)btn
{
    if(btn == cancleButton){
        _isShowingAlert = NO;
        // 保存提示信息
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:KAlertTime];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:_alertNum] forKey:KAlertNum];
        
        // 更新本地版本相差数
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:_appCodeDifVersion] forKey:KDifferVersion];
    }
    if (btn == sureButton) {
        // 判断是否是wifi网络
        if([YYReachability reachability].status == YYReachabilityStatusWWAN){
            // 手机流量
            UIAlertController *cerAlertCon = [UIAlertController alertControllerWithTitle:@"提示" message:@"您正在使用移动流量，是否确认下载" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [_updatedView show];
            }];
            UIAlertAction *downAction = [UIAlertAction actionWithTitle:@"确认下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self openDownUrl];
            }];
            [cerAlertCon addAction:cancelAction];
            [cerAlertCon addAction:downAction];
            [self presentViewController:cerAlertCon animated:YES completion:nil];
            [_updatedView dismiss];
        }else {
            [self openDownUrl];
        }
        
    }
}
// 跳转浏览器下载
- (void)openDownUrl {
    [_updatedView show];
    
    if (_model.appUrl != nil && ![_model.appUrl isKindOfClass:[NSNull class]]) {
        NSString *appUrl = _model.appUrl;   // 改为plist
        
        NSString * urlStr = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@", appUrl];    // @"https://dn-transfar.qbox.me/zhihui_admin.plist"
        [self openScheme:urlStr];
        
    }else{
        [self showHint:@"更新失败!"];
    }
}

- (void)openScheme:(NSString *)scheme {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:scheme];
    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [application openURL:URL options:@{} completionHandler:^(BOOL success) {
            NSLog(@"Open %@: %d",scheme,success);
            //退出应用程序
            exit(0);
        }];
        
    } else {
        BOOL success = [application openURL:URL];
        NSLog(@"Open %@: %d",scheme,success);
    }
}

-(void)_initCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 100);
    layout.itemSize = CGSizeMake(110, 60);
    //    [self.canDragCollectionView setCollectionViewLayout:layout];
    self.canDragCollectionView = [[YQCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    
    if (kDevice_Is_iPhoneX) {
        self.canDragCollectionView.frame = CGRectMake(0, 44, KScreenWidth, KScreenHeight - 83-44);
    }else
    {
        self.canDragCollectionView.frame = CGRectMake(0, 20, KScreenWidth, KScreenHeight -49-20);
    }
    
    self.canDragCollectionView.canDrag = NO;
    self.canDragCollectionView.dragCellAlpha = 0.9;
    self.canDragCollectionView.alwaysBounceVertical = YES;
    
    //4.设置代理
    self.canDragCollectionView.delegate = self;
    self.canDragCollectionView.dataSource = self;
    self.canDragCollectionView.backgroundColor = [UIColor whiteColor];
    //    self.collectionView.bounces = NO;
    //    self.collectionView.mj_header.hidden = YES;
    self.canDragCollectionView.mj_footer.hidden = YES;
    self.canDragCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self headerRereshing];
    }];
    self.canDragCollectionView.showsVerticalScrollIndicator = NO;
    self.canDragCollectionView.showsHorizontalScrollIndicator = NO;
    
    [self.canDragCollectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:@"HomeCollectionViewCell"];
    
    [self.canDragCollectionView registerNib:[UINib nibWithNibName:@"HomeHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"homeHeaderReusableID"];
    
    [self.view addSubview:self.canDragCollectionView];
}

- (YQEmptyView *)noDataView{
    if (!_noDataView) {
        _noDataView = [YQEmptyView diyEmptyView];
    }
    return _noDataView;
}

- (YQEmptyView *)noNetworkView{
    if (!_noNetworkView) {
        _noNetworkView = [YQEmptyView diyEmptyActionViewWithTarget:self action:@selector(headerRereshing)];
    }
    return _noNetworkView;
}

-(void)headerRereshing
{
    //加载公共参数接口
    //加载停车公共参数
    [self _loadPublicConfig];
    //加载考勤公共参数
    NSString *loginWay = [kUserDefaults objectForKey:KLoginWay];
    
    if ([loginWay isEqualToString:KLogin]) {
        [self _loadKqPublicConfig];
    }
    
    [self _loadData];
    
    [kNotificationCenter postNotificationName:@"refreshWeatherData" object:nil];
}

-(void)_loadData
{
    NSString *custId = [kUserDefaults objectForKey:kCustId];
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/getParentMenuList",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    if ([custId isKindOfClass:[NSNull class]]||custId == nil) {
        return;
    }
    [params setObject:custId forKey:@"loginName"];
    [params setObject:@"3" forKey:@"menuType"];
    
    [[NetworkClient sharedInstance] GET:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        
        [_sectionTitleArr removeAllObjects];
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            NSMutableArray *parentIdArr = [NSMutableArray array];
            NSArray *arr = responseObject[@"responseData"];
            if ([arr isKindOfClass:[NSNull class]]||arr.count == 0) {
                [self.canDragCollectionView.mj_header endRefreshing];
                self.canDragCollectionView.ly_emptyView = self.noDataView;
                [self.canDragCollectionView reloadData];
                [self.canDragCollectionView ly_endLoading];
                return;
            }
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                FirstMenuModel *model = [[FirstMenuModel alloc] initWithDataDic:obj];
                if (idx != 0) {
                    [_sectionTitleArr addObject:model.MENU_NAME];
                }
                [parentIdArr addObject:model.MENU_ID];
            }];
            
            [self _loadChildMenuData:[parentIdArr componentsJoinedByString:@","]];
        }
    } failure:^(NSError *error) {
        [self.canDragCollectionView.mj_header endRefreshing];
        YYReachability *rech = [YYReachability reachability];
        if (!rech.reachable) {
            self.canDragCollectionView.ly_emptyView = self.noNetworkView;
            [self.canDragCollectionView reloadData];
            [self.canDragCollectionView ly_endLoading];
        }else{
            self.canDragCollectionView.ly_emptyView = self.noDataView;
            [self.canDragCollectionView reloadData];
            [self.canDragCollectionView ly_endLoading];
        }
    }];
}

- (void)_loadParkMemberId {
    // 访客、员工 根据手机号查询停车接口需要使用的用户信息
    if([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KAuthLoginMobile] ||
       [[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KLogin]
       ){
        if([[NSUserDefaults standardUserDefaults] objectForKey:KMemberId] == nil){
            [self _loadParkUserInfo];
        }
    }
}
- (void)_loadParkUserInfo {
    NSString *urlStr = [NSString stringWithFormat:@"%@park-service/hntfEsb/parking/member/info",[kUserDefaults objectForKey:KParkUrl]];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    NSString *userPhone = [[NSUserDefaults standardUserDefaults] objectForKey:KUserPhoneNum];
    if(userPhone != nil){
        [params setObject:userPhone forKey:@"phone"];
    }
    NSString *timeStr = [NSString stringWithFormat:@"%f", [NSDate date].timeIntervalSince1970 * 1000000];
    NSString *time = [timeStr componentsSeparatedByString:@"."].firstObject;
    NSString *userName = [time substringFromIndex:time.length - 11];
    [params setObject:userName forKey:@"ts"];
    NSString *udid = [[UIDevice currentDevice] identifierForVendor].UUIDString;
    [params setObject:udid forKey:@"guid"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        if([responseObject[@"success"] boolValue]){
            NSDictionary *data = responseObject[@"data"];
            if(![data isKindOfClass:[NSNull class]]&&data != nil){
                NSDictionary *member = data[@"member"];
                if(![member isKindOfClass:[NSNull class]]&&member != nil){
                    NSString *memberId = member[@"memberId"];
                    if(![memberId isKindOfClass:[NSNull class]]&&memberId != nil){
                        [[NSUserDefaults standardUserDefaults] setObject:memberId forKey:KMemberId];
                        [kUserDefaults synchronize];
                    }
                }
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 加载停车公共参数
-(void)_loadPublicConfig
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/getPublicConfig",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:@"PARKING" forKey:@"configCode"];
    
    NSString *jsonStr = [Utils convertToJsonData:params];
    
    NSMutableDictionary *jsonParams = @{}.mutableCopy;
    [jsonParams setObject:jsonStr forKey:@"param"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:jsonParams progressFloat:nil succeed:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            NSDictionary *paramConfig = responseObject[@"responseData"];
            NSString *parkUrl = paramConfig[@"parking"];
            if (parkUrl !=nil&&parkUrl.length>0) {
                [kUserDefaults setObject:parkUrl forKey:KParkUrl];
                [kUserDefaults synchronize];
                [self _loadParkMemberId];
                //                [self _loadParkUserInfo];
                //                NSString *loginWay = [kUserDefaults objectForKey:KLoginWay];
                
                //    加载绑定车辆信息
                //                if (![loginWay isEqualToString:KAuthLogin]) {
                //                    [self loadBindCarData];
                //                }
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 加载考勤公共参数
-(void)_loadKqPublicConfig
{
    NSString *custId = [[NSUserDefaults standardUserDefaults] objectForKey:kCustId];
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/getCustInfo", MainUrl];
    NSMutableDictionary *param = @{}.mutableCopy;
    if(![custId isKindOfClass:[NSNull class]]&&custId != nil){
        [param setObject:custId forKey:@"custId"];
    }
    [[NetworkClient sharedInstance] POST:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
        if([responseObject[@"code"] isEqualToString:@"1"]){
            PersonMsgModel *model = [[PersonMsgModel alloc] initWithDataDic:responseObject[@"responseData"]];
            if ([model.COMPANY_ID isKindOfClass:[NSNull class]]||[model.COMPANY_ID stringValue] == nil) {
                [self loadKqConfig:nil];
            }else{
                [kUserDefaults setObject:[model.COMPANY_ID stringValue] forKey:companyID];
                [kUserDefaults synchronize];
                [self loadKqConfig:[model.COMPANY_ID stringValue]];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)loadKqConfig:(NSString *)companyId
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/attendance/getAttendanceParam",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    if ([companyId isKindOfClass:[NSNull class]]||companyId == nil) {
        [params setObject:@"" forKey:@"companyId"];
    }else{
        [params setObject:companyId forKey:@"companyId"];
    }
    
    NSString *jsonStr = [Utils convertToJsonData:params];
    NSMutableDictionary *jsonParams = @{}.mutableCopy;
    [jsonParams setObject:jsonStr forKey:@"param"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:jsonParams progressFloat:nil succeed:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            NSDictionary *paramConfig = responseObject[@"responseData"];
            NSString *attendancePosition = paramConfig[@"attendancePosition"];
            NSString *attendanceTime = paramConfig[@"attendanceTime"];
            NSString *attendanceRange = paramConfig[@"attendanceRange"];
            NSString *attendanceDeviation = paramConfig[@"attendanceDeviation"];
            [kUserDefaults setObject:attendancePosition forKey:kqPosition];
            [kUserDefaults setObject:attendanceTime forKey:kqTime];
            [kUserDefaults setObject:attendanceRange forKey:kqRange];
            [kUserDefaults setObject:attendanceDeviation forKey:kqDeviation];
            [kUserDefaults synchronize];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 加载首页菜单
-(void)_loadChildMenuData:(NSString *)parentIDs
{
    NSString *custId = [kUserDefaults objectForKey:kCustId];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/getChildMenuList",MainUrl];
    NSMutableDictionary *params = @{}.mutableCopy;
    if (![custId isKindOfClass:[NSNull class]]&&custId != nil&&custId.length != 0) {
        [params setObject:custId forKey:@"loginName"];
    }else{
        return;
    }
    [params setObject:@"3" forKey:@"menuType"];
    [params setObject:parentIDs forKey:@"parentMenuId"];
    
    [[NetworkClient sharedInstance] GET:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        [self.menuArr removeAllObjects];
        [self.dataArr removeAllObjects];
        [self.canDragCollectionView.mj_header endRefreshing];
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            NSArray *arr = responseObject[@"responseData"];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = (NSDictionary *)obj;
                NSArray *itemArr = dic[@"items"];
                
                NSMutableArray *arr = [NSMutableArray array];
                NSMutableArray *titleArr = [NSMutableArray array];
                NSMutableArray *imageNameArr = [NSMutableArray array];
                
                [itemArr enumerateObjectsUsingBlock:^(id  _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
                    FirstMenuModel *model = [[FirstMenuModel alloc] initWithDataDic:obj1];
                    [arr addObject:model];
                    [titleArr addObject:model.MENU_NAME];
                    [imageNameArr addObject:model.MENU_ICON];
                }];
                [self.menuArr addObject:arr];
            }];
        }
        
        FirstMenuModel *moreModel = [[FirstMenuModel alloc] init];
        moreModel.MENU_NAME = @"更多";
        moreModel.MENU_ICON = @"more";
        
        self.dataArr = self.menuArr[1];
        [self.dataArr addObject:moreModel];
        
        [self.canDragCollectionView reloadData];
        [self.canDragCollectionView ly_endLoading];
    } failure:^(NSError *error) {
        [self.canDragCollectionView.mj_header endRefreshing];
    }];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.menuArr.count-1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(HomeCollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    cell.model = self.dataArr[indexPath.row];
}

- (NSArray *)dataSourceWithDragCellCollectionView:(YQCollectionView *)dragCellCollectionView {
    return self.dataArr;
}

- (void)dragCellCollectionView:(YQCollectionView *)dragCellCollectionView newDataArrayAfterMove:(nullable NSArray *)newDataArray {
    self.dataArr = [newDataArray mutableCopy];
}

- (BOOL)dragCellCollectionViewShouldBeginMove:(YQCollectionView *)dragCellCollectionView indexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.dataArr.count-1) {
        return NO;
    }
    return YES;
}

- (BOOL)dragCellCollectionViewShouldBeginExchange:(YQCollectionView *)dragCellCollectionView sourceIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if (destinationIndexPath.row == self.dataArr.count-1) {
        return NO;
    }
    return YES;
}

- (void)dragCellCollectionView:(YQCollectionView *)dragCellCollectionView beganDragAtPoint:(CGPoint)point indexPath:(NSIndexPath *)indexPath
{
    begainIndex = indexPath.row;
}

- (void)dragCellCollectionViewDidEndDrag:(YQCollectionView *)dragCellCollectionView indexPath:(nonnull NSIndexPath *)indexPath
{
    endIndex = indexPath.row;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCollectionViewCell *homeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCell" forIndexPath:indexPath];
    homeCell.model = self.dataArr[indexPath.row];
    return homeCell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((KScreenWidth-65*wScale)/4, 75);
}

//footer的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}

//header的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size;
    size = CGSizeMake(10, 376.0);
    return size;
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(25.0, 10.0*wScale, 25.0, 10.0*wScale);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 15.0*wScale;
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 30.0*wScale;
}

//通过设置SupplementaryViewOfKind 来设置头部或者底部的view，其中 ReuseIdentifier 的值必须和 注册是填写的一致，本例都为 “reusableView”
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    HomeHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"homeHeaderReusableID" forIndexPath:indexPath];
    headerView.dataArr = self.menuArr[0];
    return headerView;
}

-(void)reload {
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSArray *arr = self.dataArr;
        if (indexPath.row == arr.count) {
            [self showHint:@"敬请期待!"];
            return;
        }
        FirstMenuModel *model = arr[indexPath.row];
        switch ([model.MENU_ID integerValue]) {
            case 113:
            {
                RepairViewController *repairVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"RepairViewController"];
                repairVC.title = model.MENU_NAME;
                [self.navigationController pushViewController:repairVC animated:YES];
            }
                break;
            case 114:
            {
                // 考勤
                if ([[kUserDefaults objectForKey:KLoginWay] isEqualToString:KLogin]) {
                    //                        NSString *faceimageid = [kUserDefaults objectForKey:KFACE_IMAGE_ID];
                    //                        NSString *companyId = [kUserDefaults objectForKey:companyID];
                    //                        NSString *orgId = [kUserDefaults objectForKey:OrgId];
                    //                        if ([faceimageid isKindOfClass:[NSNull class]]||faceimageid == nil||faceimageid.length == 0) {
                    //                            [self showHint:@"请先录入人像信息!" yOffset:-120];
                    //                            [self performSelector:@selector(presentHumanFaceVC) withObject:nil afterDelay:1];
                    //                        }else if([companyId isKindOfClass:[NSNull class]]||companyId == nil||companyId.length == 0||[orgId isKindOfClass:[NSNull class]]||orgId == nil||orgId.length == 0){
                    //                            [self showHint:@"请先绑定公司和部门!" yOffset:-120];
                    //                            [self performSelector:@selector(presentPersonInfoVC) withObject:nil afterDelay:1];
                    //                        }else{
                    //                            KqTabbarViewController *kqtabbarVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"KqTabbarViewController"];
                    //                            kqtabbarVC.selectedIndex = 0;
                    //                            kqtabbarVC.titleStr = model.MENU_NAME;
                    //                            [self.navigationController pushViewController:kqtabbarVC animated:YES];
                    //                        }
                    KqTabbarViewController *kqtabbarVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"KqTabbarViewController"];
                    kqtabbarVC.selectedIndex = 0;
                    kqtabbarVC.titleStr = model.MENU_NAME;
                    [self.navigationController pushViewController:kqtabbarVC animated:YES];
                }else
                {
                    BindTableViewController *bindVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"BindTableViewController"];
                    if ([[kUserDefaults objectForKey:KLoginWay] isEqualToString:KAuthLoginMobile]) {
                        bindVC.type = @"1";
                    }else{
                        bindVC.type = @"0";
                    }
                    bindVC.custName = [kUserDefaults objectForKey:KUserCustName];
                    bindVC.custMobile = [kUserDefaults objectForKey:KUserPhoneNum];
                    [self.navigationController pushViewController:bindVC animated:YES];
                }
            }
                break;
            case 115:
            {
                // 开门
                if([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KLogin]){
                    
                }else{
                    [self showHint:@"请绑定员工ID"];
                }
            }
                break;
            case 116:
            {
                // 菜谱
                FoodViewController *foodVC = [[FoodViewController alloc] init];
                foodVC.titleStr = model.MENU_NAME;
                [self.navigationController pushViewController:foodVC animated:YES];
            }
                break;
            case 117:
            {
                // 寻车
                if([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KAuthLogin]){
                    BindTableViewController *bindVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"BindTableViewController"];
                    [self.navigationController pushViewController:bindVC animated:YES];
                }else {
                    FindCarViewController *findcarVC = [[FindCarViewController alloc] init];
                    findcarVC.title = model.MENU_NAME;
                    findcarVC.source = @"0";
                    [self.navigationController pushViewController:findcarVC animated:YES];
                }
            }
                break;
            case 118:
            {
                if([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KLogin]){
                    QuickRechargeViewController *quickRechageVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"QuickRechargeViewController"];
                    quickRechageVC.titleStr = model.MENU_NAME;
                    [self.navigationController pushViewController:quickRechageVC animated:YES];
                }else{
                    BindTableViewController *bindVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"BindTableViewController"];
                    if ([[kUserDefaults objectForKey:KLoginWay] isEqualToString:KAuthLoginMobile]) {
                        bindVC.type = @"1";
                    }else{
                        bindVC.type = @"0";
                    }
                    bindVC.custName = [kUserDefaults objectForKey:KUserCustName];
                    bindVC.custMobile = [kUserDefaults objectForKey:KUserPhoneNum];
                    [self.navigationController pushViewController:bindVC animated:YES];
                }
            }
                break;
            case 119:
            {
                // 在线点餐
                MealViewController *mealVC = [[MealViewController alloc] init];
                
                [self.navigationController pushViewController:mealVC animated:YES];
            }
                break;
            case 120:
            {
                // 一键上网
                WIFIListViewController *wifiVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"WIFIListViewController"];
                wifiVC.titleStr = model.MENU_NAME;
                [self.navigationController pushViewController:wifiVC animated:YES];
            }
                break;
            case 118115:
            {
                //来访预约
                VisitTabbarViewController *visTbarVc = [[VisitTabbarViewController alloc] init];
                visTbarVc.title = @"来访预约";
                [self.navigationController pushViewController:visTbarVc animated:YES];
            }
                break;
            case 31:
            {
                // 智慧幼儿园
                NurseryViewController *nurseryVC = [[NurseryViewController alloc] init];
                [self.navigationController pushViewController:nurseryVC animated:YES];
            }
                break;
            case 32:
            {
                // 智慧培训
                TrainViewController *trainVC = [[TrainViewController alloc] init];
                [self.navigationController pushViewController:trainVC animated:YES];
            }
                break;
            case 121:
            {
                // 车位预约
                //                [self cheakIsBookParkArea];
                [self loadBindCarData];
            }
                break;
            case 1212:
            {
                SmartLearnViewController *smartLearnVc = [[SmartLearnViewController alloc] init];
                smartLearnVc.isHidenNaviBar = YES;
                smartLearnVc.title = @"智慧学习";
                [self.navigationController pushViewController:smartLearnVc animated:YES];
            }
                break;
            case 1211:
            {
                HealthViewController *healthVc = [[HealthViewController alloc] init];
                healthVc.isHidenNaviBar = YES;
                [self.navigationController pushViewController:healthVc animated:YES];
            }
                break;
            default:
            {
                [self showHint:@"敬请期待!"];
            }
                break;
        }
    }
}

#pragma mark 检查是否已经预定车位
-(void)cheakIsBookParkArea
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/parking/getCustReservationOrder",MainUrl];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:[kUserDefaults objectForKey:kCustId] forKey:@"custId"];
    
    NSString *jsonStr = [Utils convertToJsonData:params];
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setObject:jsonStr forKey:@"param"];
    
    [self showHudInView:self.view hint:nil];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if (![responseObject[@"code"] isKindOfClass:[NSNull class]]&&[responseObject[@"code"] isEqualToString:@"1"]) {
            NSDictionary *dic = responseObject[@"responseData"];
            NSArray *arr = dic[@"items"];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dataDic = obj;
                BookRecordModel *_orderModel = [[BookRecordModel alloc] initWithDataDic:dataDic[@"order"]];
                BookRecordParkAreaModel *_parkAreaModel = [[BookRecordParkAreaModel alloc] initWithDataDic:dataDic[@"parkingArea"]];
                BookRecordParkSpaceModel *_parkSpaceModel = [[BookRecordParkSpaceModel alloc] initWithDataDic:dataDic[@"parkingSpace"]];
                if ([_orderModel.status isEqualToString:@"1"]) {
                    BookRecordDetailController *bookRecordDetailVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"BookRecordDetailController"];
                    bookRecordDetailVC.orderId = _orderModel.orderId;
                    [self.navigationController pushViewController:bookRecordDetailVC animated:YES];
                }else{
                    BookDetailsViewController *bookDetailVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"BookDetailsViewController"];
                    bookDetailVC.orderModel = _orderModel;
                    bookDetailVC.parkAreaModel = _parkAreaModel;
                    bookDetailVC.parkSpaceModel = _parkSpaceModel;
                    bookDetailVC.currentTime = dic[@"cunrentTime"];
                    [self.navigationController pushViewController:bookDetailVC animated:YES];
                }
            }];
            
        }else{
            ParkReservationViewController *parkReserVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"ParkReservationViewController"];
            parkReserVC.title = @"车位预约";
            [self.navigationController pushViewController:parkReserVC animated:YES];
        }
    } failure:^(NSError *error) {
        [self hideHud];
        [self showHint:@"请重试!"];
    }];
}

#pragma mark 是否绑定车辆
-(void)loadBindCarData
{
    [self showHudInView:self.view hint:nil];
    NSString *urlStr = [NSString stringWithFormat:@"%@park-service/member/getMemberCards",[kUserDefaults objectForKey:KParkUrl]];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    NSString *memberId = [[NSUserDefaults standardUserDefaults] objectForKey:KMemberId];
    if(memberId != nil){
        [params setObject:memberId forKey:@"memberId"];
    }
    [params setObject:KToken forKey:@"token"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if([responseObject[@"success"] boolValue]){
            
            NSArray *carList = responseObject[@"data"][@"carList"];
            [carList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CarListModel *carModel = [[CarListModel alloc] initWithDataDic:obj];
                [bindCarDataArr addObject:[NSString stringWithFormat:@"%@ %@",carModel.carArea,carModel.carNum]];
            }];
            
            if (carList.count ==1) {
                [self cheakIsBookParkArea];
            }else if(carList.count == 0){
                [self showHint:@"请先绑定你要预定的车辆!"];
                [self performSelector:@selector(bindCarAction) withObject:nil afterDelay:1];
            }else{
                ParkReservationViewController *parkReserVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"ParkReservationViewController"];
                parkReserVC.title = @"车位预约";
                [self.navigationController pushViewController:parkReserVC animated:YES];
            }
        }else{
            [self showHint:@"请重试!"];
        }
    } failure:^(NSError *error) {
        [self hideHud];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)bindCarAction{
    BindCarTableViewController *bindCarVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"BindCarTableViewController"];
    [self.navigationController pushViewController:bindCarVC animated:YES];
}

-(void)bindSuccess
{
    [self _loadData];
    
    //绑定成功加载对应手机号 绑定车牌
    [self _loadParkMemberId];
    NSString *loginWay = [kUserDefaults objectForKey:KLoginWay];
    
    if ([loginWay isEqualToString:KLogin]) {
        [self _loadKqPublicConfig];
    }
}

#pragma mark 判断相差时间天数
- (NSInteger)getDifferenceByDate:(NSDate *)oldDate {
    NSDate *now = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = NSCalendarUnitDay;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:oldDate  toDate:now  options:0];
    return [comps day];
}

-(void)dealloc
{
    [kNotificationCenter removeObserver:self name:UserbindSuccess object:nil];
    [kNotificationCenter removeObserver:self name:@"EnterForegroundAlert" object:nil];
    [kNotificationCenter removeObserver:self name:@"ignorepwdexpired" object:nil];
}

@end
