//
//  BJBrowser.m
//  HLBJGJJ
//
//  Created by Hongli li on 16/1/31.
//  Copyright © 2017年 honglili. All rights reserved.
//

#import "BJBrowser.h"
#import "CaptchaBrowser.h"

#import <UIImageView+AFNetworking.h>
#import <AFImageDownloader.h>
#import <AFNetworking.h>
#import "Encrypt.h"
#import "NSString+Converter.h"
#import "Browser.h"
#import "HtmlPraser.h"


#define HLUserAgent @"bjgjj/20160701 CFNetwork/878.2 Darwin/17.0.0"
#define HLHost @"www.bjgjj.gov.cn"
#define HLLanguage @"zh-cn"
#define HLEncoding @"gzip, deflate"
#define HLConnnection @"keep-alive"
#define HLAccept @"*/*"
#define HLContentType @"application/x-www-form-urlencoded"

@implementation BJBrowser{
    Browser *_browser;
    NSString * _cookie;
    NSString * _lk;
    HtmlPraser *_praser;
    CaptchaBrowser * _captcha;
}



-(id)init{
    
    if (self = [super init]) {
        _browser = [[Browser alloc] initWithStringEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
        _praser = [[HtmlPraser alloc] init];
    }
    
    return self;
}


-(void)loginWithCard:(NSString*) lb number:(NSString *)number andPassword:(NSString *)password andSecurityCode:(NSString *)code status:(Response)statusList{
    Encrypt * enc = [[Encrypt alloc]init];
    
    // FormData
    NSString * encodeNumber = [enc strEncode:number];
    NSString * encodePassword = [enc strEncode:password];
    NSDictionary * paramaters = @{@"lb"             :lb?:@"",
                                  @"bh"             : encodeNumber?:@"",
                                  @"mm"             : encodePassword?:@"",
                                  @"gjjcxjjmyhpppp" :code?:@"",
                                  @"lk"             :_lk?:@""
                                  };
    // 设置Headers
    NSDictionary * headers = @{
                               @"Host"                  :HLHost,
                               @"Content-Type"          :HLContentType,
                               @"Connection"            :HLConnnection,
                               @"User-Agent"            :HLUserAgent,
                               @"Accept-Language"       :HLLanguage,
                               @"Accept-Encoding"       :HLEncoding,
                               @"Accept"                :HLAccept,
                               @"Cookie"                :_cookie?:@""
                               };
    
    [_browser POST:kChoice headers:headers formData:paramaters response:^(NSString *responseHtml) {
        NSLog(@"%@", responseHtml);
        statusList([_praser praserStatusList:responseHtml]);
    }];
}


-(void)refreshGlobalInfo:(NSString *)link status:(Response)statusList{
  
    NSString *str = [link stringByReplacingOccurrencesOfString:@"amp;" withString:@""];
    
    [_browser GET:str response:^(NSString *responseHtml) {
        NSLog(@"%@", responseHtml);
        statusList([_praser praserGlobalInfoList:responseHtml]);
    }];
}



- (void)refreshLK {
    [_browser POST:kLKUrl headers:nil formData:nil response:^(NSString *responseHtml) {
        
        NSString *trimmedString = [responseHtml stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString * lk = [trimmedString substringFromIndex:4];
        
        _lk = lk;
    }];
}


- (void)cleanCookie{
    NSURL *url = [NSURL URLWithString:@"http://www.bjgjj.gov.cn"];
    if (url) {
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
        for (int i = 0; i < [cookies count]; i++) {
            NSHTTPCookie *cookie = (NSHTTPCookie *)[cookies objectAtIndex:i];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
            
        }
    }
}

-(void)refreshVCodeToUIImageView:(UIImageView *)showCapImageView :(CaptchaImage)captchaImage {
    [self cleanCookie];
    NSDictionary * headers = @{
                               @"Host"                  :HLHost,
                               @"Content-Type"          :HLContentType,
                               @"Connection"            :HLConnnection,
                               @"User-Agent"            :HLUserAgent,
                               @"Accept-Language"       :HLLanguage,
                               @"Accept-Encoding"       :HLEncoding,
                               @"Accept"                :HLAccept,
                               };
    
    if (!_captcha) {
        _captcha = [[CaptchaBrowser alloc] init];
    }
    
    
    __weak CaptchaBrowser * captcha = _captcha;
    
    [_browser GET:kLoginUrl headers:headers response:^(NSString *responseHtml) {
        
        NSArray<NSHTTPCookie *> *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        
        NSString *cookiesString = @"";
        
        int pos = 0;
        for (NSHTTPCookie *cookie in cookies) {
            NSString * formater = @"%@=%@; ";
            if (pos == cookies.count - 1) {
                formater = @"%@=%@";
            }
            cookiesString = [cookiesString stringByAppendingString:[NSString stringWithFormat:formater, cookie.name, cookie.value]];
            pos ++;
        }
        
        _cookie = cookiesString;
        
        [self refreshLK];
        
        
//        [captcha captchaToTextFromUrl:kSecruityCode response:^(BOOL success, NSString *captchaText, NSString *imageUrl) {
//            NSLog(@" 验证码 解析结果： %@     %@", success ? @"YES" : @"NO", captchaText);
        
            AFImageDownloader *downloader = [[showCapImageView class] sharedImageDownloader];
            id <AFImageRequestCache> imageCache = downloader.imageCache;
            [imageCache removeImageWithIdentifier:kSecruityCode];
            
            
            NSURL *URL = [NSURL URLWithString:kSecruityCode];
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
            [request setValue:_cookie forHTTPHeaderField:@"Cookie"];
            [request setValue:@"image/webp,image/*,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
            [request setValue:HLUserAgent forHTTPHeaderField:@"User-Agent"];
            [request setValue:kLoginUrl forHTTPHeaderField:@"Referer"];
            
            
            UIImageView * view = showCapImageView;
            
            
            [showCapImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                
                
                NSMutableURLRequest *cacheRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kSecruityCode]];
                [cacheRequest setValue:_cookie forHTTPHeaderField:@"Cookie"];
                [cacheRequest setValue:@"image/webp,image/*,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
                [cacheRequest setValue:HLUserAgent forHTTPHeaderField:@"User-Agent"];
                [cacheRequest setValue:kLoginUrl forHTTPHeaderField:@"Referer"];
                [imageCache removeImageforRequest:cacheRequest withAdditionalIdentifier:kSecruityCode];
                
                [imageCache addImage:image forRequest:cacheRequest withAdditionalIdentifier:nil];
                
                [view setImage:image];
                
                captchaImage(image, @"");
                
            } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                
            }];
            
//        }];
        
    }];
}



@end
