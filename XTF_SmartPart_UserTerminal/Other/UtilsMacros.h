//
//  UtilsMacros.h
//  ZHYQ
//
//  Created by 焦平 on 2017/10/22.
//  Copyright © 2017年 焦平. All rights reserved.
//

#ifndef UtilsMacros_h
#define UtilsMacros_h

//获取系统对象
#define kApplication        [UIApplication sharedApplication]
#define kAppWindow          [UIApplication sharedApplication].delegate.window
#define kAppDelegate        [AppDelegate shareAppDelegate]
#define kRootViewController [UIApplication sharedApplication].delegate.window.rootViewController
#define kUserDefaults       [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]

#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight 44.0
#define kTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define kTopHeight (kStatusBarHeight + kNavBarHeight)

#define PADDING_OF_LEFT_STEP_LINE 15
#define PADDING_OF_LEFT_RIGHT 15
#define WIDTH_OF_PROCESS_LABLE (300 *[UIScreen mainScreen].bounds.size.width / 375)

//主线程运行
#define RunOnMainThread(code)   {dispatch_async(dispatch_get_main_queue(), ^{code;});}

#define MSG(title,msg,ok)  if(msg != nil && [msg length]>0) {\
[[DHHudPrecess sharedInstance] ShowTips:msg delayTime:1.5  atView:nil];}\

//获取屏幕宽高
#define KScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define KScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kScreen_Bounds [UIScreen mainScreen].bounds

//判断是否是iPhone X
#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

// 判断是否是iPhone5
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)]\
? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)\
|| CGSizeEqualToSize(CGSizeMake(1136, 640), [[UIScreen mainScreen] currentMode].size) : NO)

#define wScale KScreenWidth/375.0
#define hScale KScreenHeight/667.0

//根据ip6的屏幕来拉伸
#define kRealValue(with) ((with)*(KScreenWidth/375.0f))

//强弱引用
#define kWeakSelf(type)  __weak typeof(type) weak##type = type;
#define kStrongSelf(type) __strong typeof(type) type = weak##type;

//View 圆角和加边框
#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

// View 圆角
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

//property 属性快速声明 别用宏定义了，使用代码块+快捷键实现吧

///IOS 版本判断
#define IOSAVAILABLEVERSION(version) ([[UIDevice currentDevice] availableVersion:version] < 0)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
// 当前系统版本
#define CurrentSystemVersion [[UIDevice currentDevice].systemVersion doubleValue]
//当前语言
#define CurrentLanguage (［NSLocale preferredLanguages] objectAtIndex:0])

#define iOS10 ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0)

//-------------------打印日志-------------------------
//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

//主线程运行
#define RunOnMainThread(code)   {dispatch_async(dispatch_get_main_queue(), ^{code;});}

//拼接字符串
#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]

//颜色
#define KClearColor [UIColor clearColor]
#define KWhiteColor [UIColor whiteColor]
#define KBlackColor [UIColor blackColor]
#define KGrayColor [UIColor grayColor]
#define KGray2Color [UIColor lightGrayColor]
#define KBlueColor [UIColor blueColor]
#define KRedColor [UIColor redColor]
#define kRandomColor    KRGBColor(arc4random_uniform(256)/255.0,arc4random_uniform(256)/255.0,arc4random_uniform(256)/255.0)        //随机色生成

//字体
#define BOLDSYSTEMFONT(FONTSIZE)[UIFont boldSystemFontOfSize:FONTSIZE]
#define SYSTEMFONT(FONTSIZE)    [UIFont systemFontOfSize:FONTSIZE]
#define FONT(NAME, FONTSIZE)    [UIFont fontWithName:(NAME) size:(FONTSIZE)]


//定义UIImage对象
#define ImageWithFile(_pointer) [UIImage imageWithContentsOfFile:([[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@%dx", _pointer, (int)[UIScreen mainScreen].nativeScale] ofType:@"png"])]
#define IMAGE_NAMED(name) [UIImage imageNamed:name]

//数据验证
#define StrValid(f) (f!=nil && [f isKindOfClass:[NSString class]] && ![f isEqualToString:@""])
#define SafeStr(f) (StrValid(f) ? f:@"")
#define HasString(str,key) ([str rangeOfString:key].location!=NSNotFound)

