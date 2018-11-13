//
//  ParkReservationTableViewCell.m
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/6/6.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "ParkReservationTableViewCell.h"
#import "CarListModel.h"

@interface ParkReservationTableViewCell()
{
    __weak IBOutlet UIView *cardNumBackView;
    __weak IBOutlet UILabel *boodCarLab;
    __weak IBOutlet UILabel *boodAreaLab;
    UIButton *btn;
}

@property (nonatomic,retain) NSMutableArray *selectBts;
@property (nonatomic,retain) NSMutableArray *parkNameBtns;

@end

@implementation ParkReservationTableViewCell

-(NSMutableArray *)selectBts
{
    if (_selectBts == nil) {
        _selectBts = [NSMutableArray array];
    }
    return _selectBts;
}

-(NSMutableArray *)parkNameBtns
{
    if (_parkNameBtns == nil) {
        _parkNameBtns = [NSMutableArray array];
    }
    return _parkNameBtns;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    [self initCardNum];
}

-(void)setDataArr:(NSMutableArray *)dataArr
{
    _dataArr = dataArr;
    
    if ([_dataArr isKindOfClass:[NSNull class]]||_dataArr == nil||_dataArr.count == 0) {
        return;
    }
    
    [dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [[self.contentView viewWithTag:100+idx] removeFromSuperview];
        [[self.contentView viewWithTag:200+idx] removeFromSuperview];
        [[[self.contentView viewWithTag:200+idx] viewWithTag:300+idx] removeFromSuperview];
    }];
    
    [dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CarListModel *model = (CarListModel *)obj;
        
        UIButton *selectBtn = [[UIButton alloc] init];
        selectBtn.tag = 100 + idx;
        [selectBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        selectBtn.frame = CGRectMake(boodCarLab.right, boodAreaLab.bottom+25.5 + 52.5*idx, 20, 20);
        [selectBtn setBackgroundImage:[UIImage imageNamed:@"round_select"] forState:UIControlStateSelected];
        if (idx == _selectIndex) {
            selectBtn.selected = YES;
            selectBtn.layer.borderWidth = 0.5;
            selectBtn.layer.borderColor = [UIColor clearColor].CGColor;
        }else{
            selectBtn.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
            selectBtn.layer.borderWidth = 0.5;
            selectBtn.selected = NO;
        }
        
        selectBtn.layer.cornerRadius = 10;
        [self.contentView addSubview:selectBtn];
        [self.selectBts addObject:selectBtn];
        
        UIButton *parkNameBtn = [[UIButton alloc] init];
        parkNameBtn.tag = 200 + idx;
        [parkNameBtn addTarget:self action:@selector(carNumBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        parkNameBtn.frame = CGRectMake(selectBtn.right + 10, 0, 113, 40);
        parkNameBtn.centerY = selectBtn.centerY;
        if ([model.carType isEqualToString:@"0"]) {
            [parkNameBtn setBackgroundImage:[UIImage imageNamed:@"carNoBg"] forState:UIControlStateNormal];
        }else{
            [parkNameBtn setBackgroundImage:[UIImage imageNamed:@"carNoBg_gray"] forState:UIControlStateNormal];
        }
        
        [parkNameBtn.titleLabel setFont:[UIFont fontWithName:@"MicrosoftYaHei" size:17]];
        parkNameBtn.layer.cornerRadius = 5;
        parkNameBtn.layer.borderWidth = 0.5;
        parkNameBtn.clipsToBounds = YES;
        [self.contentView addSubview:parkNameBtn];
        
        UILabel *carNumLab = [[UILabel alloc] init];
        carNumLab.tag = 300 + idx;
        carNumLab.font = [UIFont fontWithName:@"MicrosoftYaHei" size:17];
        carNumLab.textAlignment = NSTextAlignmentCenter;
        carNumLab.textColor = [UIColor whiteColor];
        carNumLab.frame = CGRectMake(5, 12, parkNameBtn.width-10, 24);
        carNumLab.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@ %@",model.carArea,model.carNum]];
        [parkNameBtn addSubview:carNumLab];
        [self.parkNameBtns addObject:parkNameBtn];
        
        if (idx >= 2) {
            *stop = !_isOverNeedHide;
        }
    }];
    
    if (_dataArr.count >3) {
        if (btn == nil) {
            btn = [[UIButton alloc] init];
            btn.frame = CGRectMake(KScreenWidth/2 - 15, self.height - 35, 30, 30);
            btn.backgroundColor = [UIColor clearColor];
            btn.selected = NO;
            [btn setBackgroundImage:[UIImage imageNamed:@"open_up"] forState:UIControlStateSelected];
            [btn setBackgroundImage:[UIImage imageNamed:@"open_down"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(unfoldOrCloseAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
    }
    
    if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(selectCarNum:withIndex:)]) {
        CarListModel *model = _dataArr[_selectIndex];
        [self.delegate selectCarNum:[NSString stringWithFormat:@"%@ %@",model.carArea,model.carNum] withIndex:_selectIndex];
    }
}

-(void)setIsOverNeedHide:(BOOL)isOverNeedHide
{
    _isOverNeedHide = isOverNeedHide;
}

-(void)selectBtnAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger index = btn.tag - 100;
    _selectIndex = index;
    CarListModel *model = _dataArr[index];
    switch (index) {
        case 0:
            if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(selectCarNum:withIndex:)]) {
                [self.delegate selectCarNum:[NSString stringWithFormat:@"%@ %@",model.carArea,model.carNum] withIndex:index];
            }
            [self changeSelectBtState:btn];
            break;
        case 1:
            if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(selectCarNum:withIndex:)]) {
                [self.delegate selectCarNum:[NSString stringWithFormat:@"%@ %@",model.carArea,model.carNum] withIndex:index];
            }
            [self changeSelectBtState:btn];
            break;
        case 2:
            if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(selectCarNum:withIndex:)]) {
                [self.delegate selectCarNum:[NSString stringWithFormat:@"%@ %@",model.carArea,model.carNum] withIndex:index];
            }
            [self changeSelectBtState:btn];
            break;
        case 3:
            if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(selectCarNum:withIndex:)]) {
                [self.delegate selectCarNum:[NSString stringWithFormat:@"%@ %@",model.carArea,model.carNum] withIndex:index];
            }
            [self changeSelectBtState:btn];
            break;
        case 4:
            if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(selectCarNum:withIndex:)]) {
                [self.delegate selectCarNum:[NSString stringWithFormat:@"%@ %@",model.carArea,model.carNum] withIndex:index];
            }
            [self changeSelectBtState:btn];
            break;
            
        default:
            break;
    }
}

