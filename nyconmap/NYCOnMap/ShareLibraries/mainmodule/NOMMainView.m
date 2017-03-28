//
//  NOMMainView.m
//  trafficjfk
//
//  Created by Zhaohui Xing on 2014-03-14.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMMainView.h"
#import "NOMGUILayout.h"
#import "AdBannerHostView.h"
#import "NOMMapView.h"
#import "MainToolbarView.h"
#import "MainMenuController.h"
#import "GUIEventLoop.h"
#import "GUIBasicConstant.h"
#import "NOMAppConstants.h"
#import "NOMSystemConstants.h"
#import "MenuFactory.h"
#import "NOMGEOPlanView.h"
#import "NOMAddressFinderView.h"
#import "NOMPostView.h"
#import "NOMReadView.h"
#import "NOMTweetReadingView.h"
#import "NOMAppInfo.h"
#import "CustomMapViewPinItem.h"
#import "CustomMapViewPinCallout.h"
#import "NOMTermAcceptView.h"

@interface NOMMainView()
{
@private
    AdBannerHostView*                           m_AdBanner;
    NOMMapView*                                 m_MapView;
    MainViewBottomStatusBarController*          m_PopupToolbarButtonController;
    MainToolbarView*                            m_ToolbarView;
    MainMenuController*                         m_MenuController;
    NOMDocumentController*                      m_DocumentController;
    
    
    NOMAddressFinderView*                       m_AddressFindingView;
    NOMTermAcceptView*                          m_TermAcceptView;
    
    
    CustomMapViewPinCallout*                    m_CustomNewsCallout;
}

-(void)OnCloseToolbarView;
-(void)OnSearchButtonClicked;
-(void)OnPostButtonClicked;
-(void)OnSettingButtonClicked;
-(void)UpdateMainMenu;
-(void)InitializeMenuEvent;

@end

@implementation NOMMainView

- (BOOL)HandleRemoteNotificationData:(NSDictionary *)userInfo
{
    BOOL bRet = NO;
    
    if(m_DocumentController != nil)
        bRet = [m_DocumentController HandleRemoteNotificationData:userInfo];
    
    return bRet;
}

- (void)initAdBanner
{
    CGFloat w = [NOMGUILayout GetAdBannerWidth];
    CGFloat h = [NOMGUILayout GetAdBannerHeight];
    m_AdBanner = [[AdBannerHostView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    [self addSubview:m_AdBanner];
}

- (void)initMapView
{
    CGFloat sy = [NOMGUILayout GetMapViewOriginY];
    CGFloat w = [NOMGUILayout GetLayoutWidth];
    CGFloat h = [NOMGUILayout GetMapViewHeight];
    CGRect frame = CGRectMake(0, sy, w, h);

    m_MapView = [[NOMMapView alloc] initWithFrame:frame];
    [self addSubview:m_MapView];
    if([NOMAppInfo IsVersion8] == YES)
    {
        [m_MapView ShowMyLocationPostAnnotation];
    }

//!!!    m_GEOPlanView = [[NOMGEOPlanView alloc] initWithFrame:frame];
//!!!    [self addSubview:m_GEOPlanView];
//!!!    [m_GEOPlanView CloseView:NO];

    m_AddressFindingView = [[NOMAddressFinderView alloc] initWithFrame:frame];
    [self addSubview:m_AddressFindingView];
    [m_AddressFindingView CloseView:NO];

    m_TermAcceptView = [[NOMTermAcceptView alloc] initWithFrame:frame];
    [self addSubview:m_TermAcceptView];
    [m_TermAcceptView CloseView:NO];
}

- (void)initStatusBarController
{
    m_PopupToolbarButtonController = [[MainViewBottomStatusBarController alloc] initWithDelegate:self];
    [m_PopupToolbarButtonController RegisterCallout:self];
}

-(void)initToolBarView
{
    CGFloat size = [NOMGUILayout GetActivateButtonSize];
    CGFloat w = [NOMGUILayout GetLayoutWidth];
    CGFloat h = [NOMGUILayout GetLayoutHeight];
    
    CGRect rect = CGRectMake(0, h - size, w, size);
    m_ToolbarView = [[MainToolbarView alloc] initWithFrame:rect];
    [self addSubview:m_ToolbarView];
    m_ToolbarView.hidden = YES;
    
    [GUIEventLoop RegisterEvent:GUIID_TOOLBARVIEW_CLOSEBUTTON_CLICKDOWN eventHandler:@selector(OnCloseToolbarView) eventReceiver:self eventSender:m_ToolbarView];
    
    [GUIEventLoop RegisterEvent:GUIID_SEARCHBUTTON_ID eventHandler:@selector(OnSearchButtonClicked) eventReceiver:self eventSender:m_ToolbarView];
    
    [GUIEventLoop RegisterEvent:GUIID_POSTBUTTON_ID eventHandler:@selector(OnPostButtonClicked) eventReceiver:self eventSender:m_ToolbarView];
    
    [GUIEventLoop RegisterEvent:GUIID_SETTINGBUTTON_ID eventHandler:@selector(OnSettingButtonClicked) eventReceiver:self eventSender:m_ToolbarView];
}

-(void)initMainMenuController
{
    CGFloat size = [NOMGUILayout GetActivateButtonSize];
    CGFloat h = [NOMGUILayout GetLayoutHeight];
    float sy = h-size;
    m_MenuController = [[MainMenuController alloc] init];
    CGPoint pt = [m_ToolbarView GetSearchButtonArchorPoint];
    pt.y = sy;
    [MenuFactory CreateSearchMenu:self withController:m_MenuController inArchor:pt withPoistion:0.5];
    
    
    pt = [m_ToolbarView GetSettingButtonArchorPoint];
    pt.y = sy;
    [MenuFactory CreateSettingMenu:self withController:m_MenuController inArchor:pt withPoistion:0.5];
    
    pt = [m_ToolbarView GetPostButtonArchorPoint];
    pt.y = sy;
    [MenuFactory CreatePostMenu:self withController:m_MenuController inArchor:pt withPoistion:0.5];
    
    [self UpdateMainMenu];
}

-(void)initCustomListCallout
{
    float h = [CustomMapViewPinCallout GetDefaultContainerViewHeight];
    float w = [CustomMapViewPinCallout GetContainerViewWidth];
    float sx = 0;
    float sy = 0;
    CGRect rect = CGRectMake(sx, sy, w, h);
    m_CustomNewsCallout = [[CustomMapViewPinCallout alloc] initWithFrame:rect];
    [m_CustomNewsCallout SetArchor:CGPointMake(0.5, 0.0)];
    [self addSubview:m_CustomNewsCallout];
    [m_CustomNewsCallout Open:NO];
    [m_CustomNewsCallout Close:NO];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        m_DocumentController = nil;
        [self initAdBanner];
        [self initMapView];
        [self initStatusBarController];
        [self initToolBarView];
        [self initMainMenuController];
        [self initCustomListCallout];
        [self UpdateLayout:NO];
        [self bringSubviewToFront:m_CustomNewsCallout];
    }
    return self;
}

-(void)CloseCallout
{
    [m_CustomNewsCallout Close:YES];
}

-(void)ShowNewsCalloutAt:(CGPoint)pt withAnimation:(BOOL)bYes
{
    float w = m_CustomNewsCallout.frame.size.width;
    float sw = self.frame.size.width;
    float sh = self.frame.size.height;
    
    float archory = 0;
    float sx = pt.x - w*0.5;
    float sy = pt.y;
    if(sh*0.5 < pt.y)
    {
        sy = pt.y - m_CustomNewsCallout.frame.size.height;
        archory = m_CustomNewsCallout.frame.size.height;
    }
    
    float archorx = 0.5*w;
    if(pt.x < w*0.5)
    {
        archorx = pt.x;
        sx = 0;
    }
    else if((sw - w*0.5) < pt.x)
    {
        archorx = w - (sw - pt.x);
        sx = sw - w;
    }
    
    CGRect rect = m_CustomNewsCallout.frame;
    rect.origin.x = sx;
    rect.origin.y = sy;
    [m_CustomNewsCallout setFrame:rect];
    
    [m_CustomNewsCallout SetArchor:CGPointMake(archorx, archory)];
    [m_CustomNewsCallout UpdateLayout];
    [m_CustomNewsCallout Open:bYes];
}

-(void)SetDocumentController:(NOMDocumentController*)document
{
    m_DocumentController = document;
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetMainViewObject:self];
        [m_MapView SetMapObjectController:[m_DocumentController GetMapObjectController]];
        [self InitializeMenuEvent];
        [m_DocumentController InitializeSpotViewController:self];
        [m_DocumentController InitializePostViewController:self];
        [m_DocumentController InitializeReadViewController:self];
        [m_DocumentController SetCachedSocialNewsContainer:m_PopupToolbarButtonController];
    }
}

