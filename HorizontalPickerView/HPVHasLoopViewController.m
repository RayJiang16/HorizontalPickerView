//
//  HPVHasLoopViewController.m
//  HorizontalPickerView
//
//  Created by Emily on 2017/1/4.
//  Copyright © 2017年 Ray. All rights reserved.
//

#import "HPVHasLoopViewController.h"
#import "HorizontalPickerView.h"

@interface HPVHasLoopViewController () <HorizontalPickerViewDelegate>
@property (nonatomic, strong) HorizontalPickerView *hpv;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@end

@implementation HPVHasLoopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    _year = 2017;
    _month = 1;
    _label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 50)];
    _label.text = [NSString stringWithFormat:@"%ld-%ld", _year, _month];
    [self.view addSubview:self.label];
    
    _hpv = [[HorizontalPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 50) items:@[@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December"] isLoop:YES];
    _hpv.delegate = self;
    [self.view addSubview:self.hpv];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark <Delegate>
- (void)didLoopForward {
    NSLog(@"Call did loop forward");
    _year++;
    _label.text = [NSString stringWithFormat:@"%ld-%ld", _year, _month];
}

- (void)didLoopBack {
    NSLog(@"Call did loop back");
    _year--;
    _label.text = [NSString stringWithFormat:@"%ld-%ld", _year, _month];
}

- (void)didSelectItem:(NSInteger)index {
    NSLog(@"selcte item:%ld", index);
    _month = index+1;
    _label.text = [NSString stringWithFormat:@"%ld-%ld", _year, _month];
}

@end
