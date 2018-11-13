//
//  VisitRecordDetailController.m
//  DXWingGate
//
//  Created by coder on 2018/8/27.
//  Copyright © 2018年 com.Transfar. All rights reserved.
//

#import "VisitRecordDetailController.h"
#import "Utils.h"

@interface VisitRecordDetailController ()
{
    __weak IBOutlet UILabel *beginTimeLab;
    __weak IBOutlet UILabel *endTimeLab;
    __weak IBOutlet UILabel *visitNameLab;
    __weak IBOutlet UILabel *visitPhoneLab;
    __weak IBOutlet UILabel *sexLab;
    __weak IBOutlet UILabel *personWithLab;
    __weak IBOutlet UILabel *carLab;
    __weak IBOutlet UIImageView *qrCodeView;
    __weak IBOutlet UILabel *createTimeLab;
    __weak IBOutlet UIButton *reSendBtn;
    __weak IBOutlet UIImageView *statusView;
    UIButton *tryButton;
}

@end

@implementation VisitRecordDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initNavItems];
    
    tryButton = [[UIButton alloc] init];
    tryButton.frame = CGRectMake(0,self.view.frame.size.height-60-kTopHeight,self.view.frame.size.width,60);
    [tryButton setBackgroundColor:[UIColor colorWithHexString:@"#1B82D1"]];
    [tryButton addTarget:self action:@selector(tryButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:tryButton];
    [self.tableView bringSubviewToFront:tryButton];
    
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    self.tableView.userInteractionEnabled = YES;
    
    [reSendBtn.titleLabel setTextColor:[UIColor colorWithHexString:@"#1B82D1"]];
    
    if (![_model.carNo isKindOfClass:[NSNull class]]&&_model.carNo != nil&&_model.carNo.length != 0) {
        carLab.text = [NSString stringWithFormat:@"%@",_model.carNo];
    }else{
        carLab.text = @"-";
    }
    
    NSString *beginStr = [Utils exchWith:_model.beginTime WithFormatter:@"yyyy/MM/dd HH:mm:ss"];
    NSMutableAttributedString *beginAttStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"起 %@",beginStr]];
    NSDictionary *beginAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#1B82D1"]};
    [beginAttStr setAttributes:beginAttributes range:NSMakeRange(0,1)];
    beginTimeLab.attributedText = beginAttStr;
    
    NSString *endStr = [Utils exchWith:_model.endTime WithFormatter:@"yyyy/MM/dd HH:mm:ss"];
    NSMutableAttributedString *endAttStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"止 %@",endStr]];
    NSDictionary *endAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FF4359"]};
    [endAttStr setAttributes:endAttributes range:NSMakeRange(0,1)];
    endTimeLab.attributedText = endAttStr;
    
    NSString *dateString = [Utils exchWith:_model.createTime WithFormatter:@"yyyy/MM/dd HH:mm:ss"];
    
    createTimeLab.text = [NSString stringWithFormat:@"%@",dateString];
    
    visitNameLab.text = [NSString stringWithFormat:@"%@(",_model.visitorName];
    
    if (![_model.visitorPhone isKindOfClass:[NSNull class]]&&_model.visitorPhone != nil&&_model.visitorPhone.length>0) {
        visitPhoneLab.text = [NSString stringWithFormat:@"%@",_model.visitorPhone];
    }else{
        visitPhoneLab.text = @"-";
    }
    
    NSInteger sex = _model.visitorSex.integerValue;
    switch (sex) {
        case 1:
        {
            sexLab.text = [NSString stringWithFormat:@") 男"];
        }
            break;
        case 2:
        {
            sexLab.text = [NSString stringWithFormat:@") 女"];
        }
            break;
        case 3:
        {
            sexLab.text = [NSString stringWithFormat:@")"];
        }
            break;
        default:
            break;
    }
    
    NSString *personWithStr;
    if (![_model.persionWith isKindOfClass:[NSNull class]]) {
        NSString *strUrl = [_model.persionWith stringByReplacingOccurrencesOfString:@"，" withString:@","];
        personWithStr = [strUrl stringByReplacingOccurrencesOfString:@"," withString:@" "];
        personWithLab.text = [NSString stringWithFormat:@"%@",personWithStr];
    }else{
        personWithLab.text = @"-";
    }
    
    [qrCodeView sd_setImageWithURL:[NSURL URLWithString:_model.qrCode] placeholderImage:nil];
    
    NSInteger status = _model.status.integerValue;
    switch (status) {
        case 0:
        {
            statusView.image = [UIImage imageNamed:@"visit_unarrive"];
            [tryButton setTitle:@"取消预约" forState:UIControlStateNormal];
        }
            break;
        case 1:
        {
            statusView.image = [UIImage imageNamed:@"visit_visiting"];
            [tryButton setTitle:@"访问结束" forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            statusView.image = [UIImage imageNamed:@"visit_leave"];
            reSendBtn.hidden = YES;
            tryButton.hidden = YES;
        }
            break;
        case 3:
        {
            statusView.image = [UIImage imageNamed:@"visit_cancle"];
            reSendBtn.hidden = YES;
            tryButton.hidden = YES;
        }
            break;
        case 4:
        {
            statusView.image = [UIImage imageNamed:@"visit_leave"];
            reSendBtn.hidden = YES;
            tryButton.hidden = YES;
        }
            break;
        default:
            break;
    }
}

