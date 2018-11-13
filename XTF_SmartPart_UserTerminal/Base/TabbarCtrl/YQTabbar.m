//
//  YQTabbar.m
//  ZHYQ
//
//  Created by 焦平 on 2017/10/22.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "YQTabbar.h"

@interface YQTabbar()

@property (nonatomic,assign)UIEdgeInsets oldSafeAreaInsets;

@property (strong, nonatomic) NSMutableArray *tabBarItems;
@property (nonatomic,retain) YQTabBarItem *specialTabbarItem;

@end

@implementation YQTabbar

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self config];
    }
    
    return self;
}

#pragma mark - Private Method

- (void)config {
    self.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    UIImageView *topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, -5, KScreenWidth, 5)];
    topLine.image = [UIImage imageNamed:@"tapbar_top_line"];
    [self addSubview:topLine];
}

- (void)setSelectedIndex:(NSInteger)index {
    for (YQTabBarItem *item in self.tabBarItems) {
        if (item.tag == index) {
            item.selected = YES;
        } else {
            item.selected = NO;
        }
    }
    
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    UITabBarController *tabBarController = (UITabBarController *)keyWindow.rootViewController;
    if (tabBarController) {
        tabBarController.selectedIndex = index;
    }
}

#pragma mark - Touch Event

- (void)itemSelected:(YQTabBarItem *)sender {
    if (sender.tabBarItemType != YQTabBarItemRise) {
        [self setSelectedIndex:sender.tag];
    } else {
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(tabBarDidSelectedRiseButton)]) {
                [self.delegate tabBarDidSelectedRiseButton];
            }
        }
    }
}

-(void)recordStart:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        if (self.delegate&&[self.delegate respondsToSelector:@selector(beginRecord)]) {
            [self.delegate beginRecord];
        }
    }else if(gestureRecognizer.state == UIGestureRecognizerStateEnded){
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(finishRecord)]) {
                [self.delegate finishRecord];
            }
        }
    }
}

-(void)recordCancel:(YQTabBarItem *)sender
{
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(cancleRecord)]) {
            [self.delegate cancleRecord];
        }
    }
}

-(void)recordFinish:(YQTabBarItem *)sender
{
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(finishRecord)]) {
            [self.delegate finishRecord];
        }
    }
}

-(void)sigleTap
{
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(finishRecord)]) {
            [self.delegate tabBarDidSelectedRiseButton];
        }
    }
}

#pragma mark - Setter

- (void)setTabBarItemAttributes:(NSArray<NSDictionary *> *)tabBarItemAttributes {
    _tabBarItemAttributes = tabBarItemAttributes.copy;
    
    CGFloat itemWidth = KScreenWidth / _tabBarItemAttributes.count;
    CGFloat tabBarHeight;
    NSInteger itemTag = 0;
    BOOL passedRiseItem = NO;
    
    _tabBarItems = [NSMutableArray arrayWithCapacity:_tabBarItemAttributes.count];
    for (id item in _tabBarItemAttributes) {
        if ([item isKindOfClass:[NSDictionary class]]) {
            NSDictionary *itemDict = (NSDictionary *)item;
            
            YQTabBarItemType type = [itemDict[kYQTabBarItemAttributeType] integerValue];
            
            if (type == YQTabBarItemRise) {
                tabBarHeight = 60;
            }else{
                tabBarHeight = CGRectGetHeight(self.frame);
            }
            CGRect frame = CGRectMake(itemTag * itemWidth + (passedRiseItem ? itemWidth : 0), 0, itemWidth, tabBarHeight);
            
            YQTabBarItem *tabBarItem = [self tabBarItemWithFrame:frame
                                                           title:itemDict[kYQTabBarItemAttributeTitle]
                                                 normalImageName:itemDict[kYQTabBarItemAttributeNormalImageName]
                                               selectedImageName:itemDict[kYQTabBarItemAttributeSelectedImageName] tabBarItemType:type];
            if (itemTag == 0) {
                tabBarItem.selected = YES;
            }
            
//            if (tabBarItem.tabBarItemType == YQTabBarItemRise) {
//                _specialTabbarItem = tabBarItem;
//                [tabBarItem addTarget:self action:@selector(recordStart1:) forControlEvents:UIControlEventTouchDown];
//                UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(recordStart:)];
//                longPress.minimumPressDuration = 0.5; //定义按的时间
//                [tabBarItem addGestureRecognizer:longPress];
//                [tabBarItem addTarget:self action:@selector(recordCancel:) forControlEvents:UIControlEventTouchDragExit];
//                [tabBarItem addTarget:self action:@selector(recordFinish:) forControlEvents:UIControlEventTouchUpOutside];
//                [tabBarItem addTarget:self action:@selector(sigleTap) forControlEvents:UIControlEventTouchUpInside];
//
//            }else{
                [tabBarItem addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
//            }
            
            
            
            if (tabBarItem.tabBarItemType != YQTabBarItemRise) {
                tabBarItem.tag = itemTag;
                itemTag++;
            } else {
                passedRiseItem = YES;
            }
            
            [_tabBarItems addObject:tabBarItem];
            [self addSubview:tabBarItem];
        }
    }
}

-(void)recordStart1:(YQTabBarItem*)sender
{
    NSLog(@"123");
}

- (YQTabBarItem *)tabBarItemWithFrame:(CGRect)frame title:(NSString *)title normalImageName:(NSString *)normalImageName selectedImageName:(NSString *)selectedImageName tabBarItemType:(YQTabBarItemType)tabBarItemType {
    YQTabBarItem *item = [[YQTabBarItem alloc] initWithFrame:frame];
    [item setTitle:title forState:UIControlStateNormal];
    [item setTitle:title forState:UIControlStateSelected];
    item.titleLabel.font = [UIFont systemFontOfSize:8];
    UIImage *normalImage = [UIImage imageNamed:normalImageName];
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    [item setImage:normalImage forState:UIControlStateNormal];
    [item setImage:selectedImage forState:UIControlStateSelected];
    [item setTitleColor:[UIColor colorWithWhite:51 / 255.0 alpha:1] forState:UIControlStateNormal];
    [item setTitleColor:[UIColor colorWithWhite:51 / 255.0 alpha:1] forState:UIControlStateSelected];
    item.tabBarItemType = tabBarItemType;
    
    return item;
}


- (void) safeAreaInsetsDidChange
{
    [super safeAreaInsetsDidChange];
    if(self.oldSafeAreaInsets.left != self.safeAreaInsets.left ||
       self.oldSafeAreaInsets.right != self.safeAreaInsets.right ||
       self.oldSafeAreaInsets.top != self.safeAreaInsets.top ||
       self.oldSafeAreaInsets.bottom != self.safeAreaInsets.bottom)
    {
        self.oldSafeAreaInsets = self.safeAreaInsets;
        [self invalidateIntrinsicContentSize];
        [self.superview setNeedsLayout];
        [self.superview layoutSubviews];
    }
    
}

- (CGSize) sizeThatFits:(CGSize) size
{
    CGSize s = [super sizeThatFits:size];
    if(@available(iOS 11.0, *))
    {
        CGFloat bottomInset = self.safeAreaInsets.bottom;
        if( bottomInset > 0 && s.height < 50) {
            s.height += bottomInset;
        }
    }
    return s;
}

@end

