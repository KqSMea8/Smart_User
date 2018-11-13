//
//  GuideViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2018/3/19.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "GuideViewController.h"

@interface GuideViewController ()<UIScrollViewDelegate>
{
    UIPageControl *pageControl;
    // 判断是否是第一次进入应用
    BOOL flag;
}

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView *myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    UIImage *image;
    for (int i=0; i<4; i++) {
        if (kDevice_Is_iPhoneX) {
            image = [UIImage imageNamed:[NSString stringWithFormat:@"X_Y%d.jpg",i+1]];
        }else{
            image = [UIImage imageNamed:[NSString stringWithFormat:@"Y%d.jpg",i+1]];
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth * i, 0, KScreenWidth, KScreenHeight)];
        // 在最后一页创建按钮
        if (i == 3) {
            imageView.userInteractionEnabled = YES;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.frame = CGRectMake(KScreenWidth / 3, KScreenHeight - 100, 130, 50);
            [button setTitle:@"立即体验" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:@"#0B82D1"] forState:UIControlStateNormal];
            button.layer.borderWidth = 0.5;
            button.layer.cornerRadius = 5;
            button.clipsToBounds = YES;
            button.backgroundColor = [UIColor clearColor];
            button.layer.borderColor = [UIColor colorWithHexString:@"#0B82D1"].CGColor;
            [button addTarget:self action:@selector(go:) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:button];
        }
        imageView.image = image;
        [myScrollView addSubview:imageView];
    }
    myScrollView.bounces = NO;
    myScrollView.pagingEnabled = YES;
    myScrollView.showsHorizontalScrollIndicator = NO;
    myScrollView.contentSize = CGSizeMake(KScreenWidth * 4, KScreenHeight);
    myScrollView.delegate = self;
    [self.view addSubview:myScrollView];
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(KScreenWidth / 3, KScreenHeight * 15 / 16, KScreenWidth / 3, KScreenHeight / 16)];
    
    pageControl.numberOfPages = 4;
    // 设置页码的点的颜色
    pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"#E2E2E2"];
    // 设置当前页码的点颜色
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#0B82D1"];
    
    [self.view addSubview:pageControl];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 计算当前在第几页
    pageControl.currentPage = (NSInteger)(scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width);
}

//-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    if (scrollView.contentOffset.x > KScreenWidth * 3) {
//        [self go:nil];
//    }
//}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    //水平滑动时 判断是右滑还是左滑
    if(velocity.x>0){
        //左滑
        if (scrollView.contentOffset.x >= KScreenWidth * 3) {
            [self go:nil];
        }
    }
}

// 点击按钮保存数据并切换根视图控制器
- (void) go:(UIButton *)sender{
    flag = YES;
    
    [kUserDefaults setBool:flag forKey:@"notFirst"];
    [kUserDefaults synchronize];
    // 切换根视图控制器
    
    UINavigationController *navVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginNavViewController"];
    self.view.window.rootViewController = navVC;
    
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
