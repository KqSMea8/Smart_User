//
//  AppDelegate.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/11/30.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "AppDelegate.h"
#import <sys/sysctl.h>
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>
#import <SAMKeychain.h>
#import <iflyMSC/iflyMSC.h>

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //程序启动后创建DPSDK句柄
    struct sigaction sa;
    sa.sa_handler = SIG_IGN;
    sigaction(SIGPIPE, &sa, 0);
    
    //初始化window
    [self initWindow];
    //初始化UMeng
    [self initUMeng];
    //初始化极光推送
    [self initJPush:launchOptions];
    //初始化讯飞语音识别
    [self initIFly];
    
//    [self initWechatPay];
    //获取设备唯一ID并存储在keychain
    NSString *uuid = [self getDeviceId];
    [kUserDefaults setObject:uuid forKey:kDeveicedID];
    [kUserDefaults synchronize];
    
    // 保存信息
    [self saveDeviceModel];
    
    return YES;
}

#pragma mark ————— 初始化window —————
-(void)initWindow{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = KWhiteColor;
    [self.window makeKeyAndVisible];
    
    [[UIButton appearance] setExclusiveTouch:YES];
    //    [[UIButton appearance] setShowsTouchWhenHighlighted:YES];
    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = KWhiteColor;
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
    if (![kUserDefaults boolForKey:@"notFirst"]) {
        // 如果是第一次进入引导页
        self.window.rootViewController = [[GuideViewController alloc] init];
    }
    else{
        // 否则直接进入应用
        if ([kUserDefaults objectForKey:KLoginStatus]) {
            //1、初始化控制器
            self.mainTabBar = [RoottabbarController new];
            self.window.rootViewController = self.mainTabBar;
        }else{
            UINavigationController *navVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginNavViewController"];
            self.window.rootViewController = navVC;
        }
    }
}

- (NSString *)getDeviceId
{
    NSString *appName=[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    NSString * currentDeviceUUIDStr = [SAMKeychain passwordForService:appName account:@"incoding"];
    if (currentDeviceUUIDStr == nil || [currentDeviceUUIDStr isEqualToString:@""])
    {
        NSUUID * currentDeviceUUID  = [UIDevice currentDevice].identifierForVendor;
        currentDeviceUUIDStr = currentDeviceUUID.UUIDString;
        [SAMKeychain setPassword:currentDeviceUUIDStr forService:appName account:@"incoding"];
    }
    return currentDeviceUUIDStr;
}

-(void)initUMeng
{
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMengKey];
    
    [self configUSharePlatforms];
    
    [self confitUShareSettings];
}

-(void)initIFly
{
    //Set log level
    [IFlySetting setLogFile:LVL_ALL];
    
    //Set whether to output log messages in Xcode console
    [IFlySetting showLogcat:YES];
    
    //Set the local storage path of SDK
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];
    
    //Set APPID
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",kIFLYKey];
    
    //Configure and initialize iflytek services.(This interface must been invoked in application:didFinishLaunchingWithOptions:)
    [IFlySpeechUtility createUtility:initString];
}

-(void)initWechatPay
{
    [WXApi registerApp:@"wx37f08037003f60d1"];
}

#pragma mark ---------友盟配置-------------

- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //    [UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
}

