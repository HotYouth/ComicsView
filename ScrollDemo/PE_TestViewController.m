//
//  PE_TestViewController.m
//  ScrollDemo
//
//  Created by 王忠诚 on 2018/1/9.
//  Copyright © 2018年 王忠诚. All rights reserved.
//

#import "PE_TestViewController.h"

@interface PE_TestViewController ()

@end

@implementation PE_TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.staticNavHeader = NO;
    self.view.backgroundColor = [UIColor yellowColor];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backButton"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.customTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 55, 0);
        [self setUpWithTableView:tableView];
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identfier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identfier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identfier];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGRect headerFrame = CGRectMake(0, 0, tableView.frame.size.width, 55);
    UIView *headerView = [[UIView alloc] initWithFrame:headerFrame];
    CGFloat grey = 246.0 / 255.0;
    headerView.backgroundColor = [UIColor colorWithRed:grey green:grey blue:grey alpha:1];
    return headerView;
}

- (void)back:(UIBarButtonItem *)item {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