-(void)_initNavItems
{
    self.title = @"预约申请详情";
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#E2E2E2"];
    
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

-(void)setModel:(VisitHistoryModel *)model
{
    _model = model;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reSendBtnAction:(id)sender {
    [self showHudInView:self.view hint:nil];
    NSString *urlStr = [NSString stringWithFormat:@"%@/visitor/resendQrCode",MainUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:_model.appointmentId forKey:@"appointmentId"];
    
    NSString *jsonStr = [Utils convertToJsonData:params];
    
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setObject:jsonStr forKey:@"param"];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if (![responseObject[@"code"] isKindOfClass:[NSNull class]]&&[responseObject[@"code"] isEqualToString:@"1"]) {
            
        }
        [self showHint:[NSString stringWithFormat:@"%@",responseObject[@"message"]]];
    } failure:^(NSError *error) {
        [self hideHud];
        [self showHint:@"发送失败,请重试!"];
    }];
}

-(void)tryButtonAction:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"取消预约"]) {
        //取消预约
        [self cancleVisitRes];
    }else{
        //访问结束
        [self endVisit];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    tryButton.frame = CGRectMake(0, (self.tableView.frame.size.height - 60) + self.tableView.contentOffset.y , tryButton.frame.size.width,tryButton.frame.size.height);
}

-(void)cancleVisitRes
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/visitor/cancelAppointment",MainUrl];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:_model.appointmentId forKey:@"appointmentId"];
    
    NSString *jsonStr = [Utils convertToJsonData:params];
    
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setObject:jsonStr forKey:@"param"];
    
    [self showHudInView:self.view hint:nil];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if (![responseObject[@"code"] isKindOfClass:[NSNull class]]&&[responseObject[@"code"] isEqualToString:@"1"]) {
            [self showHint:@"取消预约成功!"];
            [self performSelector:@selector(popViewCtrl) withObject:nil afterDelay:1.5];
        }else{
            [self showHint:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        [self hideHud];
        [self showHint:@"请重试!"];
    }];
}

-(void)endVisit
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/visitor/finishAppointment",MainUrl];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:_model.appointmentId forKey:@"appointmentId"];
    
    NSString *jsonStr = [Utils convertToJsonData:params];
    
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setObject:jsonStr forKey:@"param"];
    
    [self showHudInView:self.view hint:nil];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:param progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        [self showHint:responseObject[@"message"]];
        if (![responseObject[@"code"] isKindOfClass:[NSNull class]]&&[responseObject[@"code"] isEqualToString:@"1"]) {
            [self performSelector:@selector(popViewCtrl) withObject:nil afterDelay:1.5];
        }else{
            
        }
    } failure:^(NSError *error) {
        [self hideHud];
        [self showHint:@"请重试!"];
    }];
}

-(void)popViewCtrl{
    [self.navigationController popViewControllerAnimated:YES];
    [kNotificationCenter postNotificationName:@"visitResStatusChangeNotification" object:nil];
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
