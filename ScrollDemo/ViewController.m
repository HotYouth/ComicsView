//
//  ViewController.m
//  ScrollDemo
//
//  Created by 王忠诚 on 2018/1/9.
//  Copyright © 2018年 王忠诚. All rights reserved.
//

#import "ViewController.h"
#import "XM_ScrollViewController.h"
#import "PE_TestViewController.h"

@interface ViewController ()
/** select */
@property(nonatomic, assign) BOOL select;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIViewController *scrollVC = [[PE_TestViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:scrollVC];
    [nav.navigationBar setTintColor:[UIColor blackColor]];
    [nav.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [nav.navigationBar setShadowImage:[UIImage new]];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
//    self.select = !self.select;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
