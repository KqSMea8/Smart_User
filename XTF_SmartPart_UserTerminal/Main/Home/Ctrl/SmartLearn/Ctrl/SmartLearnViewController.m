//
//  HealthViewController.m
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/10/29.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "SmartLearnViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "NoDataView.h"
#import "WebLoadFailView.h"
#import "ReadViewController.h"

#import "LSYReadPageViewController.h"
#import "LSYReadModel.h"

@interface SmartLearnViewController ()<UIWebViewDelegate,WebLoadFailDelegate,reloadDelegate>
{
    UIWebView *_webView;
    
    UIView *_headView;
    NoDataView *_noDataView;
    WebLoadFailView *webLoadFailView;
}

@end

@implementation SmartLearnViewController

//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self _initNavItems];
}

-(void)_initNavItems
{
    
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

-(void)initView{
    NSString *custId = [kUserDefaults objectForKey:kCustId];
    NSString *url = [NSString stringWithFormat:@"%@/h5/diningUser/html/xuexi.html?custId=%@",MainUrl,custId];
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, KScreenWidth, KScreenHeight-kStatusBarHeight)];
    _webView.scalesPageToFit = YES;
    _webView.scrollView.bounces = NO;
    NSURLRequest *reqest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    _webView.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
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
    _noDataView.delegate = self;
    [self.view addSubview:_noDataView];
    
    webLoadFailView = [[WebLoadFailView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-kTopHeight)];
    webLoadFailView.hidden = YES;
    webLoadFailView.webLoadFailDelegate = self;
    [self.view addSubview:webLoadFailView];
}

-(void)_leftBarBtnItemClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //设置状态栏颜色
    [self setStatusBarBackgroundColor:[UIColor colorWithHexString:@"#252E44"]];
}

//一定要在viewWillDisappear里面写，如果写在viewDidDisappear里面会出问题！！！！
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //为了不影响其他页面在viewDidDisappear做以下设置
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
}

#pragma mark UIWebView协议
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self showHudInView:self.view hint:@"加载中~"];
    webView.hidden = NO;
    webLoadFailView.hidden = YES;
    _noDataView.hidden = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    JSContext *contest = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    contest[@"myFunction"] = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        // 这里网页上的按钮被点击了, 客户端可以在这里拦截到,并进行操作
    };
    
    NSString *readyState = [webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
    BOOL complete = [readyState isEqualToString:@"complete"];
    if (complete) {
        [self hideHud];
        [self webViewDidFinishLoadCompletely:webView];
    } else {
        
    }
}

-(void)webViewDidFinishLoadCompletely:(UIWebView *)webView
{
    NSURLSessionDataTask * dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:webView.request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse *tmpresponse = (NSHTTPURLResponse *)response;
        NSLog(@"statusCode:%ld", tmpresponse.statusCode);
        RunOnMainThread(
            if (tmpresponse.statusCode != 200) {
                if (tmpresponse.statusCode == 404) {
                    _noDataView.hidden = YES;
                    webLoadFailView.hidden = NO;
                    _headView.hidden = NO;
                }else{
                    _noDataView.hidden = NO;
                    webLoadFailView.hidden = YES;
                    _headView.hidden = NO;
                }
                [self.view sendSubviewToBack:_webView];
            }else{
                _noDataView.hidden = YES;
                webLoadFailView.hidden = YES;
                _headView.hidden = YES;
            }
        );
    }];
    [dataTask resume];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideHud];
    YYReachability *rech = [YYReachability reachability];
    _headView.hidden = NO;
    if (!rech.reachable) {
        _noDataView.hidden = NO;
        webLoadFailView.hidden = YES;
    }else{
        _noDataView.hidden = YES;
        webLoadFailView.hidden = NO;
    }
    [self.view sendSubviewToBack:_webView];
}

//-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//    // 拿到网页的实时url
//    NSString *requestStr = [[request.URL absoluteString] stringByRemovingPercentEncoding];
//    if([requestStr rangeOfString:@"www.360guoxue.com"].location !=NSNotFound){
//
//        NSLog(@"yes");
//        NSArray *arr = [requestStr componentsSeparatedByString:@"="];
//          self.result_Str = arr[1];
//          NSLog(@"哈哈哈哈%@",self.result_Str);
//        // 拿到关键字符串，发送网络请求
//          [self requestSeeResult:self.result_Str];
//        return NO;
//    }
//    return YES;
//}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = [request.URL.absoluteString substringWithRange:NSMakeRange(request.URL.absoluteString.length-4, 4)];
    if (![request.URL isKindOfClass:[NSNull class]]&&[[request.URL.absoluteString substringWithRange:NSMakeRange(request.URL.absoluteString.length-4, 4)] isEqualToString:@".txt"]) {
        LSYReadPageViewController *pageView = [[LSYReadPageViewController alloc] init];
        NSURL *fileURL = request.URL;
        pageView.resourceURL = fileURL;    //文件位置
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            pageView.model = [LSYReadModel getLocalModelWithURL:fileURL];
//            [self hideHud];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self presentViewController:pageView animated:YES completion:nil];
            });
        });
    }
    return YES;
}

-(NSMutableDictionary*)getURLParameters:(NSString *)str {
    NSRange range = [str rangeOfString:@"?"];
    if(range.location==NSNotFound) {
        return nil;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *parametersString = [str substringFromIndex:range.location+1];
    
    if([parametersString containsString:@"&"]) {
        
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        
        for(NSString *keyValuePair in urlComponents) {
            
            //生成key/value
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSString*value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            
            //key不能为nil
            if(key==nil|| value ==nil) {
                continue;
            }
            id existValue = [params valueForKey:key];
            
            if(existValue !=nil) {
                //已存在的值，生成数组。
                if([existValue isKindOfClass:[NSArray class]]) {
                    //已存在的值生成数组
                    NSMutableArray*items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    [params setValue:items forKey:key];
                }else{
                    //非数组
                    [params setValue:@[existValue,value]forKey:key];
                }
            }else{
                //设置值
                [params setValue:value forKey:key];
            }
        }
    }else{
        //单个参数生成key/value
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        if(pairComponents.count==1) {
            return nil;
        }
        //分隔值
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        
        //key不能为nil
        if(key ==nil|| value ==nil) {
            return nil;
        }
        //设置值
        [params setValue:value forKey:key];
    }
    return params;
}

#pragma mark WebLoadFailDelegate
-(void)reloadWeb{
    [self refresh];
}

-(void)goHome{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark reloadDelegate
- (void)reload
{
    [self refresh];
}

-(void)refresh{
    [_webView removeFromSuperview];
    _webView.delegate = nil;
    _webView = nil;
    NSString *custId = [kUserDefaults objectForKey:kCustId];
    NSString *url = [NSString stringWithFormat:@"http://192.168.206.23:8081/hntfEsb/h5/diningUser/html/xuexi.html?custId=%@",custId];
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, KScreenWidth, KScreenHeight-kStatusBarHeight)];
    _webView.scrollView.bounces = NO;
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor colorWithHexString:@"#7bb3e0"];
    [self.view addSubview:_webView];
    
    NSURLRequest *reqest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    [_webView loadRequest:reqest];
}

@end
