//
//  StatusBean.h
//  HLBJGJJ
//
//  Created by Hongli li on 16/1/31.
//  Copyright © 2017年 honglili. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatusBean : NSObject


@property(nonatomic, strong) NSString* signedId;        //开户登记号
@property(nonatomic, strong) NSString* companyName;     //公司名称
@property(nonatomic, strong) NSString* companyLink;
@property(nonatomic, strong) NSString* status;          //缴存状态


@end
