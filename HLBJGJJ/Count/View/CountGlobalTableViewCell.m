//
//  CountGlobalTableViewCell.m
//  HLBJGJJ
//
//  Created by LHL on 2017/8/3.
//  Copyright © 2017年 andforce. All rights reserved.
//

#import "CountGlobalTableViewCell.h"

#define CountTableViewCellHeight 80

@interface CountGlobalTableViewCell()

@property (nonatomic, strong) UILabel *tipAmountLabel;
@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UILabel *lastTimeLabel;

@end

@implementation CountGlobalTableViewCell

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
    
    self.tipAmountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.tipAmountLabel.font = [UIFont systemFontOfSize:17];
    self.tipAmountLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.tipAmountLabel];
    
    self.amountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.amountLabel.font = [UIFont systemFontOfSize:24];
    self.amountLabel.textColor = [UIColor blueColor];
    [self.contentView addSubview:self.amountLabel];
    
    self.lastTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.lastTimeLabel.font = [UIFont systemFontOfSize:15];
    self.lastTimeLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.lastTimeLabel];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.tipAmountLabel.frame = CGRectMake(15, 15, 75, 30);
    self.amountLabel.frame = CGRectMake(90, 15, CGRectGetWidth(self.bounds)-100, 30);
    self.lastTimeLabel.frame = CGRectMake(15, CGRectGetMaxY(self.amountLabel.bounds)+20, CGRectGetWidth(self.bounds)- 30, 40);
}

- (void)setObject:(NSArray *)object{
    
    if ([object isKindOfClass:[NSArray class]]) {
        _object = object;
        
        for (NSUInteger i = 0 ; i < object.count ; i ++ ) {
            NSString *str = [(id)object[i] stringByReplacingOccurrencesOfString:@" " withString:@""];
            if ([str hasPrefix:@"当前余额"]) {
                self.tipAmountLabel.text = @"当前余额:";
                self.amountLabel.text = [NSString stringWithFormat:@"%@元",object[i+1]];
            }
            else if ([str hasPrefix:@"最后业务日期"]) {
                self.lastTimeLabel.text = [NSString stringWithFormat:@"%@:%@",@"最后业务日期", object[i+1]];
            }
        }
    }
}

@end