-(void)AddChildView:(UIView*)child
{
    [self addSubview:child];
}

-(CGRect)GetFrame
{
    return CGRectMake(0, 0, [NOMGUILayout GetLayoutWidth], [NOMGUILayout GetLayoutHeight]);
}

-(void)ShowPopupToolbarButton:(BOOL)bShow
{
    [m_PopupToolbarButtonController ShowPopupToolbarButton:bShow];
}


-(void)OpenToolbarView
{
    //m_bNeedTouch4Post = NO;
    [self ShowPopupToolbarButton:NO];
    m_ToolbarView.hidden = NO;
}

-(void)OpenToolbarButtonClick
{
    [self OpenToolbarView];
}

-(void)HandleCloseToolbarViewInThread
{
    m_ToolbarView.hidden = YES;
    [self ShowPopupToolbarButton:YES];
    [m_MenuController CloseAllMenus];
}

-(void)OnCloseToolbarView
{
    [self HandleCloseToolbarViewInThread];
    
/*
    m_ToolbarView.hidden = YES;
    [self ShowPopupToolbarButton:YES];
    [m_MenuController CloseAllMenus];
*/
    
    
    //??????
    //??????
    //??????
    //??????
    //[m_CustomNewsCallout Close:YES];
    
    //    if(m_StatusBar.hidden == NO)
//    {
//        [self HideStatusBar];
//    }
}

