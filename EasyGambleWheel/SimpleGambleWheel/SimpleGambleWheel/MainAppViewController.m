//
//  ViewController.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 2015-11-06.
//  Copyright © 2015 Zhaohui Xing. All rights reserved.
//
#import "MainAppViewController.h"
#import "ApplicationConfigure.h"
#import "GUILayout.h"
#import "GameViewController.h"
#import "GameScore.h"
#import "ApplicationResource.h"
#import "GUIEventLoop.h"
#import "GameViewController.h"
#import "AdBannerHostView.h"
#import "ScoreRecord.h"
#import "CustomModalAlertView.h"

@interface MainAppViewController ()
{
    AdBannerHostView*           m_AdBanner;
}

@property (nonatomic, strong) GameViewController * gameViewController;
- (void)updateLayout;

@end

@implementation MainAppViewController

- (void)OnEnableAdBanner
{
    [self setAdBannerEnable:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [GUILayout SetRootViewController:self];
    
    [GUIEventLoop RegisterEvent:GUIID_EVENT_ENABLEADBANNERVIEW eventHandler:@selector(OnEnableAdBanner) eventReceiver:self eventSender:nil];
    
    NSString *deviceModel = (NSString*)[UIDevice currentDevice].model;
    
    if ([deviceModel hasPrefix:@"iPad"] == YES || [deviceModel hasSuffix:@"iPad"] == YES)
    {
        [ApplicationConfigure SetActiveDeviceType:APPLICATION_ACTIVE_DEVICE_TYPE_IPAD];
    }
    else
    {
        [ApplicationConfigure SetActiveDeviceType:APPLICATION_ACTIVE_DEVICE_TYPE_IPHONE];
    }
    
    self.view.backgroundColor = [UIColor redColor];
    
    NSLog(@"container view width:%f height:%f", self.view.frame.size.width, self.view.frame.size.height);
    
}

-(void)Terminate
{
    //    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    [GUIEventLoop RemoveEvent:GUIID_EVENT_ENABLEADBANNERVIEW eventReceiver:self eventSender:nil];
    [((GameViewController*)[GUILayout GetGameViewController]) Terminate];
    if(m_AdBanner != nil)
    {
        m_AdBanner.hidden = YES;
        [m_AdBanner DismissAdBanner];
        m_AdBanner = nil;
    }
}

- (void)SwitchToPaidVersion
{
    [self removeAddBanner];
}

- (void)removeAddBanner
{
    if(m_AdBanner != nil)
    {
        m_AdBanner.hidden = YES;
        [m_AdBanner DismissAdBanner];
        m_AdBanner = nil;
    }
}

- (BOOL)isEnableAdBanner
{
    if(m_AdBanner != nil)
        return YES;
    else
        return NO;
}

- (void)dealloc
{
    if([self isEnableAdBanner] == YES)
        [self removeAddBanner];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *children = self.childViewControllers;
    assert(children != nil);    // must have children
    
    // keep track of our child view controller for rotation and frame management
    _gameViewController = children[0];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.gameViewController preferredInterfaceOrientationForPresentation];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    CGRect contentFrame = self.view.bounds, bannerFrame = CGRectZero;

    BOOL bEnableAdd = [self isEnableAdBanner];
    if(bEnableAdd == YES && m_AdBanner != nil)
    {
        CGFloat bh = [AdBannerHostView GetADBannerHeight];
        if([m_AdBanner HasAds] == YES)
        {
            
            bannerFrame = CGRectMake(0, contentFrame.size.height - bh, contentFrame.size.width, bh);
            contentFrame.size.height -= bh;
        }
        else
        {
            bannerFrame = CGRectMake(0, contentFrame.size.height, contentFrame.size.width, bh);
        }
        self.gameViewController.view.frame = contentFrame;
        [m_AdBanner setFrame:bannerFrame];
        [m_AdBanner UpdateLayout];
        
        [self.view layoutSubviews];
    }
    else
    {
        self.gameViewController.view.frame = contentFrame;
        [self.view layoutSubviews];
    }
    [GUILayout SetMainUIDimension:self.gameViewController.view.frame.size.width withHeight:self.gameViewController.view.frame.size.height];
    int nCount = (int)[self.view.subviews count];
    for(int i = 0; i < nCount; ++i)
    {
        id pSubView = [self.view.subviews objectAtIndex:i];
        if(pSubView && [pSubView isKindOfClass:[CustomModalAlertBackgroundView class]] && [pSubView respondsToSelector:@selector(UpdateSubViewsOrientation)])
        {
            [pSubView performSelector:@selector(UpdateSubViewsOrientation)];
        }
    }
    
}

- (void)updateLayout
{
//    if([GameConfiguration GetMainBackgroundType] == 0)
//        self.view.backgroundColor = [UIColor brownColor];
//    else
//        self.view.backgroundColor = [UIColor greenColor];
    
    [UIView animateWithDuration:0.25 animations:^{
        // viewDidLayoutSubviews will handle positioning the banner view so that it is visible.
        // You must not call [self.view layoutSubviews] directly.  However, you can flag the view
        // as requiring layout...
        [self.view setNeedsLayout];
        // ... then ask it to lay itself out immediately if it is flagged as requiring layout...
        [self.view layoutIfNeeded];
        // ... which has the same effect.
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)setAdBannerEnable:(BOOL)bEnable
{
    [ScoreRecord SetEnableAdBanner:bEnable];
    
    if(bEnable == YES)
    {
        if(m_AdBanner == nil)
        {
            CGFloat w = self.view.frame.size.width;
            CGFloat h = [AdBannerHostView GetADBannerHeight];
            CGFloat y = self.view.frame.size.height - h;
            m_AdBanner = [[AdBannerHostView alloc] initWithFrame:CGRectMake(0, y, w, h)];
            m_AdBanner.hidden = NO;
            [self.view addSubview:m_AdBanner];
        }
    }
    else
    {
        [self removeAddBanner];
    }
    [self updateLayout];
}
@end
