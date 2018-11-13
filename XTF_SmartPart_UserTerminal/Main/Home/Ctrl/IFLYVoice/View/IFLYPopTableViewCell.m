//
//  IFLYPopTableViewCell.m
//  XTF_SmartPart_UserTerminal
//
//  Created by coder on 2018/9/10.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "IFLYPopTableViewCell.h"

@implementation IFLYPopTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backView = [[UIImageView alloc] init];
        self.backView.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:self.backView];
        
        self.contentLabel = [[UILabel alloc] init];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.textColor = [UIColor whiteColor];
        self.contentLabel.font = [UIFont systemFontOfSize:17.0f];
        [self.backView addSubview:self.contentLabel];
    }
    return self;
}

- (void)refreshCell:(IFLYPopModel *)model
{
    // 首先计算文本宽度和高度
    CGRect rec = [model.msg boundingRectWithSize:CGSizeMake(280, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil];
    // 气泡
    UIImage *image = nil;

    // 模拟左边
    if (!model.isRight)
    {
        // 当输入只有一个行的时候高度就是20多一点
        self.backView.frame = CGRectMake(20, 10, rec.size.width + 20, rec.size.height + 20);
        image = [UIImage imageNamed:@"ifly_pop_bg"];
    }
    else // 模拟右边
    {
        self.backView.frame = CGRectMake(375 - 60 - rec.size.width - 20, 10, rec.size.width + 20, rec.size.height + 20);
        image = [UIImage imageNamed:@"ifly_pop_bg"];
        //        image.leftCapWidth
    }
    // 拉伸图片 参数1 代表从左侧到指定像素禁止拉伸，该像素之后拉伸，参数2 代表从上面到指定像素禁止拉伸，该像素以下就拉伸
    image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2+2];
    self.backView.image = image;
    // 文本内容的frame
    self.contentLabel.frame = CGRectMake(model.isRight ? 5 : 13, 10, rec.size.width, rec.size.height);
    self.contentLabel.text = model.msg;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

