//
//  WeatherDetailController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2018/1/18.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "WeatherDetailController.h"
#import "EnvInfoModel.h"
#import "Utils.h"

@interface WeatherDetailController ()
{
    UILabel *_locationLab;
    UIView *_titleView;
}

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIImageView *bigBgView;
@property (nonatomic,strong) UILabel *dateLab;
@property (nonatomic,strong) UIImageView *weatherView;
@property (nonatomic,strong) UILabel *weatherAndTempLab;
@property (nonatomic,strong) UILabel *airLab;
@property (nonatomic,strong) UILabel *airPoLevelLab;
@property (nonatomic,strong) UIImageView *pm25View;
@property (nonatomic,strong) UILabel *pm25Lab;
@property (nonatomic,strong) UIImageView *pm10View;
@property (nonatomic,strong) UILabel *pm10Lab;
@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) UIView *windBgView;
@property (nonatomic,strong) UIView *humBgView;
@property (nonatomic,strong) UIView *pressureBgView;
@property (nonatomic,strong) UIView *noiseBgView;

@property (nonatomic,strong) UIImageView *windView;
@property (nonatomic,strong) UILabel *windLab;
@property (nonatomic,strong) UILabel *windNumLab;

@property (nonatomic,strong) UIImageView *humView;
@property (nonatomic,strong) UILabel *humLab;
@property (nonatomic,strong) UILabel *humNumLab;

@property (nonatomic,strong) UIImageView *pressureView;
@property (nonatomic,strong) UILabel *pressureLab;
@property (nonatomic,strong) UILabel *pressureNumLab;

@property (nonatomic,strong) UIImageView *noiseView;
@property (nonatomic,strong) UILabel *noiseLab;
@property (nonatomic,strong) UILabel *noiseNumLab;

@property (nonatomic,strong) UIImageView *errorImgView;
@property (nonatomic,strong) UILabel *errorLabel;

@end

@implementation WeatherDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _initNavItems];
    
    [self _initView];
    
    [self _loadWeatherData];
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

