//
//  MyInfomatnTabViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/2.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "MyInfomatnTabViewController.h"
#import "UserModel.h"
#import <TZImagePickerController.h>
#import "CompanyModel.h"
#import "OrgModel.h"
#import "Utils.h"
#import "PersonMsgModel.h"
#import "WSDatePickerView.h"

@interface MyInfomatnTabViewController ()<TZImagePickerControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    __weak IBOutlet UIImageView *headerImageView;
    __weak IBOutlet UILabel *nameLab;
    __weak IBOutlet UILabel *sexLab;
    __weak IBOutlet UILabel *companyLab;
    
    __weak IBOutlet UILabel *orgLab;
    __weak IBOutlet UILabel *positionLab;
    __weak IBOutlet UILabel *phoneNumLab;
    __weak IBOutlet UILabel *certIdsLab;
    
    __weak IBOutlet UILabel *birthdayLab;
    UIImage *_headImage;
    
    UIPickerView *_pickView;
    NSInteger selectIndex;
    UIView *_dateView;
    
    NSMutableArray *_dataArr;
    
    NSMutableArray *_companyNameArr;
    NSMutableArray *_orgNameArr;
    
    NSMutableArray *_companyArr;
    NSMutableArray *_orgArr;
    
    NSInteger tableSelectIndex;
    UserModel *_model;
    
    BOOL IsSuccess;
}

@end

@implementation MyInfomatnTabViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)setType:(NSString *)type
{
    _type = type;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    IsSuccess = NO;
    
    [self _initView];
    
    [self _initNavItems];
    
    [self _loadData];
    
    [self _loadCompanyData];
}

-(void)_loadCompanyData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/getCompanyList",MainUrl];
    
    [[NetworkClient sharedInstance] GET:urlStr dict:nil progressFloat:nil succeed:^(id responseObject) {
        //        DLog(@"%@",responseObject);
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            
            [_companyNameArr removeAllObjects];
            [_companyArr removeAllObjects];
            
            NSArray *arr = responseObject[@"responseData"];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = (NSDictionary *)obj;
                CompanyModel *model = [[CompanyModel alloc] initWithDataDic:dic];
                [_companyNameArr addObject:model.COMPANY_NAME_DESC];
                [_companyArr addObject:model];
            }];
            [_pickView reloadAllComponents];
        }
    } failure:^(NSError *error) {
        DLog(@"%@",error);
    }];
}

-(void)_initView
{
    selectIndex = 0;
    tableSelectIndex = 0;
    _dataArr = @[].mutableCopy;
    _companyArr = @[].mutableCopy;
    _companyNameArr = @[].mutableCopy;
    _orgArr = @[].mutableCopy;
    _orgNameArr = @[].mutableCopy;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#E2E2E2"];
    
    headerImageView.layer.contentMode = UIViewContentModeScaleAspectFill;
    headerImageView.layer.cornerRadius = 35;
    headerImageView.clipsToBounds = YES;
    
    _dateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kTopHeight)];
    _dateView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.1];
    _dateView.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dateCancel)];
    _dateView.userInteractionEnabled = YES;
    [_dateView addGestureRecognizer:tap];
    [self.view addSubview:_dateView];
    
    _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, _dateView.height-200, KScreenWidth, 200)];
    _pickView.delegate = self;
    _pickView.dataSource = self;
    _pickView.backgroundColor = [UIColor whiteColor];
    [_dateView addSubview:_pickView];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, _pickView.top - 40, _dateView.width, 40)];
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    toolbar.barTintColor = [UIColor colorWithHexString:@"#efefef"];
    toolbar.translucent = YES;
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dateCancel)];
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:      UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [spaceButtonItem setWidth:KScreenWidth - 110];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(dateDone)];
    toolbar.items = @[cancelItem,spaceButtonItem, doneItem];
    [_dateView addSubview:toolbar];
    
    if ([_type isEqualToString:@"1"]) {
        // 禁止左滑
        id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
        [self.view addGestureRecognizer:pan];
    }
}