-(void)OnTweetButtonClick
{
#ifdef DEBUG
    NSLog(@"NOMMainView OnTweetButton\n");
#endif
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self OnCloseToolbarView];
    [self CloseCallout];
    if(m_DocumentController != nil)
    {
        UITouch *touch = [[[event allTouches] allObjects] objectAtIndex:0];
        if(touch != nil)
        {
            CGPoint touchPoint = [touch locationInView:m_MapView];
            [m_DocumentController OnTouchBegin:touchPoint];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    if(m_DocumentController != nil)
    {
        UITouch *touch = [[[event allTouches] allObjects] objectAtIndex:0];
        if(touch != nil)
        {
            CGPoint touchPoint = [touch locationInView:m_MapView];
            [m_DocumentController OnTouchMoved:touchPoint];
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if(m_DocumentController != nil)
    {
        UITouch *touch = [[[event allTouches] allObjects] objectAtIndex:0];
        if(touch != nil)
        {
            CGPoint touchPoint = [touch locationInView:m_MapView];
            [m_DocumentController OnTouchEnded:touchPoint];
        }
    }
}


-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    if(m_DocumentController != nil)
    {
        UITouch *touch = [[[event allTouches] allObjects] objectAtIndex:0];
        if(touch != nil)
        {
            CGPoint touchPoint = [touch locationInView:m_MapView];
            [m_DocumentController OnTouchCancelled:touchPoint];
        }
    }
}

-(void)OnSearchButtonClicked
{
    if(m_MenuController != nil)
    {
        [m_MenuController OpenMenu:GUIID_SEARCHMENU_ID];
    }
}

-(void)OnPostButtonClicked
{
    if(m_MenuController != nil)
    {
        [m_MenuController OpenMenu:GUIID_POSTMENU_ID];
    }
}

-(void)OnSettingButtonClicked
{
    if(m_MenuController != nil)
    {
        [m_MenuController OpenMenu:GUIID_SETTINGMENU_ID];
    }
}

-(void)UpdateToolbarView
{
    CGFloat size = [NOMGUILayout GetActivateButtonSize];
    
    CGFloat w = [NOMGUILayout GetLayoutWidth];
    CGFloat h = [NOMGUILayout GetLayoutHeight];
    
    CGRect rect = CGRectMake(0, h - size, w, size);
    [m_ToolbarView setFrame:rect];
    [m_ToolbarView UpdateLayout];
}

-(void)UpdateMainMenu
{
    CGFloat size = [NOMGUILayout GetActivateButtonSize];
    CGFloat h = [NOMGUILayout GetLayoutHeight];
    float sy = h-size;
    CGPoint pt = [m_ToolbarView GetSearchButtonArchorPoint];
    pt.y = sy;
    
    CGFloat mw, mh, mx, my;
    CGRect rect;
    PopupMenuContainerView* pMenu = [m_MenuController GetMenu:GUIID_SEARCHMENU_ID];
    if(pMenu != nil)
    {
        mw = [pMenu GetLayoutWidth];
        mh = [pMenu GetLayoutHeight];
        mx = pt.x - mw*0.5;
        my = pt.y - mh;
        rect = CGRectMake(mx, my, mw, mh);
        [pMenu setFrame:rect];
    }
    
    pt = [m_ToolbarView GetSettingButtonArchorPoint];
    pt.y = sy;
    pMenu = [m_MenuController GetMenu:GUIID_SETTINGMENU_ID];
    if(pMenu != nil)
    {
        mw = [pMenu GetLayoutWidth];
        mh = [pMenu GetLayoutHeight];
        mx = pt.x - mw*0.5;
        my = pt.y - mh;
        rect = CGRectMake(mx, my, mw, mh);
        [pMenu setFrame:rect];
    }
    
    pt = [m_ToolbarView GetPostButtonArchorPoint];
    pt.y = sy;
    pMenu = [m_MenuController GetMenu:GUIID_POSTMENU_ID];
    if(pMenu != nil)
    {
        mw = [pMenu GetLayoutWidth];
        mh = [pMenu GetLayoutHeight];
        mx = pt.x - mw*0.5;
        my = pt.y - mh;
        rect = CGRectMake(mx, my, mw, mh);
        [pMenu setFrame:rect];
    }
}

-(void)UpdateLayout:(BOOL)bUpdateSubViewLayout
{
    if(m_AdBanner != nil)
    {
        [m_AdBanner UpdateLayout];
    }
    CGFloat sy = [NOMGUILayout GetMapViewOriginY];
    CGFloat w = [NOMGUILayout GetLayoutWidth];
    CGFloat h = [NOMGUILayout GetMapViewHeight];
    CGRect frame = CGRectMake(0, sy, w, h);
    
    [m_MapView setFrame:frame];
    [m_MapView UpdateLayout];
//!!!    [m_GEOPlanView setFrame:frame];
//!!!    [m_GEOPlanView UpdateLayout];
    [m_AddressFindingView setFrame:frame];
    [m_AddressFindingView UpdateLayout];
//    [m_NewsReadView setFrame:frame];
//    [m_NewsReadView UpdateLayout];
//    [m_TweetReadView setFrame:frame];
//    [m_TweetReadView UpdateLayout];
    [m_TermAcceptView setFrame:frame];
    [m_TermAcceptView UpdateLayout];
    
    [m_DocumentController UpdateSpotViewControllerLayout];
    [m_DocumentController UpdatePostViewControllerLayout];
    [m_DocumentController UpdateReadViewControllerLayout];
    
    [m_PopupToolbarButtonController UpdateLayout];
    [self UpdateToolbarView];
    [self UpdateMainMenu];
    
    if(bUpdateSubViewLayout == NO)
    {
        [m_CustomNewsCallout Close:YES];
    }
    [m_CustomNewsCallout UpdateLayout];
}

-(void)StartFindLocationForPosting
{
    [m_AddressFindingView OpenView:YES];
}

-(void)InitializeSettingMenuEvent
{
    if(m_DocumentController != nil)
    {
        [m_DocumentController InitializeSettingMenuEvent];
    }
}

-(void)TestPlanView
{
//!!!    [m_MenuController CloseAllMenus];
//!!!    [self OnCloseToolbarView];
//!!!    [m_GEOPlanView OpenView:YES];
}

-(void)HandlePostEventOnThread
{
    if(m_DocumentController != nil)
    {
        [m_DocumentController StartHandlePostEvent];
    }
}

-(void)StartHandlePostEvent
{
    //[self TestPlanView];
    //[self HandlePostEventOnThread];
    
    if(m_DocumentController != nil)
    {
        [m_DocumentController StartHandlePostEvent];
    }
}

-(void)AsyncHandleSearchEvent
{
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(AsyncHandleSearchEvent) withObject:nil waitUntilDone:NO];
        return;
    }
    
    if(m_DocumentController != nil)
    {
        [m_DocumentController StartHandleSearchEvent];
    }
}

-(void)StartHandleSearchEvent
{
//    [GUIEventLoop SendEvent:GUIID_UI_STARTSEARCH_EVENT eventSender:self];

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    //dispatch_get_main_queue(); ////dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue, ^(void)
    {
        [self AsyncHandleSearchEvent];
    });

/*
    if(m_DocumentController != nil)
    {
        [m_DocumentController StartHandleSearchEvent];
    }
*/
}

-(void)OnPostJamEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserMode:NOM_USERMODE_POST
                             withCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC
                          withSubCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION
                        withThirdCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_JAM];
    }
    [self StartHandlePostEvent];
}

-(void)OnPostCrashEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserMode:NOM_USERMODE_POST
                             withCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC
                          withSubCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION
                        withThirdCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_CRASH];
    }
    [self StartHandlePostEvent];
}

-(void)OnPostPoliceCheckEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserMode:NOM_USERMODE_POST
                             withCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC
                          withSubCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION
                        withThirdCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_POLICE];
    }
    [self StartHandlePostEvent];
}

-(void)OnPostConstructionEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserMode:NOM_USERMODE_POST
                             withCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC
                          withSubCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION
                        withThirdCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_CONSTRUCTION];
    }
    [self StartHandlePostEvent];
}

-(void)OnPostRoadClosureEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserMode:NOM_USERMODE_POST
                             withCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC
                          withSubCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION
                        withThirdCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_ROADCLOSURE];
    }
    [self StartHandlePostEvent];
}

-(void)OnPostBrokenSignalEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserMode:NOM_USERMODE_POST
                             withCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC
                          withSubCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION
                        withThirdCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_BROKENTRAFFICLIGHT];
    }
    [self StartHandlePostEvent];
}

-(void)OnPostStalledCarEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserMode:NOM_USERMODE_POST
                             withCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC
                          withSubCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION
                        withThirdCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_STALLEDCAR];
    }
    [self StartHandlePostEvent];
}

-(void)OnPostFoggyEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserMode:NOM_USERMODE_POST
                             withCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC
                          withSubCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION
                        withThirdCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_FOG];
    }
    [self StartHandlePostEvent];
}

-(void)OnPostDangerEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserMode:NOM_USERMODE_POST
                             withCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC
                          withSubCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION
                        withThirdCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_DANGEROUSCONDITION];
    }
    [self StartHandlePostEvent];
}

