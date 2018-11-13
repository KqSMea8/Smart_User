//
//  MealViewController.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 魏唯隆 on 2017/12/16.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "CategoryVC.h"
#import "ProductsVC.h"

@interface CategoryVC ()<UITableViewDelegate, UITableViewDataSource, ProductsDelegate>

@property (nonatomic, strong) UITableView *categoryTableView;
@property (nonatomic, strong) NSMutableArray *categoryArr;
@property (nonatomic, strong) ProductsVC *productsVC;

@end

@implementation CategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _categoryArr = @[].mutableCopy;
    
    [self _initView];
    
}

- (void)_initView {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100)];
    topView.backgroundColor = [UIColor colorWithHexString:@"#6ba8e5"];
    [self.view addSubview:topView];
    
    self.title = @"点餐";
    [self configData];
    [self createTableView];
    [self createProductsVC];
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

- (void)configData {
    
    NSArray *numArr = @[@"盖码饭",@"炒菜",@"盖码饭",@"炒菜"];
    for (int i = 0; i < 4; i++) {
        [_categoryArr addObject:numArr[i]];
    }
}

- (void)createTableView {
    
    self.categoryTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width * 0.25, self.view.frame.size.height - 100) style:UITableViewStylePlain];
    self.categoryTableView.delegate = self;
    self.categoryTableView.dataSource = self;
    self.categoryTableView.tableFooterView = [UIView new];
    self.categoryTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.categoryTableView];
}

- (void)createProductsVC {
    
    _productsVC = [[ProductsVC alloc] init];
    _productsVC.delegate = self;
    [self addChildViewController:_productsVC];
    [self.view addSubview:_productsVC.view];
}

//MARK:-tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _categoryArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *ident = @"ident";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    
    cell.textLabel.text = [_categoryArr objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_productsVC) {
        [_productsVC scrollToSelectedIndexPath:indexPath];
    }
}

#pragma mark - ProductsDelegate
- (void)willDisplayHeaderView:(NSInteger)section {
    
    [self.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:section inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

- (void)didEndDisplayingHeaderView:(NSInteger)section {
    if(_categoryArr.count > (section + 1)){
        [self.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:section + 1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
