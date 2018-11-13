//
//  ParkReservationFooterView.m
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/6/6.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "ParkReservationFooterView.h"
#import "CarParkModel.h"

@interface ParkReservationFooterView(){
    __weak IBOutlet UIView *topview;
    __weak IBOutlet UILabel *bookAreaLab;
}

@property (nonatomic,retain) NSMutableArray *selectBts;
@property (nonatomic,retain) NSMutableArray *parkNameBtns;

@end

@implementation ParkReservationFooterView

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

- (instancetype)initWithFrame:(CGRect)frame {
     self = [super initWithFrame:frame];
     self = [[[NSBundle mainBundle] loadNibNamed:@"ParkReservationFooterView" owner:self options:nil] lastObject];
     if (self) {
         self.frame = frame;
         
     }
     return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
}

-(void)setDataArr:(NSMutableArray *)dataArr
{
    _dataArr = dataArr;
    [self initSubviews:dataArr];
}

-(void)initSubviews:(NSMutableArray *)arr
{
    
    for (int i = 0; i < arr.count; i++) {
        CarParkModel *model = arr[i];
        UIButton *selectBtn = [[UIButton alloc] init];
        selectBtn.tag = 100 + i;
        [selectBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        selectBtn.frame = CGRectMake(bookAreaLab.right, 27 + 51*i, 20, 20);
        [selectBtn setBackgroundImage:[UIImage imageNamed:@"round_select"] forState:UIControlStateSelected];
        if (i == 0) {
            selectBtn.selected = YES;
            selectBtn.layer.borderWidth = 0.5;
            selectBtn.layer.borderColor = [UIColor clearColor].CGColor;
        }else{
            selectBtn.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
            selectBtn.layer.borderWidth = 0.5;
            selectBtn.selected = NO;
        }
        selectBtn.layer.cornerRadius = 10;
        [self addSubview:selectBtn];
        [self.selectBts addObject:selectBtn];
        
        UIButton *parkNameBtn = [[UIButton alloc] init];
        parkNameBtn.tag = 200 + i;
        [parkNameBtn addTarget:self action:@selector(parkNameBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        parkNameBtn.frame = CGRectMake(selectBtn.right + 10, 0, 113, 40);
        parkNameBtn.centerY = selectBtn.centerY;
        [parkNameBtn setTitle:model.parkingAreaName forState:UIControlStateNormal];
        [parkNameBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [parkNameBtn.titleLabel setFont:[UIFont fontWithName:@"MicrosoftYaHei" size:17]];
        if (i == 0) {
            parkNameBtn.layer.borderColor = [UIColor colorWithHexString:@"#1B82D1"].CGColor;
        }else{
            parkNameBtn.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
        }
        parkNameBtn.layer.cornerRadius = 5;
        parkNameBtn.layer.borderWidth = 0.5;
        [self addSubview:parkNameBtn];
        [self.parkNameBtns addObject:parkNameBtn];
    }
}

-(void)parkNameBtnAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag - 200) {
        case 0:
            [self changeBtState:btn];
            break;
        case 1:
            [self changeBtState:btn];
            break;
        case 2:
            [self changeBtState:btn];
            break;
        case 3:
            [self changeBtState:btn];
            break;
        case 4:
            [self changeBtState:btn];
            break;
            
        default:
            break;
    }
}

- (void)changeBtState:(UIButton *)selBt {
    
    [_parkNameBtns enumerateObjectsUsingBlock:^(UIButton *numBt, NSUInteger idx, BOOL * _Nonnull stop) {
        numBt.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
    }];
    
    selBt.layer.borderColor = [UIColor colorWithHexString:@"#1B82D1"].CGColor;
    
    [_selectBts enumerateObjectsUsingBlock:^(UIButton *selectBt, NSUInteger idx, BOOL * _Nonnull stop) {
        selectBt.selected = NO;
        selectBt.layer.borderColor = [UIColor colorWithHexString:@"CCCCCC"].CGColor;
    }];
    
    UIButton *selectBtn = [self viewWithTag:(selBt.tag - 100)];
    selectBtn.selected = YES;
    selectBtn.layer.borderColor = [UIColor clearColor].CGColor;
}

-(void)selectBtnAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag - 100) {
        case 0:
            [self changeSelectBtState:btn];
            break;
        case 1:
            [self changeSelectBtState:btn];
            break;
        case 2:
            [self changeSelectBtState:btn];
            break;
        case 3:
            [self changeSelectBtState:btn];
            break;
        case 4:
            [self changeSelectBtState:btn];
            break;
            
        default:
            break;
    }
}

- (void)changeSelectBtState:(UIButton *)selBt {
    
    [_selectBts enumerateObjectsUsingBlock:^(UIButton *selectBt, NSUInteger idx, BOOL * _Nonnull stop) {
        selectBt.selected = NO;
        selectBt.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
    }];
    
    selBt.selected = YES;
    selBt.layer.borderColor = [UIColor clearColor].CGColor;
    
    [_parkNameBtns enumerateObjectsUsingBlock:^(UIButton *numBt, NSUInteger idx, BOOL * _Nonnull stop) {
        numBt.layer.borderColor = [UIColor colorWithHexString:@"CCCCCC"].CGColor;
    }];
    
    UIButton *selectBtn = [self viewWithTag:(selBt.tag + 100)];
    selectBtn.layer.borderColor = [UIColor colorWithHexString:@"#1B82D1"].CGColor;
}


@end
