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

#define kChoice @"http://www.bjgjj.gov.cn/wsyw/wscx/gjjcx-choice.jsp"
#define kSecruityCode @"http://www.bjgjj.gov.cn/wsyw/servlet/PicCheckCode1"
#define kLoginUrl @"http://www.bjgjj.gov.cn/wsyw/wscx/gjjcx-login.jsp"
#define kLKUrl @"http://www.bjgjj.gov.cn/wsyw/wscx/asdwqnasmdnams.jsp"


typedef void(^Response) (NSArray* statusList);
typedef void(^CaptchaImage) (UIImage* captchaImage, NSString *captchaText);

@interface BJBrowser : NSObject

-(void) loginWithCard:(NSString*) lb number:(NSString *)number andPassword:(NSString *)password andSecurityCode:(NSString *)code status:(Response)statusList;

-(void)refreshGlobalInfo:(NSString *)link status:(Response)statusList;


-(void)refreshVCodeToUIImageView:(UIImageView* )showCapImageView:(CaptchaImage)captchaImage ;


@end
