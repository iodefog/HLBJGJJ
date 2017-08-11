
//
//  CountInfoViewController.m
//  HLBJGJJ
//
//  Created by Hongli li on 17/8/3.
//  Copyright © 2017年 honglili. All rights reserved.
//

#import "CountInfoViewController.h"
#import "StatusBean.h"
#import "CountTableViewCell.h"
#import "CountGlobalTableViewCell.h"
#import "CountInfoTableViewController.h"
#import "LoginViewController.h"
#import "WebViewController.h"

@interface CountInfoViewController () <UITableViewDelegate, UITableViewDataSource>


@end

@implementation CountInfoViewController


@synthesize data;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"开户单位";
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStyleDone target:self action:@selector(rightClicked:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonItemStyleDone target:self action:@selector(leftClicked:)];

    [self.tableView registerClass:[CountTableViewCell class] forCellReuseIdentifier:@"CountTableViewCell"];
    [self.tableView registerClass:[CountGlobalTableViewCell class] forCellReuseIdentifier:@"CountGlobalTableViewCell"];
    self.tableView.tableFooterView = [UIView new];

}

- (void)rightClicked:(UIBarButtonItem *)sender{

}

- (void)leftClicked:(UIBarButtonItem *)sender{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否注销登录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *logoutAction = [UIAlertAction actionWithTitle:@"注销" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:logoutAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.data count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.data[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CountTableViewCell *cell = nil;
    id object = [[self.data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    if ([object isKindOfClass:[NSArray class]]) {
       cell = [tableView dequeueReusableCellWithIdentifier:@"CountGlobalTableViewCell" forIndexPath:indexPath];
    }
    else {
       cell = [tableView dequeueReusableCellWithIdentifier:@"CountTableViewCell" forIndexPath:indexPath];

    }
    
     if (indexPath.section < [self.data count] && indexPath.row < [self.data[indexPath.section] count]) {
        id object = [[self.data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.object = object;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < [self.data count] && indexPath.row < [self.data[indexPath.section] count]) {
        id bean = [[self.data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        if ([bean isKindOfClass:[StatusBean class]]) {
            CountInfoTableViewController *countTableVC = [[CountInfoTableViewController alloc] init];
            countTableVC.object = bean;
            countTableVC.title = [bean companyName];
            [self.navigationController pushViewController:countTableVC animated:YES];
        }
        else {
            NSArray *object = [[self.data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            if ([object isKindOfClass:[NSArray class]]) {
                WebViewController *webVC = [[WebViewController alloc] init];
                webVC.title = @"个人缴存明细";
                webVC.url = [object lastObject];
                [self.navigationController pushViewController:webVC animated:YES];
            }
        }
    }
}

@end
