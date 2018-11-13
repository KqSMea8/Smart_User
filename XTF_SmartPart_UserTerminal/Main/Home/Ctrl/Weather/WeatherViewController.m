//
//  WeatherViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2018/1/11.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "WeatherViewController.h"
#import "EnvInfoModel.h"
#import "Utils.h"
#import "YQRefreshGifHeader.h"

@interface WeatherViewController ()<UIScrollViewDelegate>
{
    __weak IBOutlet NSLayoutConstraint *dateTopCon;
    __weak IBOutlet NSLayoutConstraint *weatherViewTopCon;
    __weak IBOutlet NSLayoutConstraint *weatherViewHeightCon;
    __weak IBOutlet NSLayoutConstraint *weatherViewWidthCon;
    __weak IBOutlet NSLayoutConstraint *pollutionTopCon;
    __weak IBOutlet NSLayoutConstraint *airTopCon;
    __weak IBOutlet NSLayoutConstraint *PMViewTopCon;
    __weak IBOutlet NSLayoutConstraint *lineViewTopCon;
    
    __weak IBOutlet UIImageView *_errorImgView;
    __weak IBOutlet UILabel *_errorLabel;
    
    __weak IBOutlet UIImageView *weatherBgImageView;
    
    __weak IBOutlet UILabel *dateLab;
    __weak IBOutlet UIImageView *weatherView;
    __weak IBOutlet UILabel *weatherLab;
    __weak IBOutlet UILabel *pollutionLab;
    __weak IBOutlet UILabel *pm2_5Lab;
    __weak IBOutlet UILabel *pm10Lab;
    __weak IBOutlet UILabel *windDirectionLab;
    __weak IBOutlet UILabel *windSpeedLab;
    __weak IBOutlet UILabel *humNumLab;
    __weak IBOutlet UILabel *pressureLab;
    __weak IBOutlet UILabel *noiseLab;
    
    UILabel *_locationLab;
    UIView *_titleView;
    
    
}

@property (nonatomic,strong) UIScrollView *scrollView;

@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _initNavItems];
    
    [self _initView];
    
    [self _loadWeatherData];
}

-(void)_initView
{
    weatherBgImageView.userInteractionEnabled = YES;
    if (iPhone5) {
        dateTopCon.constant = 15;
        weatherViewTopCon.constant = 15;
        weatherViewHeightCon.constant = weatherViewHeightCon.constant*hScale;
        weatherViewWidthCon.constant = weatherViewWidthCon.constant*hScale;
        pollutionTopCon.constant = 10;
        airTopCon.constant = 15;
        PMViewTopCon.constant = 15;
        lineViewTopCon.constant = 30;
    }else{
        dateTopCon.constant = dateTopCon.constant*hScale;
        weatherViewTopCon.constant = weatherViewTopCon.constant*hScale;
        weatherViewHeightCon.constant = weatherViewHeightCon.constant*hScale;
        weatherViewWidthCon.constant = weatherViewWidthCon.constant*hScale;
        pollutionTopCon.constant = pollutionTopCon.constant*hScale;
        airTopCon.constant = airTopCon.constant*hScale;
        PMViewTopCon.constant = PMViewTopCon.constant*hScale;
        lineViewTopCon.constant = lineViewTopCon.constant*hScale;
    }
    
    NSString *monthStr = [self getCurrentMouth];
    NSString *weekStr = [Utils weekdayStringFromDate:[NSDate date]];
    dateLab.text = [NSString stringWithFormat:@"%@ %@",monthStr,weekStr];
    
    pollutionLab.layer.cornerRadius = 3;
    pollutionLab.clipsToBounds = YES;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-kTopHeight)];
    _scrollView.contentSize = CGSizeMake(KScreenWidth, KScreenHeight-kTopHeight);
    _scrollView.backgroundColor = [UIColor clearColor];
    YQRefreshGifHeader *header = [YQRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(_loadWeatherData)];
    _scrollView.mj_header = header;
    [self.view addSubview:_scrollView];
    [self.view bringSubviewToFront:_scrollView];
    
}

