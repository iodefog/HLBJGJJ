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
#import "Masonry.h"
#import "AXPopoverView.h"

#define kLBValue @"lb"
#define kLBName @"lbName"

#define kCardNumber @"cardnumber"
#define kCardPassward @"cardPwd"


@interface LoginViewController ()<UITextFieldDelegate>
{
    
    BJBrowser * _browser;
    NSMutableDictionary *_lbList;
    __weak IBOutlet UIButton *securityRefreshButton;
}

//@property(nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation LoginViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.securityCode.image = nil;
    self.code.text = nil;
    [self refreshSecurityCode:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.iconView.image = [UIImage imageNamed:@"AppDefaultIcon"];
    
    self.loginTypeBgView.layer.cornerRadius = 5;
    self.loginTypeBgView.layer.borderColor = [[UIColor colorWithRed:200/255. green:200/255. blue:200/255. alpha:1.0] CGColor];
    self.loginTypeBgView.layer.borderWidth = 0.5;
    
    self.catdBgView.layer.cornerRadius = 5;
    self.catdBgView.layer.borderColor = [[UIColor colorWithRed:200/255. green:200/255. blue:200/255. alpha:1.0] CGColor];
    self.catdBgView.layer.borderWidth = 0.5;

    
    self.securityBgView.layer.cornerRadius = 5;
    self.securityBgView.layer.borderColor = [[UIColor colorWithRed:200/255. green:200/255. blue:200/255. alpha:1.0] CGColor];
    self.securityBgView.layer.borderWidth = 0.5;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_circle_helper"] style:UIBarButtonItemStyleDone target:self action:@selector(helpClicked:)];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(74);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_lessThanOrEqualTo(350);
        make.height.equalTo(self.iconView.mas_width);
    }];
    
    [self.loginTypeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_bottom).offset(30);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(33);
        make.left.mas_equalTo(100);
    }];
    
    [self.loginTypeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loginTypeBgView.mas_left).offset(5);
        make.right.equalTo(self.loginTypeBgView.mas_right).offset(-5);
        make.height.equalTo(self.loginTypeBgView);
        make.centerY.equalTo(self.loginTypeBgView);
    }];
    
    [self.catdBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.loginTypeBgView);
        make.height.equalTo(self.loginTypeBgView);
        make.left.mas_equalTo(100);
        make.top.equalTo(self.loginTypeBgView.mas_bottom).offset(10);

    }];

    [self.cardNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.catdBgView.mas_left).offset(5);
        make.right.equalTo(self.catdBgView.mas_right).offset(-5);
        make.height.equalTo(self.catdBgView);
        make.centerY.equalTo(self.catdBgView);
    }];
    
    [self.securityBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.loginTypeBgView);
        make.height.equalTo(self.loginTypeBgView);
        make.left.mas_equalTo(100);
        make.top.equalTo(self.catdBgView.mas_bottom).offset(10);
    }];
    
    [self.password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.securityBgView.mas_left).offset(5);
        make.right.equalTo(self.securityBgView.mas_right).offset(-5);
        make.height.equalTo(self.securityBgView);
        make.centerY.equalTo(self.securityBgView);
    }];

    [self.loginTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.width.mas_equalTo(80);
        make.centerY.equalTo(self.loginTypeBgView.mas_centerY);
    }];
    
    [self.cardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.width.mas_equalTo(80);
        make.centerY.equalTo(self.catdBgView.mas_centerY);
    }];
    
    [self.passworldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.width.mas_equalTo(80);
        make.centerY.equalTo(self.securityBgView.mas_centerY);
    }];
    
    [self.securityCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.securityBgView.mas_bottom).offset(30);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
        make.centerX.equalTo(self.view.mas_centerX).offset(-60);
    }];
    
    [securityRefreshButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.securityCode);
    }];
    
    [self.code mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
        make.centerX.equalTo(self.view.mas_centerX).offset(60);
        make.centerY.equalTo(self.securityCode.mas_centerY);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(30);
        make.right.equalTo(self.view.mas_right).offset(-30);
        make.top.equalTo(self.code.mas_bottom).offset(40);
        make.height.mas_equalTo(44);
    }];
    
//    if (true) {
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
//    }
    
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
    
//    [_browser refreshVCodeToUIImageView:_securityCode :^(UIImage *captchaImage) {
//        
//        CaptchaBrowser * captcha = [[CaptchaBrowser alloc] init];
//        [captcha captchaToText:captchaImage response:^(BOOL success, NSString *captchaText) {
//            NSLog(@" 验证码 解析结果： %@     %@", success ? @"YES" : @"NO", captchaText);
//            if (success) {
//                _code.text = captchaText;
//            }
//        }];
//    }];
    
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

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackgroundNotification:) name:UIApplicationDidEnterBackgroundNotification object:nil];

}

