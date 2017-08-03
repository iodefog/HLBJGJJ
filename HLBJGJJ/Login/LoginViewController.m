//
//  LoginViewController.m
//  HLBJGJJ
//
//  Created by Hongli li on 16/1/25.
//  Copyright © 2017年 honglili. All rights reserved.
//

#import "LoginViewController.h"
#import "BJBrowser.h"
#import "CaptchaBrowser.h"
#import <SVProgressHUD.h>
#import "CCFNavigationController.h"
#import "CountInfoViewController.h"

#define kLBValue @"lb"
#define kLBName @"lbName"

#define kCardNumber @"cardnumber"
#define kCardPassward @"cardPwd"


@interface LoginViewController (){
    
    BJBrowser * _browser;
    NSMutableDictionary *_lbList;
    
    
}

@property(nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation LoginViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.securityCode.image = nil;
    self.code.text = nil;
    [self refreshSecurityCode:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    
    if (true) {
//        self.adView.adUnitID = @"ca-app-pub-4825035857684521/7836686290";
        
        //self.adView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
        
        self.adView.rootViewController = self;
        
        GADRequest *request = [GADRequest request];
        // Requests test ads on devices you specify. Your test device ID is printed to the console when
        // an ad request is made. GADBannerView automatically returns test ads when running on a
        // simulator.
//        request.testDevices = @[
//                                @"2ed19fd608c97b865be80811f226e03a"  // Eric's iPod Touch
//                                ];
        
        [self.adView loadRequest:request];
    }
    
    if (true) {
        
//        self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-4825035857684521/7836686290"];
        
        GADRequest *request = [GADRequest request];
        // Requests test ads on test devices.
//        request.testDevices = @[@"2ed19fd608c97b865be80811f226e03a"];
        [self.interstitial loadRequest:request];
        

    }

    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"lb" ofType:@"plist"];
    _lbList = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    _browser = [[BJBrowser alloc] init];
    
    [_browser refreshVCodeToUIImageView:_securityCode :^(UIImage *captchaImage) {
        
        CaptchaBrowser * captcha = [[CaptchaBrowser alloc] init];
        [captcha captchaToText:captchaImage response:^(BOOL success, NSString *captchaText) {
            NSLog(@" 验证码 解析结果： %@     %@", success ? @"YES" : @"NO", captchaText);
            if (success) {
                _code.text = captchaText;
            }
        }];
    }];
    
    NSString * defaultName = [[NSUserDefaults standardUserDefaults] valueForKey:kLBName];
    if (defaultName == nil) {
        _cardNumber.placeholder = @"身份证";
    }
    
    
    NSString * lb = [[NSUserDefaults standardUserDefaults] valueForKey:kLBValue];
    if (lb == nil) {
        lb = @"1";
    }
    NSUserDefaults * pref = [NSUserDefaults standardUserDefaults];
    NSString * number = [pref valueForKey:[kCardNumber stringByAppendingString:lb]];
    NSString * password = [pref valueForKey:[kCardPassward stringByAppendingString:lb]];
    if (number != nil) {
        _cardNumber.text = number;
    }
    if (password != nil) {
        _password.text = password;
    }


}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (IBAction)refreshSecurityCode:(id)sender {
    [_browser refreshVCodeToUIImageView:_securityCode :^(UIImage *captchaImage) {
        CaptchaBrowser * captcha = [[CaptchaBrowser alloc] init];
        [captcha captchaToText:captchaImage response:^(BOOL success, NSString *captchaText) {
            NSLog(@" 验证码 解析结果： %@     %@", success ? @"YES" : @"NO", captchaText);
            if (success) {
                _code.text = captchaText;
            }
        }];
    }];
}

- (IBAction)login:(id)sender {
    
    
//    if (true) {
//        if ([self.interstitial isReady]) {
//            [self.interstitial presentFromRootViewController:self];
//        }
//        return;
//    }
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    NSString * lb = [[NSUserDefaults standardUserDefaults] valueForKey:kLBValue];
    if (lb == nil) {
        lb = @"1";
    }
    NSUserDefaults * pref = [NSUserDefaults standardUserDefaults];
    [pref setValue:_cardNumber.text forKey:[kCardNumber stringByAppendingString:lb]];
    [pref setValue:_password.text forKey:[kCardPassward stringByAppendingString:lb]];
    
    __block BJBrowser * browser =  _browser;
    
    [_browser loginWithCard:lb number:_cardNumber.text andPassword:_password.text andSecurityCode:_code.text status:^(NSArray<StatusBean *> *statusList) {
        
        if (statusList.count == 0 ) {
            [SVProgressHUD showErrorWithStatus:@"密码或者验证码错误"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_global_queue(0, 0), ^{
                [SVProgressHUD dismiss];
            });
            return ;
        }else{
            [SVProgressHUD dismiss];
        }
        
        CCFNavigationController * root = (CCFNavigationController*)self.navigationController;
        
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CountInfoViewController * infoController = [storyboard instantiateViewControllerWithIdentifier:@"CountInfoViewController"];
        NSMutableArray *dataArray = [[NSMutableArray array] init];
        [dataArray addObject:statusList];
        infoController.data = dataArray;
        [root setRootViewController:infoController];
       
        __block CountInfoViewController * blockController = infoController;
        StatusBean *bean = statusList.firstObject;
        if (bean) {
            [browser refreshGlobalInfo:bean.companyLink status:^(NSArray<StatusBean *> *statusList) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                for (NSUInteger i = 0 ; i < statusList.count ; i ++ ) {
                    NSString *str = [(id)statusList[i] stringByReplacingOccurrencesOfString:@" " withString:@""];
                    
                    if ([str hasPrefix: @"姓名"]) {
                        self.title = [NSString stringWithFormat:@"%@的开户单位",statusList[i+1]];
                    }
                    else if ([str hasPrefix:@"当前余额"]) {
                        [dic setObject:@"当前余额:" forKey:@"tipAmount"];
                        [dic setObject:statusList[i+1] forKey:@"amount"];
                    }
                    else if ([str hasPrefix:@"最后业务日期"]) {
                        [dic setObject:[NSString stringWithFormat:@"%@:%@",@"最后业务日期", statusList[i+1]] forKey:@"lastTime"];
                    }
                }
                [blockController.data insertObject:@[dic] atIndex:0];
                [blockController.tableView reloadData];
            }];
        }
        
   }];
}

- (IBAction)changeCountType:(id)sender {
    UIAlertController * insertPhotoController = [UIAlertController alertControllerWithTitle:@"切换登录方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSArray* keys = _lbList.allKeys;
    for (NSString* key  in keys) {
        NSString * name = [_lbList valueForKey:key];
        UIAlertAction *action = [UIAlertAction actionWithTitle:name style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSUserDefaults * pref = [NSUserDefaults standardUserDefaults];
            [pref setValue:key forKey:kLBName];
            [pref setValue:name forKey:kLBName];
            
            _cardNumber.placeholder = name;
            
            NSString * number = [pref valueForKey:[kCardNumber stringByAppendingString:key]];
            NSString * password = [pref valueForKey:[kCardPassward stringByAppendingString:key]];
            if (number != nil) {
                _cardNumber.text = number;
            }
            if (password != nil) {
                _password.text = password;
            }
            
        }];
        [insertPhotoController addAction:action];
    }
    
    
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [insertPhotoController addAction:cancel];
    
    [self presentViewController:insertPhotoController animated:YES completion:nil];
}
@end
