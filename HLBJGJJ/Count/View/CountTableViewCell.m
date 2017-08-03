//
//  CountTableViewCell.m
//  HLBJGJJ
//
//  Created by LHL on 2017/8/2.
//  Copyright © 2017年 andforce. All rights reserved.
//

#import "CountTableViewCell.h"
#import "StatusBean.h"
#import "Masonry.h"
@interface CountTableViewCell()

#define CountTableViewCellHeight 80

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *idLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *companyLabel;


@end

@implementation CountTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self createUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createUI];
}

- (void)createUI{
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.iconImageView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.iconImageView];
    
    self.idLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.idLabel.font = [UIFont systemFontOfSize:14];
    self.idLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.idLabel];
    
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.statusLabel.font = [UIFont systemFontOfSize:14];
    self.statusLabel.textAlignment = NSTextAlignmentRight;
    self.statusLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.statusLabel];

    self.companyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.companyLabel.font = [UIFont systemFontOfSize:16];
    self.companyLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.companyLabel];

}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.iconImageView.frame = CGRectMake(15, 20, CountTableViewCellHeight - 30, CountTableViewCellHeight - 30);
    self.idLabel.frame = CGRectMake(80, 15, CGRectGetWidth(self.bounds)-150, 30);
    self.statusLabel.frame = CGRectMake(CGRectGetWidth(self.bounds)- 90, 15, 50, 30);
    self.companyLabel.frame = CGRectMake(80, CGRectGetMaxY(self.idLabel.bounds)+10, CGRectGetWidth(self.bounds)-100, 40);

}

- (void)setObject:(StatusBean *)object{
    _object = object;
    if ([object isKindOfClass:[StatusBean class]]) {
        
        self.idLabel.text = [NSString stringWithFormat:@"开户登记号:%@",object.signedId];
        self.statusLabel.text = object.status;
        self.companyLabel.text = object.companyName;
        if ([object.status isEqualToString:@"缴存"]) {
            self.iconImageView.image = [UIImage imageNamed:@"open_account"];
        }
        else {
            self.iconImageView.image = [UIImage imageNamed:@"close_account"];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