-(void)OnPostRainEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserMode:NOM_USERMODE_POST
                             withCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC
                          withSubCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION
                        withThirdCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_RAIN];
    }
    [self StartHandlePostEvent];
}

-(void)OnPostIcyEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserMode:NOM_USERMODE_POST
                             withCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC
                          withSubCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION
                        withThirdCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_ICE];
    }
    [self StartHandlePostEvent];
}

-(void)OnPostWindEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserMode:NOM_USERMODE_POST
                             withCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC
                          withSubCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION
                        withThirdCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_WIND];
    }
    [self StartHandlePostEvent];
}

-(void)OnPostLaneCloseEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserMode:NOM_USERMODE_POST
                             withCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC
                          withSubCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION
                        withThirdCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_LANECLOSURE];
    }
    [self StartHandlePostEvent];
}

-(void)OnPostRampCloseEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserMode:NOM_USERMODE_POST
                             withCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC
                          withSubCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION
                        withThirdCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_SLIPROADCLOSURE];
    }
    [self StartHandlePostEvent];
}

-(void)OnPostDetourEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserMode:NOM_USERMODE_POST
                             withCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC
                          withSubCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION
                        withThirdCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_DETOUR];
    }
    [self StartHandlePostEvent];
}

-(void)OnPostRedLightCameraEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserModeSpotAction:NOM_USERMODE_MARKTRAFFICSPOT withSpotType:NOM_TRAFFICSPOT_PHOTORADAR withSpotDS:NOM_PHOTORADAR_TYPE_REDLIGHTCAMERA];
    }
    [self StartHandlePostEvent];
}

-(void)OnPostSpeedCameraEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserModeSpotAction:NOM_USERMODE_MARKTRAFFICSPOT withSpotType:NOM_TRAFFICSPOT_PHOTORADAR withSpotDS:NOM_PHOTORADAR_TYPE_SPEEDCAMERA];
    }
    [self StartHandlePostEvent];
}

-(void)OnPostSchoolZoneEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserModeSpotAction:NOM_USERMODE_MARKTRAFFICSPOT withSpotType:NOM_TRAFFICSPOT_SCHOOLZONE withSpotDS:0];
    }
    [self StartHandlePostEvent];
}

-(void)OnPostPlayGroundEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserModeSpotAction:NOM_USERMODE_MARKTRAFFICSPOT withSpotType:NOM_TRAFFICSPOT_PLAYGROUND withSpotDS:0];
    }
    [self StartHandlePostEvent];
}

-(void)OnPostParkingEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserModeSpotAction:NOM_USERMODE_MARKTRAFFICSPOT withSpotType:NOM_TRAFFICSPOT_PARKINGGROUND withSpotDS:0];
    }
    [self StartHandlePostEvent];
}

-(void)OnPostGasStationEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserModeSpotAction:NOM_USERMODE_MARKTRAFFICSPOT withSpotType:NOM_TRAFFICSPOT_GASSTATION withSpotDS:0];
    }
    [self StartHandlePostEvent];
}

-(void)OnPostPublicTransitDelayEvent
{
    [self OnCloseToolbarView];
//    if(m_DocumentController != nil)
//    {
//        [m_DocumentController SetUserMode:NOM_USERMODE_POST
//                             withCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC
//                          withSubCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT
//                        withThirdCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_DELAY];
//    }
    [self StartHandlePostEvent];
}


-(void)OnPostPublicTransitBusDelayEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserMode:NOM_USERMODE_POST
                             withCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC
                          withSubCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT
                        withThirdCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_BUS_DELAY];
    }
    [self StartHandlePostEvent];
}

-(void)OnPostPublicTransitTrainDelayEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserMode:NOM_USERMODE_POST
                             withCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC
                          withSubCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT
                        withThirdCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_TRAIN_DELAY];
    }
    [self StartHandlePostEvent];
}

-(void)OnPostPublicTransitFlightDelayEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserMode:NOM_USERMODE_POST
                             withCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC
                          withSubCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT
                        withThirdCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_FLIGHT_DELAY];
    }
    [self StartHandlePostEvent];
}

-(void)OnPostPassengerCrowdedEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserMode:NOM_USERMODE_POST
                             withCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC
                          withSubCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT
                        withThirdCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_PASSENGERSTUCK];
    }
    [self StartHandlePostEvent];
}

-(void)OnPostTaxiAvailableByDriverEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserMode:NOM_USERMODE_POST
                             withCategory:NOM_NEWSCATEGORY_TAXI
                          withSubCategory:NOM_NEWSCATEGORY_TAXI_SUBCATEGORY_TAXIAVAILABLEBYDRIVER
                        withThirdCategory:-1];
    }
    [self StartHandlePostEvent];
}

-(void)OnPostTaxiRequestByPassengerEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserMode:NOM_USERMODE_POST
                             withCategory:NOM_NEWSCATEGORY_TAXI
                          withSubCategory:NOM_NEWSCATEGORY_TAXI_SUBCATEGORY_TAXIREQUESTBYPASSENGER
                        withThirdCategory:-1];
    }
    [self StartHandlePostEvent];
}


