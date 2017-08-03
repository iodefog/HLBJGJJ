//
//  CaptchaBrowser.h
//  HLBJGJJ
//
//  Created by Hongli li on 16/1/31.
//  Copyright © 2017年 honglili. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^CaptchaResult) (BOOL success, NSString* captchaText);

@interface CaptchaBrowser : NSObject

-(void) captchaToText:(UIImage*) captchaImage response:(CaptchaResult)response;

@end