#define ValidStr(f) StrValid(f)
#define ValidDict(f) (f!=nil && [f isKindOfClass:[NSDictionary class]])
#define ValidArray(f) (f!=nil && [f isKindOfClass:[NSArray class]] && [f count]>0)
#define ValidNum(f) (f!=nil && [f isKindOfClass:[NSNumber class]])
#define ValidClass(f,cls) (f!=nil && [f isKindOfClass:[cls class]])
#define ValidData(f) (f!=nil && [f isKindOfClass:[NSData class]])

//获取一段时间间隔
#define kStartTime CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
#define kEndTime  NSLog(@"Time: %f", CFAbsoluteTimeGetCurrent() - start)
//打印当前方法名
#define ITTDPRINTMETHODNAME() ITTDPRINT(@"%s", __PRETTY_FUNCTION__)


//发送通知
#define KPostNotification(name,obj) [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj];

//单例化一个类
#define SINGLETON_FOR_HEADER(className) \
\
+ (className *)shared##className;

#define SINGLETON_FOR_CLASS(className) \
\
+ (className *)shared##className { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}

#define single_interface(class)  + (class *)shared##class;

// .m
// \ 代表下一行也属于宏
// ## 是分隔符
#define single_implementation(class) \
static class *_instance; \
\
+ (class *)shared##class \
{ \
if (_instance == nil) { \
_instance = [[self alloc] init]; \
} \
return _instance; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
}

// 保存本地宏
#define KDeviceModel @"phoneDeviceModel"
#define KPushRegisterId @"pushRegisterId"

//#define KuserModel @"userModel"
#define KLoginStatus @"loginStatus"

#define KAppScheme @"YQAlipayScheme"

#define kCustId @"custId"   //客户id
#define KUserCertId @"userCertId" // 登录员工id  仅员工登录才有
#define KLoginWay @"loginWay"
#define KLogin @"login"     // 正常登录 员工
#define KAuthLoginMobile @"authLoginMobile" // 第三方绑定手机号登录 访客
#define KAuthLogin @"authLogin"  // 第三方未绑定手机号登录 游客

#define KUserPhoneNum @"userPhoneNum"   // 手机号(访客、员工有  访客无)
#define KLoginPasword @"kloginpassword" //用户密码

#define kUserAccount  @"kuseraccount"   // 记住密码保存用户名
#define kUserPwd      @"kuserpassword"  // 记住密码保存密码

#define isRememberPwd @"isRememberPassWord"

#define KUserCustName @"custName"         // 真实姓名
#define KUserSex      @"usersex"          // 性别
#define kUserBirthDay  @"userbirthday"    // 出生日期

#define KAuthName  @"authname"   //第三方登录名
#define KAuthId @"authId"   // 第三方登录id
#define KAuthType @"authType"   // 第三方登录方式 / qq:2 wechat:3 weibo:4

#define KParkId @"8a04a41f56bc33a20156bc3726df0004"
#define KAreaId @"8a04a41f56c0c3f90157277802150065"

#define KMemberId @"parkMemberId"
#define KToken @"445291AA6C27A051821DA0F99CADE332"  // 固定token请求

#define UserbindSuccess @"UserbindSuccess"

#define isSetPwd @"pwdExist"  //登录密码是否存在

#define isSetPayPwd @"payWwdExist"  //支付密码是否存在

#define isAllowSmallPay @"smallPayNopwd"  //是否允许小额支付

#define AESKey @"660c345cf08a4829"

#define isJumpOverGuide @"jumpoverguide"

#define KMonitorInfo @"monitorInfo"  // 大华sdk登录信息

#define KPublicKey @"HNTFZHCY"  // DES公钥

#define KParkUrl @"parkurl"   //停车接口地址
#define isBindCar @"isbindcar" //是否绑定了车辆

// 版本更新提醒信息
#define KAlertTime @"alertTime"         // 提醒时间
#define KDifferVersion @"differVersion" // 相差版本数
#define KAlertNum @"alertNum"           // 提醒次数

// 密码长时间未修改
#define KPwdAlertTime @"pwdalerttime"   // 提醒时间
#define KIsShowPwdAlert @"isShowPwdAlert" 

#define KNeedRemain @"needremain"       // 需要提醒

//考勤公共参数
#define kqPosition @"attendancePosition"
#define kqTime @"attendanceTime"
#define kqRange @"attendanceRange"
#define kqDeviation @"attendanceDeviation"

#define companyID @"companyid" //公司ID
#define OrgId @"orgid" //部门ID
#define KFACE_IMAGE_ID @"faceimageid"

//失效token
#define kUserLoginToken @"kuserlogintoken"

#endif /* UtilsMacros_h */