-(void)_initView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-kTopHeight)];
    _scrollView.contentSize = CGSizeMake(KScreenWidth, KScreenHeight-kTopHeight);
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_loadWeatherData)];
    [self.view addSubview:_scrollView];
    
    _bigBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.width, _scrollView.height)];
    _bigBgView.image = [UIImage imageNamed:@"weatherBgImage"];
    [_scrollView addSubview:_bigBgView];
    
    _dateLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 27*wScale, 180, 17)];
    _dateLab.centerX = _bigBgView.width/2;
    _dateLab.font = [UIFont systemFontOfSize:17];
    _dateLab.textColor = [UIColor whiteColor];
    _dateLab.textAlignment = NSTextAlignmentCenter;
    _dateLab.text = @"-";
    [_bigBgView addSubview:_dateLab];
    
    NSString *monthStr = [self getCurrentMouth];
    NSString *weekStr = [Utils weekdayStringFromDate:[NSDate date]];
    _dateLab.text = [NSString stringWithFormat:@"%@ %@",monthStr,weekStr];
    
    _weatherView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _dateLab.bottom+33*wScale, 100*wScale, 100*wScale)];
    _weatherView.image = [UIImage imageNamed:@"未知天气"];
    _weatherView.centerX = _bigBgView.width/2;
    [_bigBgView addSubview:_weatherView];
    
    _weatherAndTempLab = [[UILabel alloc] initWithFrame:CGRectMake(0, _weatherView.bottom+12*wScale, 180, 19)];
    _weatherAndTempLab.font = [UIFont systemFontOfSize:20];
    _weatherAndTempLab.textColor = [UIColor whiteColor];
    _weatherAndTempLab.text = @"-";
    _weatherAndTempLab.centerX = _bigBgView.width/2;
    _weatherAndTempLab.textAlignment = NSTextAlignmentCenter;
    [_bigBgView addSubview:_weatherAndTempLab];
    
    _airLab = [[UILabel alloc] initWithFrame:CGRectMake(19, _weatherAndTempLab.bottom+37*wScale, 80, 17)];
    _airLab.font = [UIFont systemFontOfSize:17];
    _airLab.text = @"空气质量 :";
    _airLab.textColor = [UIColor whiteColor];
    _airLab.textAlignment = NSTextAlignmentLeft;
    [_bigBgView addSubview:_airLab];
    
    _airPoLevelLab = [[UILabel alloc] initWithFrame:CGRectMake(_airLab.right+7*wScale, _airLab.top, 120, _airLab.height)];
    _airPoLevelLab.font = [UIFont systemFontOfSize:17];
    _airPoLevelLab.text = @"-";
    _airPoLevelLab.textColor = [UIColor redColor];
    _airPoLevelLab.textAlignment = NSTextAlignmentLeft;
    [_bigBgView addSubview:_airPoLevelLab];
    
    _pm25View = [[UIImageView alloc] initWithFrame:CGRectMake(0, _airLab.bottom+35*wScale, 79, 65)];
    _pm25View.image = [UIImage imageNamed:@"PM2.5-1"];
    _pm25View.centerX = _bigBgView.width/2*0.65;
    [_bigBgView addSubview:_pm25View];
    
    _pm10View = [[UIImageView alloc] initWithFrame:CGRectMake(0, _airLab.bottom+35*wScale, 79, 65)];
    _pm10View.image = [UIImage imageNamed:@"PM10"];
    _pm10View.centerX = _bigBgView.width/2*1.35;
    [_bigBgView addSubview:_pm10View];
    
    _pm25Lab = [[UILabel alloc] initWithFrame:CGRectMake(0, _pm25View.bottom+15.5*wScale, 80, 15)];
    _pm25Lab.font = [UIFont systemFontOfSize:17];
    _pm25Lab.text = @"-";
    _pm25Lab.centerX = _pm25View.centerX;
    _pm25Lab.textColor = [UIColor whiteColor];
    _pm25Lab.textAlignment = NSTextAlignmentCenter;
    [_bigBgView addSubview:_pm25Lab];
    
    _errorImgView = [[UIImageView alloc] initWithFrame:CGRectMake(_pm25View.left, _pm25Lab.bottom+5, 20, 20)];
    _errorImgView.image = [UIImage imageNamed:@"aircondition_error"];
    _errorImgView.hidden = YES;
    [_bigBgView addSubview:_errorImgView];
    
    _errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(_errorImgView.right+4, 0, KScreenWidth - _errorImgView.right - 10, 17)];
    _errorLabel.font = [UIFont systemFontOfSize:17];
    _errorLabel.text = @"-";
    _errorLabel.centerY = _errorImgView.centerY;
    _errorLabel.textColor = [UIColor whiteColor];
    _errorLabel.textAlignment = NSTextAlignmentLeft;
    _errorLabel.hidden = YES;
    [_bigBgView addSubview:_errorLabel];
    
    _pm10Lab = [[UILabel alloc] initWithFrame:CGRectMake(0, _pm10View.bottom+15.5*wScale, 80, 15)];
    _pm10Lab.font = [UIFont systemFontOfSize:17];
    _pm10Lab.text = @"-";
    _pm10Lab.centerX = _pm10View.centerX;
    _pm10Lab.textColor = [UIColor whiteColor];
    _pm10Lab.textAlignment = NSTextAlignmentCenter;
    [_bigBgView addSubview:_pm10Lab];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _pm10Lab.bottom+33*hScale, KScreenWidth, 0.5)];
    _lineView.backgroundColor = [UIColor colorWithHexString:@"#88C9FF"];
    [_bigBgView addSubview:_lineView];
    
    _windBgView = [[UIView alloc] initWithFrame:CGRectMake(0, _lineView.bottom, KScreenWidth/2, (KScreenHeight-_lineView.bottom-kTopHeight)/2)];
    _windBgView.backgroundColor = [UIColor clearColor];
    [_bigBgView addSubview:_windBgView];
    
    _windView = [[UIImageView alloc] initWithFrame:CGRectMake(59*hScale, 42*hScale, 24, 20)];
    if (iPhone5) {
        _windView.frame = CGRectMake(59, 25, 24, 20);
    }
    _windView.image = [UIImage imageNamed:@"wind"];
    [_windBgView addSubview:_windView];
    
    _windLab = [[UILabel alloc] initWithFrame:CGRectMake(_windView.right+11, 35, 54, 17)];
    if (iPhone5) {
        _windLab.frame = CGRectMake(_windView.right+11, 18, 54, 17);
    }
    _windLab.font = [UIFont systemFontOfSize:17];
    _windLab.textAlignment = NSTextAlignmentLeft;
    _windLab.text = @"-";
    _windLab.textColor = [UIColor whiteColor];
    [_windBgView addSubview:_windLab];
    
    _windNumLab = [[UILabel alloc] initWithFrame:CGRectMake(_windView.right+11, _windLab.bottom+5, 54, 17)];
    _windNumLab.font = [UIFont systemFontOfSize:17];
    _windNumLab.textAlignment = NSTextAlignmentLeft;
    _windNumLab.text = @"-";
    _windNumLab.textColor = [UIColor whiteColor];
    [_windBgView addSubview:_windNumLab];
    
    _humBgView = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth/2, _lineView.bottom, KScreenWidth/2, (KScreenHeight-_lineView.bottom-kTopHeight)/2)];
    _humBgView.backgroundColor = [UIColor clearColor];
    [_bigBgView addSubview:_humBgView];
    
    _humView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 42, 24, 20)];
    if (iPhone5) {
        _humView.frame = CGRectMake(30, 25, 24, 20);
    }
    _humView.image = [UIImage imageNamed:@"hum"];
    [_humBgView addSubview:_humView];
    
    _humLab = [[UILabel alloc] initWithFrame:CGRectMake(_humView.right+11, 35, 54, 17)];
    if (iPhone5) {
        _humLab.frame = CGRectMake(_humView.right+11, 18, 54, 17);
    }
    _humLab.font = [UIFont systemFontOfSize:17];
    _humLab.textAlignment = NSTextAlignmentLeft;
    _humLab.text = @"湿度";
    _humLab.textColor = [UIColor whiteColor];
    [_humBgView addSubview:_humLab];
    
    _humNumLab = [[UILabel alloc] initWithFrame:CGRectMake(_humView.right+11, _humLab.bottom+5, 54, 17)];
    
    _humNumLab.font = [UIFont systemFontOfSize:17];
    _humNumLab.textAlignment = NSTextAlignmentLeft;
    _humNumLab.text = @"-";
    _humNumLab.textColor = [UIColor whiteColor];
    [_humBgView addSubview:_humNumLab];

    _pressureBgView = [[UIView alloc] initWithFrame:CGRectMake(0, _windBgView.bottom, KScreenWidth/2, (KScreenHeight-_lineView.bottom-kTopHeight)/2)];
    _pressureBgView.backgroundColor = [UIColor clearColor];
    [_bigBgView addSubview:_pressureBgView];
    
    _pressureView = [[UIImageView alloc] initWithFrame:CGRectMake(59, 24, 24, 20)];
    _pressureView.image = [UIImage imageNamed:@"pressure"];
    if (iPhone5) {
        _pressureView.frame = CGRectMake(59, 25, 24, 20);
    }
    [_pressureBgView addSubview:_pressureView];
    
    _pressureLab = [[UILabel alloc] initWithFrame:CGRectMake(_pressureView.right+11, 18, 54, 17)];
    if (iPhone5) {
        _pressureLab.frame = CGRectMake(_pressureView.right+11, 9, 54, 17);
    }
    _pressureLab.font = [UIFont systemFontOfSize:17];
    _pressureLab.textAlignment = NSTextAlignmentLeft;
    _pressureLab.text = @"气压";
    _pressureLab.textColor = [UIColor whiteColor];
    [_pressureBgView addSubview:_pressureLab];
    
    _pressureNumLab = [[UILabel alloc] initWithFrame:CGRectMake(_pressureView.right+11, _pressureLab.bottom+5, 100, 17)];
    _pressureNumLab.font = [UIFont systemFontOfSize:17];
    _pressureNumLab.textAlignment = NSTextAlignmentLeft;
    _pressureNumLab.text = @"-";
    _pressureNumLab.textColor = [UIColor whiteColor];
    [_pressureBgView addSubview:_pressureNumLab];

    _noiseBgView = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth/2, _humBgView.bottom, KScreenWidth/2, (KScreenHeight-_lineView.bottom-kTopHeight)/2)];
    _noiseBgView.backgroundColor = [UIColor clearColor];
    [_bigBgView addSubview:_noiseBgView];

    _noiseView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 24, 24, 20)];
    _noiseView.image = [UIImage imageNamed:@"noise"];
    if (iPhone5) {
        _noiseView.frame = CGRectMake(30*hScale, 15, 24, 20);
    }
    [_noiseBgView addSubview:_noiseView];
    
    _noiseLab = [[UILabel alloc] initWithFrame:CGRectMake(_noiseView.right+11, 18, 120, 17)];
    if (iPhone5) {
        _noiseLab.frame = CGRectMake(_noiseView.right+11, 9, 120, 17);
    }
    _noiseLab.font = [UIFont systemFontOfSize:17];
    _noiseLab.textAlignment = NSTextAlignmentLeft;
    _noiseLab.text = @"噪音";
    _noiseLab.textColor = [UIColor whiteColor];
    [_noiseBgView addSubview:_noiseLab];
    
    _noiseNumLab = [[UILabel alloc] initWithFrame:CGRectMake(_noiseView.right+11, _noiseLab.bottom+5, 100, 17)];
    _noiseNumLab.font = [UIFont systemFontOfSize:17];
    _noiseNumLab.textAlignment = NSTextAlignmentLeft;
    _noiseNumLab.text = @"-";
    _noiseNumLab.textColor = [UIColor whiteColor];
    [_noiseBgView addSubview:_noiseNumLab];
}