-(void)_initNavItems
{
    self.title = @"我的信息";
    
    UIButton *leftBtn = [[UIButton alloc] init];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [leftBtn setImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(_leftBarBtnItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)_loadData {
    NSString *custId = [[NSUserDefaults standardUserDefaults] objectForKey:kCustId];
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/getCustInfo", MainUrl];
    NSMutableDictionary *param = @{}.mutableCopy;
    if(![custId isKindOfClass:[NSNull class]]&&custId != nil){
        [param setObject:custId forKey:@"custId"];
    }
    
    [self showHudInView:self.view hint:nil];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if([responseObject[@"code"] isEqualToString:@"1"]){
            _model = [[UserModel alloc] initWithDataDic:responseObject[@"responseData"]];
            if([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KLogin]){
                // 员工
                if (![_model.CUST_NAME isKindOfClass:[NSNull class]]&&_model.CUST_NAME != nil) {
                    nameLab.text = _model.CUST_NAME;
                }
                
                if (![_model.COMPANY_NAME isKindOfClass:[NSNull class]]&&_model.COMPANY_NAME != nil) {
                    companyLab.text = _model.COMPANY_NAME;
                }else{
                    companyLab.text = @"请尽快完善公司信息";
                }
                
                if (![_model.ORG_NAME isKindOfClass:[NSNull class]]&&_model.ORG_NAME != nil) {
                    orgLab.text = _model.ORG_NAME;
                }else{
                    orgLab.text = @"请尽快完善部门信息";
                }
                
                if (![_model.ORG_ID isKindOfClass:[NSNull class]]&&_model.ORG_ID != nil) {
                    [kUserDefaults setObject:[_model.ORG_ID stringValue] forKey:OrgId];
                }else{
                    [kUserDefaults setObject:@"" forKey:OrgId];
                }
                
                if (![_model.CUST_MOBILE isKindOfClass:[NSNull class]]&&_model.CUST_MOBILE != nil) {
                    
                    NSString *phoneStr = _model.CUST_MOBILE;
                    
                    NSString *numberString = [phoneStr stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                    
                    phoneNumLab.text = numberString;
                }
                
                if (![_model.CERT_IDS isKindOfClass:[NSNull class]]) {
                    certIdsLab.text = _model.CERT_IDS;
                }
                
                if(![_model.CUST_HEADIMAGE isKindOfClass:[NSNull class]]&&_model.CUST_HEADIMAGE != nil){
                    [headerImageView sd_setImageWithURL:[NSURL URLWithString:_model.CUST_HEADIMAGE] placeholderImage:[UIImage imageNamed:@"_member_icon"]];
                }
                
                if(![_model.BIRTHDAY isKindOfClass:[NSNull class]]&&_model.BIRTHDAY != nil){
                    birthdayLab.text = [NSString stringWithFormat:@"%@",_model.BIRTHDAY];
                }
                
                if(![_model.SEX isKindOfClass:[NSNull class]]&&_model.SEX != nil){
                    if ([_model.SEX isEqualToString:@"0"]) {
                        sexLab.text = @"男";
                    }else{
                        sexLab.text = @"女";
                    }
                }
            }
        }
    } failure:^(NSError *error) {
        [self hideHud];
    }];
}

- (void)_leftBarBtnItemClick {
    if (IsSuccess) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYReachability *rech = [YYReachability reachability];
    if (!rech.reachable) {
        [self showHint:@"网络不给力,请重试!"];
        return;
    }
    if (indexPath.row == 0) {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        
        // 你可以通过block或者代理，来得到用户选择的照片.
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            _headImage = photos.firstObject;
            //图片上传
            [self uploadHeadIconImage:_headImage];
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }else if (indexPath.row == 2){
        NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"男",@"女", nil];
        tableSelectIndex = indexPath.row;
        _dataArr = arr;
        _dateView.hidden = NO;
        tableView.scrollEnabled = NO;
        [_pickView reloadAllComponents];
    }else if (indexPath.row == 3){
        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay scrollToDate:[NSDate date] CompleteBlock:^(NSDate *selectDate) {
            NSString *date1 = [selectDate stringWithFormat:@"yyyy-MM-dd"];
            birthdayLab.text = date1;
            
            [self updateBirthdayDate:date1 OrUpdateSex:nil];
        }];
        datepicker.dateLabelColor = [UIColor colorWithHexString:@"#1B82D1"];//年-月-日-时-分 颜色
        datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
        datepicker.doneButtonColor = [UIColor colorWithHexString:@"#1B82D1"];//确定按钮的颜色
        datepicker.yearLabelColor = [UIColor clearColor];//大号年份字体颜色
        [datepicker show];
    }else if (indexPath.row == 4){
        tableSelectIndex = indexPath.row;
        _dataArr = _companyArr;
        
        if (_dataArr.count == 0 || [_dataArr isKindOfClass:[NSNull class]]) {
            [self showHint:@"获取公司列表信息失败!"];
            return;
        }
        _dateView.hidden = NO;
        tableView.scrollEnabled = NO;
        [_pickView reloadAllComponents];
    }else if (indexPath.row == 5){
        //加载对应公司的部门信息
        tableSelectIndex = indexPath.row;
        
        if ([_model.COMPANY_ID isKindOfClass:[NSNull class]]||_model.COMPANY_ID == nil) {
            [self showHint:@"请先绑定公司信息!"];
            return;
        }
        
        [self _loadOrgData:_model];
    }
}

