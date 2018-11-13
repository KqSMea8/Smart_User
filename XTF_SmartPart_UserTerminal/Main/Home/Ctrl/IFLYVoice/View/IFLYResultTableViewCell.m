//
//  IFLYResultTableViewCell.m
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/9/6.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "IFLYResultTableViewCell.h"

@interface IFLYResultTableViewCell()
{
    __weak IBOutlet UIImageView *titleView;
    __weak IBOutlet UILabel *nameLab;
}

@end

@implementation IFLYResultTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setMatchStr:(NSString *)matchStr
{
    _matchStr = matchStr;
}

-(void)setModel:(FirstMenuModel *)model
{
    _model = model;
    titleView.image = [UIImage imageNamed:model.MENU_ICON];
    
    NSMutableAttributedString *menuName = [[NSMutableAttributedString alloc] initWithString:model.MENU_NAME];
    for (int i = 0; i < _matchStr.length; i++) {
        NSString *str = [_matchStr substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [model.MENU_NAME rangeOfString:str];
        [menuName addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#1B82D1"] range:range];
    }
    
    nameLab.attributedText = menuName;
}

@end
