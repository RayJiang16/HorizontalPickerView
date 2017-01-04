//
//  HPVViewController.m
//  HorizontalPickerView
//
//  Created by Emily on 2017/1/4.
//  Copyright © 2017年 Ray. All rights reserved.
//

#import "HPVViewController.h"
#import "HorizontalPickerView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface HPVViewController () <HorizontalPickerViewDelegate>
@property (nonatomic, strong) HorizontalPickerView *hpv;
@end

@implementation HPVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self createButton];
    _hpv = [[HorizontalPickerView alloc] initWithFrame:CGRectMake(0, 200, kScreenWidth, 50) items:@[@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December"] isLoop:NO];
    _hpv.delegate = self;
    [self.view addSubview:_hpv];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Button
- (void)createButton {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"随机选择" style:UIBarButtonItemStyleDone target:self action:@selector(clickButton:)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)clickButton:(UIButton *)sender {
    [_hpv scrollToItemWithIndex:random()%12];
}

#pragma mark <Delegate>
- (void)didSelectItem:(NSInteger)index {
    NSLog(@"selcte item:%ld", index);
}

@end
