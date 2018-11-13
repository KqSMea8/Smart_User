//
//  BindCarTableViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/3.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "BindCarTableViewController.h"

#import "InputKeyBoardView.h"
#import "NumInputView.h"

@interface BindCarTableViewController ()<UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>
{
    UITextField *_myProvinceTF;
    UITextField *_myLetterTF;
    
    UITextField *_carNumTF;
    
    UITextField *_myNum1TF;
    UITextField *_myNum2TF;
    UITextField *_myNum3TF;
    UITextField *_myNum4TF;
    UITextField *_myNum5TF;
    
    __weak IBOutlet UILabel *titleLab;
    
    __weak IBOutlet UITextField *_colorTF;
    __weak IBOutlet UITextField *typeTF;
    
    UIPickerView *_carPicker;
    UIToolbar *accessoryView;
    
    NSMutableArray *_carColorData;
    NSMutableArray *_carTypeData;
    NSInteger _currentIndex;
    NSString *_selCarType;
    BOOL _isNewEngry;
    __weak IBOutlet UIButton *selectNewEngryBtn;
    __weak IBOutlet UILabel *newEngryLab;
}

@property (weak, nonatomic) IBOutlet UIButton *bindCarBtn;

@property (weak, nonatomic) IBOutlet UIView *carNoContentView;

@end

@implementation BindCarTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _carColorData = @[@"黑色",@"红色",@"白色",@"蓝色"].mutableCopy;
    _carTypeData = @[@"小型车",@"中型车",@"大型车",@"电动车",@"摩托车"].mutableCopy;
    _selCarType = @"0";
    _isNewEngry = NO;
    
    [self _initView];
    
    [self _initNavItems];
    
    [self _initCarInputView];
}

#pragma mark 初始化键盘输入
-(void)_initView
{
    UITapGestureRecognizer *endDditTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditAction)];
    [self.tableView addGestureRecognizer:endDditTap];
    
    newEngryLab.userInteractionEnabled = YES;
    UITapGestureRecognizer *newEngryTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newEnergyTap)];
    [newEngryLab addGestureRecognizer:newEngryTap];
    
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    _bindCarBtn.layer.cornerRadius = 6;
    _bindCarBtn.layer.borderColor = [UIColor colorWithHexString:@"#D2D2D2"].CGColor;
    _bindCarBtn.layer.borderWidth = 0.5;
    
    _myProvinceTF = [[UITextField alloc] initWithFrame:CGRectZero];
    _myProvinceTF.tintColor = MainColor;
    _myLetterTF = [[UITextField alloc] initWithFrame:CGRectZero];
    _myLetterTF.tintColor = MainColor;
    _carNumTF = [[UITextField alloc] initWithFrame:CGRectZero];
    _carNumTF.tintColor = MainColor;
    _carNumTF.placeholder = @"请输入车牌号";
    _carNumTF.textColor = [UIColor colorWithHexString:@"#1B82D1"];
//    _myNum1TF = [[UITextField alloc] initWithFrame:CGRectZero];
//    _myNum1TF.tintColor = MainColor;
//    _myNum2TF = [[UITextField alloc] initWithFrame:CGRectZero];
//    _myNum2TF.tintColor = MainColor;
//    _myNum3TF = [[UITextField alloc] initWithFrame:CGRectZero];
//    _myNum3TF.tintColor = MainColor;
//    _myNum4TF = [[UITextField alloc] initWithFrame:CGRectZero];
//    _myNum4TF.tintColor = MainColor;
//    _myNum5TF = [[UITextField alloc] initWithFrame:CGRectZero];
//    _myNum5TF.tintColor = MainColor;
    
