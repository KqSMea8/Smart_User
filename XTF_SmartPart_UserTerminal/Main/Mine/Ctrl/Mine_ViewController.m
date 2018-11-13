//
//  Mine_ViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/6/8.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "Mine_ViewController.h"
#import "HomeCollectionViewCell.h"
#import "MineHeaderView.h"
#import "PersonMsgModel.h"
#import "FirstMenuModel.h"
#import "AESUtil.h"
#import "KqTabbarViewController.h"
#import "BindTableViewController.h"
#import "MyPurseTableViewController.h"
#import "MyCarViewController.h"
#import "ParkRecordsViewController.h"
#import "HumanFaceViewController.h"
#import "BookRecordViewController.h"
#import "SetTableViewController.h"
#import "MyInfomatnTabViewController.h"
#import "QuickRechargeViewController.h"
#import <UShareUI/UShareUI.h>
#import <WXApi.h>

@interface Mine_ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,MineHeaderDelegate>
{
    PersonMsgModel *model;
    NSString *money;
    NSMutableDictionary *_kqParams;
    NSMutableDictionary *_walletParams;
    NSMutableDictionary *_carParams;
    NSMutableDictionary *_parkRecordParams;
    NSMutableDictionary *_humanFaceParams;
    NSMutableDictionary *_bookRecordParams;
    NSMutableDictionary *_setParams;
}

@property (nonatomic,strong) UICollectionView *canDragCollectionView;
@property (nonatomic,retain) NSMutableArray *dataArr;

@end

@implementation Mine_ViewController

