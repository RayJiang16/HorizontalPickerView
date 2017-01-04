//
//  MenuTableViewController.m
//  HorizontalPickerView
//
//  Created by Emily on 2017/1/4.
//  Copyright © 2017年 Ray. All rights reserved.
//

#import "MenuTableViewController.h"
#import "HPVViewController.h"
#import "HPVHasLoopViewController.h"

@interface MenuTableViewController ()
@property (nonatomic, strong) NSArray *listArray;
@end

@implementation MenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.listArray = @[@"横向选择器", @"横向选择器+循环"];
    self.navigationController.title = @"HorizontalPickerView";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = self.listArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            HPVViewController *vc = [HPVViewController new];
            vc.title = self.listArray[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1: {
            HPVHasLoopViewController *vc = [HPVHasLoopViewController new];
            vc.title = self.listArray[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
