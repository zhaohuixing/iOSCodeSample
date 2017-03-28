//
//  XZCareCoreBaseTabBarViewController.m
//  XZCareOneDown
//
//  Created by Zhaohui Xing on 2015-07-14.
//  Copyright (c) 2015 zhaohuixing. All rights reserved.
//
#import "XZCareCoreBaseTabBarViewController.h"

@interface XZCareCoreBaseTabBarViewController ()  <XZCarePasscodeViewControllerDelegate>

@property (nonatomic) BOOL isPasscodeShowing;

@end

@implementation XZCareCoreBaseTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setShowPasscodeScreen:(BOOL)showPasscodeScreen
{
    _showPasscodeScreen = showPasscodeScreen;
    if (showPasscodeScreen)
    {
        [self performSelector:@selector(showPasscode) withObject:nil afterDelay:0.4];
    }
}

- (void)showPasscode
{
    
    if (!self.isPasscodeShowing)
    {
        XZCarePasscodeViewController *passcodeViewController = [XZCarePasscodeViewController CreateInstance];
        passcodeViewController.delegate = self;
        UIViewController * presentVC = self.presentedViewController ? self.presentedViewController : self;
        [presentVC presentViewController:passcodeViewController animated:YES completion:nil];
        self.isPasscodeShowing = YES;
    }
    
}


- (void)passcodeViewControllerDidSucceed:(XZCarePasscodeViewController *)viewController
{
    self.isPasscodeShowing = NO;
    self.showPasscodeScreen = NO;
    [viewController dismissViewControllerAnimated:YES completion:nil];
    if ([self.passcodeDelegate respondsToSelector:@selector(passcodeViewControllerDidSucceed:)])
    {
        [self.passcodeDelegate passcodeViewControllerDidSucceed: viewController];
    }
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