-(NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self _loadData];
    //获取用户余额
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KLogin]) {
        [self _loadBalanceData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#252E44"];
    
    [self initCollectionView];
    
    [self createDataArr];
    
    [self _loadBalanceData];
    
    [self _loadData];
}

-(void)createDataArr{
    
    _kqParams = @{@"MENU_NAME": @"考勤统计",@"MENU_ICON": @"home_sign",@"MENU_ID":@1}.mutableCopy;
    _walletParams = @{@"MENU_NAME": @"我的钱包",@"MENU_ICON": @"mine_purse",@"MENU_ID":@2}.mutableCopy;
    _carParams = @{@"MENU_NAME": @"我的车辆",@"MENU_ICON": @"mine_car",@"MENU_ID":@3}.mutableCopy;
    _parkRecordParams = @{@"MENU_NAME": @"停车记录",@"MENU_ICON": @"mine_park_all",@"MENU_ID":@4}.mutableCopy;
    _humanFaceParams = @{@"MENU_NAME": @"人像信息",@"MENU_ICON": @"humanface",@"MENU_ID":@5}.mutableCopy;
    _bookRecordParams = @{@"MENU_NAME": @"预约记录",@"MENU_ICON": @"bookRecord",@"MENU_ID":@6}.mutableCopy;
//    _setParams = @{@"MENU_NAME": @"设置",@"MENU_ICON": @"mine_set",@"MENU_ID":@7}.mutableCopy;
    
    [self.dataArr addObject:[[FirstMenuModel alloc] initWithDataDic:_kqParams]];
    [self.dataArr addObject:[[FirstMenuModel alloc] initWithDataDic:_walletParams]];
    [self.dataArr addObject:[[FirstMenuModel alloc] initWithDataDic:_carParams]];
    [self.dataArr addObject:[[FirstMenuModel alloc] initWithDataDic:_parkRecordParams]];
    [self.dataArr addObject:[[FirstMenuModel alloc] initWithDataDic:_humanFaceParams]];
    [self.dataArr addObject:[[FirstMenuModel alloc] initWithDataDic:_bookRecordParams]];
//    [self.dataArr addObject:[[FirstMenuModel alloc] initWithDataDic:_setParams]];
}

#pragma mark 获取用户账户余额
-(void)_loadBalanceData
{
    NSString *custId = [kUserDefaults objectForKey:kCustId];
    NSString *urlStr = [NSString stringWithFormat:@"%@/rechargeOrder/getBalance",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:custId forKey:@"custId"];
    
    [[NetworkClient sharedInstance] GET:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            NSDictionary *dic = responseObject[@"responseData"];
            NSString *balance = dic[@"balance"];
            balance = [AESUtil decryptAES:balance key:AESKey];
            money = [NSString stringWithFormat:@"%.2f元",[balance floatValue]/100.00];
            [self.canDragCollectionView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)_loadData {
    NSString *custId = [[NSUserDefaults standardUserDefaults] objectForKey:kCustId];
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/getCustInfo", MainUrl];
    
    NSMutableDictionary *param = @{}.mutableCopy;
    if(![custId isKindOfClass:[NSNull class]]&&custId != nil){
        [param setObject:custId forKey:@"custId"];
    }
    
    [[NetworkClient sharedInstance] POST:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
        if([responseObject[@"code"] isEqualToString:@"1"]){
            [self.dataArr removeAllObjects];
            model = [[PersonMsgModel alloc] initWithDataDic:responseObject[@"responseData"]];
            if([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KAuthLogin]){
                // 游客
                [self.dataArr addObject:[[FirstMenuModel alloc] initWithDataDic:_walletParams]];
                [self.dataArr addObject:[[FirstMenuModel alloc] initWithDataDic:_carParams]];
                [self.dataArr addObject:[[FirstMenuModel alloc] initWithDataDic:_setParams]];
                
            }else if([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KAuthLoginMobile]){
                // 访客
                [self.dataArr addObject:[[FirstMenuModel alloc] initWithDataDic:_walletParams]];
                [self.dataArr addObject:[[FirstMenuModel alloc] initWithDataDic:_carParams]];
                [self.dataArr addObject:[[FirstMenuModel alloc] initWithDataDic:_parkRecordParams]];
                [self.dataArr addObject:[[FirstMenuModel alloc] initWithDataDic:_bookRecordParams]];
                [self.dataArr addObject:[[FirstMenuModel alloc] initWithDataDic:_setParams]];
                
            }else if([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KLogin]){
                //员工
                [self.dataArr addObject:[[FirstMenuModel alloc] initWithDataDic:_kqParams]];
                [self.dataArr addObject:[[FirstMenuModel alloc] initWithDataDic:_walletParams]];
                [self.dataArr addObject:[[FirstMenuModel alloc] initWithDataDic:_carParams]];
                [self.dataArr addObject:[[FirstMenuModel alloc] initWithDataDic:_parkRecordParams]];
                [self.dataArr addObject:[[FirstMenuModel alloc] initWithDataDic:_humanFaceParams]];
                [self.dataArr addObject:[[FirstMenuModel alloc] initWithDataDic:_bookRecordParams]];
                [self.dataArr addObject:[[FirstMenuModel alloc] initWithDataDic:_setParams]];
            }
            
            if ([model.CUST_PASSWD isKindOfClass:[NSNull class]] || model.CUST_PASSWD == nil) {
                [kUserDefaults setBool:NO forKey:isSetPwd];
            }else{
                [kUserDefaults setBool:YES forKey:isSetPwd];
            }
            
            if ([model.PAY_PASSWD isKindOfClass:[NSNull class]] || model.PAY_PASSWD == nil) {
                [kUserDefaults setBool:NO forKey:isSetPayPwd];
            }else{
                [kUserDefaults setBool:YES forKey:isSetPayPwd];
            }
            
            if (![model.IS_SMALL_PAY isKindOfClass:[NSNull class]]&&model.IS_SMALL_PAY != nil&&[model.IS_SMALL_PAY isEqualToString:@"1"]) {
                [kUserDefaults setBool:YES forKey:isAllowSmallPay];
            }else{
                [kUserDefaults setBool:NO forKey:isAllowSmallPay];
            }
            
            if (![model.CUST_NAME isKindOfClass:[NSNull class]]&&model.CUST_NAME != nil) {
                [kUserDefaults setObject:model.CUST_NAME forKey:KUserCustName];
            }
            
            [kUserDefaults setObject:model.CUST_MOBILE forKey:KUserPhoneNum];
            [kUserDefaults synchronize];
            
            [self.canDragCollectionView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}


-(void)initCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 100);
    layout.itemSize = CGSizeMake(110, 60);

    self.canDragCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    
    if (kDevice_Is_iPhoneX) {
        self.canDragCollectionView.frame = CGRectMake(0, 44, KScreenWidth, KScreenHeight - 83-44);
    }else
    {
        self.canDragCollectionView.frame = CGRectMake(0, 20, KScreenWidth, KScreenHeight -49-20);
    }
    self.canDragCollectionView.alwaysBounceVertical = YES;
    //4.设置代理
    self.canDragCollectionView.delegate = self;
    self.canDragCollectionView.dataSource = self;
    self.canDragCollectionView.backgroundColor = [UIColor whiteColor];
    self.canDragCollectionView.mj_footer.hidden = YES;
    self.canDragCollectionView.showsVerticalScrollIndicator = NO;
    self.canDragCollectionView.showsHorizontalScrollIndicator = NO;
    self.canDragCollectionView.scrollEnabled = NO;
    [self.canDragCollectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:@"HomeCollectionViewCell"];
    [self.canDragCollectionView registerNib:[UINib nibWithNibName:@"MineHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MineHeaderView"];
    [self.view addSubview:self.canDragCollectionView];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(HomeCollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
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
    size = CGSizeMake(10, 254);
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
    MineHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MineHeaderView" forIndexPath:indexPath];
    headerView.delegate = self;
    headerView.model = model;
    headerView.money = money;
    return headerView;
}

-(void)reload {
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FirstMenuModel *model = self.dataArr[indexPath.row];
    switch ([model.MENU_ID integerValue]) {
        case 1:{
            if ([[kUserDefaults objectForKey:KLoginWay] isEqualToString:KLogin]) {
//                NSString *faceimageid = [kUserDefaults  objectForKey:KFACE_IMAGE_ID];
//                NSString *companyId = [kUserDefaults objectForKey:companyID];
//                NSString *orgId = [kUserDefaults objectForKey:OrgId];
//                if ([faceimageid isKindOfClass:[NSNull class]]||faceimageid == nil||faceimageid.length == 0) {
//                    [self showHint:@"请先录入人像信息!" yOffset:-120];
//                    [self performSelector:@selector(presentHumanFaceVC) withObject:nil afterDelay:1];
//                }else if([companyId isKindOfClass:[NSNull class]]||companyId == nil||companyId.length == 0||[orgId isKindOfClass:[NSNull class]]||orgId == nil||orgId.length == 0){
//                    [self showHint:@"请先绑定公司和部门!" yOffset:-120];
//                    [self performSelector:@selector(presentPersonInfoVC) withObject:nil afterDelay:1];
//                }else{
//                    KqTabbarViewController *kqtabbarVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"KqTabbarViewController"];
//                    kqtabbarVC.selectedIndex = 1;
//                    //                kqtabbarVC.titleStr = model.MENU_NAME;
//                    [self.navigationController pushViewController:kqtabbarVC animated:YES];
//                }
                KqTabbarViewController *kqtabbarVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"KqTabbarViewController"];
                kqtabbarVC.selectedIndex = 1;
                //                kqtabbarVC.titleStr = model.MENU_NAME;
                [self.navigationController pushViewController:kqtabbarVC animated:YES];
            }else
            {
                BindTableViewController *bindVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"BindTableViewController"];
                [self.navigationController pushViewController:bindVC animated:YES];
            }
        }
            break;
        case 2:
        {
            if([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KLogin]){
                MyPurseTableViewController *purseVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"MyPurseTableViewController"];
                [self.navigationController pushViewController:purseVC animated:YES];
            } else {
                BindTableViewController *bindVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"BindTableViewController"];
                if ([[kUserDefaults objectForKey:KLoginWay] isEqualToString:KAuthLoginMobile]) {
                    bindVC.type = @"1";
                }else{
                    bindVC.type = @"0";
                }
                [self.navigationController pushViewController:bindVC animated:YES];
            }
        }
            break;
        case 3:
        {
            if([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KAuthLogin]){
                BindTableViewController *bindVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"BindTableViewController"];
                [self.navigationController pushViewController:bindVC animated:YES];
            }else {
                MyCarViewController *myCarVC = [[MyCarViewController alloc] init];
                [self.navigationController pushViewController:myCarVC animated:YES];
            }
        }
            break;
        case 4:
        {
            if([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KAuthLogin]){
                BindTableViewController *bindVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"BindTableViewController"];
                [self.navigationController pushViewController:bindVC animated:YES];
            }else {
                ParkRecordsViewController *parkReVc = [[ParkRecordsViewController alloc] init];
                [self.navigationController pushViewController:parkReVc animated:YES];
            }
        }
            break;
        case 5:
        {
            if([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KAuthLogin]){
                BindTableViewController *bindVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"BindTableViewController"];
                [self.navigationController pushViewController:bindVC animated:YES];
            }else {
                HumanFaceViewController *humanVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"HumanFaceViewController"];
                [self.navigationController pushViewController:humanVC animated:YES];
            }
        }
            break;
        case 6:
        {
            BookRecordViewController *bookRecordVC = [[BookRecordViewController alloc] init];
            bookRecordVC.title = @"预约记录";
            [self.navigationController pushViewController:bookRecordVC animated:YES];
        }
            break;
        case 7:
        {
            SetTableViewController *setVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"SetTableViewController"];
            [self.navigationController pushViewController:setVC animated:YES];
        }
            break;
        default:
            break;
    }
}

