//
//  ECardViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/26.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "ECardViewController.h"
#import "BillCell.h"
#import <MJRefresh.h>
#import "BalanceDetailModel.h"
#import "YQEmptyView.h"
#import "BillDetailsViewController.h"
#import "WSDatePickerView.h"
#import "Utils.h"
#import "AESUtil.h"

@interface ECardViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_billData;
    
    NSMutableArray *_monthBillData;
    NSMutableArray *_monthTitleData;
    
    int _page;
    UIButton *_searchBtn;
    CGFloat _topHeight;
    
    NSString *currentDateStr;
    NSDate *currentDate;
    NSMutableArray *_dataArray;
    NSMutableArray *_titleArray;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) YQEmptyView *noNetworkView;
@property (nonatomic,strong) YQEmptyView *noDataView;

@end

@implementation ECardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _billData = @[].mutableCopy;
    _monthBillData = @[].mutableCopy;
    _monthTitleData = @[].mutableCopy;
    
    _page = 1;
    
    [self _initView];
    
    [self _loadBalanceDetailData];
    
    [self.tableView.mj_header beginRefreshing];
    
    YYReachability *rech = [YYReachability reachability];
    if (!rech.reachable) {
        self.tableView.ly_emptyView = self.noNetworkView;
        [self.tableView reloadData];
        [self.tableView ly_endLoading];
    }
}

- (void)_initView {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    NSDateFormatter *minDateFormater = [[NSDateFormatter alloc] init];
    [minDateFormater setDateFormat:@"yyyy-MM"];
    currentDate = [minDateFormater dateFromString:[Utils getCurrentMouth]];
    
    UIButton *leftBtn = [[UIButton alloc] init];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [leftBtn setImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(_leftBarBtnItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    if (kDevice_Is_iPhoneX) {
        self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - kTopHeight-17);
    }else{
        self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - kTopHeight);
    }
    [self.tableView registerNib:[UINib nibWithNibName:@"BillCell" bundle:nil] forCellReuseIdentifier:@"BillCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
//    self.tableView.mj_header.hidden = YES;
//    self.tableView.mj_footer.hidden = YES;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
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
    [self.view addSubview:self.tableView];
    
    _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_searchBtn setBackgroundImage:[UIImage imageNamed:@"calendar"] forState:UIControlStateNormal];
    _searchBtn.frame = CGRectMake(KScreenWidth - 30, 55/2, 20, 20);
    [self.view bringSubviewToFront:_searchBtn];
    [_searchBtn addTarget:self action:@selector(selectDateAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _topHeight = 55/2;
}

- (void)_leftBarBtnItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectDateAction:(UIButton *)btn
{
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonth scrollToDate:currentDate CompleteBlock:^(NSDate *selectDate) {
//        NSString *date = [selectDate stringWithFormat:@"yyyy年MM"];
        NSString *date1 = [selectDate stringWithFormat:@"yyyy-MM"];
        currentDateStr = date1;
        currentDate = selectDate;
        _page = 1;
        [self _loadBalanceDetailData];
        [self.tableView.mj_header beginRefreshing];
        _searchBtn.enabled = NO;
        
    }];
    datepicker.dateLabelColor = [UIColor colorWithHexString:@"#1B82D1"];//年-月-日-时-分 颜色
    datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
    datepicker.doneButtonColor = [UIColor colorWithHexString:@"#1B82D1"];//确定按钮的颜色
    datepicker.yearLabelColor = [UIColor clearColor];//大号年份字体颜色
    [datepicker show];
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
    if (currentDateStr != nil&&![currentDateStr isKindOfClass:[NSNull class]]) {
        [params setObject:currentDateStr forKey:@"selectByMonth"];
    }else{
        [params setObject:@"" forKey:@"selectByMonth"];
    }
    
    [[NetworkClient sharedInstance] GET:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        _searchBtn.enabled = YES;
        
        if(_page == 1){
            [_billData removeAllObjects];
            [_monthBillData removeAllObjects];
            [_monthTitleData removeAllObjects];
        }
        
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            
            if (![responseObject[@"responseData"] isKindOfClass:[NSNull class]]) {
                NSDictionary *dic = responseObject[@"responseData"];
                NSArray *arr;
                if (![dic[@"items"] isKindOfClass:[NSNull class]]) {
                    arr = dic[@"items"];
                }
                if (arr.count == 0||[arr isKindOfClass:[NSNull class]]) {
//                    _searchBtn.hidden = YES;
                    
                    self.tableView.ly_emptyView = self.noDataView;
                    [self.tableView reloadData];
                    [self.tableView ly_endLoading];
                    return;
                }
                _searchBtn.hidden = NO;
                
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
        }else{
//            _searchBtn.hidden = YES;
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            return;
        }
    } failure:^(NSError *error) {
        _searchBtn.enabled = YES;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        YYReachability *rech = [YYReachability reachability];
        if (!rech.reachable) {
            self.tableView.ly_emptyView = self.noNetworkView;
            [self.tableView reloadData];
            [self.tableView ly_endLoading];
        }else{
            self.tableView.ly_emptyView = self.noDataView;
            [self.tableView reloadData];
            [self.tableView ly_endLoading];
        }
        
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
                [_monthTitleData addObject:[friDateStr substringWithRange:NSMakeRange(0, 8)]];
                [_monthBillData addObject:monthData.copy];
                [monthData removeAllObjects];
                friDate = billDate;
                friDateStr = billDateStr;
                
                [monthData addObject:model];
            }
            
        }else {
            //            [_dateDic setObject:monthData forKey:[friDateStr substringWithRange:NSMakeRange(5, 3)]];
            [_monthTitleData addObject:[friDateStr substringWithRange:NSMakeRange(0, 8)]];
            [_monthBillData addObject:monthData.copy];
            [monthData removeAllObjects];
            friDate = billDate;
            friDateStr = billDateStr;
            
            [monthData addObject:model];
            
        }
    }];
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents *friComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:friDate];
    NSDateComponents *newComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate new]];
    
    if(friComponents.year == newComponents.year){
        //        [_dateDic setObject:monthData.copy forKey:[friDateStr substringWithRange:NSMakeRange(5, 3)]];
        [_monthTitleData addObject:[friDateStr substringWithRange:NSMakeRange(0, 8)]];
        [_monthBillData addObject:monthData.copy];
    }else {
        //        [_dateDic setObject:monthData.copy forKey:[friDateStr substringWithRange:NSMakeRange(0, 8)]];
        [_monthTitleData addObject:[friDateStr substringWithRange:NSMakeRange(0, 8)]];
        [_monthBillData addObject:monthData.copy];
    }
    
    [self.view addSubview:_searchBtn];
    [self.tableView reloadData];
    [self.tableView ly_endLoading];
}

