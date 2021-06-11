//
//  ZYViewController.m
//  ZYTextInputAvoidKeyboard
//
//  Created by 赵洋 on 06/11/2021.
//  Copyright (c) 2021 赵洋. All rights reserved.
//

#import "ZYViewController.h"

@interface ZYViewController ()

@end

@implementation ZYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  
  [self.view addSubview:({
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 200, 40)];
    label.text = @"textView focus Demo";
    label;
  })];
  
  [self.view addSubview:({
      UIButton *button = [self createButtonWithFrame:CGRectMake(20, 200, 200, 50)];
      button.tag = 100;
      [button setTitle:@"one textView" forState:UIControlStateNormal];
      button;
  })];

  [self.view addSubview:({
      UIButton *button = [self createButtonWithFrame:CGRectMake(20, 300, 200, 50)];
      button.tag = 101;
      [button setTitle:@"multi textView" forState:UIControlStateNormal];
      button;
  })];
  
  [self.view addSubview:({
      UIButton *button = [self createButtonWithFrame:CGRectMake(20, 400, 200, 50)];
      button.tag = 102;
      [button setTitle:@"multi text table" forState:UIControlStateNormal];
      button;
  })];
}


- (void)jumpButtonClick:(UIButton *)button {
    
    NSArray<NSString *> * vcNames =
    @[@"OneTextViewOnScrollViewVC",
      @"MultiTextViewOnScrollViewVC",
      @"MultiTextViewOnTableViewVC"];
    
    NSString *vcName = vcNames[button.tag - 100];
    
    //-test
    if (self.navigationController) {
        Class cls = NSClassFromString(vcName);
        UIViewController *vc = [cls new];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }else {
        Class cls = NSClassFromString(vcName);
        UIViewController *vc = [cls new];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:^{}];
    }
    
}

- (UIButton *)createButtonWithFrame:(CGRect)frame {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.titleLabel.font = [UIFont systemFontOfSize:20];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(jumpButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    // corner
    button.layer.cornerRadius = button.bounds.size.height / 2;
    button.layer.masksToBounds = YES;
    // border
    button.layer.borderColor = [UIColor redColor].CGColor;
    button.layer.borderWidth = 1;
    
    return button;
}


@end