//    NSArray *textFs = @[_myProvinceTF, _myLetterTF, _myNum1TF, _myNum2TF, _myNum3TF, _myNum4TF, _myNum5TF];
    NSArray *textFs = @[_myProvinceTF, _myLetterTF, _carNumTF];
    for(int i=0; i<textFs.count; i++) {
        UITextField *textField = textFs[i];
//        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2.5, 45)];
//        textField.rightView = rightView;
//        textField.rightViewMode = UITextFieldViewModeAlways;
        textField.frame = CGRectMake(10*wScale + wScale*40*i + wScale*8*i, CGRectGetMaxY(titleLab.frame)+15*wScale, 40*wScale, 50*wScale);
        if (i>=2) {
//            textField.frame = CGRectMake(40*wScale + 40*i*wScale + 8*i*wScale, CGRectGetMaxY(titleLab.frame)+15*wScale, 40*wScale, 50*wScale);
            textField.frame = CGRectMake(40*wScale + 40*i*wScale + 8*i*wScale, CGRectGetMaxY(titleLab.frame)+15*wScale, KScreenWidth- (40*wScale + 40*i*wScale + 8*i*wScale+10), 50*wScale);
        }
//        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.layer.borderColor = [UIColor colorWithHexString:@"#1B82D1"].CGColor;
        textField.layer.borderWidth = 1;
        textField.layer.cornerRadius = 6;
        textField.textAlignment = NSTextAlignmentCenter;
        NSArray *titles = @[@"湘", @"A"];
        if(i == 0 || i == 1){
            textField.textColor = [UIColor whiteColor];
            textField.backgroundColor = [UIColor colorWithHexString:@"#1B82D1"];
            textField.text = titles[i];
        }
        [_carNoContentView addSubview:textField];
    }

    // 设置自定义键盘
    int verticalCount = 5;
    CGFloat kheight = KScreenWidth/10 + 8;
    InputKeyBoardView *keyBoardView = [[InputKeyBoardView alloc] initWithFrame:CGRectMake(0, KScreenHeight - kheight * verticalCount, KScreenWidth, kheight * verticalCount) withClickKeyBoard:^(NSString *character) {
        _myProvinceTF.text = character;
        [_myProvinceTF resignFirstResponder];
        [_myLetterTF becomeFirstResponder];
    } withDelete:^{
        if(_myProvinceTF.text.length > 0){
            _myProvinceTF.text = [_myProvinceTF.text substringWithRange:NSMakeRange(0, _myProvinceTF.text.length - 1)];
        }
    } withConfirm:^{
        [self.view endEditing:YES];
    } withChangeKeyBoard:^{
        
    }];
    [keyBoardView setNeedsDisplay];
    _myProvinceTF.inputView = keyBoardView;
    
//    NSArray *textFields = @[_myLetterTF, _myNum1TF, _myNum2TF, _myNum3TF, _myNum4TF, _myNum5TF];
    NSArray *textFields = @[_myLetterTF, _carNumTF];
    [textFields enumerateObjectsUsingBlock:^(UITextField *textField, NSUInteger idx, BOOL * _Nonnull stop) {
        //        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(8, 0, 8, 45)];
        dispatch_async(dispatch_get_main_queue(), ^{
            NumInputView *numInputView = [[NumInputView alloc] initWithFrame:CGRectMake(0, KScreenHeight - kheight * verticalCount, KScreenWidth, kheight * verticalCount) withClickKeyBoard:^(NSString *character) {
                textField.text = [textField.text stringByAppendingString:character];
                if(textField == _carNumTF){
                    NSDictionary *attrsDictionary =@{
                                                     NSFontAttributeName: textField.font,
                                                     NSKernAttributeName:[NSNumber numberWithFloat:15.0f]//这里修改字符间距
                                                     };
                    textField.attributedText = [[NSAttributedString alloc]initWithString:textField.text attributes:attrsDictionary];
                    
                    if (textField.text.length > 6) {
                        textField.text = [textField.text substringToIndex:6];
                    }
                    
                }
//                textField.text = character;
//                [textField resignFirstResponder];
                if(idx != (textFields.count - 1)){
                    UITextField *nextTF = textFields[idx + 1];
                    [nextTF becomeFirstResponder];
                }
            } withDelete:^{
                // 依次删除
                [self deleteTF];
                if(textField.text.length > 0){
                    textField.text = [textField.text substringWithRange:NSMakeRange(0, textField.text.length - 1)];
                }
            } withConfirm:^{
                [self.view endEditing:YES];
            } withChangeKeyBoard:^{
                
            }];
            [numInputView setNeedsDisplay];
            textField.inputView = numInputView;
        });
    }];
    
    typeTF.tintColor = [UIColor clearColor];
}

