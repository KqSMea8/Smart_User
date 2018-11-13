//
//  WebLoadFailView.m
//  ZHYQ
//
//  Created by 魏唯隆 on 2018/2/23.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "WebLoadFailView.h"

@implementation WebLoadFailView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        [self _initView];
    }
    return self;
}

- (void)_initView {
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView *hitImgView = [[UIImageView alloc] initWithFrame:CGRectMake((KScreenWidth - 211)/2, 100, 211, 108)];
    hitImgView.image = [UIImage imageNamed:@"notfound_placeholder"];
    [self addSubview:hitImgView];
    
    UILabel *msgLabel = [[UILabel alloc] init];
    msgLabel.frame = CGRectMake((KScreenWidth - 150)/2,hitImgView.bottom + 30,150,17);
    msgLabel.textAlignment = NSTextAlignmentCenter;
    msgLabel.text = @"对不起，出错了！";
    msgLabel.textColor = [UIColor colorWithHexString:@"#1B82D1"];
    [self addSubview:msgLabel];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0,self.height - 208,KScreenWidth,0.5);
    lineView.backgroundColor = [UIColor colorWithHexString:@"#CFCFCF"];
    [self addSubview:lineView];
    
    UILabel *operateLabel = [[UILabel alloc] initWithFrame:CGRectMake(33, lineView.bottom + 34, 80, 17)];
    operateLabel.text = @"你可以：";
    operateLabel.textColor = [UIColor blackColor];
    operateLabel.font = [UIFont systemFontOfSize:17];
    operateLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:operateLabel];
    
    UIButton *reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reloadButton.frame = CGRectMake(85, operateLabel.bottom + 22, 60, 60);
    [reloadButton setBackgroundImage:[UIImage imageNamed:@"notfound_reload"] forState:UIControlStateNormal];
    [reloadButton addTarget:self action:@selector(reloadWebAct) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:reloadButton];
    
    UILabel *reloadLabel = [[UILabel alloc] initWithFrame:CGRectMake(reloadButton.left - 10, reloadButton.bottom + 12, 80, 17)];
    reloadLabel.text = @"重新加载";
    reloadLabel.textColor = [UIColor colorWithHexString:@"#1B82D1"];
    reloadLabel.font = [UIFont systemFontOfSize:17];
    reloadLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:reloadLabel];
    
    UIButton *gohomeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    gohomeButton.frame = CGRectMake(KScreenWidth - 85 - 60, reloadButton.top, 60, 60);
    [gohomeButton setBackgroundImage:[UIImage imageNamed:@"notfound_backhome"] forState:UIControlStateNormal];
    [gohomeButton addTarget:self action:@selector(goHomeAct) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:gohomeButton];
    
    UILabel *gohomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(gohomeButton.left - 10, gohomeButton.bottom + 12, 80, 17)];
    gohomeLabel.text = @"返回首页";
    gohomeLabel.textColor = [UIColor colorWithHexString:@"#1B82D1"];
    gohomeLabel.font = [UIFont systemFontOfSize:17];
    gohomeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:gohomeLabel];
}

- (void)reloadWebAct {
    if(_webLoadFailDelegate && [_webLoadFailDelegate respondsToSelector:@selector(reloadWeb)]){
        [_webLoadFailDelegate reloadWeb];
    }
}

- (void)goHomeAct {
    if(_webLoadFailDelegate && [_webLoadFailDelegate respondsToSelector:@selector(goHome)]){
        [_webLoadFailDelegate goHome];
    }
}

@end
