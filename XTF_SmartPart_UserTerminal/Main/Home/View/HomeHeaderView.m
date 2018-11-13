//
//  HomeHeaderView.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/11/30.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "HomeHeaderView.h"
#import "ParkHomeViewController.h"

#import "UserModel.h"
#import "FirstMenuModel.h"

#import "BindTableViewController.h"
#import "PayMentTableViewController.h"

#import "ScanViewController.h"

#import "HomeImgModel.h"
#import "EnvInfoModel.h"

#import "WeatherViewController.h"
#import "AccessControlViewController.h"
#import "WeatherDetailController.h"
#import "AccessListViewController.h"

@implementation HomeHeaderView
{
    __weak IBOutlet UIView *_parkView;
    __weak IBOutlet UIView *_scanView;
    __weak IBOutlet UIView *repairView;
    
    __weak IBOutlet NSLayoutConstraint *parkViewWidth;
    
    __weak IBOutlet NSLayoutConstraint *scanViewWidth;
    __weak IBOutlet NSLayoutConstraint *repeairViewWidth;
    __weak IBOutlet UIImageView *leftImageView;
    __weak IBOutlet UILabel *leftTitleLab;
    
    __weak IBOutlet UIImageView *centerImageView;
    __weak IBOutlet UILabel *centerTitleLab;
    
    __weak IBOutlet UIImageView *rightImageView;
    __weak IBOutlet UILabel *rightTitleLab;
    
    __weak IBOutlet UIImageView *weatherView;
    
    __weak IBOutlet UILabel *tempNumLab;
    __weak IBOutlet UILabel *humNumLab;
    __weak IBOutlet UILabel *pmNumLab;
    __weak IBOutlet UILabel *pmLevelLab;
    
    __weak IBOutlet NSLayoutConstraint *weatherViewLeadSpace;
    
    __weak IBOutlet NSLayoutConstraint *tempViewLeadSpace;
    
    __weak IBOutlet NSLayoutConstraint *humViewLeadSpace;
    
    __weak IBOutlet NSLayoutConstraint *pmViewLeadSpace;
    
    __weak IBOutlet UIView *weatherBgView;
    
    SDCycleScrollView *cycleView;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    if (iPhone5) {
        weatherViewLeadSpace.constant = 15;
        tempViewLeadSpace.constant = 15;
        humViewLeadSpace.constant = 15;
        pmViewLeadSpace.constant = 15;
    }else{
        weatherViewLeadSpace.constant = wScale * weatherViewLeadSpace.constant;
        tempViewLeadSpace.constant = wScale * tempViewLeadSpace.constant;
        humViewLeadSpace.constant = wScale * humViewLeadSpace.constant;
        pmViewLeadSpace.constant = wScale * pmViewLeadSpace.constant;
    }
    
    UITapGestureRecognizer *parkTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(parkAction)];
    _parkView.userInteractionEnabled = YES;
    [_parkView addGestureRecognizer:parkTap];
    
    UITapGestureRecognizer *repairTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(repairTapAction)];
    repairView.userInteractionEnabled = YES;
    [repairView addGestureRecognizer:repairTap];
    
    UITapGestureRecognizer *scanTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanTapAction)];
    _scanView.userInteractionEnabled = YES;
    [_scanView addGestureRecognizer:scanTap];
    
    [kNotificationCenter addObserver:self selector:@selector(refreshWeather:) name:@"refreshWeatherData" object:nil];
    
    UITapGestureRecognizer *weatherTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(weatherTapAction:)];
    weatherBgView.userInteractionEnabled = YES;
    [weatherBgView addGestureRecognizer:weatherTap];
    
    [self _initView];
    
    [self _loadImgData];
    
    [self _loadWeatherData];
    
}

-(void)_initView
{
    
    cycleView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 158+0.5+46, KScreenWidth, 132)];
    cycleView.autoScroll = YES;
    cycleView.autoScrollTimeInterval = 3;
//    cycleView.localizationImageNamesGroup = arr;
    cycleView.pageDotImage = [UIImage imageNamed:@"whitepoint"];
    cycleView.currentPageDotImage = [UIImage imageNamed:@"redpoint"];
    [self addSubview:cycleView];
}

