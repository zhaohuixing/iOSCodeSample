//
//  NOMGEOPlanPanel.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-03-26.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMGEOPlanPanel.h"
#import "NOMGUILayout.h"
#import "NOMGEOPlanPanelBar.h"
#import "NOMGEOPlanView.h"
#import "AutoLayoutButton.h"
#import "NOMAppInfo.h"
#import "TriStateButton.h"
#import "DrawHelper2.h"

@interface NOMGEOPlanPanel()
{
    CGGradientRef           m_RendingGradient;
    CGColorSpaceRef         m_RendingColorspace;

    NOMGEOPlanPanelBar*     m_MainControlBar;
    AutoLayoutButton*       m_MainCloseButton;

    
    NOMGEOPlanPanelBar*     m_OperationControlBar;
    
    TriStateButton*         m_MapButton;
    AutoLayoutButton*       m_OperationCloseButton;
    AutoLayoutButton*       m_OperationDoneButton;
    AutoLayoutButton*       m_OperationUndoButton;
    //AutoLayoutButton*       m_OperationSyncButton;
}

-(void)InitializeMainBar;
-(void)InitializeOperationBar;
-(void)OnCloseButtonClick;
-(void)OpenReminderBar;
-(void)CloseReminderBar;

@end


@implementation NOMGEOPlanPanel

+(CGFloat)GetBarButtonSize:(BOOL)bProtrait
{
    if([NOMAppInfo IsDeviceIPad] == YES)
    {
        if(bProtrait == YES)
            return 60;
        else
            return 68;
    }
    else
    {
        if(bProtrait == YES)
            return 40;
        else
            return 40;
    }
}

+(CGFloat)GetSmallDemensionSize
{
    CGFloat w = [NOMGUILayout GetLayoutWidth];
    CGFloat h = [NOMGUILayout GetLayoutHeight];
    
    CGFloat fRet = h < w ? h : w;
    
    return fRet;
}

+(CGRect)GetBarLastOneButtonProtraitRect
{
    CGFloat w = [NOMGEOPlanPanel GetSmallDemensionSize];
    CGFloat h = [NOMGEOPlanView GetControlPanelSize:YES];
    
    CGFloat size = [NOMGEOPlanPanel GetBarButtonSize:YES];
    
    CGFloat sy = (h - size)*0.5;
    CGFloat sx = (w - (size + sy));

    CGRect rect = CGRectMake(sx, sy, size, size);
    
    return rect;
}

+(CGRect)GetBarLastOneButtonLandscapeRect
{
    CGFloat h = [NOMGEOPlanPanel GetSmallDemensionSize];
    if([NOMAppInfo ShowAdBanner] == YES)
        h = h - [NOMGUILayout GetAdBannerHeight:NO];
    
    CGFloat w = [NOMGEOPlanView GetControlPanelSize:NO];
    
    CGFloat size = [NOMGEOPlanPanel GetBarButtonSize:NO];
    
    CGFloat sx = (w - size)*0.5;
    CGFloat sy = (h - (size + sx));
    
    CGRect rect = CGRectMake(sx, sy, size, size);
    
    return rect;
}

+(CGRect)GetBarLastTwoButtonProtraitRect
{
    CGFloat w = [NOMGEOPlanPanel GetSmallDemensionSize];
    CGFloat h = [NOMGEOPlanView GetControlPanelSize:YES];
    
    CGFloat size = [NOMGEOPlanPanel GetBarButtonSize:YES];
    
    CGFloat sy = (h - size)*0.5;
    CGFloat sx = (w - (size + sy)*2.0);
    
    CGRect rect = CGRectMake(sx, sy, size, size);
    
    return rect;
}

+(CGRect)GetBarLastTwoButtonLandscapeRect
{
    CGFloat h = [NOMGEOPlanPanel GetSmallDemensionSize];
    if([NOMAppInfo ShowAdBanner] == YES)
        h = h - [NOMGUILayout GetAdBannerHeight:NO];
    
    CGFloat w = [NOMGEOPlanView GetControlPanelSize:NO];
    
    CGFloat size = [NOMGEOPlanPanel GetBarButtonSize:NO];
    
    CGFloat sx = (w - size)*0.5;
    CGFloat sy = (h - (size + sx)*2.0);
    
    CGRect rect = CGRectMake(sx, sy, size, size);
    
    return rect;
}


+(CGRect)GetBarFirstButtonProtraitRect
{
    CGFloat h = [NOMGEOPlanView GetControlPanelSize:YES];
    
    CGFloat size = [NOMGEOPlanPanel GetBarButtonSize:YES];
    
    CGFloat sy = (h - size)*0.5;
    CGFloat sx = sy;
    
    CGRect rect = CGRectMake(sx, sy, size, size);
    
    return rect;
}

