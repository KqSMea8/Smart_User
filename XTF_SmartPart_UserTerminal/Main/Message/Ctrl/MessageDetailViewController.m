//
//  MessageDetailViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/6/26.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "BookRecordDetailController.h"

@interface MessageDetailViewController ()
{
    __weak IBOutlet UIView *messageDetailBackView;
}

@property (weak, nonatomic) IBOutlet UILabel *messageTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *messageContentLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@end

@implementation MessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavItems];
    
    [self initView];
}

-(void)initNavItems
{
    self.title = @"消息详情";
    
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

-(void)initView{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    _messageTitleLab.text = [NSString stringWithFormat:@"%@",_model.PUSH_TITLE];
    _messageContentLab.text = [NSString stringWithFormat:@"%@",_model.PUSH_CONTENT];
    _timeLab.text = [NSString stringWithFormat:@"%@",_model.PUSH_TIMESTR];
    
    messageDetailBackView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesAction)];
    [messageDetailBackView addGestureRecognizer:tapGes];
}

-(void)tapGesAction
{
    BookRecordDetailController *bookRecordDetailVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"BookRecordDetailController"];
    bookRecordDetailVC.orderId = _model.MESSAGE_PUSH_INDEX;
    [self.navigationController pushViewController:bookRecordDetailVC animated:YES];
}

-(void)setModel:(ParkMessageModel *)model
{
    _model = model;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
