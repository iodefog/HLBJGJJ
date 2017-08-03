//
//  HtmlPraser.h
//  HLBJGJJ
//
//  Created by Hongli li on 16/1/31.
//  Copyright © 2017年 honglili. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatusBean.h"

@interface HtmlPraser : NSObject

-(NSArray<StatusBean *> *)praserGlobalInfoList:(NSString *)html;


-(NSArray<StatusBean*>*) praserStatusList:(NSString*)html;


@end