+(CGRect)GetBarFirstButtonLandscapeRect
{
    CGFloat h = [NOMGEOPlanPanel GetSmallDemensionSize];
    if([NOMAppInfo ShowAdBanner] == YES)
        h = h - [NOMGUILayout GetAdBannerHeight:NO];
    
    CGFloat w = [NOMGEOPlanView GetControlPanelSize:NO];
    
    CGFloat size = [NOMGEOPlanPanel GetBarButtonSize:NO];
    
    CGFloat sx = (w - size)*0.5;
    CGFloat sy = sx;
    
    CGRect rect = CGRectMake(sx, sy, size, size);
    
    return rect;
}


+(CGRect)GetBarSecondButtonProtraitRect
{
    CGFloat h = [NOMGEOPlanView GetControlPanelSize:YES];
    
    CGFloat size = [NOMGEOPlanPanel GetBarButtonSize:YES];
    
    CGFloat sy = (h - size)*0.5;
    CGFloat sx = sy + (sy + size);
    
    CGRect rect = CGRectMake(sx, sy, size, size);
    
    return rect;
}

+(CGRect)GetBarSecondButtonLandscapeRect
{
    CGFloat h = [NOMGEOPlanPanel GetSmallDemensionSize];
    if([NOMAppInfo ShowAdBanner] == YES)
        h = h - [NOMGUILayout GetAdBannerHeight:NO];
    
    CGFloat w = [NOMGEOPlanView GetControlPanelSize:NO];
    
    CGFloat size = [NOMGEOPlanPanel GetBarButtonSize:NO];
    
    CGFloat sx = (w - size)*0.5;
    CGFloat sy = sx + (sx + size);
    
    CGRect rect = CGRectMake(sx, sy, size, size);
    
    return rect;
}

+(CGRect)GetBarThirdButtonProtraitRect
{
    CGFloat h = [NOMGEOPlanView GetControlPanelSize:YES];
    
    CGFloat size = [NOMGEOPlanPanel GetBarButtonSize:YES];
    
    CGFloat sy = (h - size)*0.5;
    CGFloat sx = sy + (sy + size)*2;
    
    CGRect rect = CGRectMake(sx, sy, size, size);
    
    return rect;
}

+(CGRect)GetBarThirdButtonLandscapeRect
{
    CGFloat h = [NOMGEOPlanPanel GetSmallDemensionSize];
    if([NOMAppInfo ShowAdBanner] == YES)
        h = h - [NOMGUILayout GetAdBannerHeight:NO];
    
    CGFloat w = [NOMGEOPlanView GetControlPanelSize:NO];
    
    CGFloat size = [NOMGEOPlanPanel GetBarButtonSize:NO];
    
    CGFloat sx = (w - size)*0.5;
    CGFloat sy = sx + (sx + size)*2;
    
    CGRect rect = CGRectMake(sx, sy, size, size);
    
    return rect;
}

+(CGRect)GetBarFourButtonProtraitRect
{
    CGFloat h = [NOMGEOPlanView GetControlPanelSize:YES];
    
    CGFloat size = [NOMGEOPlanPanel GetBarButtonSize:YES];
    
    CGFloat sy = (h - size)*0.5;
    CGFloat sx = sy + (sy + size)*3;
    
    CGRect rect = CGRectMake(sx, sy, size, size);
    
    return rect;
}

+(CGRect)GetBarFourButtonLandscapeRect
{
    CGFloat h = [NOMGEOPlanPanel GetSmallDemensionSize];
    if([NOMAppInfo ShowAdBanner] == YES)
        h = h - [NOMGUILayout GetAdBannerHeight:NO];
    
    CGFloat w = [NOMGEOPlanView GetControlPanelSize:NO];
    
    CGFloat size = [NOMGEOPlanPanel GetBarButtonSize:NO];
    
    CGFloat sx = (w - size)*0.5;
    CGFloat sy = sx + (sx + size)*3;
    
    CGRect rect = CGRectMake(sx, sy, size, size);
    
    return rect;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    return;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    return;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    return;
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    return;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        size_t num_locations = 2;
        CGFloat locations[3] = {0.0, 1.0};
        CGFloat colors[12] =
        {
            //0.7, 0.7, 0.7, 1.0,
            0.85, 0.85, 0.85, 1.0,
            0.5, 0.5, 0.5, 1.0,
        };
        
        m_RendingColorspace = CGColorSpaceCreateDeviceRGB();
        m_RendingGradient = CGGradientCreateWithColorComponents (m_RendingColorspace, colors, locations, num_locations);
        CGFloat w = frame.size.width;
        CGFloat h = frame.size.height;
        CGRect rect = CGRectMake(0, 0, w, h);
        
        m_MainControlBar = [[NOMGEOPlanPanelBar alloc] initWithFrame:rect];
        [self addSubview:m_MainControlBar];
        m_OperationControlBar = [[NOMGEOPlanPanelBar alloc] initWithFrame:rect];
        [self addSubview:m_OperationControlBar];
        [m_OperationControlBar Close];
        [m_MainControlBar Open];
        [self InitializeMainBar];
        [self InitializeOperationBar];
    }
    return self;
}