-(void)InitializePostMenuEvent
{
    [GUIEventLoop RegisterEvent:GUIID_POSTMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_JAM_ID eventHandler:@selector(OnPostJamEvent) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_POSTMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_CRASH_ID eventHandler:@selector(OnPostCrashEvent) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_POSTMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_POLICE_ID eventHandler:@selector(OnPostPoliceCheckEvent) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_POSTMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_CONSTRUCTION_ID eventHandler:@selector(OnPostConstructionEvent) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_POSTMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_ROADCLOSURE_ID eventHandler:@selector(OnPostRoadClosureEvent) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_POSTMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_BROKENTRAFFICLIGHT_ID eventHandler:@selector(OnPostBrokenSignalEvent) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_POSTMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_STALLEDCAR_ID eventHandler:@selector(OnPostStalledCarEvent) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_POSTMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_FOG_ID eventHandler:@selector(OnPostFoggyEvent) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_POSTMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_DANGEROUSCONDITION_ID eventHandler:@selector(OnPostDangerEvent) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_POSTMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_RAIN_ID eventHandler:@selector(OnPostRainEvent) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_POSTMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_ICE_ID eventHandler:@selector(OnPostIcyEvent) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_POSTMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_WIND_ID eventHandler:@selector(OnPostWindEvent) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_POSTMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_LANECLOSURE_ID eventHandler:@selector(OnPostLaneCloseEvent) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_POSTMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_SLIPROADCLOSURE_ID eventHandler:@selector(OnPostRampCloseEvent) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_POSTMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_DETOUR_ID eventHandler:@selector(OnPostDetourEvent) eventReceiver:self eventSender:nil];
    
    
    [GUIEventLoop RegisterEvent:GUIID_POSTMENU_MARKSPOTMENU_TRAFFICSPOTMENU_PHOTORADARMENU_ITEM_REDLIGHTCAMERA_ID eventHandler:@selector(OnPostRedLightCameraEvent) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_POSTMENU_MARKSPOTMENU_TRAFFICSPOTMENU_PHOTORADARMENU_ITEM_SPEEDCAMERA_ID eventHandler:@selector(OnPostSpeedCameraEvent) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_POSTMENU_MARKSPOTMENU_TRAFFICSPOTMENU_ITEM_SCHOOLZONE_ID eventHandler:@selector(OnPostSchoolZoneEvent) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_POSTMENU_MARKSPOTMENU_TRAFFICSPOTMENU_ITEM_PLAYGROUND_ID eventHandler:@selector(OnPostPlayGroundEvent) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_POSTMENU_MARKSPOTMENU_TRAFFICSPOTMENU_ITEM_PARKINGGROUND_ID eventHandler:@selector(OnPostParkingEvent) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_POSTMENU_MARKSPOTMENU_TRAFFICSPOTMENU_ITEM_GASSTATION_ID eventHandler:@selector(OnPostGasStationEvent) eventReceiver:self eventSender:nil];
    
    
//    [GUIEventLoop RegisterEvent:GUIID_POSTMENU_TRAFFICMENU_PUBLICTRANSITMENU_ITEM_DELAY_ID eventHandler:@selector(OnPostPublicTransitDelayEvent) eventReceiver:self eventSender:nil];

    [GUIEventLoop RegisterEvent:GUIID_POSTMENU_TRAFFICMENU_PUBLICTRANSITMENU_ITEM_BUS_DELAY_ID eventHandler:@selector(OnPostPublicTransitBusDelayEvent) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_POSTMENU_TRAFFICMENU_PUBLICTRANSITMENU_ITEM_TRAIN_DELAY_ID eventHandler:@selector(OnPostPublicTransitTrainDelayEvent) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_POSTMENU_TRAFFICMENU_PUBLICTRANSITMENU_ITEM_FLIGHT_DELAY_ID eventHandler:@selector(OnPostPublicTransitFlightDelayEvent) eventReceiver:self eventSender:nil];
    
    [GUIEventLoop RegisterEvent:GUIID_POSTMENU_TRAFFICMENU_PUBLICTRANSITMENU_ITEM_PASSENGERSTUCK_ID eventHandler:@selector(OnPostPassengerCrowdedEvent) eventReceiver:self eventSender:nil];
 
    //
    //Post taxi and passenger information
    //
    [GUIEventLoop RegisterEvent:GUIID_POSTMENU_TAXISHAREMENU_TAXISHAREMENU_ITEM_DRIVER_ID eventHandler:@selector(OnPostTaxiAvailableByDriverEvent) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_POSTMENU_TAXISHAREMENU_TAXISHAREMENU_ITEM_PASSENGER_ID eventHandler:@selector(OnPostTaxiRequestByPassengerEvent) eventReceiver:self eventSender:nil];
    
}

-(void)OnSearchJamEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserMode:NOM_USERMODE_QUERY
                             withCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC
                          withSubCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION
                        withThirdCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_JAM];
    }
    [self StartHandleSearchEvent];
}

-(void)OnSearchCrashEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserMode:NOM_USERMODE_QUERY
                             withCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC
                          withSubCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION
                        withThirdCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_CRASH];
    }
    [self StartHandleSearchEvent];
}

-(void)OnSearchPoliceCheckEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserMode:NOM_USERMODE_QUERY
                             withCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC
                          withSubCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION
                        withThirdCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_POLICE];
    }
    [self StartHandleSearchEvent];
}

-(void)OnSearchConstructionEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserMode:NOM_USERMODE_QUERY
                             withCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC
                          withSubCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION
                        withThirdCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_CONSTRUCTION];
    }
    [self StartHandleSearchEvent];
}

-(void)OnSearchRoadClosureEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserMode:NOM_USERMODE_QUERY
                             withCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC
                          withSubCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION
                        withThirdCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_ROADCLOSURE];
    }
    [self StartHandleSearchEvent];
}

-(void)OnSearchBrokenSignalEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserMode:NOM_USERMODE_QUERY
                             withCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC
                          withSubCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION
                        withThirdCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_BROKENTRAFFICLIGHT];
    }
    [self StartHandleSearchEvent];
}

-(void)OnSearchStalledCarEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserMode:NOM_USERMODE_QUERY
                             withCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC
                          withSubCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION
                        withThirdCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_STALLEDCAR];
    }
    [self StartHandleSearchEvent];
}

-(void)OnSearchFoggyEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserMode:NOM_USERMODE_QUERY
                             withCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC
                          withSubCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION
                        withThirdCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_FOG];
    }
    [self StartHandleSearchEvent];
}

-(void)OnSearchDangerEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserMode:NOM_USERMODE_QUERY
                             withCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC
                          withSubCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION
                        withThirdCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_DANGEROUSCONDITION];
    }
    [self StartHandleSearchEvent];
}

-(void)OnSearchRainEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserMode:NOM_USERMODE_QUERY
                             withCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC
                          withSubCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION
                        withThirdCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_RAIN];
    }
    [self StartHandleSearchEvent];
}

-(void)OnSearchIcyEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserMode:NOM_USERMODE_QUERY
                             withCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC
                          withSubCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION
                        withThirdCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_ICE];
    }
    [self StartHandleSearchEvent];
}

-(void)OnSearchWindEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserMode:NOM_USERMODE_QUERY
                             withCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC
                          withSubCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION
                        withThirdCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_WIND];
    }
    [self StartHandleSearchEvent];
}

-(void)OnSearchLaneCloseEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserMode:NOM_USERMODE_QUERY
                             withCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC
                          withSubCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION
                        withThirdCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_LANECLOSURE];
    }
    [self StartHandleSearchEvent];
}

-(void)OnSearchRampCloseEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserMode:NOM_USERMODE_QUERY
                             withCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC
                          withSubCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION
                        withThirdCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_SLIPROADCLOSURE];
    }
    [self StartHandleSearchEvent];
}

