//
//  UserAgreementViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/28.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "UserAgreementViewController.h"
#import "WebLoadFailView.h"
#import "NoDataView.h"

@interface UserAgreementViewController ()<UIWebViewDelegate,WebLoadFailDelegate>
{
    NoDataView *nodataView;
    WebLoadFailView *webLoadFailView;
    UIWebView *_webView;
}


@end

@implementation UserAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _initNavItems];
    
    [self _initView];
}

-(void)_initNavItems
{
    self.title = @"用户协议";
    
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

-(void)_initView{
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _webView.scalesPageToFit = YES;
    NSString *urlStr = [NSString stringWithFormat:@"%@/h5/user/html/yhxy.html", MainUrl];
    NSURL* url = [NSURL URLWithString:urlStr];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [_webView loadRequest:request];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    nodataView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    nodataView.hidden = YES;
    nodataView.label.text = @"对不起,网络连接失败";
    nodataView.imgView.image = [UIImage imageNamed:@"webView_noNetWork"];
    nodataView.imgView.frame = CGRectMake(0, 15, 150, 150);
    [self.view addSubview:nodataView];
    
    webLoadFailView = [[WebLoadFailView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    webLoadFailView.hidden = YES;
    webLoadFailView.webLoadFailDelegate = self;
    [self.view addSubview:webLoadFailView];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [self showHudInView:self.view hint:@"加载中~"];
    NSHTTPURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    if (response.statusCode != 200) {
        [self hideHud];
        if (response.statusCode == 404 ) {
            webView.hidden = YES;
            nodataView.hidden = YES;
            webLoadFailView.hidden = NO;
        }else{
            webView.hidden = YES;
            nodataView.hidden = NO;
            webLoadFailView.hidden = YES;
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    webView.hidden = NO;
    nodataView.hidden = YES;
    webLoadFailView.hidden = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideHud];
    webView.hidden = NO;
    nodataView.hidden = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self showHint:@"请重试!"];
    webView.hidden = YES;
    nodataView.hidden = NO;
    webLoadFailView.hidden = YES;
    [self hideHud];
}

- (void)reloadWeb {
    [_webView removeFromSuperview];
    _webView.delegate = nil;
    _webView = nil;
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _webView.scrollView.bounces = NO;
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/h5/user/html/yhxy.html", MainUrl];
    
    NSURLRequest *reqest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    [_webView loadRequest:reqest];
    
}

-(void)goHome{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
