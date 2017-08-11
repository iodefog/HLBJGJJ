//
//  CountInfoTableViewController.m
//  HLBJGJJ
//
//  Created by Hongli li on 17/8/3.
//  Copyright © 2017年 honglili. All rights reserved.
//

#import "CountInfoTableViewController.h"
#import "BJBrowser.h"
#import "SVProgressHUD.h"

@interface CountInfoTableViewController (){
    BJBrowser * _browser;
}

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation CountInfoTableViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [SVProgressHUD show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _browser = [[BJBrowser alloc] init];
    
    [SVProgressHUD show];
    __weak typeof(self) mySelf = self;
    [_browser refreshGlobalInfo:self.object.companyLink status:^(NSArray<StatusBean *> *statusList) {
        mySelf.dataArray = statusList;
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    }];
    
    self.tableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count/2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CountInfoTableCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CountInfoTableCell"];
    }
    
    if (indexPath.row < self.dataArray.count/2) {
        cell.textLabel.text = self.dataArray[indexPath.row*2];
    }
    if (indexPath.row*2+1 < self.dataArray.count) {
        cell.detailTextLabel.text = self.dataArray[indexPath.row*2+1];
    }
    
    return cell;
}

@end