-(void)_loadWeatherData
{
    [self showHudInView:self.view hint:@"加载中~"];
    NSString *urkStr = [NSString stringWithFormat:@"%@/roadLamp/sensor",MainUrl];
    
    [[NetworkClient sharedInstance] POST:urkStr dict:nil progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        NSDictionary *data = responseObject;
        if ([data[@"code"] isEqualToString:@"1"]) {
            [self.scrollView.mj_header endRefreshing];
            
            NSDictionary *dic = data[@"responseData"];
            if (![dic isKindOfClass:[NSNull class]]&&dic != nil) {
                
                EnvInfoModel *model = [[EnvInfoModel alloc] initWithDataDic:dic];
                
                _weatherAndTempLab.text = [NSString stringWithFormat:@"%@ %.1f℃",model.weather,[model.temperature floatValue]];
                
                if (![model.bigColor isKindOfClass:[NSNull class]]&&model.bigColor != nil) {
                    [_weatherView sd_setImageWithURL:[NSURL URLWithString:[model.bigColor stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"未知天气"]];
                }
                
                _windLab.text = [NSString stringWithFormat:@"%@",model.winddirection];
                _windNumLab.text = [NSString stringWithFormat:@"%.1fm/s",[model.windspeed floatValue]];
                _pm25Lab.text = [NSString stringWithFormat:@"%@",model.pm2_5];
                _pm10Lab.text = [NSString stringWithFormat:@"%@",model.pm10];
                _humNumLab.text = [NSString stringWithFormat:@"%.1f%%",[model.humidity floatValue]];
                _pressureNumLab.text = [NSString stringWithFormat:@"%@hpa",model.airpressure];
                _noiseNumLab.text = [NSString stringWithFormat:@"%.1fdpi",[model.noise floatValue]];
                
                //                _locationLab.text = [NSString stringWithFormat:@"%@",model.adv_name];
                
                CGSize size = [_locationLab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
                
                _titleView.size = CGSizeMake(size.width, 25);
                
                [self changeValueColor:[model.pm2_5 stringValue]];
            }
        }
    } failure:^(NSError *error) {
        [self hideHud];
        [self.scrollView.mj_header endRefreshing];
        YYReachability *rech = [YYReachability reachability];
        if (!rech.reachable) {
            [self showHint:@"无网络连接!"];
        }else{
            [self showHint:@"请重试!"];
        }
    }];
}

// 根据pm值改变数值颜色
- (void)changeValueColor:(NSString *)pm25 {
    if(![pm25 isKindOfClass:[NSNull class]]&&pm25 != nil){
        if(pm25.integerValue <= 35){
            // 优
            _airPoLevelLab.textColor = [UIColor colorWithHexString:@"#03ff01"];
            _airPoLevelLab.text = @"优";
        }else if(pm25.integerValue <= 75){
            // 良
            _airPoLevelLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
            _airPoLevelLab.text = @"良";
        }else if(pm25.integerValue <= 115){
            // 轻
            _airPoLevelLab.textColor = [UIColor colorWithHexString:@"#ffc600"];
            _airPoLevelLab.text = @"轻度";
        }else if(pm25.integerValue <= 150){
            // 中
            _airPoLevelLab.textColor = [UIColor colorWithHexString:@"#ffff01"];
            _airPoLevelLab.text = @"中度";
        }else if(pm25.integerValue <= 250){
            // 重
            _airPoLevelLab.textColor = [UIColor colorWithHexString:@"#fe9900"];
            _airPoLevelLab.text = @"重度";
        }else {
            // 严重
            _airPoLevelLab.textColor = [UIColor colorWithHexString:@"#ff0e00"];
            _airPoLevelLab.text = @"严重";
        }
        
        if(pm25.integerValue > 75){
            _errorImgView.hidden = NO;
            _errorLabel.hidden = NO;
            _errorLabel.text = [NSString stringWithFormat:@"%@污染，请注意防护！", _airPoLevelLab.text];
            _errorLabel.textColor = _airPoLevelLab.textColor;
        }
    }
}

- (NSString *)getCurrentMouth {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月dd日"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
