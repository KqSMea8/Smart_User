//
//  CheckViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 魏唯隆 on 2017/12/15.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "CheckViewController.h"
#import "BillCell.h"
#import <MJRefresh.h>
//#import "PayInfoViewController.h"
#import "BalanceDetailModel.h"
#import "NoDataView.h"
//#import "TopupInfoViewController.h"
#import "BillDetailsViewController.h"

@interface CheckViewController ()<CYLTableViewPlaceHolderDelegate>
{
    NSMutableArray *_billData;
    
    NSMutableArray *_monthBillData;
    NSMutableArray *_monthTitleData;
    
    NoDataView *noDateView;
    
    int _page;
    int _length;
}
@end

@implementation CheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _billData = @[].mutableCopy;
    _monthBillData = @[].mutableCopy;
    _monthTitleData = @[].mutableCopy;
    
    _page = 1;
    _length = 15;
    
    [self _initView];
    
    [self _loadBalanceDetailData];
}

- (void)_initView {
    self.title = @"余额明细";
    
    UIButton *leftBtn = [[UIButton alloc] init];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [leftBtn setImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(_leftBarBtnItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
//    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64) style:uitable];
    [self.tableView registerNib:[UINib nibWithNibName:@"BillCell" bundle:nil] forCellReuseIdentifier:@"BillCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.mj_header.hidden = YES;
    self.tableView.mj_footer.hidden = YES;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self _loadBalanceDetailData];
    }];
    // 上拉刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page ++;
        [self _loadBalanceDetailData];
    }];
    self.tableView.mj_footer.automaticallyHidden = YES;

}

- (void)_leftBarBtnItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 加载余额明细数据
-(void)_loadBalanceDetailData
{
    NSString *custId = [kUserDefaults objectForKey:kCustId];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/rechargeOrder/getGeneralChargeAndConsumeSource",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:custId forKey:@"custId"];
    [params setObject:[NSString stringWithFormat:@"%d",_page] forKey:@"pageNo"];
    [params setObject:@"10" forKey:@"pageSize"];
    
    [[NetworkClient sharedInstance] GET:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if(_page == 1){
            [_billData removeAllObjects];
        }

        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            
            NSArray *arr = responseObject[@"responseData"];
            
            if ([arr isKindOfClass:[NSNull class]]) {
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                return;
            }else{
                self.tableView.mj_footer.state = MJRefreshStateIdle;
            }
            
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                BalanceDetailModel *model = [[BalanceDetailModel alloc] initWithDataDic:obj];
                [_billData addObject:model];
            }];
            [self dealData:_billData];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)dealData:(NSMutableArray *)billData {
    [_monthTitleData removeAllObjects];
    [_monthBillData removeAllObjects];
    
    NSMutableArray *monthData = @[].mutableCopy;
    
    BalanceDetailModel *friModel = billData.firstObject;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMddHHmmss"];
    __block NSDate *friDate = [dateFormat dateFromString:friModel.orderPayTime];
    
    NSDateFormatter *newFormat = [[NSDateFormatter alloc] init];
    [newFormat setDateFormat:@"yyyy年MM月dd日"];
    __block NSString *friDateStr = [newFormat stringFromDate:friDate];
    
    [billData enumerateObjectsUsingBlock:^(BalanceDetailModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDate *billDate = [dateFormat dateFromString:model.orderPayTime];
        NSString *billDateStr = [newFormat stringFromDate:billDate];
        
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents *friComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:friDate];
        NSDateComponents *billComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:billDate];
        
        if(friComponents.year == billComponents.year){
            if(friComponents.month == billComponents.month){
                // 同月
                [monthData addObject:model];
            }else {
//                [_dateDic setObject:monthData.copy forKey:[friDateStr substringWithRange:NSMakeRange(5, 3)]];
                [_monthTitleData addObject:[friDateStr substringWithRange:NSMakeRange(5, 3)]];
                [_monthBillData addObject:monthData.copy];
                [monthData removeAllObjects];
                friDate = billDate;
                friDateStr = billDateStr;
                
                [monthData addObject:model];
            }
            
        }else {
//            [_dateDic setObject:monthData forKey:[friDateStr substringWithRange:NSMakeRange(5, 3)]];
            [_monthTitleData addObject:[friDateStr substringWithRange:NSMakeRange(5, 3)]];
            [_monthBillData addObject:monthData.copy];
            [monthData removeAllObjects];
            friDate = billDate;
            friDateStr = billDateStr;
            
            if(friComponents.month == billComponents.month){
                // 同月
                [monthData addObject:model];
            }else {
//                [_dateDic setObject:monthData forKey:[friDateStr substringWithRange:NSMakeRange(0, 8)]];
                [_monthTitleData addObject:[friDateStr substringWithRange:NSMakeRange(0, 8)]];
                [_monthBillData addObject:monthData.copy];
                [monthData removeAllObjects];
                friDate = billDate;
                friDateStr = billDateStr;
                
                [monthData addObject:model];
            }
        }
        
    }];
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents *friComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:friDate];
    NSDateComponents *newComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate new]];
    
    if(friComponents.year == newComponents.year){
//        [_dateDic setObject:monthData.copy forKey:[friDateStr substringWithRange:NSMakeRange(5, 3)]];
        [_monthTitleData addObject:[friDateStr substringWithRange:NSMakeRange(5, 3)]];
        [_monthBillData addObject:monthData.copy];
    }else {
//        [_dateDic setObject:monthData.copy forKey:[friDateStr substringWithRange:NSMakeRange(0, 8)]];
        [_monthTitleData addObject:[friDateStr substringWithRange:NSMakeRange(0, 8)]];
        [_monthBillData addObject:monthData.copy];
    }
    
    [self.tableView cyl_reloadData];
}

#pragma mark 无数据协议
- (UIView *)makePlaceHolderView {
    noDateView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    return noDateView;
}
- (BOOL)enableScrollWhenPlaceHolderViewShowing {
    return YES;
}

#pragma mark UITableView 协议
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _monthTitleData.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *monthData = _monthBillData[section];
    return monthData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 50)];
    headView.backgroundColor = [UIColor colorWithHexString:@"#ebebeb"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 100, 20)];
    label.text = _monthTitleData[section];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:17];
    label.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:label];
    
    return headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BillCell *billCell = [tableView dequeueReusableCellWithIdentifier:@"BillCell" forIndexPath:indexPath];
    NSArray *monthBill = _monthBillData[indexPath.section];
    BalanceDetailModel *model = monthBill[indexPath.row];
    billCell.model = model;
    return billCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *monthBill = _monthBillData[indexPath.section];
    BalanceDetailModel *balanceDetailModel = monthBill[indexPath.row];
    
    BillDetailsViewController *billDetVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"BillDetailsViewController"];
    billDetVC.orderId = balanceDetailModel.Base_DataTwo;
    [self.navigationController pushViewController:billDetVC animated:YES];
}
@end
