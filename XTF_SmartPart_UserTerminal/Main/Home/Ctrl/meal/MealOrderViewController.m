//
//  MealOrderViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 魏唯隆 on 2018/1/25.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "MealOrderViewController.h"
#import "NoDataView.h"
#import "DES3Util.h"
#import "Utils.h"
#import "WebLoadFailView.h"

@interface MealOrderViewController ()<UIWebViewDelegate,WebLoadFailDelegate>
{
    UIWebView *_webView;
    WebLoadFailView *webLoadFailView;
    NoDataView *_noDataView;
}

@end

@implementation MealOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initView];
}

- (void)_initView {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.text = @"我的订单";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:19];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    self.navigationItem.titleView = label;
    
    // titleView点击事件
    UITapGestureRecognizer *homeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadWebView)];
    label.userInteractionEnabled = YES;
    [label addGestureRecognizer:homeTap];
    
    UIButton *leftBtn = [[UIButton alloc] init];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [leftBtn setImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(_leftBarBtnItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    /*
    NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:KUserPhoneNum];
    NSString *desUrlStr = [DES3Util encryptUseDES:phone key:KPublicKey];
    desUrlStr = [Utils UrlValueEncode:desUrlStr];
     */
    
    NSString *custId = [[NSUserDefaults standardUserDefaults] objectForKey:kCustId];
    
    NSString *actUrl = [NSString stringWithFormat:@"%@/txshop/prodoffer/getOrderInfo.action?txuuid=%@",MealMainUrl, custId];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    _webView.scrollView.bounces = NO;
    NSURLRequest *reqest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:actUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    [_webView loadRequest:reqest];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    // 禁止左滑
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
    
    // 加载失败图片
    _noDataView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _noDataView.hidden = YES;
    _noDataView.backgroundColor = [UIColor whiteColor];
    _noDataView.label.text = @"对不起,网络连接失败";
    _noDataView.imgView.image = [UIImage imageNamed:@"webView_noNetWork"];
    _noDataView.imgView.frame = CGRectMake(10, 15, 150, 150);
    [self.view addSubview:_noDataView];
    
    webLoadFailView = [[WebLoadFailView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-kTopHeight)];
    webLoadFailView.hidden = YES;
    webLoadFailView.webLoadFailDelegate = self;
    [self.view addSubview:webLoadFailView];
    
}

- (void)_leftBarBtnItemClick {
//    if([_webView canGoBack]){
//        [_webView goBack];
//    }else {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark UIWebView协议
- (void)webViewDidStartLoad:(UIWebView *)webView {
    webView.hidden = NO;
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideHud];
    
    //    NSString *htmlTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    //    self.title = htmlTitle;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self hideHud];
    [self showHint:@"加载失败"];
    
    self.navigationController.navigationBar.hidden = NO;
    _noDataView.hidden = NO;
    webLoadFailView.hidden = YES;
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"-------------- %@", [NSString stringWithFormat:@"%@", request.URL]);
    [self showHudInView:self.view hint:@"加载中~"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]  completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode != 200) {
            [self hideHud];
            if (httpResponse.statusCode == 404) {
                _noDataView.hidden = YES;
                webLoadFailView.hidden = NO;
            }else{
                _noDataView.hidden = NO;
                webLoadFailView.hidden = YES;
            }
        }else{
            _noDataView.hidden = YES;
            webLoadFailView.hidden = YES;
        }
    }];
    
    NSString *str = @"about:blank";
    if([[NSString stringWithFormat:@"%@", request.URL] isEqualToString:str]){
        if([webView canGoBack]){
            [webView goBack];
        }
    }
    
    return YES;
}

- (void)reloadWebView {
    [_webView removeFromSuperview];
    _webView.delegate = nil;
    _webView = nil;
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    _webView.scrollView.bounces = NO;
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    /*
    NSString *phone = [[ NSUserDefaults standardUserDefaults] objectForKey:KUserPhoneNum];
    NSString *desUrlStr = [DES3Util encryptUseDES:phone key:KPublicKey];
    desUrlStr = [Utils UrlValueEncode:desUrlStr];
     */
    
    NSString *custId = [[NSUserDefaults standardUserDefaults] objectForKey:kCustId];
    
    NSString *actUrl = [NSString stringWithFormat:@"%@/txshop/prodoffer/getOrderInfo.action?txuuid=%@",MealMainUrl, custId];
    
    NSURLRequest *reqest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:actUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    [_webView loadRequest:reqest];
}

- (void)reloadWeb
{
    [self reloadWebView];
}
- (void)goHome
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
