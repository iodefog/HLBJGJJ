//
//  BJBrowser.m
//  HLBJGJJ
//
//  Created by Hongli li on 16/1/31.
//  Copyright © 2017年 honglili. All rights reserved.
//

#import "BJBrowser.h"

#import <UIImageView+AFNetworking.h>
#import <AFImageDownloader.h>
#import <AFNetworking.h>
#import "Encrypt.h"
#import "NSString+Converter.h"
#import "Browser.h"
#import "HtmlPraser.h"

#define kChoice @"http://www.bjgjj.gov.cn/wsyw/wscx/gjjcx-choice.jsp"
#define kSecruityCode @"http://www.bjgjj.gov.cn/wsyw/servlet/PicCheckCode1"
#define kLoginUrl @"http://www.bjgjj.gov.cn/wsyw/wscx/gjjcx-login.jsp"
#define kLKUrl @"http://www.bjgjj.gov.cn/wsyw/wscx/asdwqnasmdnams.jsp"

// http://www.bjgjj.gov.cn/wsyw/wscx/gjj_cx.jsp?nicam=Y3pyMjJ6enl5cnI1MjhyODU4cnI2&hskwe=R0pKd2M1NncyejM2NzkA&vnv=JiMyNjQ0NjsmIzMyNDE4OyYjMjExNDc7&lx=0 个人总账
// http://www.bjgjj.gov.cn/wsyw/wscx/gjj_cxls.jsp?xm=JiMyNjQ0NjsmIzMyNDE4OyYjMjExNDc7&grdjh=41022119900528085800&sfzh=GJJ015602936&bh=127&jczt=%BD%C9%B4%E6 个人明细
// http://www.bjgjj.gov.cn/wsyw/wscx/gjj_grdznd.jsp?grbh=MTY3OQAA&dwdjh=MTIwNTkx&grdjh=NDEwMjIxMTk5MDA1MjgwODU4MDAA&zjh=NDEwMjIxMTk5MDA1MjgwODU4&zjlx=JiMyMzYyMTsmIzI3NjY1OyYjMzY1MjM7JiMyMDIyMTsmIzM1Nzc3OwAA&xm=JiMyNjQ0NjsmIzMyNDE4OyYjMjExNDc7&snjzye=ODU1MTQuMTgA&dnjce=NTU4NzIuMAAA&dntqe=MC4w&lxe=MTY2Ni44MwAA&bxhj=MTQzMDUzLjAx&nd=MjAxNi0yMDE3&glmc=JiMxOTk5NjsmIzIyNDc4OyYjMzE2NDk7JiMyOTcwMjsmIzM3MDk2OyYjMjI4MDY7JiMyMDIyNTsmIzMzODI5OyYjMTk5OTQ7JiMyMTM4MTsA 2016-2017年度个人住房公积金结息对账单

/****
 http://www.bjgjj.gov.cn/wsyw/servlet/PicCheckCode1
 
 http://www.bjgjj.gov.cn/wsyw/wscx/asdwqnasmdnams.jsp
 
 http://www.bjgjj.gov.cn/wsyw/wscx/gjjcx-choice.jsp
 
 http://www.bjgjj.gov.cn/wsyw/wscx/gjj_cx.jsp?nicam=Y3pyMjJ6enl5cnI1MjhyODU4cnIxOAAA&hskwe=R0pKd2M1NncyejM2ODYw&vnv=JiMyNjQ0NjsmIzMyNDE4OyYjMjExNDc7&lx=0
 
 http://www.bjgjj.gov.cn/wsyw/wscx/gjj_cxls.jsp?xm=JiMyNjQ0NjsmIzMyNDE4OyYjMjExNDc7&grdjh=41022119900528085800&sfzh=GJJ015602936&bh=127&jczt=%E7%BC%B4%E5%AD%98
 
 http://www.bjgjj.gov.cn/wsyw/wscx/gjj_cx.jsp?nicam=Y3pyMjJ6enl5cnI1MjhyODU4cnIxOAAA&hskwe=R0pKd2MyNzV3Y3dhMjEz&vnv=JiMyNjQ0NjsmIzMyNDE4OyYjMjExNDc7&lx=0
 
 
 http://www.bjgjj.gov.cn/wsyw/wscx/gjj_cx.jsp?nicam=Y3pyMjJ6enl5cnI1MjhyODU4cnIzNzIA&amp;hskwe=R0pKd2M1NncyejM2Nzk2&amp;vnv=JiMyNjQ0NjsmIzMyNDE4OyYjMjExNDc7&amp;lx=0
 
 */

@implementation BJBrowser{
    Browser *_browser;
    NSString * _cookie;
    NSString * _lk;
    HtmlPraser *_praser;
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
                               @"Host"                  :@"www.bjgjj.gov.cn",
                               @"Content-Type"          :@"application/x-www-form-urlencoded",
                               @"Connection"            :@"keep-alive",
                               @"User-Agent"            :@"Mozilla/5.0 (Windows;U; Windows NT 5.1; en-US; rv:0.9.4)",
                               @"Accept-Language"       :@"zh-CN",
                               @"Accept-Encoding"       :@"gzip, deflate",
                               @"Accept"                :@"*/*",
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
    NSURL *url = [NSURL URLWithString:@"www.bjgjj.gov.cn"];
    if (url) {
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
        for (int i = 0; i < [cookies count]; i++) {
            NSHTTPCookie *cookie = (NSHTTPCookie *)[cookies objectAtIndex:i];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
            
        }
    }
}

-(void)refreshVCodeToUIImageView:(UIImageView *)showCapImageView :(CaptchaImage)captchaImage{
    [self cleanCookie];
    NSDictionary * headers = @{
                               @"Host"                  :@"www.bjgjj.gov.cn",
                               @"Content-Type"          :@"application/x-www-form-urlencoded",
                               @"Connection"            :@"keep-alive",
                               @"User-Agent"            :@"Mozilla/5.0 (Windows;U; Windows NT 5.1; en-US; rv:0.9.4)",
                               @"Accept-Language"       :@"zh-CN",
                               @"Accept-Encoding"       :@"gzip, deflate",
                               @"Accept"                :@"*/*",
                               };
    
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
        
        AFImageDownloader *downloader = [[showCapImageView class] sharedImageDownloader];
        id <AFImageRequestCache> imageCache = downloader.imageCache;
        [imageCache removeImageWithIdentifier:kSecruityCode];
        
        
        NSURL *URL = [NSURL URLWithString:kSecruityCode];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        [request setValue:_cookie forHTTPHeaderField:@"Cookie"];
        [request setValue:@"image/webp,image/*,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
        [request setValue:@"Mozilla/5.0 (Windows;U; Windows NT 5.1; en-US; rv:0.9.4)" forHTTPHeaderField:@"User-Agent"];
        [request setValue:@"http://www.bjgjj.gov.cn/wsyw/wscx/gjjcx-login.jsp" forHTTPHeaderField:@"Referer"];
        
        
        UIImageView * view = showCapImageView;
        
        [showCapImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            
            [view setImage:image];
            
            captchaImage(image);
            
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            
        }];
        
        
        
    }];
}



@end
