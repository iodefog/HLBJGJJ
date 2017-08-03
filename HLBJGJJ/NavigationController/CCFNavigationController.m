//
//  CCFNavigationController.m
//  CCF
//
//  Created by honglili on 16/1/12.
//  Copyright © 2017年 honglili. All rights reserved.
//

#import "CCFNavigationController.h"


@interface CCFNavigationController (){
   
}

@end

@implementation CCFNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

}



-(void)setRootViewController:(UIViewController *)rootViewController {
    //rootViewController.navigationItem.hidesBackButton = YES;
    [self popToRootViewControllerAnimated:NO];
//    [self popToViewController:fakeRootViewController animated:NO];
    [self pushViewController:rootViewController animated:NO];
}


@end
