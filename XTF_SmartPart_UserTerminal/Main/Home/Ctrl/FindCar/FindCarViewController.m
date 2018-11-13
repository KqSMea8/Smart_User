//
//  FindCarViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/3.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "FindCarViewController.h"

#import "YQInDoorPointMapView.h"
#import "DownParkMdel.h"
#import "FindCarView.h"
#import "CarListModel.h"

#import "InputKeyBoardView.h"
#import "NumInputView.h"

@interface FindCarViewController ()<DidSelInMapPopDelegate,UITextFieldDelegate>
{
    NSMutableArray *_parkData;
    NSMutableArray *_graphData;
    
    UILabel *_carNumLab;
    UITextField *_carNumTex;
    UIButton *_findcarBtn;
    
    YQInDoorPointMapView *_indoorView;
    
    FindCarView *_findCarView;
    
    // 记录上次搜索车位数据
    DownParkMdel *_searchDownParkMdel;
    
    InputKeyBoardView *keyBoardView;
    NumInputView *numInputView;
    
    UIView *_carBgView;
    
    BOOL _isHide;
}

@end

@implementation FindCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initNavItems];
    
    _isHide = YES;
    
    _parkData = @[].mutableCopy;
    _graphData = @[].mutableCopy;
    
    [self _initView];
    
//    [self _loadUserCarData];
    if ([_source isEqualToString:@"0"]) {
        [self findMyCar];
    }else{
        [self searchCar:_carNo];
    }
}

-(void)searchCar:(NSString *)carNo
{
    _carNumTex.text = carNo;
    [self findCarBtnAction];
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
}