- (YQEmptyView *)noDataView{
    if (!_noDataView) {
        _noDataView = [YQEmptyView diyEmptyView];
    }
    return _noDataView;
}

- (YQEmptyView *)noNetworkView{
    if (!_noNetworkView) {
        _noNetworkView = [YQEmptyView diyEmptyActionViewWithTarget:self action:@selector(_loadBalanceDetailData)];
    }
    return _noNetworkView;
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
    
    return 75;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 75)];
    headView.backgroundColor = [UIColor colorWithHexString:@"#ebebeb"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 100, 20)];
    label.text = _monthTitleData[section];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:17];
    label.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:label];
    
    NSArray *monthData = _monthBillData[section];
    BalanceDetailModel *model = monthData[0];
    
    UILabel *conLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(label.frame)+12, 100, 20)];
    conLabel.textColor = [UIColor colorWithHexString:@"#888787"];
    
//    NSString *conMoney = [AESUtil decryptAES:model.consumeSum key:AESKey];
    
    
    NSString *conMoney = model.consumeSum;
    
    NSString *conMoneyStr = [NSString stringWithFormat:@"%.2f",[conMoney floatValue]/100.00];
    NSString *MoneyStr = [NSString stringWithFormat:@"消费%@元",conMoneyStr];
    NSMutableAttributedString *attriMoneyStr = [[NSMutableAttributedString alloc] initWithString:MoneyStr];
    [attriMoneyStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FF4359"] range:NSMakeRange(2, conMoneyStr.length)];
    
    CGSize size = [MoneyStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    conLabel.size = size;
    
    conLabel.attributedText = attriMoneyStr;
    conLabel.font = [UIFont systemFontOfSize:16];
    conLabel.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:conLabel];
    
    UILabel *recLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(conLabel.frame)+10, CGRectGetMaxY(label.frame)+12, 160, 20)];
    recLabel.textColor = [UIColor colorWithHexString:@"#888787"];
    
//    NSString *reMoney = [AESUtil decryptAES:model.chargeSum key:AESKey];
    NSString *reMoney = model.chargeSum;
    
    NSString *reMoneyStr = [NSString stringWithFormat:@"%.2f",[reMoney floatValue]/100.00];
    NSString *rechageStr = [NSString stringWithFormat:@"充值%@元",reMoneyStr];
    NSMutableAttributedString *attriRechageStr = [[NSMutableAttributedString alloc] initWithString:rechageStr];
    [attriRechageStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FF4359"] range:NSMakeRange(2, reMoneyStr.length)];
    recLabel.attributedText = attriRechageStr;
    
    recLabel.font = [UIFont systemFontOfSize:16];
    recLabel.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:recLabel];
    
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
    
    if(balanceDetailModel.orderType == nil || [balanceDetailModel.orderType isKindOfClass:[NSNull class]] || balanceDetailModel.payType == nil || [balanceDetailModel.payType isKindOfClass:[NSNull class]]){
        return;
    }
    
    // 判断是否是通过一卡通系统操作(无详情)
    if([balanceDetailModel.orderType isEqualToString:@"02"] && (balanceDetailModel.Base_DataTwo == nil || [balanceDetailModel.Base_DataTwo isKindOfClass:[NSNull class]])){
        // 一卡通 消费 通过一卡通系统
        return;
    }
    if([balanceDetailModel.orderType isEqualToString:@"01"] && [balanceDetailModel.payType isEqualToString:@"03"]){
        // 一卡通 充值 通过一卡通系统现金缴费
        return;
    }
    
    BillDetailsViewController *billDetVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"BillDetailsViewController"];
    billDetVC.orderId = balanceDetailModel.Base_DataTwo;
    if(balanceDetailModel.Base_ManMoney != nil && ![balanceDetailModel.Base_ManMoney isKindOfClass:[NSNull class]] && balanceDetailModel.Base_ManMoney.integerValue != 0){
        billDetVC.Base_ManMoney = balanceDetailModel.Base_ManMoney;
    }
    [self.navigationController pushViewController:billDetVC animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offSetY = scrollView.contentOffset.y;
    
    if (offSetY <= 0) {
        _searchBtn.frame = CGRectMake(_searchBtn.frame.origin.x, _topHeight - offSetY, _searchBtn.frame.size.width, _searchBtn.frame.size.height);
    }
}

@end
