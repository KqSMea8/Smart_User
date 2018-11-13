//
//  KqTabbarViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/4.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "KqTabbarViewController.h"
#import "KqViewController.h"
#import "KqCountViewController.h"
#import "DKViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "YQTabbar.h"
#import "RootNavigationController.h"
#import "UITabBar+CustomBadge.h"
#import <CoreGraphics/CoreGraphics.h>
#import "KQDKViewController.h"
#import <UShareUI/UShareUI.h>
#import <WXApi.h>
#import "AttendanceDetailViewController.h"

@interface KqTabbarViewController ()<UITabBarControllerDelegate>
{
    UIButton *rightBtn;
    UIImage *image;
}

@property (nonatomic, assign) UIStatusBarStyle StatusBarStyle;

@end

@implementation KqTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initView];
    
    [kNotificationCenter addObserver:self selector:@selector(tabbarDidSelectItem) name:@"tabbarDidSelectItemNotification" object:nil];
    
    for (UITabBarItem *item in self.tabBar.items) {
        item.selectedImage = [item.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        item.image = [item.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //item.title
    }
};

- (UIStatusBarStyle)preferredStatusBarStyle{
    return _StatusBarStyle;
}

//动态更新状态栏颜色
-(void)setStatusBarStyle:(UIStatusBarStyle)StatusBarStyle{
    _StatusBarStyle=StatusBarStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}

-(void)setTitleStr:(NSString *)titleStr
{
    _titleStr = titleStr;
}

- (void)_initView {
    if (_titleStr == nil||[_titleStr isKindOfClass:[NSNull class]]) {
        self.title = @"员工考勤";
    }else{
        self.title = _titleStr;
    }
    
    self.StatusBarStyle = UIStatusBarStyleLightContent;
    
    //未选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:12]} forState:UIControlStateNormal];
    //选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:12]} forState:UIControlStateSelected];
    self.tabBar.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    
    self.delegate = self;
    
    UIButton *leftBtn = [[UIButton alloc] init];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [leftBtn setImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(_leftBarBtnItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    rightBtn = [[UIButton alloc] init];
    rightBtn.hidden = YES;
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    [rightBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

-(void)_leftBarBtnItemClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClick {
    image = [self snapshotViewFromRect:CGRectMake(0, 0, KScreenWidth, KScreenHeight-49-kTopHeight) withCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[UIFont systemFontOfSize:23] forKey:NSFontAttributeName];
    [dic setValue:[UIColor colorWithHexString:@"#c7c7c7"] forKey:NSForegroundColorAttributeName];
    
    image = [self jx_WaterImageWithImage:image text:[kUserDefaults objectForKey:KUserCustName] textPoint:CGPointMake(30, 140) attributedString:dic];
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [self shareWebPageToPlatformType:platformType];
        
    }];
    
    [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.shareTitleViewTitleString = @"分享至";
}

// 给图片添加文字水印：
- (UIImage *)jx_WaterImageWithImage:(UIImage *)image text:(NSString *)text textPoint:(CGPoint)point attributedString:(NSDictionary * )attributed{
    //1.开启上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    //2.绘制图片
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    //添加水印文字
    [text drawAtPoint:point withAttributes:attributed];
    //3.从上下文中获取新图片
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    //4.关闭图形上下文
    UIGraphicsEndImageContext();
    //返回图片
    return newImage;
}

- (UIImage *)snapshotViewFromRect:(CGRect)rect withCapInsets:(UIEdgeInsets)capInsets {

    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(currentContext, - CGRectGetMinX(rect), - CGRectGetMinY(rect));
    [self.view.layer renderInContext:currentContext];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    UIImageView *snapshotView = [[UIImageView alloc] initWithFrame:rect];
    snapshotView.image = [snapshotImage resizableImageWithCapInsets:capInsets];
    return snapshotView.image;
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    YYReachability *rech = [YYReachability reachability];
    if (!rech.reachable) {
        [self showHint:@"网络不给力,请重试!"];
        return;
    }
    BOOL isInstallWeChat = [[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"weixin://"]];
    switch (platformType) {
        case UMSocialPlatformType_WechatTimeLine:
            
            if (!isInstallWeChat) {
                [self showHint:@"请先安装微信!"];
                return;
            }
            break;
        case UMSocialPlatformType_WechatSession:
            if (!isInstallWeChat) {
                [self showHint:@"请先安装微信!"];
                return;
            }
            break;
        case UMSocialPlatformType_Sina:
            if (![[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_Sina]) {
                [self showHint:@"请先安装新浪微博!"];
                return;
            }
            break;
        case UMSocialPlatformType_QQ:
            if (![[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ]) {
                [self showHint:@"请先安装QQ!"];
                return;
            }
            break;
        case UMSocialPlatformType_Qzone:
            if (![[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_Qzone]) {
                [self showHint:@"请先安装QQ!"];
                return;
            }
            break;
        default:
            break;
    }
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    if (platformType == UMSocialPlatformType_WechatTimeLine) {

        UMShareImageObject *imageObject = [[UMShareImageObject alloc] init];
        [imageObject setShareImage:image];
        //分享消息对象设置分享内容对象
        messageObject.shareObject = imageObject;
        
    }else if(platformType == UMSocialPlatformType_Sina){
        UMShareImageObject *imageObject = [[UMShareImageObject alloc] init];
        [imageObject setShareImage:image];
        messageObject.shareObject = imageObject;
    }else{
        //创建网页内容对象
        UMShareImageObject *imageObject = [[UMShareImageObject alloc] init];
        [imageObject setShareImage:image];
        //分享消息对象设置分享内容对象
        messageObject.shareObject = imageObject;
    }
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            [self showHint:@"分享取消!"];
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            [self showHint:@"分享成功!"];
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    return YES;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    // 此协议方法执行完成 self.selectedIndex才会改变，故取反
//    if(self.selectedIndex == 0){
//        
//        rightBtn.hidden = NO;
////        self.title = @"今日考勤";
//    }else if(self.selectedIndex == 1){
//        rightBtn.hidden = YES;
////        self.title = @"统计";
//    }
}

-(void)tabbarDidSelectItem{
    if(self.selectedIndex == 0){
        rightBtn.hidden = YES;
        //        self.title = @"今日考勤";
    }else if(self.selectedIndex == 1){
        rightBtn.hidden = NO;
        //        self.title = @"统计";
    }else{
        rightBtn.hidden = YES;
    }
}

-(void)dealloc
{
    [kNotificationCenter removeObserver:self name:@"tabbarDidSelectItemNotification" object:nil];
}

@end
