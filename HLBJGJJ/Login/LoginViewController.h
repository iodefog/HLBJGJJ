//
//  LoginViewController.h
//  HLBJGJJ
//
//  Created by Hongli li on 16/1/25.
//  Copyright © 2017年 honglili. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <GoogleMobileAds/GoogleMobileAds.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIButton *loginTypeButton;
@property (weak, nonatomic) IBOutlet UITextField *cardNumber;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIImageView *securityCode;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UIView *loginTypeBgView;
@property (weak, nonatomic) IBOutlet UIView *catdBgView;
@property (weak, nonatomic) IBOutlet UIView *securityBgView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *loginTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardLabel;
@property (weak, nonatomic) IBOutlet UILabel *passworldLabel;

//@property (weak, nonatomic) IBOutlet GADBannerView *adView;

- (IBAction)refreshSecurityCode:(id)sender;
- (IBAction)login:(id)sender;
- (IBAction)changeCountType:(id)sender;

@end