#pragma mark 头像图片上传
-(void)uploadHeadIconImage:(UIImage *)image
{
    [self showHudInView:self.view hint:@""];
    NSString *urlStr = [NSString stringWithFormat:@"%@/common/custImageUpload",MainUrl];
    
    [[NetworkClient sharedInstance] UPLOAD:urlStr dict:nil imageArray:@[image] progressFloat:^(float progressFloat) {
        
    } succeed:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            [self hideHud];
            NSDictionary *dic = responseObject[@"responseData"];
            NSString *headUrl = dic[@"url"];
            
            //修改个人信息
            [self upCustInfo:headUrl company:nil companyid:nil org:nil orgid:nil];
        }
    } failure:^(NSError *error) {
        [self hideHud];
    }];
}

#pragma mrak 修改性别或者生日
-(void)updateBirthdayDate:(NSString *)date OrUpdateSex:(NSString *)sex
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/upCustExt",MainUrl];
    
    NSString *custId = [kUserDefaults objectForKey:kCustId];
    
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setObject:custId forKey:@"custId"];
    if (date != nil) {
        [param setObject:date forKey:@"birthday"];
    }
    if (sex != nil) {
        if ([sex isEqualToString:@"男"]) {
            [param setObject:@"0" forKey:@"sex"];
        }else{
            [param setObject:@"1" forKey:@"sex"];
        }
    }
    
    NSString *jsonStr = [Utils convertToJsonData:param];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:jsonStr forKey:@"params"];
    
    [self showHudInView:self.view hint:nil];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if (![responseObject isKindOfClass:[NSNull class]]&&![responseObject[@"code"] isKindOfClass:[NSNull class]]&&[responseObject[@"code"] isEqualToString:@"1"]) {
            
        }
    } failure:^(NSError *error) {
        [self hideHud];
    }];
}