- (void)applicationDidEnterBackgroundNotification:(NSNotification *)nofication{
    [self refreshSecurityCode:nil];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (void)helpClicked:(UIBarButtonItem *)sender{
    [AXPopoverView hideVisiblePopoverViewsAnimated:NO fromView:self.view];
    [AXPopoverView showLabelFromRect:CGRectMake(CGRectGetWidth(self.view.bounds) - 100, 25, 100, 50) inView:self.view animated:YES duration:2 title:@"提示:" detail:@"初始密码为身份证后四位+00，客服电话12329。\n 如若提示密码或验证码错误，请多尝试几次" configuration:^(AXPopoverView *popoverView) {
        popoverView.titleTextColor = [UIColor whiteColor];
        popoverView.detailTextColor = [UIColor whiteColor];
    }];
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
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
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
    [SVProgressHUD show];
    NSString * lb = [[NSUserDefaults standardUserDefaults] valueForKey:kLBValue];
    if (lb == nil) {
        lb = @"1";
    }
    NSUserDefaults * pref = [NSUserDefaults standardUserDefaults];
    [pref setValue:_cardNumber.text forKey:[kCardNumber stringByAppendingString:lb]];
    [pref setValue:_password.text forKey:[kCardPassward stringByAppendingString:lb]];
    
    __weak __block BJBrowser * browser =  _browser;
    __weak typeof(self) mySelf = self;
    [_browser loginWithCard:lb number:_cardNumber.text andPassword:_password.text andSecurityCode:_code.text status:^(NSArray<StatusBean *> *statusList) {
        
        if (statusList.count == 0 ) {
            [SVProgressHUD showErrorWithStatus:@"密码或者验证码错误"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_global_queue(0, 0), ^{
                [SVProgressHUD dismiss];
                [mySelf refreshSecurityCode:nil];
            });
            return ;
        }else{
            [SVProgressHUD dismiss];
        }
        
        CCFNavigationController * root = (CCFNavigationController*)mySelf.navigationController;
        
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CountInfoViewController * infoController = [storyboard instantiateViewControllerWithIdentifier:@"CountInfoViewController"];
        NSMutableArray *dataArray = [[NSMutableArray array] init];
        [dataArray addObject:statusList];
        infoController.data = dataArray;
        [root setRootViewController:infoController];
       
       __weak __block CountInfoViewController * blockController = infoController;
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

- (IBAction)changeCountType:(UIButton *)sender {
    UIAlertController * insertPhotoController = [UIAlertController alertControllerWithTitle:@"切换登录方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSArray* keys = _lbList.allKeys;
    for (NSString* key  in keys) {
        NSString * name = [_lbList valueForKey:key];
        UIAlertAction *action = [UIAlertAction actionWithTitle:name style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSUserDefaults * pref = [NSUserDefaults standardUserDefaults];
            [pref setValue:key forKey:kLBValue];
            [pref setValue:name forKey:kLBName];
            [pref synchronize];
            _cardNumber.placeholder = name;
            [self.loginTypeButton setTitle:name forState:UIControlStateNormal];

            NSString * number = [pref valueForKey:[kCardNumber stringByAppendingString:key]];
            NSString * password = [pref valueForKey:[kCardPassward stringByAppendingString:key]];
            _cardNumber.text = number;
            _password.text = password;
        }];
        [insertPhotoController addAction:action];
    }
    
    
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [insertPhotoController addAction:cancel];
    
    
    if([[self class] deviceIsPhone]){
        [self presentViewController:insertPhotoController animated:YES completion:nil];
        
    }else{
        
        UIPopoverPresentationController *popPresenter = [insertPhotoController
                                                         popoverPresentationController];
        popPresenter.sourceView = sender; // 这就是挂靠的对象
        popPresenter.sourceRect = sender.bounds;
        [self presentViewController:insertPhotoController animated:YES completion:nil];
    }
//    [self presentViewController:insertPhotoController animated:YES completion:nil];
}

#pragma mark - textfile delegate
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    if (textField.tag == 1000) {
        _cardNumber.text = nil;
        _password.text = nil;
        
        NSString * lb = [[NSUserDefaults standardUserDefaults] valueForKey:kLBValue];
        lb = lb?:@"1";
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:[kCardNumber stringByAppendingString:lb]];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:[kCardPassward stringByAppendingString:lb]];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if([[self class] deviceIsPhone]){
        
        [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(74-216);
            make.centerX.equalTo(self.view.mas_centerX);
            make.width.mas_lessThanOrEqualTo(350);
            make.height.equalTo(self.iconView.mas_width);
        }];
        
        [self.view setNeedsLayout];
    }
}

-  (void)textFieldDidEndEditing:(UITextField *)textField{
    if([[self class] deviceIsPhone]){
        
        [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(74);
            make.centerX.equalTo(self.view.mas_centerX);
            make.width.mas_lessThanOrEqualTo(350);
            make.height.equalTo(self.iconView.mas_width);
        }];
        [self.view setNeedsLayout];
    }
}

#pragma mark ---

// 返回时否是手机
+ (BOOL)deviceIsPhone{
    
    BOOL _isIdiomPhone = YES;// 默认是手机
    UIDevice *currentDevice = [UIDevice currentDevice];
    
    // 项目里只用到了手机和pad所以就判断两项
    // 设备是手机
    if (currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        
        _isIdiomPhone = YES;
    }
    // 设备室pad
    else if (currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad){
        
        _isIdiomPhone = NO;
    }
    
    return _isIdiomPhone;
}

@end