- (void)_leftBarBtnItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)_initView
{
    UITapGestureRecognizer *endEditTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewEndEdit)];
    [self.view addGestureRecognizer:endEditTap];
    
    _indoorView = [[YQInDoorPointMapView alloc]initWithIndoorMapImageName:@"dxck" Frame:CGRectMake(0, 0, self.view.frame.size.width, KScreenHeight-kTopHeight)];
    _indoorView.selInMapDelegate = self;
    [self.view addSubview:_indoorView];
    
    [self.view insertSubview:_indoorView.smallMapView aboveSubview:_indoorView];
    _indoorView.isMinScaleWithHeight = YES;
    
    _carBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 45)];
    _carBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_carBgView];
    
    NSString *str = @"车牌号 : ";
    CGSize size = [str sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}];
    _carNumLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 14, size.width, size.height)];
    _carNumLab.text = str;
    _carNumLab.font = [UIFont systemFontOfSize:15];
    _carNumLab.textColor = [UIColor blackColor];
    _carNumLab.textAlignment = NSTextAlignmentLeft;
    [_carBgView addSubview:_carNumLab];
    
    _carNumTex = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_carNumLab.frame), 0, KScreenWidth-CGRectGetMaxX(_carNumLab.frame)-90, 30)];
    _carNumTex.centerY = _carNumLab.centerY;
    _carNumTex.borderStyle = UITextBorderStyleNone;
    _carNumTex.delegate = self;
    _carNumTex.placeholder = @"请输入要查找的车牌号";
    _carNumTex.font = [UIFont systemFontOfSize:15];
    [_carBgView addSubview:_carNumTex];
    
    // 设置自定义键盘
    int verticalCount = 5;
    CGFloat kheight = KScreenWidth/10 + 8;
    
    numInputView = [[NumInputView alloc] initWithFrame:CGRectMake(0, KScreenHeight - kheight * verticalCount, KScreenWidth, kheight * verticalCount) withClickKeyBoard:^(NSString *character) {
        _carNumTex.text = [_carNumTex.text stringByAppendingString:character];
        
    } withDelete:^{
        if(_carNumTex.text.length > 0){
            _carNumTex.text = [_carNumTex.text substringWithRange:NSMakeRange(0, _carNumTex.text.length - 1)];
        }
        
    } withConfirm:^{
        [self.view endEditing:YES];
    } withChangeKeyBoard:^{
        
        _carNumTex.inputView = keyBoardView;
        [_carNumTex reloadInputViews];
        
    }];
    [numInputView setNeedsDisplay];
    _carNumTex.inputView = numInputView;
    
    keyBoardView = [[InputKeyBoardView alloc] initWithFrame:CGRectMake(0, KScreenHeight - kheight * verticalCount, KScreenWidth, kheight * verticalCount) withClickKeyBoard:^(NSString *character) {
        _carNumTex.text = [_carNumTex.text stringByAppendingString:character];
        
        _carNumTex.inputView = numInputView;
        [_carNumTex reloadInputViews];

    } withDelete:^{
        if(_carNumTex.text.length > 0){
            _carNumTex.text = [_carNumTex.text substringWithRange:NSMakeRange(0, _carNumTex.text.length - 1)];
        }
    } withConfirm:^{
        [self.view endEditing:YES];
    } withChangeKeyBoard:^{

        _carNumTex.inputView = numInputView;
        [_carNumTex reloadInputViews];

    }];
    [keyBoardView setNeedsDisplay];
    _carNumTex.inputView = keyBoardView;
    
    _findcarBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_carNumTex.frame)+10, 0, 70, 25)];
    _findcarBtn.centerY = _carNumTex.centerY;
    [_findcarBtn setTitle:@"立即找车" forState:UIControlStateNormal];
    [_findcarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_findcarBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    _findcarBtn.layer.cornerRadius = 5;
    _findcarBtn.backgroundColor = [UIColor colorWithHexString:@"#1B82D1"];
    [_findcarBtn addTarget:self action:@selector(findCarBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_carBgView addSubview:_findcarBtn];
    
    _findcarBtn.hidden = YES;
    
    // 点击点位图弹窗
    _findCarView = [[FindCarView alloc] init];
    
//    [self hideCarBgView];
}
- (void)viewEndEdit {
    [self.view endEditing:YES];
    
    _findcarBtn.hidden = NO;
//    if (_isHide) {
//        [self showCarBgView];
//    }else{
//        [self hideCarBgView];
//    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _findcarBtn.hidden = NO;
    return YES;
}

/*
// 查询用户在停车场中的车辆
- (void)_loadUserCarData {
    NSString *urlStr = [NSString stringWithFormat:@"%@park-service/park/seatCamera/findMember/seatStatus",[kUserDefaults objectForKey:KParkUrl]];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    NSString *memberId = [[NSUserDefaults standardUserDefaults] objectForKey:KMemberId];
    if(memberId != nil){
        [params setObject:memberId forKey:@"memberId"];
    }
    [params setObject:KToken forKey:@"token"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        if([responseObject[@"success"] boolValue]){
            
            NSArray *arr = responseObject[@"data"];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                DownParkMdel *downParkMdel = [[DownParkMdel alloc] initWithDataDic:obj];
                // 过滤未停车位
                if([downParkMdel.seatIdle isEqualToString:@"1"]){
                    [_graphData addObject:downParkMdel.seatXY];
                    [_parkData addObject:downParkMdel];
                }
            }];
            
            _indoorView.graphData = _graphData;
            _indoorView.parkDownArr = _parkData;
            
        }
    } failure:^(NSError *error) {
        
    }];
}
*/

-(void)findMyCar
{
    NSString *urlStr = [NSString stringWithFormat:@"%@park-service/member/getMemberCards",[kUserDefaults objectForKey:KParkUrl]];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    NSString *memberId = [[NSUserDefaults standardUserDefaults] objectForKey:KMemberId];
    if(memberId != nil){
        [params setObject:memberId forKey:@"memberId"];
    }
    [params setObject:KToken forKey:@"token"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        if([responseObject[@"success"] boolValue]){
            NSArray *carList = responseObject[@"data"][@"carList"];
            if ([carList isKindOfClass:[NSNull class]]||carList.count == 0) {
                [self showHint:@"对不起,您没绑定车辆!"];
                return;
            }
            [carList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CarListModel *carModel = [[CarListModel alloc] initWithDataDic:obj];
                [self findMyCarInMap:carModel.carNo];
            }];
        }else{
            [self showHint:@"对不起,您没绑定车辆!"];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)findMyCarInMap:(NSString *)carNum
{
    NSString *urlStr = [NSString stringWithFormat:@"%@park-service/park/seatCamera/findByCarno",[kUserDefaults objectForKey:KParkUrl]];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:carNum forKey:@"carNo"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        if([responseObject[@"success"] boolValue]){
            NSDictionary *seatStatus = responseObject[@"data"][@"seatStatus"];
            if(![seatStatus isKindOfClass:[NSNull class]]&&seatStatus != nil){
                DownParkMdel *downParkMdel = [[DownParkMdel alloc] initWithDataDic:seatStatus];
                
                __block BOOL isInclude = NO;
                [_parkData enumerateObjectsUsingBlock:^(DownParkMdel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                    if([model.seatIdleCarno isEqualToString:downParkMdel.seatIdleCarno]){
                        isInclude = YES;
                        *stop = YES;
                    }
                }];
                
                if(!isInclude){
                    [_graphData addObject:downParkMdel.seatXY];
                    [_parkData addObject:downParkMdel];
                    
                    _indoorView.isLayCoord = YES;
                    _indoorView.graphData = _graphData;
                    _indoorView.parkDownArr = _parkData;
                }
            }
        }else{
            if (![responseObject[@"message"] isKindOfClass:[NSNull class]]&&responseObject[@"message"] != nil) {
                [self showHint:[NSString stringWithFormat:@"%@暂未入场!",carNum]];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 立即找车
-(void)findCarBtnAction {
    [self.view endEditing:YES];
    
    if (_carNumTex.text.length == 0||_carNumTex.text == nil) {
        [self showHint:@"请输入要查找的车牌号!"];
        return;
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@park-service/park/seatCamera/findByCarno",[kUserDefaults objectForKey:KParkUrl]];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:_carNumTex.text forKey:@"carNo"];
    
    [self showHudInView:self.view hint:@""];
    [[NetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if([responseObject[@"success"] boolValue]){
            NSDictionary *seatStatus = responseObject[@"data"][@"seatStatus"];
            if(![seatStatus isKindOfClass:[NSNull class]]&&seatStatus != nil){
                DownParkMdel *downParkMdel = [[DownParkMdel alloc] initWithDataDic:seatStatus];
                
                __block BOOL isInclude = NO;
                [_parkData enumerateObjectsUsingBlock:^(DownParkMdel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                    if([model.seatIdleCarno isEqualToString:downParkMdel.seatIdleCarno]){
                        isInclude = YES;
                        *stop = YES;
                    }
                }];
                
                if(!isInclude){
                    [_graphData addObject:downParkMdel.seatXY];
                    [_parkData addObject:downParkMdel];
                    
                    _indoorView.isLayCoord = YES;
                    _indoorView.graphData = _graphData;
                    _indoorView.parkDownArr = _parkData;
                }
                
                // 滑动到指定位置
                if(![downParkMdel.seatXY isKindOfClass:[NSNull class]]&&downParkMdel.seatXY != nil){
                    NSArray *pointAry = [downParkMdel.seatXY componentsSeparatedByString:@","];
                    if(pointAry != nil && pointAry.count >= 2){
                        NSString *pointX = pointAry.firstObject;
                        NSString *pointY = pointAry.lastObject;
                        [self mapToPoint:CGPointMake(pointX.floatValue, pointY.floatValue)];
                    }
                }
                
                // 更改搜索到车位图标
                [_parkData enumerateObjectsUsingBlock:^(DownParkMdel *seaDownParkMdel, NSUInteger idx, BOOL * _Nonnull stop) {
                    if([downParkMdel.seatNo isEqualToString:seaDownParkMdel.seatNo]){
                        if(_searchDownParkMdel != nil){
                            [_indoorView normalCarIcon:_searchDownParkMdel withIndex:[_parkData indexOfObject:_searchDownParkMdel]];
                        }
                        [_indoorView updateCarIcon:seaDownParkMdel withIndex:idx];
                        _searchDownParkMdel = seaDownParkMdel;
                        *stop = YES;
                    }
                }];
                
                // 显示菜单
                _findCarView.downParkMdel = downParkMdel;
                _findCarView.hidden = NO;
            }
            
        }else {
            [self showHint:@"对不起,该车辆暂未停在地下车库!"];
        }
        
    } failure:^(NSError *error) {
        [self hideHud];
        YYReachability *rech = [YYReachability reachability];
        if (!rech.reachable) {
            [self showHint:@"网络不给力,请重试!"];
        }else{
            [self showHint:@"查询失败!"];
        }
    }];
}

#pragma mark 点位图代理
- (void)selInMapWithId:(NSString *)identity {
    
    NSInteger selIndex = identity.integerValue - 100;
    if(_parkData.count > selIndex){
        DownParkMdel *parkModel = _parkData[selIndex];
        _findCarView.downParkMdel = parkModel;
        _findCarView.hidden = NO;
        
        if(_searchDownParkMdel != nil){
            // 去除搜索标记图标
            [_indoorView normalCarIcon:_searchDownParkMdel withIndex:[_parkData indexOfObject:_searchDownParkMdel]];
        }
        [_indoorView updateCarIcon:parkModel withIndex:[_parkData indexOfObject:parkModel]];
        _searchDownParkMdel = parkModel;
    }
}

- (void)mapToPoint:(CGPoint)point {
    // 地图滑动到搜索位置
    CGFloat difWidth = _indoorView.width;
    CGFloat difHeight = _indoorView.height;
    if(_indoorView.mapView.width < difWidth){
        difWidth = _indoorView.mapView.width;
    }
    if(_indoorView.mapView.height < difHeight){
        difHeight = _indoorView.mapView.height;
    }
    
    difWidth = 0;
    difHeight = 0;
    CGPoint mapPoint = CGPointMake(_indoorView.contentSize.width/_indoorView.mapView.image.size.width * point.x - difWidth, _indoorView.contentSize.height/_indoorView.mapView.image.size.height * point.y - difHeight);
    
    [_indoorView setContentOffset:mapPoint animated:YES];
}

//-(void)hideCarBgView
//{
//    _isHide = YES;
//    [UIView animateWithDuration:0.6 animations:^{
//        _carBgView.frame = CGRectMake(0, -45, KScreenWidth, 45);
//    }];
//}
//
//-(void)showCarBgView
//{
//    _isHide = NO;
//    [UIView animateWithDuration:0.6 animations:^{
//        _carBgView.frame = CGRectMake(0, 0, KScreenWidth, 45);
//    }];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
