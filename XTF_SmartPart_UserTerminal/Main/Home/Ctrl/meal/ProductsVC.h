//
//  MealViewController.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 魏唯隆 on 2017/12/16.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductsDelegate <NSObject>

- (void)willDisplayHeaderView:(NSInteger)section;
- (void)didEndDisplayingHeaderView:(NSInteger)section;

@end

@interface ProductsVC : UIViewController

@property(nonatomic, weak) id<ProductsDelegate> delegate;/**< delegate */

/**
 *  当CategoryTableView滚动时,ProductsTableView跟随滚动至指定section
 *
 *  @param section
 */
- (void)scrollToSelectedIndexPath:(NSIndexPath *)indexPath;

@end
