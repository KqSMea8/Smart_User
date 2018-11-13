//
//  BookRecordTableViewCell.m
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/6/6.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "BookRecordTableViewCell.h"
#import "BookRecordModel.h"
#import "BookRecordParkSpaceModel.h"
#import "BookRecordParkAreaModel.h"
#import "ParkReservationViewController.h"
#import "Utils.h"
#import "ReservationRemindViewController.h"
#import "BookRecordDetailController.h"
#import "CarListModel.h"
#import "BindCarTableViewController.h"

@interface BookRecordTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *carNumLab;
@property (weak, nonatomic) IBOutlet UIImageView *bookStateView;
@property (weak, nonatomic) IBOutlet UILabel *parkNameLab;
@property (weak, nonatomic) IBOutlet UILabel *parkSpacesLab;
@property (weak, nonatomic) IBOutlet UILabel *bookTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *latestTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *noteLab;
@property (weak, nonatomic) IBOutlet UIButton *dealBtn;

@end

@implementation BookRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initView];
}

-(void)initView
{
    _dealBtn.layer.cornerRadius = 5;
    _dealBtn.clipsToBounds = YES;
    _dealBtn.layer.borderColor = [UIColor colorWithHexString:@"#1B82D1"].CGColor;
    _dealBtn.layer.borderWidth = 0.5;
    
    [_dealBtn addTarget:self action:@selector(dealBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setModel:(BookRecordModel *)model
{
    _model = model;
    _carNumLab.text = [NSString stringWithFormat:@"%@",model.carNo];
    _parkSpacesLab.text = [NSString stringWithFormat:@"%@",model.parkingSpaceName];
    _bookTimeLab.text = [NSString stringWithFormat:@"%@",[self dateStrFormDateStr:model.orderTime]];
    _latestTimeLab.text = [NSString stringWithFormat:@"%@",[self dateStrFormDateStr:model.invalidTime]];
    _noteLab.text = [NSString stringWithFormat:@"%@",model.remark];
    if ([model.status isEqualToString:@"0"]) {
        _bookStateView.image = [UIImage imageNamed:@"booking"];
        [_dealBtn setTitle:@"打开车位锁" forState:UIControlStateNormal];
        _noteLab.textColor = [UIColor blackColor];
    }else if ([model.status isEqualToString:@"1"]){
        _bookStateView.image = [UIImage imageNamed:@"completed_Subscript"];
        [_dealBtn setTitle:@"取车出场" forState:UIControlStateNormal];
        _noteLab.textColor = [UIColor blackColor];
    }else if ([model.status isEqualToString:@"2"]){
        _bookStateView.image = [UIImage imageNamed:@"book_cancle_subscript"];
        [_dealBtn setTitle:@"重新预约" forState:UIControlStateNormal];
        _noteLab.textColor = [UIColor colorWithHexString:@"#FF4359"];
    }else if ([model.status isEqualToString:@"3"]){
        _bookStateView.image = [UIImage imageNamed:@"book_cancle_subscript"];
        [_dealBtn setTitle:@"重新预约" forState:UIControlStateNormal];
        _noteLab.textColor = [UIColor colorWithHexString:@"#FF4359"];
    }else{
        _bookStateView.image = [UIImage imageNamed:@"completed_Subscript"];
        [_dealBtn setTitle:@"重新预约" forState:UIControlStateNormal];
        _noteLab.textColor = [UIColor blackColor];
    }
}

-(void)setParkAreaModel:(BookRecordParkAreaModel *)parkAreaModel
{
    _parkAreaModel = parkAreaModel;
    
}

-(void)setParkSpaceModel:(BookRecordParkSpaceModel *)parkSpaceModel
{
    _parkSpaceModel = parkSpaceModel;

    _parkNameLab.text = [NSString stringWithFormat:@"%@%@",parkSpaceModel.parkingName,parkSpaceModel.parkingAreaName];
}

#pragma 重新预约/打开车位锁/取车出场
-(void)dealBtnAction:(id)sender
{
    NSInteger index = [_model.status integerValue];
    switch (index) {
        case 0:
            [self unLock];
            break;
        case 1:
            //取车出场
            [self unLock];
            break;
        case 2:
            [self reAppointmentParkArea];
            break;
        case 3:
            [self reAppointmentParkArea];
            break;
        case 4:
            [self reAppointmentParkArea];
            break;
        default:
            break;
    }
}

#pragma mark 取车出场
-(void)unLock
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/parking/operateParkingLock",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:_model.orderId forKey:@"orderId"];
    [params setObject:@"on" forKey:@"operateType"];
    
    NSString *jsonStr = [Utils convertToJsonData:params];
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setObject:jsonStr forKey:@"param"];
    
    [self.viewController showHudInView:self.viewController.view hint:nil];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
        
        [kNotificationCenter postNotificationName:@"unlockNotification" object:nil];
        [self.viewController hideHud];
        if (![responseObject[@"code"] isKindOfClass:[NSNull class]]&&[responseObject[@"code"] isEqualToString:@"1"]) {
//            ReservationRemindViewController *reservationRemindVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"ReservationRemindViewController"];
//            reservationRemindVC.orderId = _model.orderId;
//            reservationRemindVC.type = BookParkAreaOpen;
//            [self.viewController.navigationController pushViewController:reservationRemindVC animated:YES];
            BookRecordDetailController *bookRecordDetailVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"BookRecordDetailController"];
            bookRecordDetailVC.orderId = _model.orderId;
            [self.viewController.navigationController pushViewController:bookRecordDetailVC animated:YES];
        }
        if (![responseObject[@"message"] isKindOfClass:[NSNull class]]) {
            [self.viewController showHint:[NSString stringWithFormat:@"%@",responseObject[@"message"]]];
        }
    } failure:^(NSError *error) {
        [self.viewController hideHud];
        [self.viewController showHint:@"开锁失败,请重试!"];
    }];
}