-(void)carNumBtnAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger index = btn.tag - 200;
    _selectIndex = index;
    CarListModel *model = _dataArr[index];
    switch (index) {
        case 0:
            if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(selectCarNum:withIndex:)]) {
                [self.delegate selectCarNum:[NSString stringWithFormat:@"%@ %@",model.carArea,model.carNum] withIndex:index];
            }
            [self changeBtState:btn];
            break;
        case 1:
            if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(selectCarNum:withIndex:)]) {
                [self.delegate selectCarNum:[NSString stringWithFormat:@"%@ %@",model.carArea,model.carNum] withIndex:index];
            }
            [self changeBtState:btn];
            break;
        case 2:
            if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(selectCarNum:withIndex:)]) {
                [self.delegate selectCarNum:[NSString stringWithFormat:@"%@ %@",model.carArea,model.carNum] withIndex:index];
            }
            [self changeBtState:btn];
            break;
        case 3:
            if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(selectCarNum:withIndex:)]) {
                [self.delegate selectCarNum:[NSString stringWithFormat:@"%@ %@",model.carArea,model.carNum] withIndex:index];
            }
            [self changeBtState:btn];
            break;
        case 4:
            if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(selectCarNum:withIndex:)]) {
                [self.delegate selectCarNum:[NSString stringWithFormat:@"%@ %@",model.carArea,model.carNum] withIndex:index];
            }
            [self changeBtState:btn];
            break;
            
        default:
            break;
    }
}

- (void)changeBtState:(UIButton *)selBt {
    
    [_selectBts enumerateObjectsUsingBlock:^(UIButton *selectBt, NSUInteger idx, BOOL * _Nonnull stop) {
        selectBt.selected = NO;
        selectBt.layer.borderColor = [UIColor colorWithHexString:@"CCCCCC"].CGColor;
    }];
    
    UIButton *selectBtn = [self viewWithTag:(selBt.tag - 100)];
    selectBtn.selected = YES;
    selectBtn.layer.borderColor = [UIColor clearColor].CGColor;
}

- (void)changeSelectBtState:(UIButton *)selBt {
    
    [_selectBts enumerateObjectsUsingBlock:^(UIButton *selectBt, NSUInteger idx, BOOL * _Nonnull stop) {
        selectBt.selected = NO;
        selectBt.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
    }];
    
    selBt.selected = YES;
    selBt.layer.borderColor = [UIColor clearColor].CGColor;

}

-(void)unfoldOrCloseAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(unfoldOrCloseCell:)]) {
        if (btn.selected) {
            [self.delegate unfoldOrCloseCell:@"1"];
//            if (_selectIndex > 2) {
//                if (self.delegate != nil&&[self.delegate respondsToSelector:@selector(selectCarNum:withIndex:)]) {
//                    CarListModel *model = _dataArr[0];
//                    [self.delegate selectCarNum:[NSString stringWithFormat:@"%@ %@",model.carArea,model.carNum] withIndex:0];
//                }
//            }
        }else{
            [self.delegate unfoldOrCloseCell:@"0"];
        }
    }
    btn.selected = !btn.selected;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    btn.frame = CGRectMake(KScreenWidth/2 - 15, self.height - 35, 30, 30);
}

-(void)setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = selectIndex;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
