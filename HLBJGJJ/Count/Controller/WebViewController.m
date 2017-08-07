//
//  WebViewController.m
//  HLBJGJJ
//
//  Created by LHL on 2017/8/7.
//  Copyright © 2017年 andforce. All rights reserved.
//

#import "WebViewController.h"
#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"
/**
 *  http://www.bjgjj.gov.cn/wsyw/wscx/gjj_cxls.jsp?xm=JiMyNjQ0NjsmIzMyNDE4OyYjMjExNDc7&grdjh=41022119900528085800&sfzh=GJJ015602936&bh=127&jczt=%BD%C9%B4%E6
 
 */
@interface WebViewController ()<UIWebViewDelegate>

@property (nonatomic, nonnull) UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    [SVProgressHUD show];

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [SVProgressHUD dismiss];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