- (NSString *)getCurrentMouth {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月dd日"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

-(void)_initNavItems
{
    
    UIButton *leftBtn = [[UIButton alloc] init];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [leftBtn setImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(_leftBarBtnItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
    titleView.backgroundColor = [UIColor clearColor];
    _titleView = titleView;
    
    UILabel *locationLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 133, 25)];
    locationLab.textColor = [UIColor whiteColor];
    locationLab.text = @"天园智慧园区";
    [titleView addSubview:locationLab];
    
    _locationLab = locationLab;
    
    self.navigationItem.titleView = titleView;
}

- (void)_leftBarBtnItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)_loadWeatherData
{
    [self showHudInView:self.view hint:@"加载中~"];
    NSString *urkStr = [NSString stringWithFormat:@"%@/roadLamp/sensor",MainUrl];
    
    [[NetworkClient sharedInstance] POST:urkStr dict:nil progressFloat:nil succeed:^(id responseObject) {
        
        NSDictionary *data = responseObject;
        if ([data[@"code"] isEqualToString:@"1"]) {
            [self.scrollView.mj_header endRefreshing];
            [self hideHud];
            NSDictionary *dic = data[@"responseData"];
            if (![dic isKindOfClass:[NSNull class]]&&dic != nil) {
                
                EnvInfoModel *model = [[EnvInfoModel alloc] initWithDataDic:dic];
                
                weatherLab.text = [NSString stringWithFormat:@"%@ %.1f℃",model.weather,[model.temperature floatValue]];
                
                weatherView.image = [UIImage imageNamed:[NSString stringWithFormat:@"bigIcon_%@",model.weather]];
                
                windDirectionLab.text = [NSString stringWithFormat:@"%@",model.winddirection];
                windSpeedLab.text = [NSString stringWithFormat:@"%.1fm/s",[model.windspeed floatValue]];
                pm2_5Lab.text = [NSString stringWithFormat:@"%@",model.pm2_5];
                pm10Lab.text = [NSString stringWithFormat:@"%@",model.pm10];
                humNumLab.text = [NSString stringWithFormat:@"%.1f%%",[model.humidity floatValue]];
                pressureLab.text = [NSString stringWithFormat:@"%@hpa",model.airpressure];
                noiseLab.text = [NSString stringWithFormat:@"%.1fdpi",[model.noise floatValue]];
                
                //                _locationLab.text = [NSString stringWithFormat:@"%@",model.adv_name];
                
                CGSize size = [_locationLab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
                
                _titleView.size = CGSizeMake(size.width, 25);
                
                [self changeValueColor:[model.pm2_5 stringValue]];
            }
        }
    } failure:^(NSError *error) {
        [self.scrollView.mj_header endRefreshing];
    }];
}

// 根据pm值改变数值颜色
- (void)changeValueColor:(NSString *)pm25 {
    if(![pm25 isKindOfClass:[NSNull class]]&&pm25 != nil){
        if(pm25.integerValue <= 35){
            // 优
            pollutionLab.textColor = [UIColor colorWithHexString:@"#03ff01"];
            pollutionLab.text = @"优";
        }else if(pm25.integerValue <= 75){
            // 良
            pollutionLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
            pollutionLab.text = @"良";
        }else if(pm25.integerValue <= 115){
            // 轻
            pollutionLab.textColor = [UIColor colorWithHexString:@"#ffc600"];
            pollutionLab.text = @"轻度";
        }else if(pm25.integerValue <= 150){
            // 中
            pollutionLab.textColor = [UIColor colorWithHexString:@"#ffff01"];
            pollutionLab.text = @"中度";
        }else if(pm25.integerValue <= 250){
            // 重
            pollutionLab.textColor = [UIColor colorWithHexString:@"#fe9900"];
            pollutionLab.text = @"重度";
        }else {
            // 严重
            pollutionLab.textColor = [UIColor colorWithHexString:@"#ff0e00"];
            pollutionLab.text = @"严重";
        }
        
        if(pm25.integerValue > 75){
            _errorImgView.hidden = NO;
            _errorLabel.hidden = NO;
            _errorLabel.text = [NSString stringWithFormat:@"%@污染，请注意防护！", pollutionLab.text];
            _errorLabel.textColor = pollutionLab.textColor;
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
