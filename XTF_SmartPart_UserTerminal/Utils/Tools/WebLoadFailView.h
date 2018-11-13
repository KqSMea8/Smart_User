//
//  WebLoadFailView.h
//  ZHYQ
//
//  Created by 魏唯隆 on 2018/2/23.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WebLoadFailDelegate <NSObject>

- (void)reloadWeb;
- (void)goHome;

@end

@interface WebLoadFailView : UIView

@property (nonatomic,assign) id<WebLoadFailDelegate> webLoadFailDelegate;

@end
