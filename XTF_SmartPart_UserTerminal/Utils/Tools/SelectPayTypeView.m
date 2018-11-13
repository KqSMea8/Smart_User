//
//  SelectPayTypeView.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/20.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "SelectPayTypeView.h"
#import "PayTypeTableViewCell.h"
#import "SelectPayTypeModel.h"

@interface SelectPayTypeView()<UITableViewDelegate,UITableViewDataSource>
{
    UIView *_contentView;
    UILabel *titleLab;
    UIButton *closeBtn;
    UITableView *tableView;
    
    NSInteger selectIndex;
    
    NSMutableArray *dataArr;
}

@end

@implementation SelectPayTypeView

- (id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame])
    {
        dataArr = @[].mutableCopy;
        
        [self initContent];
    }
    
    return self;
}

- (void)initContent
{
    self.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    
    selectIndex = 0;
    
    //alpha 0.0  白色   alpha 1 ：黑色   alpha 0～1 ：遮罩颜色，逐渐
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)]];
    
    if (_contentView == nil)
    {
        
//        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - 116, KScreenWidth, 116)];
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - 216, KScreenWidth, 216)];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        
        titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 14, 180, 22)];
        titleLab.centerX = _contentView.width/2;
        titleLab.text = @"请选择支付方式";
        titleLab.font = [UIFont systemFontOfSize:20];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.textColor = [UIColor blackColor];
        [_contentView addSubview:titleLab];
        
        closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"pop_window_close"] forState:UIControlStateNormal];
        closeBtn.frame = CGRectMake(_contentView.width-43, 0, 33, 33);
        closeBtn.centerY = titleLab.centerY;
        [_contentView addSubview:closeBtn];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, titleLab.bottom+14, _contentView.width, 0.5)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#BEBEBE"];
        [_contentView addSubview:lineView];
        
        tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, lineView.bottom, _contentView.width, _contentView.height-lineView.bottom) style:UITableViewStylePlain];
        [tableView registerNib:[UINib nibWithNibName:@"PayTypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"PayTypeTableViewCell"];
        tableView.separatorColor = [UIColor clearColor];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.bounces = NO;
        [_contentView addSubview:tableView];
    }
    
}

-(void)setBalanceStr:(NSString *)balanceStr
{
    _balanceStr = balanceStr;
    
    [self initData];
}

-(void)initData{
    
    NSMutableDictionary *cardDic = @{@"payTypeImage":@"card_pay",@"descriptionMsg":_balanceStr,@"status":@"1"}.mutableCopy;
    NSMutableDictionary *alipayDic = @{@"payTypeImage":@"alipay",@"descriptionMsg":@"支付宝",@"status":@"0"}.mutableCopy;
    NSMutableDictionary *wechatDic = @{@"payTypeImage":@"wechat",@"descriptionMsg":@"微信",@"status":@"0"}.mutableCopy;
    
    if (_currentSelectIndex == 1) {
        [cardDic setValue:@"1" forKey:@"status"];
        [alipayDic setValue:@"0" forKey:@"status"];
        [wechatDic setValue:@"0" forKey:@"status"];
    }else if (_currentSelectIndex == 2){
        [cardDic setValue:@"0" forKey:@"status"];
        [alipayDic setValue:@"1" forKey:@"status"];
        [wechatDic setValue:@"0" forKey:@"status"];
    }else{
        [cardDic setValue:@"0" forKey:@"status"];
        [alipayDic setValue:@"0" forKey:@"status"];
        [wechatDic setValue:@"1" forKey:@"status"];
    }

    NSMutableArray *arr = @[].mutableCopy;
    if([[[NSUserDefaults standardUserDefaults] objectForKey:KLoginWay] isEqualToString:KLogin]){
        [arr addObject:cardDic];
    }
    
    [arr addObject:alipayDic];
    [arr addObject:wechatDic];
    
    [dataArr removeAllObjects];
    
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SelectPayTypeModel *model = [[SelectPayTypeModel alloc] initWithDataDic:obj];
        [dataArr addObject:model];
    }];
    
    [tableView reloadData];
}

#pragma mark tableview delegate and datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[kUserDefaults objectForKey:KLoginWay] isEqualToString:KLogin]) {
        return 3;
    }else{
        return 2;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[kUserDefaults objectForKey:KLoginWay] isEqualToString:KLogin]) {
        return tableView.height/3;
    }else{
        return tableView.height/2;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PayTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayTypeTableViewCell" forIndexPath:indexPath];
    
    cell.model = dataArr[indexPath.row];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.height-0.5, cell.contentView.width, 0.5)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
    [cell.contentView addSubview:lineView];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectPayTypeModel *model = dataArr[selectIndex];
    model.status = @"0";
    
    SelectPayTypeModel *model1 = dataArr[indexPath.row];
    model1.status = @"1";
    
    selectIndex = indexPath.row;
    
    if (indexPath.row == 0) {
        if ([[kUserDefaults objectForKey:KLoginWay] isEqualToString:KLogin]) {
            if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(currentSelectPayType:)]) {
                [self.delegate currentSelectPayType:cardpay];
            }
        }else{
            if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(currentSelectPayType:)]) {
                [self.delegate currentSelectPayType:alipay];
            }
        }
        
    }else if (indexPath.row == 1)
    {
        if ([[kUserDefaults objectForKey:KLoginWay] isEqualToString:KLogin]) {
            if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(currentSelectPayType:)]) {
                [self.delegate currentSelectPayType:alipay];
            }
        }else{
            if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(currentSelectPayType:)]) {
                [self.delegate currentSelectPayType:wechatpay];
            }
        }
        
    }else
    {
        if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(currentSelectPayType:)]) {
            [self.delegate currentSelectPayType:wechatpay];
        }
    }
    
    [self disMissView];
}

- (void)loadMaskView
{
    
}

//展示从底部向上弹出的UIView（包含遮罩）
- (void)showInView:(UIView *)view
{
    if (!view)
    {
        return;
    }
    
    [view addSubview:self];
    [view addSubview:_contentView];
    
    [_contentView setFrame:CGRectMake(0, KScreenHeight, KScreenWidth, 216)];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 1.0;
        
        [_contentView setFrame:CGRectMake(0, KScreenHeight - 216, KScreenWidth, 216)];
        
    } completion:nil];
}

-(void)closeBtnAction
{
    [self disMissView];
}

//移除从上向底部弹下去的UIView（包含遮罩）
- (void)disMissView
{
    [_contentView setFrame:CGRectMake(0, KScreenHeight - 216, KScreenWidth, 216)];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         self.alpha = 0.0;
                         
                         [_contentView setFrame:CGRectMake(0, KScreenHeight, KScreenWidth, 216)];
                     }
                     completion:^(BOOL finished){
                         
                         [self removeFromSuperview];
                         [_contentView removeFromSuperview];
                         
                     }];
    
}

@end