#pragma mark 修改个人信息
-(void)upCustInfo:(NSString *)headUrl company:(NSString *)companyName companyid:(NSString *)companyId org:(NSString *)orgName orgid:(NSString *)orgId
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/upCustInfo",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:[kUserDefaults objectForKey:kCustId] forKey:@"custId"];
    if (headUrl != nil) {
        [params setObject:headUrl forKey:@"custHeadImage"];
    }
    if (companyName != nil) {
        [params setObject:companyName forKey:@"companyName"];
        [params setObject:companyId forKey:@"companyId"];
        [params setObject:@"" forKey:@"orgName"];
        [params setObject:@"" forKey:@"orgId"];
    }
    
    if (orgName != nil) {
        [params setObject:orgName forKey:@"orgName"];
        [params setObject:orgId forKey:@"orgId"];
    }
    
    NSString *jsonStr = [Utils convertToJsonData:params];
    
    NSMutableDictionary *jsonParam = @{}.mutableCopy;
    [jsonParam setObject:jsonStr forKey:@"param"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:jsonParam progressFloat:nil succeed:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            UserModel *model = [[UserModel alloc] initWithDataDic:responseObject[@"responseData"]];
            
            if (![model.ORG_ID isKindOfClass:[NSNull class]]&&_model.ORG_ID != nil) {
                [kUserDefaults setObject:[model.ORG_ID stringValue] forKey:OrgId];
            }else{
                [kUserDefaults setObject:@"" forKey:OrgId];
            }
            
            if (![model.COMPANY_ID isKindOfClass:[NSNull class]]&&model.COMPANY_ID != nil) {
                [kUserDefaults setObject:[model.COMPANY_ID stringValue] forKey:companyID];
            }else{
                [kUserDefaults setObject:@"" forKey:companyID];
            }
            [kUserDefaults synchronize];
            
            if ([_type isEqualToString:@"1"]) {
                if([model.COMPANY_ID isKindOfClass:[NSNull class]]||model.COMPANY_ID == nil||[model.ORG_ID isKindOfClass:[NSNull class]]||model.ORG_ID == nil){
                    [self showHint:@"请完善公司与部门信息！"];
                    IsSuccess = NO;
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
            [self _loadData];
            [self _loadKqPublicConfig];
        }else{
            if(![responseObject[@"message"] isKindOfClass:[NSNull class]]&&responseObject[@"message"] != nil){
                [self showHint:responseObject[@"message"]];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 加载考勤公共参数
-(void)_loadKqPublicConfig
{
    NSString *custId = [[NSUserDefaults standardUserDefaults] objectForKey:kCustId];
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/getCustInfo", MainUrl];
    NSMutableDictionary *param = @{}.mutableCopy;
    if(![custId isKindOfClass:[NSNull class]]&&custId != nil){
        [param setObject:custId forKey:@"custId"];
    }
    [[NetworkClient sharedInstance] POST:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
        if([responseObject[@"code"] isEqualToString:@"1"]){
            PersonMsgModel *model = [[PersonMsgModel alloc] initWithDataDic:responseObject[@"responseData"]];
            if ([model.COMPANY_ID isKindOfClass:[NSNull class]]||[model.COMPANY_ID stringValue] == nil) {
                [self loadKqConfig:nil];
            }else{
                [kUserDefaults setObject:[model.COMPANY_ID stringValue] forKey:companyID];
                [kUserDefaults synchronize];
                [self loadKqConfig:[model.COMPANY_ID stringValue]];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)loadKqConfig:(NSString *)companyId
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/attendance/getAttendanceParam",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    if ([companyId isKindOfClass:[NSNull class]]||companyId == nil) {
        [params setObject:@"" forKey:@"companyId"];
    }else{
        [params setObject:companyId forKey:@"companyId"];
    }
    
    NSString *jsonStr = [Utils convertToJsonData:params];
    NSMutableDictionary *jsonParams = @{}.mutableCopy;
    [jsonParams setObject:jsonStr forKey:@"param"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:jsonParams progressFloat:nil succeed:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            NSDictionary *paramConfig = responseObject[@"responseData"];
            NSString *attendancePosition = paramConfig[@"attendancePosition"];
            NSString *attendanceTime = paramConfig[@"attendanceTime"];
            NSString *attendanceRange = paramConfig[@"attendanceRange"];
            [kUserDefaults setObject:attendancePosition forKey:kqPosition];
            [kUserDefaults setObject:attendanceTime forKey:kqTime];
            [kUserDefaults setObject:attendanceRange forKey:kqRange];
            [kUserDefaults synchronize];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Picker view data source

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return _dataArr.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return self.view.bounds.size.width;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    if (!view) {
        view = [[UIView alloc] init];
    }
    UILabel *textlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    textlabel.textAlignment = NSTextAlignmentCenter;
    if (tableSelectIndex == 4) {
        textlabel.text = _companyNameArr[row];
    }else if(tableSelectIndex == 2){
        textlabel.text = _dataArr[row];
    }else{
        textlabel.text = _orgNameArr[row];
    }
    
    textlabel.font = [UIFont systemFontOfSize:19];
    [view addSubview:textlabel];
    return view;
}

// didSelectRow
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectIndex = row;
}

// 取消
- (void)dateCancel {
    self.tableView.scrollEnabled = YES;
    _dateView.hidden = YES;
}

// 完成
- (void)dateDone {
    self.tableView.scrollEnabled = YES;
    _dateView.hidden = YES;
    
    if (tableSelectIndex == 4) {
        NSString *companyName = _companyNameArr[selectIndex];
        CompanyModel *model = _companyArr[selectIndex];
        companyLab.text = companyName;
        NSString *companyId = [NSString stringWithFormat:@"%@",model.COMPANY_ID];
        [self upCustInfo:nil company:companyName companyid:companyId org:nil orgid:nil];
    }else if(tableSelectIndex == 2){
        sexLab.text = [NSString stringWithFormat:@"%@",_dataArr[selectIndex]];
        
        [self updateBirthdayDate:nil OrUpdateSex:sexLab.text];
    }else{
        NSString *orgName = _orgNameArr[selectIndex];
        orgLab.text = orgName;
        OrgModel *model = _orgArr[selectIndex];
        NSString *ordid = [NSString stringWithFormat:@"%@",model.ORG_ID];
        [self upCustInfo:nil company:nil companyid:nil org:orgName orgid:ordid];
    }
}

#pragma mark 加载部门信息
-(void)_loadOrgData:(UserModel *)model
{
    [self showHudInView:self.view hint:@""];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/public/getOrgListByCompanyId?companyId=%@",MainUrl,model.COMPANY_ID];
    
    [[NetworkClient sharedInstance] GET:urlStr dict:nil progressFloat:nil succeed:^(id responseObject) {
        
        [_orgNameArr removeAllObjects];
        [_orgArr removeAllObjects];
        [self hideHud];
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            
            NSArray *arr = responseObject[@"responseData"];
            
            if (arr.count == 0||[arr isKindOfClass:[NSNull class]]) {
                [self showHint:@"没有部门信息!"];
                return;
            }
            
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = (NSDictionary *)obj;
                OrgModel *model = [[OrgModel alloc] initWithDataDic:dic];
                [_orgNameArr addObject:model.ORG_NAME];
                [_orgArr addObject:model];
            }];
            
            _dataArr = _orgArr;
            _dateView.hidden = NO;
            self.tableView.scrollEnabled = NO;
            [_pickView reloadAllComponents];
            
        }
    } failure:^(NSError *error) {
        [self hideHud];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