-(void)OnSearchDetourEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserMode:NOM_USERMODE_QUERY
                             withCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC
                          withSubCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION
                        withThirdCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_DETOUR];
    }
    [self StartHandleSearchEvent];
}

-(void)OnSearchAllDrivingEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserMode:NOM_USERMODE_QUERY
                             withCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC
                          withSubCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION
                        withThirdCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_DRIVINGCONDITION_ALL];
    }
    [self StartHandleSearchEvent];
}

-(void)OnSearchPublicTransitDelayEvent
{
    [self OnCloseToolbarView];
//    if(m_DocumentController != nil)
//    {
//        [m_DocumentController SetUserMode:NOM_USERMODE_QUERY
//                             withCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC
//                          withSubCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT
//                        withThirdCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_DELAY];
//    }
    [self StartHandleSearchEvent];
}

-(void)OnSearchPassengerCrowdedEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserMode:NOM_USERMODE_QUERY
                             withCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC
                          withSubCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT
                        withThirdCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_PASSENGERSTUCK];
    }
    [self StartHandleSearchEvent];
}

-(void)OnSearchAllPublicTransitEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserMode:NOM_USERMODE_QUERY
                             withCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC
                          withSubCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT
                        withThirdCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_PUBLICTRANSIT_ALL];
    }
    [self StartHandleSearchEvent];
}

-(void)OnSearchAllTrafficEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserMode:NOM_USERMODE_QUERY
                             withCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC
                          withSubCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_ALL
                        withThirdCategory:-1];
    }
    [self StartHandleSearchEvent];
}

-(void)OnSearchRedLightCameraEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserModeSpotAction:NOM_USERMODE_QUERYTRAFFICSPOT withSpotType:NOM_TRAFFICSPOT_PHOTORADAR withSpotDS:NOM_PHOTORADAR_TYPE_REDLIGHTCAMERA];
    }
    [self StartHandleSearchEvent];
}

-(void)OnSearchSpeedCameraEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserModeSpotAction:NOM_USERMODE_QUERYTRAFFICSPOT withSpotType:NOM_TRAFFICSPOT_PHOTORADAR withSpotDS:NOM_PHOTORADAR_TYPE_SPEEDCAMERA];
    }
    [self StartHandleSearchEvent];
}

-(void)OnSearchAllPhotoRadarEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserModeSpotAction:NOM_USERMODE_QUERYTRAFFICSPOT withSpotType:NOM_TRAFFICSPOT_PHOTORADAR withSpotDS:-1];
    }
    [self StartHandleSearchEvent];
}

-(void)OnSearchSchoolZoneEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserModeSpotAction:NOM_USERMODE_QUERYTRAFFICSPOT withSpotType:NOM_TRAFFICSPOT_SCHOOLZONE withSpotDS:0];
    }
    [self StartHandleSearchEvent];
}

-(void)OnSearchPlayGroundEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserModeSpotAction:NOM_USERMODE_QUERYTRAFFICSPOT withSpotType:NOM_TRAFFICSPOT_PLAYGROUND withSpotDS:0];
    }
    [self StartHandleSearchEvent];
}

-(void)OnSearchAllSpeedLimitEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserModeSpotAction:NOM_USERMODE_QUERYTRAFFICSPOT withSpotType:NOM_TRAFFICSPOT_ALL_SPEEDLIMIT withSpotDS:0];
    }
    [self StartHandleSearchEvent];
}

-(void)OnSearchParkingEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserModeSpotAction:NOM_USERMODE_QUERYTRAFFICSPOT withSpotType:NOM_TRAFFICSPOT_PARKINGGROUND withSpotDS:0];
    }
    [self StartHandleSearchEvent];
}

-(void)OnSearchGasStationEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserModeSpotAction:NOM_USERMODE_QUERYTRAFFICSPOT withSpotType:NOM_TRAFFICSPOT_GASSTATION withSpotDS:0];
    }
    [self StartHandleSearchEvent];
}

-(void)OnSearchAllTrafficSpotEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserModeSpotAction:NOM_USERMODE_QUERYTRAFFICSPOT withSpotType:-1 withSpotDS:0];
    }
    [self StartHandleSearchEvent];
}

-(void)OnSearchAvailableTaxiTEvent
{
    [self OnCloseToolbarView];
//    if(m_DocumentController != nil)
//    {
//        [m_DocumentController SetUserMode:NOM_USERMODE_QUERY
//                             withCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC
//                          withSubCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_ALL
//                        withThirdCategory:-1];
//    }
//    [self StartHandleSearchEvent];
}

-(void)OnSearchTaxiPassengerEvent
{
    [self OnCloseToolbarView];
//    if(m_DocumentController != nil)
//    {
//        [m_DocumentController SetUserMode:NOM_USERMODE_QUERY
//                             withCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC
//                          withSubCategory:NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_ALL
//                        withThirdCategory:-1];
//    }
//    [self StartHandleSearchEvent];
}

-(void)OnSearchAllTaxiInformationEvent
{
    [self OnCloseToolbarView];
    if(m_DocumentController != nil)
    {
        [m_DocumentController SetUserMode:NOM_USERMODE_QUERY
                             withCategory:NOM_NEWSCATEGORY_TAXI
                          withSubCategory:NOM_NEWSCATEGORY_TAXI_SUBCATEGORY_ALL
                        withThirdCategory:-1];
    }
    [self StartHandleSearchEvent];
}

