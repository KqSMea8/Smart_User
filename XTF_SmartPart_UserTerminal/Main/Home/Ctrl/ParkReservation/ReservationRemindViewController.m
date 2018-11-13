//
//  ReservationRemindViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/6/5.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "ReservationRemindViewController.h"
#import "ParkReservationViewController.h"
#import "BookRecordModel.h"
#import "BookRecordParkAreaModel.h"
#import "BookRecordParkSpaceModel.h"
#import "Utils.h"

@interface ReservationRemindViewController ()
{
    __weak IBOutlet UIImageView *remindImageView;
    __weak IBOutlet UILabel *remindLab;
    
    __weak IBOutlet UILabel *messageLab;
    __weak IBOutlet UIButton *backHomeBtn;
    __weak IBOutlet UIButton *reAppointmentBtn;
}

@end

@implementation ReservationRemindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavItems];
    
    [self initView];
    
    [self loadData];
}

-(void)initNavItems
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
    [kNotificationCenter postNotificationName:@"refreshParkAreaStatusNotification" object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)setType:(BookRemaindType)type
{
    _type = type;
}

-(void)initView{
    // 禁止左滑
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
    
    reAppointmentBtn.backgroundColor = [UIColor colorWithHexString:@"#1B82D1"];
    reAppointmentBtn.layer.cornerRadius = 4;
    reAppointmentBtn.clipsToBounds = YES;
    
}

-(void)loadData{
    NSString *urlStr = [NSString stringWithFormat:@"%@/parking/parkingOrderDetail",MainUrl];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:_orderId forKey:@"orderId"];
    NSString *jsonStr = [Utils convertToJsonData:params];
    
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setObject:jsonStr forKey:@"param"];
    [self showHudInView:self.view hint:nil];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if (![responseObject[@"code"] isKindOfClass:[NSNull class]]&&[responseObject[@"code"] isEqualToString:@"1"]) {
            if (![responseObject[@"responseData"] isKindOfClass:[NSNull class]]) {
                NSDictionary *dic = responseObject[@"responseData"];
                 BookRecordModel *orderModel = [[BookRecordModel alloc] initWithDataDic:dic[@"order"]];
                BookRecordParkSpaceModel *parkSpaceModel = [[BookRecordParkSpaceModel alloc] initWithDataDic:dic[@"parkingSpace"]];
                BookRecordParkAreaModel *parkAreaModel = [[BookRecordParkAreaModel alloc] initWithDataDic:dic[@"parkingArea"]];
                
                NSString *parckingSpaceName = parkSpaceModel.parkingSpaceName;
                NSString *carNoStr = orderModel.carNo;
                
                if (_type == BookCancle) {
                    remindImageView.image = [UIImage imageNamed:@"cancle"];
                    remindLab.text = [NSString stringWithFormat:@"取消成功!"];
                    remindLab.textColor = [UIColor colorWithHexString:@"#6BDB6A"];
                    messageLab.text = [NSString stringWithFormat:@"%@成功取消%@车位%@预约",carNoStr,parkSpaceModel.parkingName,parckingSpaceName];
                }else if(_type == BookFailure){
                    
                }else{
                    [reAppointmentBtn setTitle:@"完成" forState:UIControlStateNormal];
                    remindImageView.image = [UIImage imageNamed:@"book_open"];
                    remindLab.text = [NSString stringWithFormat:@"车位已开启"];
                    remindLab.textColor = [UIColor colorWithHexString:@"#30CEEA"];
                    backHomeBtn.hidden = YES;
                    messageLab.text = [NSString stringWithFormat:@"%@预约车位%@已开启,请尽快停入.",carNoStr,parckingSpaceName];
                }
            }
        }
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"%@",error);
    }];
}

#pragma mark 重新预约
- (IBAction)reAppointmentAction:(id)sender {
    if (_type == BookParkAreaOpen) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        // 新建将要push的控制器
        ParkReservationViewController *newVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"ParkReservationViewController"];
        newVC.isSholudBackRootViewController = YES;
        newVC.title = @"车位预约";
        NSMutableArray *temp = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [temp insertObject:newVC atIndex:temp.count - 1];
        
        // 此时 temp 数组中存在 A -->B -->C 三个控制器,在 C 中直接 pop 即可
        [self.navigationController setViewControllers:temp animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark 返回首页
- (IBAction)backHomeAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)setOrderId:(NSString *)orderId
{
    _orderId = orderId;
}

-(NSString *)dateStrFormDateStr:(NSString *)dateStr
{
    NSDateFormatter *inDateFormat = [[NSDateFormatter alloc] init];
    [inDateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date =[inDateFormat dateFromString:dateStr];
    
    NSDateFormatter* outDateFormat = [[NSDateFormatter alloc] init];
    [outDateFormat setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString *currentDateStr = [outDateFormat stringFromDate:date];
    return currentDateStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
