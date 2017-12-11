//
//  CaptchaBrowser.h
//  HLBJGJJ
//
//  Created by Hongli li on 16/1/31.
//  Copyright © 2017年 honglili. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^CaptchaResult) (BOOL success, NSString* captchaText, NSString *imageUrl);

@interface CaptchaBrowser : NSObject

-(void)captchaToTextFromUrl:(NSString *)imageUrl response:(CaptchaResult)response;


-(void) captchaToText:(UIImage*) captchaImage response:(CaptchaResult)response;

@end