-(void)Reset
{
    [m_OperationControlBar Close];
    [m_MainControlBar Open];
    [m_MapButton SetState:0];
    [self UpdateUndoButton:NO];
    //[self UpdateSyncButton:NO];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint pt1, pt2;
    if([NOMGUILayout IsProtrait])
    {
        pt1.x = rect.origin.x;
        pt1.y = rect.origin.y;
        pt2.x = rect.origin.x;
        pt2.y = pt1.y+rect.size.height;
    }
    else
    {
        pt1.x = rect.origin.x;
        pt1.y = rect.origin.y;
        pt2.x = rect.origin.x+rect.size.width;
        pt2.y = pt1.y;
    }
    CGContextDrawLinearGradient (context, m_RendingGradient, pt1, pt2, 0);
}

-(void)UpdateLayout
{
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    CGRect rect = CGRectMake(0, 0, w, h);
    
    [m_MainControlBar setFrame:rect];
    [m_MainControlBar UpdateLayout];

    [m_OperationControlBar setFrame:rect];
    [m_OperationControlBar UpdateLayout];
    
    [self setNeedsDisplay];
}

-(void)OnCloseButtonClick
{
    [self CloseReminderBar];
    [m_OperationControlBar Close];
    [m_MainControlBar Open];
    [((NOMGEOPlanView*)(self.superview)) CloseView:YES];
}

-(void)OnCompleteButtonClick
{
    [self CloseReminderBar];
    [m_OperationControlBar Close];
    [m_MainControlBar Open];
    [((NOMGEOPlanView*)(self.superview)) OnPlanCompleted];
}

-(void)OnLineButtonClick
{
    [((NOMGEOPlanView*)(self.superview)) SetPlanEditMode:NOMGEOPLAN_EDITMODE_LINE];
    [self OpenReminderBar];
    [m_OperationControlBar Open];
    [m_MainControlBar Close];
}

-(void)OnRouteButtonClick
{
    [((NOMGEOPlanView*)(self.superview)) SetPlanEditMode:NOMGEOPLAN_EDITMODE_ROUTE];
    [self OpenReminderBar];
    [m_OperationControlBar Open];
    [m_MainControlBar Close];
}

-(void)OnPolyButtonClick
{
    [((NOMGEOPlanView*)(self.superview)) SetPlanEditMode:NOMGEOPLAN_EDITMODE_POLY];
    [self OpenReminderBar];
    [m_OperationControlBar Open];
    [m_MainControlBar Close];
}

-(void)OnRectButtonClick
{
    [((NOMGEOPlanView*)(self.superview)) SetPlanEditMode:NOMGEOPLAN_EDITMODE_RECT];
    [self OpenReminderBar];
    [m_OperationControlBar Open];
    [m_MainControlBar Close];
}

