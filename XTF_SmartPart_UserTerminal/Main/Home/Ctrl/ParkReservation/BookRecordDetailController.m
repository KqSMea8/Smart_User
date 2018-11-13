//
//  BookRecordDetailController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/6/7.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "BookRecordDetailController.h"
#import "ParkRecordsViewController.h"
#import "Utils.h"
#import "BookRecordParkAreaModel.h"
#import "BookRecordModel.h"
#import "BookRecordParkSpaceModel.h"
#import "ReservationRemindViewController.h"

@interface BookRecordDetailController ()
{
    __weak IBOutlet UIImageView *stateView;
    __weak IBOutlet UILabel *stateLab;
    __weak IBOutlet UILabel *carNumLab;
    __weak IBOutlet UILabel *parkSpacesNameLab;
    
    __weak IBOutlet UILabel *noteLab;
    __weak IBOutlet UIButton *parkRecordBtn;
    __weak IBOutlet UILabel *parkAreaNameLab;
    __weak IBOutlet UILabel *bookNumLab;
    __weak IBOutlet UILabel *bookTimeLab;
    
    __weak IBOutlet UILabel *remarkLab;
    __weak IBOutlet UILabel *remarkContentLab;
    
    BookRecordModel *_orderModel;
    BookRecordParkSpaceModel *_parkSpaceModel;
    BookRecordParkAreaModel *_parkAreaModel;
    int btnY;
}

@property (nonatomic,retain)UIButton *suspensionBtn;

@end

@implementation BookRecordDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    [self initNavItems];
    
    [self loadDetailData];
}

-(void)initNavItems
{
    self.title = @"预约详情";
    
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

-(void)setOrderId:(NSString *)orderId
{
    _orderId = orderId;
}

-(void)loadDetailData
{
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
                _orderModel = [[BookRecordModel alloc] initWithDataDic:dic[@"order"]];
                _parkSpaceModel = [[BookRecordParkSpaceModel alloc] initWithDataDic:dic[@"parkingSpace"]];
                _parkAreaModel = [[BookRecordParkAreaModel alloc] initWithDataDic:dic[@"parkingArea"]];
                
                if ([_orderModel.status isEqualToString:@"1"]) {
                    stateView.image = [UIImage imageNamed:@"book_open"];
                    stateLab.text = @"车辆已入场";
                    noteLab.text = [NSString stringWithFormat:@"%@已入场停车",[self dateStrFormDateStr:_orderModel.updateTime]];
                }else if ([_orderModel.status isEqualToString:@"2"]){
                    stateView.image = [UIImage imageNamed:@"book_cancle"];
                    stateLab.text = @"预约已取消";
                    stateLab.textColor = [UIColor colorWithHexString:@"#EA9D30"];
                    parkRecordBtn.hidden = YES;
                    noteLab.text = [NSString stringWithFormat:@"%@取消预约",[self dateStrFormDateStr:_orderModel.updateTime]];
                }else if ([_orderModel.status isEqualToString:@"3"]){
                    parkRecordBtn.hidden = YES;
                    stateLab.text = @"超时未入场";
                    stateView.image = [UIImage imageNamed:@"book_overtime"];
                    stateLab.textColor = [UIColor colorWithHexString:@"#6BDB6A"];
                    noteLab.text = [NSString stringWithFormat:@"%@前未入场停车,车位已取消",[self dateStrFormDateStr:_orderModel.updateTime]];
                }else if ([_orderModel.status isEqualToString:@"4"]){
                    stateLab.text = @"车辆已出场";
                    stateView.image = [UIImage imageNamed:@"book_end"];
                    stateLab.textColor = [UIColor colorWithHexString:@"#FF7679"];
                    noteLab.text = [NSString stringWithFormat:@"%@入场停车,%@取车出场",[self dateStrFormDateStr:dic[@"inTime"]],[self dateStrFormDateStr:dic[@"outTime"]]];
                }
                remarkContentLab.text = [NSString stringWithFormat:@"%@",_orderModel.remark];
                carNumLab.text = [NSString stringWithFormat:@"%@",_orderModel.carNo];
                parkSpacesNameLab.text = [NSString stringWithFormat:@"预定%@",_parkSpaceModel.parkingSpaceName];
                parkAreaNameLab.text = [NSString stringWithFormat:@"%@%@",_parkSpaceModel.parkingName,_parkSpaceModel.parkingAreaName];
                bookNumLab.text = [NSString stringWithFormat:@"%@",_orderModel.orderId];
                bookTimeLab.text = [NSString stringWithFormat:@"%@",[self dateStrFormDateStr:_orderModel.orderTime]];
                [self creatDownBtn];
                
                [self.tableView reloadData];
            }
        }
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"%@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    if (indexPath.section == 0||indexPath.section == 1) {
        return 150;
    }else{
        CGSize remarkSize = [_orderModel.remark sizeForFont:[UIFont systemFontOfSize:17] size:CGSizeMake(KScreenWidth-124, MAXFLOAT) mode:NSLineBreakByCharWrapping];
        height = 153+remarkSize.height;
    }
    return height;
}

#pragma mark 停车记录
- (IBAction)parkRecordBtnAction:(id)sender {
    ParkRecordsViewController *parkReVc = [[ParkRecordsViewController alloc] init];
    [self.navigationController pushViewController:parkReVc animated:YES];
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

#pragma mark 创建取车出场悬浮按钮
-(void)creatDownBtn
{
    self.suspensionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.suspensionBtn.hidden = YES;
    self.suspensionBtn.frame = CGRectMake(0,kScreenHeight - kTopHeight-60,kScreenWidth,60);
    [self.suspensionBtn setTitle:@"取车出场" forState:UIControlStateNormal];
    self.suspensionBtn.backgroundColor = [UIColor colorWithHexString:@"#1B82D1"];
    [self.suspensionBtn addTarget:self action:@selector(openAndGetTheCar:)forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:self.suspensionBtn];
    [self.tableView bringSubviewToFront:self.suspensionBtn];
    btnY = (int)self.suspensionBtn.frame.origin.y;
    if ([_orderModel.status isEqualToString:@"1"]) {
        self.suspensionBtn.hidden = NO;
    }
}

#pragma mark 实现代理方法固定悬浮按钮的位置
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.suspensionBtn.frame = CGRectMake(0,btnY+self.tableView.contentOffset.y , kScreenWidth, 60);
}

-(void)openAndGetTheCar:(id)sender
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/parking/operateParkingLock",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:_orderModel.orderId forKey:@"orderId"];
    [params setObject:@"on" forKey:@"operateType"];
    
    NSString *jsonStr = [Utils convertToJsonData:params];
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setObject:jsonStr forKey:@"param"];
    
    [self showHudInView:self.view hint:nil];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if (![responseObject[@"code"] isKindOfClass:[NSNull class]]&&[responseObject[@"code"] isEqualToString:@"1"]) {
            [self showHint:@"开锁成功，请尽快将车开离车位!"];
            [kNotificationCenter postNotificationName:@"unlockNotification" object:nil];
            [self performSelector:@selector(remind) withObject:nil afterDelay:1];
        }else{
            if (![responseObject[@"message"] isKindOfClass:[NSNull class]]) {
                [self showHint:[NSString stringWithFormat:@"%@",responseObject[@"message"]]];
            }
        }
    } failure:^(NSError *error) {
        [self hideHud];
        [self showHint:@"开锁失败,请重试!"];
    }];
}

-(void)remind{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