-(void)InitializeSearchMenuEvent
{
    if([NOMAppInfo IsSimpleSearchMode] == NO)
    {
        [GUIEventLoop RegisterEvent:GUIID_SEARCHMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_JAM_ID eventHandler:@selector(OnSearchJamEvent) eventReceiver:self eventSender:nil];
        [GUIEventLoop RegisterEvent:GUIID_SEARCHMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_CRASH_ID eventHandler:@selector(OnSearchCrashEvent) eventReceiver:self eventSender:nil];
        [GUIEventLoop RegisterEvent:GUIID_SEARCHMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_POLICE_ID eventHandler:@selector(OnSearchPoliceCheckEvent) eventReceiver:self eventSender:nil];
        [GUIEventLoop RegisterEvent:GUIID_SEARCHMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_CONSTRUCTION_ID eventHandler:@selector(OnSearchConstructionEvent) eventReceiver:self eventSender:nil];
        [GUIEventLoop RegisterEvent:GUIID_SEARCHMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_ROADCLOSURE_ID eventHandler:@selector(OnSearchRoadClosureEvent) eventReceiver:self eventSender:nil];
        [GUIEventLoop RegisterEvent:GUIID_SEARCHMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_BROKENTRAFFICLIGHT_ID eventHandler:@selector(OnSearchBrokenSignalEvent) eventReceiver:self eventSender:nil];
        [GUIEventLoop RegisterEvent:GUIID_SEARCHMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_STALLEDCAR_ID eventHandler:@selector(OnSearchStalledCarEvent) eventReceiver:self eventSender:nil];
        [GUIEventLoop RegisterEvent:GUIID_SEARCHMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_FOG_ID eventHandler:@selector(OnSearchFoggyEvent) eventReceiver:self eventSender:nil];
        [GUIEventLoop RegisterEvent:GUIID_SEARCHMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_DANGEROUSCONDITION_ID eventHandler:@selector(OnSearchDangerEvent) eventReceiver:self eventSender:nil];
        [GUIEventLoop RegisterEvent:GUIID_SEARCHMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_RAIN_ID eventHandler:@selector(OnSearchRainEvent) eventReceiver:self eventSender:nil];
        [GUIEventLoop RegisterEvent:GUIID_SEARCHMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_ICE_ID eventHandler:@selector(OnSearchIcyEvent) eventReceiver:self eventSender:nil];
        [GUIEventLoop RegisterEvent:GUIID_SEARCHMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_WIND_ID eventHandler:@selector(OnSearchWindEvent) eventReceiver:self eventSender:nil];
        [GUIEventLoop RegisterEvent:GUIID_SEARCHMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_LANECLOSURE_ID eventHandler:@selector(OnSearchLaneCloseEvent) eventReceiver:self eventSender:nil];
        [GUIEventLoop RegisterEvent:GUIID_SEARCHMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_SLIPROADCLOSURE_ID eventHandler:@selector(OnSearchRampCloseEvent) eventReceiver:self eventSender:nil];
        [GUIEventLoop RegisterEvent:GUIID_SEARCHMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_DETOUR_ID eventHandler:@selector(OnSearchDetourEvent) eventReceiver:self eventSender:nil];
        [GUIEventLoop RegisterEvent:GUIID_SEARCHMENU_TRAFFICMENU_DRIVINGCONDITIONMENU_ITEM_ALL_ID eventHandler:@selector(OnSearchAllDrivingEvent) eventReceiver:self eventSender:nil];


        [GUIEventLoop RegisterEvent:GUIID_SEARCHMENU_TRAFFICMENU_PUBLICTRANSITMENU_ITEM_DELAY_ID eventHandler:@selector(OnSearchPublicTransitDelayEvent) eventReceiver:self eventSender:nil];
        [GUIEventLoop RegisterEvent:GUIID_SEARCHMENU_TRAFFICMENU_PUBLICTRANSITMENU_ITEM_PASSENGERSTUCK_ID eventHandler:@selector(OnSearchPassengerCrowdedEvent) eventReceiver:self eventSender:nil];
        [GUIEventLoop RegisterEvent:GUIID_SEARCHMENU_TRAFFICMENU_PUBLICTRANSITMENU_ITEM_ALL_ID eventHandler:@selector(OnSearchAllPublicTransitEvent) eventReceiver:self eventSender:nil];
    
        [GUIEventLoop RegisterEvent:GUIID_SEARCHMENU_TRAFFICMENU_ITEM_ALL_ID eventHandler:@selector(OnSearchAllTrafficEvent) eventReceiver:self eventSender:nil];
        
        //
        //Taxi related event handler
        //
        [GUIEventLoop RegisterEvent:GUIID_SEARCHMENU_TAXISHAREMENU_TAXISHAREMENU_ITEM_DRIVER_ID eventHandler:@selector(OnSearchAvailableTaxiTEvent) eventReceiver:self eventSender:nil];
        [GUIEventLoop RegisterEvent:GUIID_SEARCHMENU_TAXISHAREMENU_TAXISHAREMENU_ITEM_PASSENGER_ID eventHandler:@selector(OnSearchTaxiPassengerEvent) eventReceiver:self eventSender:nil];
        [GUIEventLoop RegisterEvent:GUIID_SEARCHMENU_TAXISHAREMENU_TAXISHAREMENU_ITEM_ALL_ID eventHandler:@selector(OnSearchAllTaxiInformationEvent) eventReceiver:self eventSender:nil];
    }
    else
    {
        [GUIEventLoop RegisterEvent:GUIID_SEARCHMENU_ITEM_TRAFFIC_ID eventHandler:@selector(OnSearchAllTrafficEvent) eventReceiver:self eventSender:nil];

        //
        //Taxi related event handler
        //
        [GUIEventLoop RegisterEvent:GUIID_SEARCHMENU_ITEM_TAXISHARING_ID eventHandler:@selector(OnSearchAllTaxiInformationEvent) eventReceiver:self eventSender:nil];
    }
    

    [GUIEventLoop RegisterEvent:GUIID_SETTINGMENU_SHOWSPOTMENU_TRAFFICSPOTMENU_SPEEDLIMITMENU_PHOTORADARMENU_ITEM_REDLIGHTCAMERA_ID eventHandler:@selector(OnSearchRedLightCameraEvent) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_SETTINGMENU_SHOWSPOTMENU_TRAFFICSPOTMENU_SPEEDLIMITMENU_PHOTORADARMENU_ITEM_SPEEDCAMERA_ID eventHandler:@selector(OnSearchSpeedCameraEvent) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_SETTINGMENU_SHOWSPOTMENU_TRAFFICSPOTMENU_SPEEDLIMITMENU_PHOTORADARMENU_ITEM_ALL_ID eventHandler:@selector(OnSearchAllPhotoRadarEvent) eventReceiver:self eventSender:nil];
    
    
    [GUIEventLoop RegisterEvent:GUIID_SETTINGMENU_SHOWSPOTMENU_TRAFFICSPOTMENU_SPEEDLIMITMENU_ITEM_PHOTORADAR_ID eventHandler:@selector(OnSearchAllPhotoRadarEvent) eventReceiver:self eventSender:nil];
    

    [GUIEventLoop RegisterEvent:GUIID_SETTINGMENU_SHOWSPOTMENU_TRAFFICSPOTMENU_SPEEDLIMITMENU_ITEM_SCHOOLZONE_ID eventHandler:@selector(OnSearchSchoolZoneEvent) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_SETTINGMENU_SHOWSPOTMENU_TRAFFICSPOTMENU_SPEEDLIMITMENU_ITEM_PLAYGROUND_ID eventHandler:@selector(OnSearchPlayGroundEvent) eventReceiver:self eventSender:nil];
    
    [GUIEventLoop RegisterEvent:GUIID_SETTINGMENU_SHOWSPOTMENU_TRAFFICSPOTMENU_SPEEDLIMITMENU_ITEM_ALL_ID eventHandler:@selector(OnSearchAllSpeedLimitEvent) eventReceiver:self eventSender:nil];
    
    
    [GUIEventLoop RegisterEvent:GUIID_SETTINGMENU_SHOWSPOTMENU_TRAFFICSPOTMENU_ITEM_PARKINGGROUND_ID eventHandler:@selector(OnSearchParkingEvent) eventReceiver:self eventSender:nil];
    [GUIEventLoop RegisterEvent:GUIID_SETTINGMENU_SHOWSPOTMENU_TRAFFICSPOTMENU_ITEM_GASSTATION_ID eventHandler:@selector(OnSearchGasStationEvent) eventReceiver:self eventSender:nil];

    [GUIEventLoop RegisterEvent:GUIID_SETTINGMENU_SHOWSPOTMENU_TRAFFICSPOTMENU_ITEM_ALL_ID eventHandler:@selector(OnSearchAllTrafficSpotEvent) eventReceiver:self eventSender:nil];
    
    [GUIEventLoop RegisterEvent:GUIID_UI_STARTSEARCH_EVENT eventHandler:@selector(AsyncHandleSearchEvent) eventReceiver:self eventSender:nil];
    
}