- (void)configUSharePlatforms
{
    /*
     设置微信的appKey和appSecret
     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kAppKey_Wechat appSecret:kSecret_Wechat redirectURL:kredirectURL_Wechat];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     100424468.no permission of union id
     [QQ/QZone平台集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_3
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:kAppKey_Tencent/*设置QQ平台的appID*/  appSecret:nil redirectURL:kredirectURL_Tencent];
    
    /*
     设置新浪的appKey和appSecret
     [新浪微博集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_2
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:kAppKey_Sina  appSecret:kAppSecret_Sina redirectURL:kredirectURL_Sina];
    
}

#pragma mark ————— OpenURL 回调 —————
// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
        if ([url.host isEqualToString:@"safepay"]) {
            //支付跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                DLog(@"%@",resultDic);
                
            }];
        }else{
            return [WXApi handleOpenURL:url delegate:self];
        }
    }else{
        return [[UMSocialManager defaultManager] handleOpenURL:url];
    }
    
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        if ([url.host isEqualToString:@"safepay"]) {
            // 支付跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
    
                NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
                
                if (orderState==9000) {
                    NSString *allString=resultDic[@"result"];
                    NSString * FirstSeparateString=@"\"&";
                    NSString *  SecondSeparateString=@"=\"";
                    NSMutableDictionary *dic=[self componentsStringToDic:allString withSeparateString:FirstSeparateString AndSeparateString:SecondSeparateString];
                    NSLog(@"ali=%@",dic);
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"alipaySuccess" object:nil];
                    
                }else{
                    NSString *returnStr;
                    switch (orderState) {
                        case 8000:
                            returnStr=@"订单正在处理中";
                            break;
                        case 4000:
                            returnStr=@"订单支付失败";
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"alipayfa" object:nil];
                            break;
                        case 6001:
                            returnStr=@"订单取消";
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"alipayDidntFinsh" object:nil];
                            break;
                        case 6002:
                            returnStr=@"网络连接出错";
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"alipayNetWor" object:nil];
                            break;
                            
                        default:
                            break;
                    }
                    
                }
            }];
            
        }else{
            return [WXApi handleOpenURL:url delegate:self];
        }
    }else{
        return [[UMSocialManager defaultManager] handleOpenURL:url];
    }
    return YES;
}

//微信SDK自带的方法，处理从微信客户端完成操作后返回程序之后的回调方法,显示支付结果的
-(void) onResp:(BaseResp*)resp
{
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp*response=(PayResp*)resp;
        switch (response.errCode) {
            case WXSuccess:
            {// 支付成功，向后台发送消息
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WX_PaySuccess" object:nil];
                
            }
                break;
            case WXErrCodeCommon:
            { //签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等
                
                
            }
                break;
            case WXErrCodeUserCancel:
            { //用户点击取消并返回
                
            }
                break;
            case WXErrCodeSentFail:
            { //发送失败
                
            }
                break;
            case WXErrCodeUnsupport:
            { //微信不支持
                
            }
                break;
            case WXErrCodeAuthDeny:
            { //授权失败
                
            }
                break;
            default:
                break;
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EnterBackgroundNotification" object:nil];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // 后台到前台
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EnterForegroundAlert" object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)saveDeviceModel{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    NSString *deviceModel = @"";
    
    if ([platform isEqualToString:@"iPhone1,1"]) deviceModel = @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) deviceModel = @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) deviceModel = @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) deviceModel = @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) deviceModel = @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) deviceModel = @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) deviceModel = @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) deviceModel = @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) deviceModel = @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) deviceModel = @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) deviceModel = @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) deviceModel = @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) deviceModel = @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) deviceModel = @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) deviceModel = @"iPhone 6 (A1549/A1586)";
    if ([platform isEqualToString:@"iPhone8,1"]) deviceModel = @"iPhone 6S";
    if ([platform isEqualToString:@"iPhone8,2"]) deviceModel = @"iPhone 6S Plus";
    if ([platform isEqualToString:@"iPhone8,4"]) deviceModel = @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"]) deviceModel = @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"]) deviceModel = @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone10,1"]) deviceModel = @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,4"]) deviceModel = @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"]) deviceModel = @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,5"]) deviceModel = @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"]) deviceModel = @"iPhone X";
    
    [[NSUserDefaults standardUserDefaults] setObject:deviceModel forKey:KDeviceModel];
    
}

-(NSMutableDictionary *)componentsStringToDic:(NSString*)AllString withSeparateString:(NSString *)FirstSeparateString AndSeparateString:(NSString *)SecondSeparateString{
    
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    
    NSArray *FirstArr=[AllString componentsSeparatedByString:FirstSeparateString];
    
    for (int i=0; i<FirstArr.count; i++) {
        NSString *Firststr=FirstArr[i];
        NSArray *SecondArr=[Firststr componentsSeparatedByString:SecondSeparateString];
        [dic setObject:SecondArr[1] forKey:SecondArr[0]];
    }
    
    return dic;
}

-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (self.allowRotation) {//如果设置了allowRotation属性，支持全屏
        return UIInterfaceOrientationMaskAll;
    }
    return UIInterfaceOrientationMaskPortrait;//默认全局不支持横屏
}

@end
