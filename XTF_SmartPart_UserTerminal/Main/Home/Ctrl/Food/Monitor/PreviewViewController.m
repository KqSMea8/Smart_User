//
//  PreviewViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/11/7.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "PreviewViewController.h"

#import "DHPlayWindow.h"
#import "DHDataCenter.h"
#import "DHLoginManager.h"
#import "DPSRTCamera.h"

@interface PreviewViewController ()
{
    UIButton *_colseBt;
    BOOL _isHidBar;
}

@property (copy, nonatomic) NSString *selectChannelId;
//playwindow
@property (retain, nonatomic) DHPlayWindow *playWindow;
//播放视图 playwindow backgroundview
@property (retain, nonatomic) UIView *playWndView;

@end

@implementation PreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    
    [self initView];
}

-(void)initNav{
    self.title = @"就餐热度";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor blackColor];
    
    UIButton *leftBtn = [[UIButton alloc] init];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [leftBtn setImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(_leftBarBtnItemClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    // 禁止左滑
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
}

-(void)initView
{
    self.playWindow = [[DHPlayWindow alloc] initWithFrame:CGRectMake(0, (KScreenHeight - 64 - 293*hScale)/2, KScreenWidth, 293*hScale)];
    [self.view addSubview:self.playWindow];
    
    self.playWndView = [[UIView alloc] initWithFrame:CGRectMake(0, (KScreenHeight - 64 - 293*hScale)/2, KScreenWidth, 293*hScale)];
    self.playWndView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.playWndView];
    
    UITapGestureRecognizer *fullTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fullAction)];
    fullTap.numberOfTapsRequired = 2;
    [self.playWndView addGestureRecognizer:fullTap];
    
    _colseBt = [UIButton buttonWithType:UIButtonTypeCustom];
    _colseBt.hidden = YES;
    _colseBt.frame = CGRectMake(KScreenWidth - 80, KScreenHeight - 60, 50, 50);
    if(KScreenWidth > 440){ // ipad
        _colseBt.frame = CGRectMake(KScreenWidth - 80, KScreenHeight - 60 , 50, 50);
    }else {
        _colseBt.frame = CGRectMake(KScreenWidth - 80, KScreenHeight - 60 , 50, 50);
    }
    [_colseBt setBackgroundImage:[UIImage imageNamed:@"show_menu_close"] forState:UIControlStateNormal];
    [_colseBt addTarget:self action:@selector(closeFull) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_colseBt];
    
    //初始化就播放窗口数，正常情况下，使用1。 init play window count(default:1)
    [self.playWindow defultwindows:1];
    DSSUserInfo* userinfo = [DHLoginManager sharedInstance].userInfo;
    NSString *host = [[DHDataCenter sharedInstance] getHost];
    int port = [[DHDataCenter sharedInstance] getPort];
    [self.playWindow setHost:host Port:port UserName:userinfo.userName];
    self.playWindow.hideDefultToolViews = YES;
    
    self.selectChannelId = @"1000229$1$0$0";
    [self startToplay:self.selectChannelId winIndex:0 streamType:0];
}

- (void)startToplay:(NSString *)local_channelId winIndex:(int)winIndex streamType:(int)streamType{
    DSSUserInfo* userinfo = [DHLoginManager sharedInstance].userInfo;
    NSNumber* handleDPSDKEntity = (NSNumber*)[userinfo getInfoValueForKey:kUserInfoHandleDPSDKEntity];
    //  NSString* handleRestToken = [[DHDataCenter sharedInstance] getLoginToken];
    DPSRTCamera* ymCamera = [[DPSRTCamera alloc] init];
    ymCamera.dpHandle = [handleDPSDKEntity longValue];
    ymCamera.cameraID = local_channelId;
    //  ymCamera.dpRestToken = handleRestToken;
    ymCamera.server_ip = [[DHDataCenter sharedInstance] getHost];
    ymCamera.server_port = [[DHDataCenter sharedInstance] getPort];
    ymCamera.isCheckPermission = YES;
    ymCamera.mediaType = 1;
    //如果支持三码流，就默认播放辅码流，只有在用户主动选择三码流时才会去播放三码流
    //default stream ：subStream
    DSSChannelInfo* channelInfo = (DSSChannelInfo *)[DHDataCenter sharedInstance].selectNode.content;
    DSSDeviceInfo *deviceInfo = [[DHDeviceManager sharedInstance] getDeviceInfo:[channelInfo deviceId]];
    if ([self isThirdStreamSupported:local_channelId]) {
        ymCamera.streamType = 2;
    } else {
        if ([self isSubStreamSupported:local_channelId]) {
            ymCamera.streamType = 2;
        } else {
            ymCamera.streamType = 1;
        }
    }
    [self.playWindow playCamera:ymCamera withName:channelInfo.name at:winIndex deviceProvide:deviceInfo.deviceProvide];
    
}

- (BOOL)isSubStreamSupported:(NSString *)channelIDStr{
    if (channelIDStr != nil || ![channelIDStr isEqualToString:@""]) {
        DSSChannelInfo* channelInfo = (DSSChannelInfo *)[DHDataCenter sharedInstance].selectNode.content;
        if(channelInfo.encChannelInfo.streamtypeSupported == 2){
            return YES;
        }
        return NO;
    }
    return NO;
}
- (BOOL)isThirdStreamSupported:(NSString *)channelIDStr{
    if (channelIDStr != nil || ![channelIDStr isEqualToString:@""]) {
        DSSChannelInfo* channelInfo = (DSSChannelInfo *)[DHDataCenter sharedInstance].selectNode.content;
        if(channelInfo.encChannelInfo.streamtypeSupported == 3){
            return YES;
        }
        return NO;
    }
    return NO;
}

//-(BOOL)prefersStatusBarHidden {
//    [super prefersStatusBarHidden];
//    return _isHidBar;
//}

- (void)_leftBarBtnItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

// 全屏显示
- (void)fullAction {
    _isHidBar = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self setNeedsStatusBarAppearanceUpdate];
    self.navigationController.navigationBar.hidden = YES;
    _colseBt.hidden = NO;
    self.playWndView.userInteractionEnabled = NO;
    
    // 改变视频frame
    self.playWindow.transform = CGAffineTransformRotate(self.playWindow.transform, M_PI_2);
    if(KScreenWidth > 440){ // ipad
        self.playWindow.frame = CGRectMake(KScreenWidth, 0, -KScreenWidth, KScreenHeight);
    }else {
        self.playWindow.frame = CGRectMake(KScreenWidth, 0, -KScreenWidth, KScreenHeight);
    }
}
- (void)closeFull {
    _isHidBar = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self setNeedsStatusBarAppearanceUpdate];
    self.navigationController.navigationBar.hidden = NO;
    _colseBt.hidden = YES;
    self.playWndView.userInteractionEnabled = YES;
    
    self.playWindow.transform = CGAffineTransformRotate(self.playWindow.transform, -M_PI_2);
    self.playWindow.frame = CGRectMake(0, (KScreenHeight - 64 - 293*hScale)/2, KScreenWidth, 293*hScale);
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.playWindow stop:0];
}

@end