-(void)presentHumanFaceVC{
    HumanFaceViewController *humanVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"HumanFaceViewController"];
    humanVC.type = @"1";
    [self.navigationController pushViewController:humanVC animated:YES];
}

#pragma mark 头部视图代理
-(void)headerTap{
    if([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KLogin]){
        // 信息
        MyInfomatnTabViewController *myInfoVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"MyInfomatnTabViewController"];
        [self.navigationController pushViewController:myInfoVC animated:YES];
    }else {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KAuthLoginMobile]) {
            //绑定
            [self bindTapAction:@"1"];
        }else{
            //绑定
            [self bindTapAction:@"0"];
        }
    }
}

#pragma mark 快速充值
-(void)quickRechageTap
{
    if([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KLogin]){
        QuickRechargeViewController *quickRechageVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"QuickRechargeViewController"];
        quickRechageVC.titleStr = @"一卡通充值";
        [self.navigationController pushViewController:quickRechageVC animated:YES];
        
    } else {
        BindTableViewController *bindVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"BindTableViewController"];
        if ([[kUserDefaults objectForKey:KLoginWay] isEqualToString:KAuthLoginMobile]) {
            bindVC.type = @"1";
        }else{
            bindVC.type = @"0";
        }
        [self.navigationController pushViewController:bindVC animated:YES];
    }
}