- (void)_loadImgData {
    NSString *versionUrl = [NSString stringWithFormat:@"%@/public/getBannerImag", MainUrl];
    [[NetworkClient sharedInstance] GET:versionUrl dict:nil progressFloat:nil succeed:^(id responseObject) {
        if([responseObject[@"code"] isEqualToString:@"1"]){
            NSArray *responseData = responseObject[@"responseData"];
            if(![responseData isKindOfClass:[NSNull class]]&&responseData != nil){
                NSMutableArray *imgUrls = @[].mutableCopy;
                [responseData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    HomeImgModel *model = [[HomeImgModel alloc] initWithDataDic:obj];
                    if(![model.imageUrl isKindOfClass:[NSNull class]]&&model.imageUrl != nil){
                        [imgUrls addObject:model.imageUrl];
                    }
                }];
                cycleView.imageURLStringsGroup = imgUrls;
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)_loadWeatherData
{
    NSString *urkStr = [NSString stringWithFormat:@"%@/roadLamp/sensor",MainUrl];
    
    [[NetworkClient sharedInstance] POST:urkStr dict:nil progressFloat:nil succeed:^(id responseObject) {
        
        NSDictionary *data = responseObject;
        if ([data[@"code"] isEqualToString:@"1"]) {
            
            NSDictionary *dic = data[@"responseData"];
            if (![dic isKindOfClass:[NSNull class]]&&dic != nil) {
                
                EnvInfoModel *model = [[EnvInfoModel alloc] initWithDataDic:dic];
                
                if (![model.smallWhite isKindOfClass:[NSNull class]]&&model.smallWhite != nil) {
                    [weatherView sd_setImageWithURL:[NSURL URLWithString:[model.smallWhite stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"未知"]];
                }
                tempNumLab.text = [NSString stringWithFormat:@"%.1f℃",[model.temperature floatValue]];
                humNumLab.text = [NSString stringWithFormat:@"%.1f%%",[model.humidity floatValue]];
                pmNumLab.text = [NSString stringWithFormat:@"%@",model.pm2_5];
                
                [self changeValueColor:[model.pm2_5 stringValue]];
            }
        }
    } failure:^(NSError *error) {
        DLog(@"%@",error);
    }];
}

// 根据pm值改变数值颜色
- (void)changeValueColor:(NSString *)pm25 {
    if(![pm25 isKindOfClass:[NSNull class]]&&pm25 != nil){
        if(pm25.integerValue <= 35){
            // 优
            pmNumLab.textColor = [UIColor colorWithHexString:@"#03ff01"];
            pmLevelLab.text = @"优";
        }else if(pm25.integerValue <= 75){
            // 良
            pmNumLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
            pmLevelLab.text = @"良";
        }else if(pm25.integerValue <= 115){
            // 轻
            pmNumLab.textColor = [UIColor colorWithHexString:@"#ffc600"];
            pmLevelLab.text = @"轻度";
        }else if(pm25.integerValue <= 150){
            // 中
            pmNumLab.textColor = [UIColor colorWithHexString:@"#ffff01"];
            pmLevelLab.text = @"中度";
        }else if(pm25.integerValue <= 250){
            // 重
            pmNumLab.textColor = [UIColor colorWithHexString:@"#fe9900"];
            pmLevelLab.text = @"重度";
        }else {
            // 严重
            pmNumLab.textColor = [UIColor colorWithHexString:@"#ff0e00"];
            pmLevelLab.text = @"严重";
        }
        pmLevelLab.textColor = pmNumLab.textColor;
    }
}

-(void)weatherTapAction:(UITapGestureRecognizer *)tap
{
//    WeatherViewController *weatherVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"WeatherViewController"];
//    [self.viewController.navigationController pushViewController:weatherVC animated:YES];
    WeatherDetailController *weaDetailVC = [[WeatherDetailController alloc] init];
    [self.viewController.navigationController pushViewController:weaDetailVC animated:YES];
}

#pragma mark 停车
- (void)parkAction {
    ParkHomeViewController *parkVC = [[ParkHomeViewController alloc] init];
    parkVC.hidesBottomBarWhenPushed = YES;
    parkVC.title = leftTitleLab.text;
    [[self viewController].navigationController pushViewController:parkVC animated:YES];
}

#pragma mark 智能开门
-(void)repairTapAction
{
//    RepairViewController *repairVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"RepairViewController"];
//    repairVC.title = rightTitleLab.text;
//    [[self viewController].navigationController pushViewController:repairVC animated:YES];

    if([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KLogin]){
//        AccessControlViewController *accessCtrlVC = [[AccessControlViewController alloc] init];
//        accessCtrlVC.titleStr = rightTitleLab.text;
//        [[self viewController].navigationController pushViewController:accessCtrlVC animated:YES];
        AccessListViewController *accessCtrlVC = [[AccessListViewController alloc] init];
        accessCtrlVC.titleStr = rightTitleLab.text;
        [[self viewController].navigationController pushViewController:accessCtrlVC animated:YES];
    }else{
        BindTableViewController *bindVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"BindTableViewController"];
        if ([[kUserDefaults objectForKey:KLoginWay] isEqualToString:KAuthLoginMobile]) {
            bindVC.type = @"1";
        }else{
            bindVC.type = @"0";
        }
        bindVC.custName = [kUserDefaults objectForKey:KUserCustName];
        bindVC.custMobile = [kUserDefaults objectForKey:KUserPhoneNum];
        [[self viewController].navigationController pushViewController:bindVC animated:YES];
    }
}

#pragma mark 扫一扫
-(void)scanTapAction
{
//    PayMentTableViewController *payMentVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"PayMentTableViewController"];
//    [[self viewController].navigationController pushViewController:payMentVC animated:YES];
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KLogin]){
        ScanViewController *scanVC = [[ScanViewController alloc] init];
        scanVC.title = centerTitleLab.text;
        [[self viewController].navigationController pushViewController:scanVC animated:YES];
    }else {
        BindTableViewController *bindVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"BindTableViewController"];
        if ([[kUserDefaults objectForKey:KLoginWay] isEqualToString:KAuthLoginMobile]) {
            bindVC.type = @"1";
        }else{
            bindVC.type = @"0";
        }
        bindVC.custName = [kUserDefaults objectForKey:KUserCustName];
        bindVC.custMobile = [kUserDefaults objectForKey:KUserPhoneNum];
        [[self viewController].navigationController pushViewController:bindVC animated:YES];
    }
}