// 依次删除
- (void)deleteTF {
    if([_carNumTF isFirstResponder] && _carNumTF.text.length <= 0){
        [_myLetterTF becomeFirstResponder];
        _myLetterTF.text = @"";
    }
    else if([_myLetterTF isFirstResponder] && _myLetterTF.text.length <= 0){
        [_myProvinceTF becomeFirstResponder];
        _myProvinceTF.text = @"";
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 155*hScale;
    }else if(indexPath.row == 1){
        return 1;
    }else{
        return 60;
    }
}

-(void)_initNavItems {
    self.title = @"绑定车辆";
    
    UIButton *leftBtn = [[UIButton alloc] init];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [leftBtn setImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(_leftBarBtnItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)_initCarInputView {
    _colorTF.delegate = self;
    typeTF.delegate = self;
    
    // 时间选择器
    _carPicker = [[UIPickerView alloc]init];
    _carPicker.hidden = NO;
    _carPicker.frame = CGRectMake(0, KScreenHeight - 215, KScreenWidth, 215);
    _carPicker.backgroundColor = [UIColor whiteColor];
    _carPicker.delegate = self;
    _carPicker.dataSource = self;
    
    accessoryView = [[UIToolbar alloc] init];
    accessoryView.frame=CGRectMake(0, 0, KScreenWidth, 38);
    accessoryView.backgroundColor = [UIColor grayColor];
    UIBarButtonItem *cancelBtn=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(calcelAction)];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(selectDoneAction)];
    [doneBtn setTintColor:MainColor];
    UIBarButtonItem *spaceBtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    accessoryView.items=@[cancelBtn,spaceBtn,doneBtn];
    
    _colorTF.inputView = _carPicker;
    _colorTF.inputAccessoryView = accessoryView;
    
    typeTF.inputView = _carPicker;
    typeTF.inputAccessoryView = accessoryView;
}

#pragma mark UIPickView协议
//指定pickerview有几列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if([_colorTF isFirstResponder]){
        return _carColorData.count;
    }else {
        return _carTypeData.count;
    }
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if([_colorTF isFirstResponder] && _carColorData.count > row){
        return _carColorData[row];
    }else if(_carTypeData.count > row){
        return _carTypeData[row];
    }else {
        return 0;
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _currentIndex = row;
    if([typeTF isFirstResponder]){
        _selCarType = [NSString stringWithFormat:@"%ld", row];
    }
}

#pragma mark datepicker tool方法
- (void)calcelAction {
    [self.view endEditing:YES];
}

- (void)selectDoneAction {
    
    if([_colorTF isFirstResponder]){
        if(_carColorData.count > _currentIndex){
            NSString *curStr = _carColorData[_currentIndex];
            _colorTF.text = curStr;
        }
    }else {
        if(_carTypeData.count > _currentIndex){
            NSString *curStr = _carTypeData[_currentIndex];
            typeTF.text = curStr;
        }
    }
    
    [self.view endEditing:YES];
}

