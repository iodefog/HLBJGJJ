//
//  BJBrowser.h
//  HLBJGJJ
//
//  Created by Hongli li on 16/1/31.
//  Copyright © 2017年 honglili. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "StatusBean.h"


typedef void(^Response) (NSArray<StatusBean*>* statusList);
typedef void(^CaptchaImage) (UIImage* captchaImage);

@interface BJBrowser : NSObject

-(void) loginWithCard:(NSString*) lb number:(NSString *)number andPassword:(NSString *)password andSecurityCode:(NSString *)code status:(Response)statusList;

-(void)refreshGlobalInfo:(NSString *)link status:(Response)statusList;


-(void)refreshVCodeToUIImageView:(UIImageView* )showCapImageView :(CaptchaImage)captchaImage;


@end
