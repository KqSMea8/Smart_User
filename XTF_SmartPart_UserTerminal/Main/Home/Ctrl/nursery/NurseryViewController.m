//
//  NurseryViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 魏唯隆 on 2018/1/25.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "NurseryViewController.h"
#import "NoDataView.h"
#import "WebLoadFailView.h"

@interface NurseryViewController ()<UIWebViewDelegate,WebLoadFailDelegate>
{
    UIWebView *_webView;
    
    UIView *_headView;
    NoDataView *_noDataView;
    WebLoadFailView *webLoadFailView;
}

@end

@implementation NurseryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initView];
}

- (void)_initView {
//    self.view.backgroundColor = [UIColor colorWithHexString:@"#7bb3e0"];
    
    NSString *actUrl = [NSString stringWithFormat:@"http://220.168.59.11:8083/hnzhxy/"];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _webView.backgroundColor = [UIColor colorWithHexString:@"#7bb3e0"];
    _webView.scrollView.bounces = NO;
    NSURLRequest *reqest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:actUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    [_webView loadRequest:reqest];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    // 禁止左滑
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
    
    // 头部视图
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 64)];
    _headView.hidden = YES;
    _headView.backgroundColor = [UIColor colorWithHexString:@"#272c40"];
    [self.view addSubview:_headView];
    
    UIButton *headBtn = [[UIButton alloc] init];
    headBtn.frame = CGRectMake(20, 20, 40, 40);
    [headBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [headBtn setImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
    [headBtn addTarget:self action:@selector(_leftBarBtnItemClick:) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:headBtn];
    
    // 加载失败图片
    _noDataView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight - 64)];
    _noDataView.hidden = YES;
    _noDataView.backgroundColor = [UIColor whiteColor];
    _noDataView.label.text = @"对不起,网络连接失败";
    _noDataView.imgView.image = [UIImage imageNamed:@"webView_noNetWork"];
    _noDataView.imgView.frame = CGRectMake(10, 15, 150, 150);
    [self.view addSubview:_noDataView];
    
    webLoadFailView = [[WebLoadFailView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-kTopHeight)];
    webLoadFailView.hidden = YES;
    webLoadFailView.webLoadFailDelegate = self;
    [self.view addSubview:webLoadFailView];
}

-(void)_leftBarBtnItemClick:(id)sender
{
//    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UIWebView协议
- (void)webViewDidStartLoad:(UIWebView *)webView {
    webView.hidden = NO;
    webLoadFailView.hidden = YES;
    _noDataView.hidden = YES;
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideHud];
    
    //    NSString *htmlTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    //    self.title = htmlTitle;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self hideHud];
    [self showHint:@"加载失败"];
    
//    self.navigationController.navigationBar.hidden = NO;
    _noDataView.hidden = NO;
    webLoadFailView.hidden = YES;
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [self showHudInView:self.view hint:@"加载中~"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]  completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode != 200) {
            [self hideHud];
            if (httpResponse.statusCode == 404) {
                _noDataView.hidden = YES;
                webLoadFailView.hidden = NO;
                _headView.hidden = NO;
            }else{
                _noDataView.hidden = NO;
                webLoadFailView.hidden = YES;
                _headView.hidden = NO;
            }
        }else{
            _noDataView.hidden = YES;
            webLoadFailView.hidden = YES;
            _headView.hidden = YES;
        }
    }];
    
    [self.view sendSubviewToBack:_webView];
    NSString *str = @"about:blank";
    if([[NSString stringWithFormat:@"%@", request.URL] isEqualToString:str]){
        if([webView canGoBack]){
            [webView goBack];
        }
    }
    
    if([[NSString stringWithFormat:@"%@", request.URL] isEqualToString:@"http://www.sina.com.cn/"]){
        [self.navigationController popViewControllerAnimated:YES];
        
//        self.navigationController.navigationBar.hidden = NO;
        
        return NO;
    }
    return YES;
}

-(void)reloadWeb{
    [_webView removeFromSuperview];
    _webView.delegate = nil;
    _webView = nil;
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _webView.scrollView.bounces = NO;
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor colorWithHexString:@"#7bb3e0"];
    [self.view addSubview:_webView];
    
    NSString *actUrl = [NSString stringWithFormat:@"http://220.168.59.11:8083/hnzhxy/"];
    
    NSURLRequest *reqest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:actUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    [_webView loadRequest:reqest];
}

-(void)goHome{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