-(void)setDataArr:(NSMutableArray *)dataArr
{
    _dataArr = dataArr;
    
    if (dataArr.count == 0) {
        _parkView.hidden = YES;
        _scanView.hidden = YES;
        repairView.hidden = YES;
    }else if (dataArr.count == 1)
    {
        _scanView.hidden = YES;
        repairView.hidden = YES;
    }else if(dataArr.count == 2){
        repairView.hidden = YES;
    }else{
        _parkView.hidden = NO;
        _scanView.hidden = NO;
        repairView.hidden = NO;
    }
    
    if (![dataArr isKindOfClass:[NSNull class]]&&dataArr.count != 0) {
        FirstMenuModel *model1 = dataArr[0];
        leftTitleLab.text = model1.MENU_NAME;
        leftImageView.image = [UIImage imageNamed:model1.MENU_ICON];
    }
    
    if (![dataArr isKindOfClass:[NSNull class]]&&dataArr.count > 1) {
        FirstMenuModel *model2 = dataArr[1];
        centerTitleLab.text = model2.MENU_NAME;
        centerImageView.image = [UIImage imageNamed:model2.MENU_ICON];
    }
    
    if (![dataArr isKindOfClass:[NSNull class]]&&dataArr.count>2) {
        FirstMenuModel *model3 = dataArr[2];
        rightTitleLab.text = model3.MENU_NAME;
        rightImageView.image = [UIImage imageNamed:model3.MENU_ICON];
    }
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (_dataArr.count == 0) {
        
    }else if (_dataArr.count == 1)
    {
       
    }else if(_dataArr.count == 2){
        parkViewWidth.constant = KScreenWidth/6;
    }else{
        parkViewWidth.constant = 0;
        scanViewWidth.constant = 0;
        repeairViewWidth.constant = 0;
    }
}

-(void)refreshWeather:(NSNotification *)notification
{
    [self _loadImgData];
    [self _loadWeatherData];
}

@end
