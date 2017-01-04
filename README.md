# HorizontalPickerView-横向的选择器
By Ray Jiang

##导入
将HorizontalPickerView.h HorizontalPickerView.m 两个文件拖拽至工程中<br><br>

##横向选择器 使用效果
![image](https://github.com/RayJiang16/HorizontalPickerView/blob/master/1.gif)


    HorizontalPickerView *hpv = [[HorizontalPickerView alloc] initWithFrame:frame 
                                items:@[@"January", @"February", ...] isLoop:NO];
    hpv.delegate = self;
    [self.view addSubview:hpv];

##横向选择器+循环 使用效果
![image](https://github.com/RayJiang16/HorizontalPickerView/blob/master/2.gif)
![image](https://github.com/RayJiang16/HorizontalPickerView/blob/master/3.gif)


    HorizontalPickerView *hpv = [[HorizontalPickerView alloc] initWithFrame:frame 
                                items:@[@"January", @"February", ...] isLoop:YES];
    hpv.delegate = self;
    [self.view addSubview:hpv];
    
    
##HorizontalPickerView的代理方法
    /// 当HorizontalPickerView向右循环时调用的方法 eg.2016-12 -> 2017-1
    -(void)didLoopForward;

    /// 当HorizontalPickerView向左循环时调用的方法 eg.2016-12 <- 2017-1
    -(void)didLoopBack;

    ///当HorizontalPickerView选中了一个Item时调用的方法
    -(void)didSelectItem:(NSInteger)index;

