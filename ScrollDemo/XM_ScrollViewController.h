//
//  XM_ScrollViewController.h
//  ScrollDemo
//
//  Created by 王忠诚 on 2018/1/9.
//  Copyright © 2018年 王忠诚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XM_ScrollViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

/** staticNavHeader */
@property(nonatomic, assign) BOOL staticNavHeader;
/** customTableView */
@property (strong, nonatomic) UITableView *customTableView;

- (void)reloadImage:(UIImage *)image withMaxBrightness:(double)maxBrightness;

- (void)setUpWithTableView:(UITableView *)tableView;

@end
