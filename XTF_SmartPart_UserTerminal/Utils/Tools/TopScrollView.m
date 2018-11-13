//
//  TopScrollView.m
//  TanXun
//
//  Created by 魏唯隆 on 2016/9/7.
//  Copyright © 2016年 魏唯隆. All rights reserved.
//

#import "TopScrollView.h"
#import "ParkPhotoModel.h"

@implementation TopScrollView 
{
    int _time;
    UIScrollView *_scrollView;
    UIPageControl *pageControl;
    NSTimer *_timer;
    
    NSInteger _currentPage;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        [self _initView];
        _time = 3;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self){
        [self _initView];
        _time = 3;
    }
    return self;
}

- (void)_initView{
    self.backgroundColor = [UIColor whiteColor];
    
    [self createScroll];
    
    [self createPage];
}

- (void)createScroll{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, self.height)];
//    _scrollView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    [self addSubview:_scrollView];
}

- (void)createPage{
    //创建页码器，并设置位置和大小
    pageControl=[[UIPageControl alloc]initWithFrame:CGRectZero];
//    pageControl.center=CGPointMake(self.frame.size.width/2, pageControl.center.y);
//    pageControl.numberOfPages = ;
    pageControl.currentPageIndicatorTintColor=[UIColor whiteColor];
    pageControl.pageIndicatorTintColor=[UIColor colorWithWhite:0.600 alpha:1.000];
    pageControl.userInteractionEnabled = NO ;
    [self insertSubview:pageControl aboveSubview:_scrollView];
}

- (void)setImgData:(NSArray *)imgData {
    // 循环滚动处理数据
    if(imgData.count > 1){
        NSMutableArray *tmpArray = [imgData mutableCopy];
        // 额外拷贝第一个和最后一个数据
        [tmpArray addObject:[imgData firstObject]];
        [tmpArray insertObject:[imgData lastObject] atIndex:0];
        _imgData = [tmpArray copy];
    }else {
        _imgData = imgData;
    }
    pageControl.frame = CGRectMake((KScreenWidth - 20*imgData.count)/2, self.height - 25, 20*imgData.count, 25);
    pageControl.numberOfPages = imgData.count;
    
    
    _scrollView.contentSize = CGSizeMake(_imgData.count * KScreenWidth, 0);
    if(_imgData.count > 1){
        _scrollView.contentOffset = CGPointMake(KScreenWidth, 0);
    }else {
        _scrollView.contentOffset = CGPointMake(0, 0);
    }
    
    if(_imgData!= nil && _imgData.count > 0) {
        [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    UIImageView *noDataImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.width, _scrollView.height)];
    noDataImgView.image = [UIImage imageNamed:@"icon_no_picture"];
    [_scrollView addSubview:noDataImgView];
    
    [_imgData enumerateObjectsUsingBlock:^(ParkPhotoModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth*idx, 0, KScreenWidth, self.height)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        imgView.image = [UIImage imageNamed:@"icon_no_picture"];
        NSString *imageUrl = model.photoUrl;
        if(imageUrl != nil && ![imageUrl isKindOfClass:[NSNull class]] && imageUrl.length > 0){
            [imgView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"icon_no_picture"]];
        }
        imgView.tag = 100 + idx;
        [_scrollView addSubview:imgView];
        
    }];
    
    
    if(imgData.count > 1){
        [self startAutoScroll];
    }
    
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self makeInfiniteScrolling];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self makeInfiniteScrolling];
}

- (void)makeInfiniteScrolling {
    
    NSInteger currentPage = (_scrollView.contentOffset.x + KScreenWidth / 2.0) / KScreenWidth;
    
    if (currentPage == _imgData.count-1) {
        _currentPage = 0;
        [_scrollView setContentOffset:CGPointMake(KScreenWidth, 0) animated:NO];
    } else if (currentPage == 0) {
        _currentPage = _imgData.count - 2;
        
        [_scrollView setContentOffset:CGPointMake(KScreenWidth * (_imgData.count-2), 0) animated:NO];
    } else {
        _currentPage = currentPage-1 ;
    }
    
    pageControl.currentPage = _currentPage;
}

- (void)startAutoScroll {
    if (_timer || _time == 0 ) {
        return;
    }
    
    _timer = [NSTimer timerWithTimeInterval:_time target:self selector:@selector(doScroll) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

- (void)doScroll {
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x + KScreenWidth, 0) animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopAutoScroll];
}

- (void)stopAutoScroll {
    [_timer invalidate];
    _timer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startAutoScroll];
}

- (void)tapAction:(UITapGestureRecognizer *)recognizer {
    
}

#pragma mark 定制活动 进H5活动页面
- (void)webKey:(NSString *)webId withColorStr:(NSString *)colorStr withJspParam:(NSString *)jspParam {
    
}


@end