- (void)_leftBarBtnItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)bindcar:(id)sender {
//    if(_myProvinceTF.text.length <= 0 ||
//       _myLetterTF.text.length <= 0 ||
//       _myNum1TF.text.length <= 0 ||
//       _myNum2TF.text.length <= 0 ||
//       _myNum3TF.text.length <= 0 ||
//       _myNum4TF.text.length <= 0 ||
//       _myNum5TF.text.length <= 0
//       ){
//        [self showHint:@"请输入完整的车牌"];
//        return;
//    }
    [self endEditAction];
    if (_isNewEngry) {
        if(_myProvinceTF.text.length <= 0 ||
           _myLetterTF.text.length <= 0
           ){
            [self showHint:@"请输入真实有效的车牌"];
            return;
        }else{
            if (_carNumTF.text.length !=6) {
                if (_carNumTF.text.length < 5) {
                    [self showHint:@"请输入真实有效的车牌"];
                }else{
                    [self showHint:@"车牌号与能源类型不符!"];
                }
                
                return;
            }
        }
    }else{
        if(_myProvinceTF.text.length <= 0 ||
           _myLetterTF.text.length <= 0
           ){
            [self showHint:@"请输入真实有效的车牌"];
            return;
        }else{
            if (_carNumTF.text.length !=5) {
                if (_carNumTF.text.length < 5) {
                    [self showHint:@"请输入真实有效的车牌"];
                }else{
                    [self showHint:@"车牌号与能源类型不符!"];
                }
                return;
            }
        }
    }

    NSString *inputCarNo = [NSString stringWithFormat:@"%@%@%@", _myProvinceTF.text, _myLetterTF.text, _carNumTF.text];
    NSString *urlStr = [NSString stringWithFormat:@"%@park-service/member/addMemberCar",[kUserDefaults objectForKey:KParkUrl]];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    NSString *memberId = [[NSUserDefaults standardUserDefaults] objectForKey:KMemberId];
    if(memberId != nil){
        [params setObject:memberId forKey:@"memberId"];
    }
    [params setObject:KToken forKey:@"token"];
    [params setObject:inputCarNo forKey:@"carNo"];
    [params setObject:_selCarType forKey:@"carType"];
    [params setObject:@"" forKey:@"carNike"];
    
    [self showHudInView:self.view hint:nil];
    
    [[NetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if([responseObject[@"success"] boolValue]){
            [self showHint:@"绑定成功!"];
            // 绑定成功
            if(_bindSucDelegate && [_bindSucDelegate respondsToSelector:@selector(bindCarSuc)]){
                [_bindSucDelegate bindCarSuc];
            }
            [kNotificationCenter postNotificationName:@"refreshBindCarData" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            if (![responseObject[@"message"] isKindOfClass:[NSNull class]]&&responseObject[@"message"] != nil) {
                [self showHint:responseObject[@"message"]];
            }else{
                [self showHint:@"绑定失败!"];
            }
        }
    } failure:^(NSError *error) {
        [self hideHud];
    }];
}

-(void)endEditAction{
    [self.tableView endEditing:YES];
}

#pragma mark UITextField协议
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    [_carPicker reloadAllComponents];
//    return YES;
//}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    __block NSInteger row = 0;
    if(textField == _colorTF){
        [_carColorData enumerateObjectsUsingBlock:^(NSString *carColor, NSUInteger idx, BOOL * _Nonnull stop) {
            if([carColor isEqualToString:textField.text]){
                row = idx;
                *stop = YES;
            }
        }];
    }else {
        [_carTypeData enumerateObjectsUsingBlock:^(NSString *carType, NSUInteger idx, BOOL * _Nonnull stop) {
            if([carType isEqualToString:textField.text]){
                row = idx;
                *stop = YES;
            }
        }];
    }
    [_carPicker reloadAllComponents];
    [_carPicker selectRow:row inComponent:0 animated:YES];
    _currentIndex = row;
}

#pragma mark 新能源车
- (IBAction)newEnergyAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.selected) {
        _isNewEngry = NO;
    }else{
        _isNewEngry = YES;
    }
    btn.selected = !btn.selected;
}

-(void)newEnergyTap
{
    if (selectNewEngryBtn.selected) {
        _isNewEngry = NO;
    }else{
        _isNewEngry = YES;
    }
    selectNewEngryBtn.selected = !selectNewEngryBtn.selected;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