-(void)InitializeMainBar
{
    CGRect closeBtnRectP = [NOMGEOPlanPanel GetBarLastOneButtonProtraitRect];
    CGRect closeBtnRectL = [NOMGEOPlanPanel GetBarLastOneButtonLandscapeRect];
    m_MainCloseButton = [[AutoLayoutButton alloc] initWithFrame:closeBtnRectP];
    m_MainCloseButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_MainCloseButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [m_MainCloseButton setBackgroundImage:[UIImage imageNamed:@"redclose400.png"] forState:UIControlStateNormal];
    [m_MainCloseButton setBackgroundImage:[UIImage imageNamed:@"redclose400hi.png"] forState:UIControlStateHighlighted];
    [m_MainCloseButton addTarget:self action:@selector(OnCloseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [m_MainControlBar AddChild:m_MainCloseButton];
    [m_MainCloseButton SetProtraitLayout:closeBtnRectP];
    [m_MainCloseButton SetLandScapeLayout:closeBtnRectL];
    [m_MainCloseButton UpdateLayout:[NOMGUILayout IsProtrait]];


    CGRect lineBtnRectP = [NOMGEOPlanPanel GetBarFirstButtonProtraitRect];
    CGRect lineBtnRectL = [NOMGEOPlanPanel GetBarFirstButtonLandscapeRect];
    AutoLayoutButton* lineButton = [[AutoLayoutButton alloc] initWithFrame:lineBtnRectP];
    lineButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    lineButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [lineButton setBackgroundImage:[UIImage imageNamed:@"linebtn.png"] forState:UIControlStateNormal];
    [lineButton setBackgroundImage:[UIImage imageNamed:@"linebtnhi.png"] forState:UIControlStateHighlighted];
    [lineButton addTarget:self action:@selector(OnLineButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [m_MainControlBar AddChild:lineButton];
    [lineButton SetProtraitLayout:lineBtnRectP];
    [lineButton SetLandScapeLayout:lineBtnRectL];
    [lineButton UpdateLayout:[NOMGUILayout IsProtrait]];

    CGRect routeBtnRectP = [NOMGEOPlanPanel GetBarSecondButtonProtraitRect];
    CGRect routeBtnRectL = [NOMGEOPlanPanel GetBarSecondButtonLandscapeRect];
    AutoLayoutButton* routeButton = [[AutoLayoutButton alloc] initWithFrame:routeBtnRectP];
    routeButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    routeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [routeButton setBackgroundImage:[UIImage imageNamed:@"routebtn.png"] forState:UIControlStateNormal];
    [routeButton setBackgroundImage:[UIImage imageNamed:@"routebtnhi.png"] forState:UIControlStateHighlighted];
    [routeButton addTarget:self action:@selector(OnRouteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [m_MainControlBar AddChild:routeButton];
    [routeButton SetProtraitLayout:routeBtnRectP];
    [routeButton SetLandScapeLayout:routeBtnRectL];
    [routeButton UpdateLayout:[NOMGUILayout IsProtrait]];
    
    CGRect polyBtnRectP = [NOMGEOPlanPanel GetBarThirdButtonProtraitRect];
    CGRect polyBtnRectL = [NOMGEOPlanPanel GetBarThirdButtonLandscapeRect];
    AutoLayoutButton* polyButton = [[AutoLayoutButton alloc] initWithFrame:polyBtnRectP];
    polyButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    polyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [polyButton setBackgroundImage:[UIImage imageNamed:@"polybtn.png"] forState:UIControlStateNormal];
    [polyButton setBackgroundImage:[UIImage imageNamed:@"polybtnhi.png"] forState:UIControlStateHighlighted];
    [polyButton addTarget:self action:@selector(OnPolyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [m_MainControlBar AddChild:polyButton];
    [polyButton SetProtraitLayout:polyBtnRectP];
    [polyButton SetLandScapeLayout:polyBtnRectL];
    [polyButton UpdateLayout:[NOMGUILayout IsProtrait]];

    CGRect rectBtnRectP = [NOMGEOPlanPanel GetBarFourButtonProtraitRect];
    CGRect rectBtnRectL = [NOMGEOPlanPanel GetBarFourButtonLandscapeRect];
    AutoLayoutButton* rectButton = [[AutoLayoutButton alloc] initWithFrame:rectBtnRectP];
    rectButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    rectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [rectButton setBackgroundImage:[UIImage imageNamed:@"rectbtn.png"] forState:UIControlStateNormal];
    [rectButton setBackgroundImage:[UIImage imageNamed:@"rectbtnhi.png"] forState:UIControlStateHighlighted];
    [rectButton addTarget:self action:@selector(OnRectButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [m_MainControlBar AddChild:rectButton];
    [rectButton SetProtraitLayout:rectBtnRectP];
    [rectButton SetLandScapeLayout:rectBtnRectL];
    [rectButton UpdateLayout:[NOMGUILayout IsProtrait]];
}

-(void)OnMapTypeButtonClick
{
    [m_MapButton UpdateState];
    int nState = [m_MapButton GetState];
    if(nState == 0)
    {
        [((NOMGEOPlanView*)(self.superview)) SetMapTypeStandard];
    }
    else if(nState == 1)
    {
        [((NOMGEOPlanView*)(self.superview)) SetMapTypeHybrid];
    }
    else if(nState == 2)
    {
        [((NOMGEOPlanView*)(self.superview)) SetMapTypeSatellite];
    }
}

-(void)OnUndoButtonClick
{
    if(m_OperationUndoButton.hidden == YES)
        return;
    
    [((NOMGEOPlanView*)(self.superview)) Undo];
}

-(void)InitializeOperationBar
{
    CGRect mapBtnRectP = [NOMGEOPlanPanel GetBarFirstButtonProtraitRect];
    CGRect mapBtnRectL = [NOMGEOPlanPanel GetBarFirstButtonLandscapeRect];
    m_MapButton = [[TriStateButton alloc] initWithFrame:mapBtnRectP];
    m_MapButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_MapButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [m_MapButton SetImage:[DrawHelper2 CloneImage:[UIImage imageNamed:@"std200.png"].CGImage withFlip:YES]
                   Image2:[DrawHelper2 CloneImage:[UIImage imageNamed:@"hybird200.png"].CGImage withFlip:YES]
                   Image3:[DrawHelper2 CloneImage:[UIImage imageNamed:@"satellite200.png"].CGImage withFlip:YES]];
    [m_MapButton addTarget:self action:@selector(OnMapTypeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [m_OperationControlBar AddChild:m_MapButton];
    [m_MapButton SetProtraitLayout:mapBtnRectP];
    [m_MapButton SetLandScapeLayout:mapBtnRectL];
    [m_MapButton UpdateLayout:[NOMGUILayout IsProtrait]];
    
    
    CGRect closeBtnRectP = [NOMGEOPlanPanel GetBarLastTwoButtonProtraitRect];
    CGRect closeBtnRectL = [NOMGEOPlanPanel GetBarLastTwoButtonLandscapeRect];
    m_OperationCloseButton = [[AutoLayoutButton alloc] initWithFrame:closeBtnRectP];
    m_OperationCloseButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_OperationCloseButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [m_OperationCloseButton setBackgroundImage:[UIImage imageNamed:@"redclose400.png"] forState:UIControlStateNormal];
    [m_OperationCloseButton setBackgroundImage:[UIImage imageNamed:@"redclose400hi.png"] forState:UIControlStateHighlighted];

    [m_OperationCloseButton addTarget:self action:@selector(OnCloseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [m_OperationControlBar AddChild:m_OperationCloseButton];
    [m_OperationCloseButton SetProtraitLayout:closeBtnRectP];
    [m_OperationCloseButton SetLandScapeLayout:closeBtnRectL];
    [m_OperationCloseButton UpdateLayout:[NOMGUILayout IsProtrait]];

    CGRect doneBtnRectP = [NOMGEOPlanPanel GetBarLastOneButtonProtraitRect];
    CGRect doneBtnRectL = [NOMGEOPlanPanel GetBarLastOneButtonLandscapeRect];
    m_OperationDoneButton = [[AutoLayoutButton alloc] initWithFrame:doneBtnRectP];
    m_OperationDoneButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_OperationDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [m_OperationDoneButton setBackgroundImage:[UIImage imageNamed:@"donebtn.png"] forState:UIControlStateNormal];
    [m_OperationDoneButton setBackgroundImage:[UIImage imageNamed:@"donebtnhi.png"] forState:UIControlStateHighlighted];
    
    [m_OperationDoneButton addTarget:self action:@selector(OnCompleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [m_OperationControlBar AddChild:m_OperationDoneButton];
    [m_OperationDoneButton SetProtraitLayout:doneBtnRectP];
    [m_OperationDoneButton SetLandScapeLayout:doneBtnRectL];
    [m_OperationDoneButton UpdateLayout:[NOMGUILayout IsProtrait]];
    
    CGRect undoBtnRectP = [NOMGEOPlanPanel GetBarSecondButtonProtraitRect];
    CGRect undoBtnRectL = [NOMGEOPlanPanel GetBarSecondButtonLandscapeRect];
    m_OperationUndoButton = [[AutoLayoutButton alloc] initWithFrame:undoBtnRectP];
    m_OperationUndoButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_OperationUndoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [m_OperationUndoButton setBackgroundImage:[UIImage imageNamed:@"undobtn.png"] forState:UIControlStateNormal];
    [m_OperationUndoButton setBackgroundImage:[UIImage imageNamed:@"undobtnhi.png"] forState:UIControlStateHighlighted];
    [m_OperationUndoButton addTarget:self action:@selector(OnUndoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [m_OperationControlBar AddChild:m_OperationUndoButton];
    [m_OperationUndoButton SetProtraitLayout:undoBtnRectP];
    [m_OperationUndoButton SetLandScapeLayout:undoBtnRectL];
    [m_OperationUndoButton UpdateLayout:[NOMGUILayout IsProtrait]];
}


-(void)OpenReminderBar
{
    [((NOMGEOPlanView*)(self.superview)) OpenReminderBar];
}

-(void)CloseReminderBar
{
    [((NOMGEOPlanView*)(self.superview)) CloseReminderBar];
}

-(void)UpdateUndoButton:(BOOL)bShow
{
    m_OperationUndoButton.hidden = (!bShow);
}

@end