#pragma mark 分享
-(void)shareTap
{
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [self shareWebPageToPlatformType:platformType];
        
    }];
    
    [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.shareTitleViewTitleString = @"分享至";
}

#pragma mark 绑定
-(void)bindTapAction:(NSString *)type
{
    BindTableViewController *bindVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"BindTableViewController"];
    bindVC.type = type;
    bindVC.custName = model.CUST_NAME;
    bindVC.custMobile = model.CUST_MOBILE;
    [self.navigationController pushViewController:bindVC animated:YES];
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
    UIImage *image = [UIImage imageNamed:@"logo512.png"];
    
    if (platformType == UMSocialPlatformType_WechatTimeLine) {
        
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"智慧天园 - 打造园区智能一体化，智慧创新管理，实现节能环保科技化园区" descr:@"打造园区智能一体化，智慧创新管理，实现节能环保科技化园区" thumImage:image];
        //设置网页地址
        shareObject.webpageUrl = [NSString stringWithFormat:@"http://app.wisehn.com/hntfEsb/h5/appstore/userdown.html"];
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
    }else if(platformType == UMSocialPlatformType_Sina){
        NSString *str = [NSString stringWithFormat:@"智慧天园 - 打造园区智能一体化，智慧创新管理，实现节能环保科技化园区!下载地址 -> http://app.wisehn.com/hntfEsb/h5/appstore/userdown.html"];
        messageObject.text = str;
        UMShareImageObject *imageObject = [[UMShareImageObject alloc] init];
        [imageObject setShareImage:@"http://220.168.59.13:8081/hntfEsb/upload/images//temp/18040218213705256b41fdb25445b840e439054dd36ed.jpg"];
        messageObject.shareObject = imageObject;
    }else{
        //创建网页内容对象
        //    NSString* thumbURL =  @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"智慧天园" descr:@"打造园区智能一体化，智慧创新管理，实现节能环保科技化园区" thumImage:image];
        //设置网页地址
        shareObject.webpageUrl = [NSString stringWithFormat:@"http://app.wisehn.com/hntfEsb/h5/appstore/userdown.html"];
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
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

-(void)presentPersonInfoVC
{
    MyInfomatnTabViewController *myInfoVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"MyInfomatnTabViewController"];
    [self.navigationController pushViewController:myInfoVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
