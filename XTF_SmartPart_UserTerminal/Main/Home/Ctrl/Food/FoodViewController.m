//
//  FoodViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2017/12/1.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "FoodViewController.h"
#import "WebLoadFailView.h"
#import "NoDataView.h"
#import "Utils.h"

#import "PreviewViewController.h"

@interface FoodViewController ()<UIWebViewDelegate,WebLoadFailDelegate,reloadDelegate>
{
    NoDataView *nodataView;
    WebLoadFailView *webLoadFailView;
}

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (nonatomic,strong) UIWebView *webView;

@end

@implementation FoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _initNavItems];
    
    [self _initView];
    
    [self loadData];
}

-(void)setTitleStr:(NSString *)titleStr
{
    _titleStr = titleStr;
}

-(void)_initNavItems
{
//    self.title = _titleStr;
    NSString *title = [Utils currentWeek];
    self.title = [NSString stringWithFormat:@"%@菜谱",title];
    
    UIButton *leftBtn = [[UIButton alloc] init];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [leftBtn setImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(_leftBarBtnItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *rightBtn = [[UIButton alloc] init];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    [rightBtn setTitle:@"就餐热度" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [rightBtn addTarget:self action:@selector(_rightBarBtnItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtnItems = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItems;
}

- (UIWebView *)webView{
    if (!_webView) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame: CGRectMake(0, 0, KScreenWidth, KScreenHeight-kTopHeight)];
        webView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
        webView.delegate = self;
        webView.scrollView.bounces = NO;
        webView.scalesPageToFit = YES;
        
        self.webView = webView;
    }
    return _webView;
}

- (void)loadData{
//    http://220.168.59.11:8083/txshop/prod/jrcp.action
//    NSString *urlString = [NSString stringWithFormat:@"%@/h5/diningUser/html/jrcp.jsp",MainUrl];
    NSString *urlString = @"http://220.168.59.11:8083/txshop/prod/jrcp.action";
//    NSString *urlString = [NSString stringWithFormat:@"http://220.168.59.11:8083/txshop/shop/dingdan/initDingdaninfo.action?sellersId=064df94aa5124e64a1514ee17ef76a91&txuuid=61f6aff9e51e470ab44a7dcb6d1a8ca6"];

    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:request];
}
/*
#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [self showHudInView:self.view hint:@"加载中~"];
    NSHTTPURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    if (response.statusCode != 200) {
        [self hideHud];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        webView.hidden = YES;
        nodataView.hidden = YES;
        webLoadFailView.hidden = NO;
        
    }else{
        webView.hidden = NO;
        nodataView.hidden = YES;
        webLoadFailView.hidden = YES;
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
    webLoadFailView.hidden = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    webView.hidden = YES;
    nodataView.hidden = NO;
    webLoadFailView.hidden = YES;
    [self hideHud];
}
*/
#pragma mark UIWebView协议
- (void)webViewDidStartLoad:(UIWebView *)webView {
    webView.hidden = NO;
    [self showHudInView:self.view hint:nil];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideHud];
    
    //    NSString *htmlTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    //    self.title = htmlTitle;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self hideHud];
    [self showHint:@"加载失败"];
    
    nodataView.hidden = NO;
    webLoadFailView.hidden = YES;
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]  completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode != 200) {
            [self hideHud];
            webLoadFailView.hidden = NO;
            nodataView.hidden = YES;
        }else {
            webLoadFailView.hidden = YES;
            nodataView.hidden = YES;
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
-(void)_initView
{
    [self.view addSubview:self.webView];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    nodataView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-kTopHeight)];
    nodataView.hidden = YES;
    nodataView.delegate = self;
    nodataView.label.text = @"对不起,网络连接失败";
    nodataView.imgView.image = [UIImage imageNamed:@"webView_noNetWork"];
    nodataView.imgView.frame = CGRectMake(10, 15, 150, 150);
    [self.view addSubview:nodataView];
    
    webLoadFailView = [[WebLoadFailView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-kTopHeight)];
    webLoadFailView.hidden = YES;
    webLoadFailView.webLoadFailDelegate = self;
    [self.view addSubview:webLoadFailView];
}

#pragma mark 无网络重新刷新
-(void)reload
{
    [self reloadWeb];
}

-(void)reloadWeb{
    [_webView removeFromSuperview];
    _webView.delegate = nil;
    _webView = nil;
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-kTopHeight)];
    _webView.scrollView.bounces = NO;
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    [self.view insertSubview:_webView belowSubview:nodataView];
    
//    NSString *urlString = [NSString stringWithFormat:@"%@/h5/diningUser/html/jrcp.jsp",MainUrl];
    NSString *urlString = @"http://220.168.59.11:8083/txshop/prod/jrcp.action";
//    NSString *urlString = [NSString stringWithFormat:@"http://220.168.59.11:8083/txshop/shop/dingdan/initDingdaninfo.action?sellersId=064df94aa5124e64a1514ee17ef76a91&txuuid=61f6aff9e51e470ab44a7dcb6d1a8ca6"];
    
    NSURLRequest *reqest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    [_webView loadRequest:reqest];
}

-(void)goHome{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)_leftBarBtnItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)_rightBarBtnItemClick
{
    PreviewViewController *previewVc = [[PreviewViewController alloc] init];
    [self.navigationController pushViewController:previewVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
