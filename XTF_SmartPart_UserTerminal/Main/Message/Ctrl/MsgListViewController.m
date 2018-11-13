//
//  MsgListViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/5.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "MsgListViewController.h"

#import "ParkMsgViewController.h"
#import "WorkMsgViewController.h"
#import "PNoticeViewController.h"

@interface MsgListViewController (){
    NSInteger _currentSelectIndex;
}

@property (nonatomic, strong) NSArray *titleData;

@end

@implementation MsgListViewController

#pragma mark 标题数组
- (NSArray *)titleData {
    if (!_titleData) {
        _titleData = @[@"停车消息", @"工作消息",@"园区通知"];
    }
    return _titleData;
}

#pragma mark 初始化代码
- (instancetype)init {
    if (self = [super init]) {
        self.titleSizeNormal = 15;
        self.titleSizeSelected = 15;
        self.titleColorSelected = [UIColor colorWithHexString:@"#1B82D1"];
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuItemWidth = [UIScreen mainScreen].bounds.size.width / self.titleData.count;
        self.menuHeight = 60;
        self.progressHeight = 5;
        self.scrollEnable = NO;
        self.progressColor = [UIColor colorWithHexString:@"#1B82D1"];
    }
    return self;
}

-(void)loadData:(NSInteger)currentSelectIndex
{
    NSString *messageType;
    if (currentSelectIndex == 0) {
        messageType = @"05";
    }else if (currentSelectIndex == 1){
        
    }else{
        
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/getUnreadMessage?appType=user&loginName=%@&messageType=%@",MainUrl,[kUserDefaults objectForKey:kCustId],messageType];
    
    [[NetworkClient sharedInstance] GET:urlStr dict:nil progressFloat:nil succeed:^(id responseObject) {
        NSDictionary *data = responseObject;
        if ([data[@"code"] isEqualToString:@"1"]) {
            NSNumber *msgNum = responseObject[@"responseData"];
            if ([msgNum isKindOfClass:[NSNull class]]||msgNum == nil||[msgNum integerValue] == 0) {
                if (currentSelectIndex == 0) {
                    [self updateTitle:[NSString stringWithFormat:@"停车消息"] atIndex:currentSelectIndex];
                }else if (currentSelectIndex == 1){
                    [self updateTitle:[NSString stringWithFormat:@"工作消息"] atIndex:currentSelectIndex];
                }else{
                    [self updateTitle:[NSString stringWithFormat:@"园区通知"] atIndex:currentSelectIndex];
                }
            }else{
                if ([msgNum integerValue] >99) {
                    if (currentSelectIndex == 0) {
                        [self updateTitle:[NSString stringWithFormat:@"停车消息(99+)"] atIndex:currentSelectIndex];
                    }else if (currentSelectIndex == 1){
                        [self updateTitle:[NSString stringWithFormat:@"工作消息(99+)"] atIndex:currentSelectIndex];
                    }else{
                        [self updateTitle:[NSString stringWithFormat:@"园区通知(99+)"] atIndex:currentSelectIndex];
                    }
                }else{
                    if (currentSelectIndex == 0) {
                        [self updateTitle:[NSString stringWithFormat:@"停车消息(%@)",msgNum] atIndex:currentSelectIndex];
                    }else if (currentSelectIndex == 1){
                        [self updateTitle:[NSString stringWithFormat:@"工作消息(%@)",msgNum] atIndex:currentSelectIndex];
                    }else{
                        [self updateTitle:[NSString stringWithFormat:@"园区通知(%@)",msgNum] atIndex:currentSelectIndex];
                    }
                }
            }
        }
    } failure:^(NSError *error) {
    }];
}

#pragma mark - Datasource & Delegate

#pragma mark 返回子页面的个数
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titleData.count;
}

#pragma mark 返回某个index对应的页面
- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    switch (index) {
        case 0:{
            ParkMsgViewController *parkMsgVC = [[ParkMsgViewController alloc] init];
            return parkMsgVC;
        }
            break;
        case 1:{
            WorkMsgViewController *workMsgVC = [[WorkMsgViewController alloc] init];
            return workMsgVC;
        }
            break;
        default:{
            PNoticeViewController *parknoticeVC = [[PNoticeViewController alloc] init];
            return parknoticeVC;
        }
            break;
    }
}

#pragma mark 返回index对应的标题
- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    
    return self.titleData[index];
}

-(void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info
{
    NSInteger index = pageController.selectIndex;
    _currentSelectIndex = index;
    switch (index) {
        case 0:
            [self loadData:index];
            break;
        case 1:
            [self loadData:index];
            break;
        case 2:
            [self loadData:index];
            break;
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initNavItems];
    
    [self _initView];
    
    [kNotificationCenter addObserver:self selector:@selector(refreshTitleAction) name:@"readMessageNotification" object:nil];
}

-(void)refreshTitleAction
{
    [self loadData:_currentSelectIndex];
}

-(void)_initNavItems
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#E2E2E2"];
    
    self.title = @"消息列表";
    
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
    for (int i=1; i<3; i++) {
        UIImageView *hLineView = [[UIImageView alloc] init];
        hLineView.image = [UIImage imageNamed:@"LED_seperateline_blue"];
        hLineView.frame = CGRectMake(KScreenWidth/3 * i, 15, 0.5, 32);
        [self.menuView addSubview:hLineView];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}


@end
