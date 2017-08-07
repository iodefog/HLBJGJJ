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


@interface LoginViewController ()<UITextFieldDelegate>
{
    
    BJBrowser * _browser;
    NSMutableDictionary *_lbList;
    
    
}
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

//@property(nonatomic, strong) GADInterstitial *interstitial;

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
    
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    self.iconView.image = [UIImage imageNamed:icon];
    
    self.loginTypeBgView.layer.cornerRadius = 5;
    self.loginTypeBgView.layer.borderColor = [[UIColor colorWithRed:200/255. green:200/255. blue:200/255. alpha:1.0] CGColor];
    self.loginTypeBgView.layer.borderWidth = 0.5;
    
    self.catdBgView.layer.cornerRadius = 5;
    self.catdBgView.layer.borderColor = [[UIColor colorWithRed:200/255. green:200/255. blue:200/255. alpha:1.0] CGColor];
    self.catdBgView.layer.borderWidth = 0.5;

    
    self.securityBgView.layer.cornerRadius = 5;
    self.securityBgView.layer.borderColor = [[UIColor colorWithRed:200/255. green:200/255. blue:200/255. alpha:1.0] CGColor];
    self.securityBgView.layer.borderWidth = 0.5;

    
    if (true) {
//        self.adView.adUnitID = @"ca-app-pub-4825035857684521/7836686290";
        
        //self.adView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
        
//        self.adView.rootViewController = self;
        
//        GADRequest *request = [GADRequest request];
        // Requests test ads on devices you specify. Your test device ID is printed to the console when
        // an ad request is made. GADBannerView automatically returns test ads when running on a
        // simulator.
//        request.testDevices = @[
//                                @"2ed19fd608c97b865be80811f226e03a"  // Eric's iPod Touch
//                                ];
        
//        [self.adView loadRequest:request];
    }
    
//    if (true) {
    
//        self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-4825035857684521/7836686290"];
        
//        GADRequest *request = [GADRequest request];
        // Requests test ads on test devices.
//        request.testDevices = @[@"2ed19fd608c97b865be80811f226e03a"];
//        [self.interstitial loadRequest:request];
        

//    }

    [self.loginTypeButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
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
    
    _cardNumber.placeholder = defaultName?:@"身份证";
    [self.loginTypeButton setTitle:defaultName?:@"身份证" forState:UIControlStateNormal];
    
    
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
    
    if (!_cardNumber.text) {
        [SVProgressHUD showErrorWithStatus:@"请填写账户"];
        return;
    }
    else if (!_password.text) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    
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
            [browser refreshGlobalInfo:bean.companyLink status:^(NSArray *statusList) {
                for (NSUInteger i = 0 ; i < statusList.count ; i ++ ) {
                    NSString *str = [(id)statusList[i] stringByReplacingOccurrencesOfString:@" " withString:@""];
                    
                    if ([str hasPrefix: @"姓名"]) {
                        self.title = [NSString stringWithFormat:@"%@的开户单位",statusList[i+1]];
                        break;
                    }
                }
                
                [blockController.data insertObject:@[statusList] atIndex:0];
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
            [self.loginTypeButton setTitle:name forState:UIControlStateNormal];

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
    
    
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [insertPhotoController addAction:cancel];
    
    [self presentViewController:insertPhotoController animated:YES completion:nil];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    _cardNumber.text = nil;
    _password.text = nil;
    [NSUserDefaults resetStandardUserDefaults];
    return YES;
}

@end