#pragma mark 重新预约
-(void)reAppointmentParkArea
{
//    ParkReservationViewController *parkReserVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"ParkReservationViewController"];
//    parkReserVC.title = @"车位预约";
//    [self.viewController.navigationController pushViewController:parkReserVC animated:YES];
    
    [self loadBindCarData];
}

#pragma mark 是否绑定车辆
-(void)loadBindCarData
{
    [self.viewController showHudInView:self.viewController.view hint:nil];
    NSString *urlStr = [NSString stringWithFormat:@"%@park-service/member/getMemberCards",[kUserDefaults objectForKey:KParkUrl]];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    NSString *memberId = [[NSUserDefaults standardUserDefaults] objectForKey:KMemberId];
    if(memberId != nil){
        [params setObject:memberId forKey:@"memberId"];
    }
    [params setObject:KToken forKey:@"token"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        [self.viewController hideHud];
        if([responseObject[@"success"] boolValue]){
            
            NSArray *carList = responseObject[@"data"][@"carList"];
            [carList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CarListModel *carModel = [[CarListModel alloc] initWithDataDic:obj];
//                [bindCarDataArr addObject:[NSString stringWithFormat:@"%@ %@",carModel.carArea,carModel.carNum]];
            }];
            
            if(carList.count == 0){
                [self.viewController showHint:@"请先绑定你要预定的车辆!"];
                [self performSelector:@selector(bindCarAction) withObject:nil afterDelay:1];
            }else{
                ParkReservationViewController *parkReserVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"ParkReservationViewController"];
                parkReserVC.title = @"车位预约";
                [self.viewController.navigationController pushViewController:parkReserVC animated:YES];
            }
        }else{
            [self.viewController showHint:@"请重试!"];
        }
    } failure:^(NSError *error) {
        [self.viewController hideHud];
    }];
}

-(void)bindCarAction{
    BindCarTableViewController *bindCarVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"BindCarTableViewController"];
    [self.viewController.navigationController pushViewController:bindCarVC animated:YES];
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