-(void)InitializeMenuEvent
{
    [self InitializeSettingMenuEvent];
    [self InitializePostMenuEvent];
    [self InitializeSearchMenuEvent];
}

-(void)OpenTermOfUseView:(BOOL)bAccept
{
    [m_TermAcceptView SetDocumentController:m_DocumentController];
    [m_TermAcceptView OpenTermOfUseView:YES AcceptOption:bAccept];
}

-(void)OnMenuEvent:(int)nMenuID
{
    //[m_MenuController CloseAllMenus];
    [self OnCloseToolbarView];
    if(nMenuID == GUIID_SETTINGMENU_ITEM_OPENPRIVACYVIEW_ID)
    {
        [m_TermAcceptView OpenPrivacyView:YES];
    }
    else if(nMenuID == GUIID_SETTINGMENU_ITEM_OPENTERMSOFUSEVIEW_ID)
    {
        BOOL bAccepted = [NOMAppInfo GetTermOfUse];
        
        [m_TermAcceptView OpenTermOfUseView:YES AcceptOption:bAccepted];
    }
}

-(void)HandlePlanCompleted:(NSString*)kml
{
    NSLog(@"KML:%@", kml);
    
    [m_MapView HandleGneralKML:kml];
}

-(void)MakeAppLocationOnMap
{
    [m_MapView MakeAppLocationOnMap];
}

-(void)AddressFindingViewClosed:(BOOL)bOK
{
    if(bOK == YES)
    {
        CLLocationCoordinate2D location = [m_AddressFindingView GetSelectedCoordinate];
        NSString*   szStreet = [m_AddressFindingView GetStreetAddress];
        NSString*   szCity = [m_AddressFindingView GetCity];
        NSString*   szState = [m_AddressFindingView GetState];
        NSString*   szZipCode = [m_AddressFindingView GetZipCode];
        NSString*   szCountry = [m_AddressFindingView GetCountry];
        NSString*   szCountryKey = [m_AddressFindingView GetCountryKey];
        [m_DocumentController SetUserModeCachedAddress:szStreet city:szCity state:szState zipCode:szZipCode country:szCountry countryKey:szCountryKey];
        [m_DocumentController ShowPostPinAnnotation:location];
    }
    else
    {
        [m_DocumentController ResetUserStatus];
    }
}

//
//INOMCustomListCalloutDelegate methods
//
-(void)OpenListCallout:(id<INOMCustomListCalloutCaller>)caller
{
    [m_CustomNewsCallout RemoveAllPinItems];
    if(caller != nil)
    {
        if([caller PrepareCalloutList:self] == YES)
        {
            [m_CustomNewsCallout UpdateLayout];
            CGPoint showPt = [caller GetViewPointFromCurrentLocation];
            [m_CustomNewsCallout SetCurrentLocation:[caller GetCurrentLocation]];
            [self ShowNewsCalloutAt:showPt withAnimation:YES];
        }
    }
}

-(void)AddCalloutItem:(id<INOMCustomListCalloutItem>)calloutItem
{
    if(calloutItem != nil && [calloutItem isKindOfClass:[CustomMapViewPinItem class]] == YES)
    {
        [m_CustomNewsCallout AddPinItem:(CustomMapViewPinItem*)calloutItem];
    }
}

-(id<INOMCustomListCalloutDelegate>)GetCalloutDelegate
{
    return self;
}

+(Class)GetClass
{
    return [NOMMainView class];
}

-(id<INOMCustomListCalloutItem>)CreateCustomeCalloutItem
{
    float w = [CustomMapViewPinCallout GetCalloutItemWidth];
    float h = [CustomMapViewPinCallout GetCalloutItemHeight];
    CGRect rect = CGRectMake(0, 0, w, h);
    CustomMapViewPinItem* item = [[CustomMapViewPinItem alloc] initWithFrame:rect];
    [item AttachDelegate:[m_DocumentController GetCustomMapViewPinItemDelegate]];
    
    return item;
}


-(CGPoint)ConvertLocationToViewPoint:(CLLocationCoordinate2D)location
{
    CGPoint pt = CGPointMake(0, 0);
    
    pt = [m_MapView GetPointFromMapLocation:location];
    
    return pt;
}

//
//IMainViewDelegate functions for nolocation social news Data
//
-(void)AddNoLocationSocialNewsData:(id)newsData
{
    if(m_PopupToolbarButtonController != nil)
        [m_PopupToolbarButtonController AddNoneLocationTweetData:newsData];
}

-(void)RemoveAllNoLocationSocialNewsData
{
    [self CloseCallout];
    if(m_PopupToolbarButtonController != nil)
        [m_PopupToolbarButtonController CleanNoneLocationTweetList];
}

-(void)OpenTwitterAccountSetting
{
    [self OnCloseToolbarView];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://user?screen_name=   9QAX7"]];
}


@end
