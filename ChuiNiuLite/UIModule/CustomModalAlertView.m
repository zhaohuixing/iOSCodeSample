//
//  CustomModalAlertView.m
//  BubbleTile
//
//  Created by Zhaohui Xing on 12-02-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "CustomModalAlertView.h"
#import "ApplicationConfigure.h"
#import "GUILayout.h"
#import "DrawHelper2.h"
#include "drawhelper.h"

///////////////////////////////////////////////////////////////////////////////////////////
//
// CustomModalAlertDelegateClass
//
///////////////////////////////////////////////////////////////////////////////////////////
@interface CustomModalAlertDelegateClass : NSObject<CustomModalAlertDelegate>
{
    int                 m_nClickButtonID;
	CFRunLoopRef        m_CurrentLoop;
}
-(int)GetClickedButtonID;
-(void)SetClickedButtonID:(int)nButtonID;
@end

@implementation CustomModalAlertDelegateClass

-(id)initWithRunLoop:(CFRunLoopRef)runLoop 
{
    self = [super init];
    
    if(self)
    {
        m_CurrentLoop = runLoop;
        m_nClickButtonID = -1;
    }
    
    return self;
}

-(int)GetClickedButtonID
{
    return m_nClickButtonID;
}

-(void)SetClickedButtonID:(int)nButtonID
{
    m_nClickButtonID = nButtonID;
	CFRunLoopStop(m_CurrentLoop);
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
//
// CustomModalAlertBackgroundView
// This class object don't need manully release
//
///////////////////////////////////////////////////////////////////////////////////////////
@implementation CustomModalAlertBackgroundView

-(void)UpdateSubViewsOrientation
{
    float w = [GUILayout GetMainUIWidth];
    float h = [GUILayout GetMainUIHeight];
    CGRect rect = CGRectMake(0, 0, w, h);
    [self setFrame:rect];
    
    int nCount = [self.subviews count];
    for(int i = 0; i < nCount; ++i)
    {
        id pSubView = [self.subviews objectAtIndex:i];
        if(pSubView && [pSubView isKindOfClass:[CustomModalAlertView class]] && [pSubView respondsToSelector:@selector(UpdateSubViewsOrientation)])
        {
            [pSubView performSelector:@selector(UpdateSubViewsOrientation)];
        }
    }
}

@end


///////////////////////////////////////////////////////////////////////////////////////////
//
// CustomModalAlertView
// This class object don't need manully release
//
///////////////////////////////////////////////////////////////////////////////////////////
@implementation CustomModalAlertView

- (BOOL) isLandscape
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
	return (orientation == UIDeviceOrientationLandscapeLeft) || (orientation == UIDeviceOrientationLandscapeRight);
}



-(void)CalculateLayoutWithText
{
    float w =[GUILayout GetMainUIWidth];
    float h = [GUILayout GetContentViewHeight];
    float width, height;
    float fCharWidth = [GUILayout GetDefaultAlertLabelLineHeight];
    if(!m_Label || !m_Label.text || [m_Label.text length] == 0)
    {
        width = [GUILayout GetDefaultAlertWidth:NO];
        height = [GUILayout GetDefaultAlertButtonHeight] + 4.0*[GUILayout GetDefaultAlertUIEdge];
        CGRect rt = CGRectMake((w-width)*0.5, (h-height)*0.5, width, height);
        [self setFrame:rt];
        if(m_Label)
            m_Label.hidden = YES;
    }
    else
    {

        BOOL bReleaseContext = NO;
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGColorSpaceRef colorSpace = NULL;
        if(context == NULL)
        {
            bReleaseContext = YES;
            colorSpace = CGColorSpaceCreateDeviceRGB();
            context = CGBitmapContextCreate(nil, w, h, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
            
        }
        CGContextSaveGState(context);
        CGPoint ptLeft = CGContextGetTextPosition(context);
        const char *pText = [m_Label.text UTF8String];
        //float fCharspce = 3;
        float fFontSize = [GUILayout GetDefaultAlertFontSize];
        int nLength = strlen(pText);
		CGContextSetTextDrawingMode(context, kCGTextInvisible);
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);		
        CGContextSelectFont(context, "Times New Roman",  fFontSize, kCGEncodingMacRoman);
        CGContextShowText(context, pText, nLength);
		CGPoint ptRight = CGContextGetTextPosition(context);
        float nTextLength = ptRight.x-ptLeft.y;
        CGContextRestoreGState(context);
        
        if(bReleaseContext)
        {
            if(colorSpace)
                CGColorSpaceRelease(colorSpace);
            CGContextRelease(context);
        }
        
        if(![self isLandscape] || [ApplicationConfigure iPADDevice])
        {
            width = [GUILayout GetDefaultAlertWidth:NO];
            float wlabel = width - 4.0*[GUILayout GetDefaultAlertUIEdge]; 
            float nLabelLines = (nTextLength/wlabel + 1.0);
            float hlabel = nLabelLines*fCharWidth;
            height = [GUILayout GetDefaultAlertButtonHeight] + 5.0*[GUILayout GetDefaultAlertUIEdge]+hlabel;
            CGRect rt = CGRectMake((w-width)*0.5, (h-height)*0.5, width, height);
            [self setFrame:rt];
            CGRect rt2 = CGRectMake((width-wlabel)/2.0, [GUILayout GetDefaultAlertUIEdge]*2.0, wlabel, hlabel);
            m_Label.frame = rt2;
            m_Label.hidden = NO;
        }
        else
        {
            float minWidth = [GUILayout GetDefaultAlertWidth:NO];
            float maxWidth = [GUILayout GetDefaultAlertWidth:YES];
            float wlabel = minWidth - 4.0*[GUILayout GetDefaultAlertUIEdge]; 
            float nLabelLines;
            if(nTextLength/wlabel <= 4.0)
            {    
                nLabelLines = (nTextLength/wlabel + 1.0);
                width = minWidth;
            }
            else
            {
                width = maxWidth;
                wlabel = width - 4.0*[GUILayout GetDefaultAlertUIEdge];
                nLabelLines = (nTextLength/wlabel + 1.0);
            }
            float hlabel = nLabelLines*fCharWidth;
            height = [GUILayout GetDefaultAlertButtonHeight] + 5.0*[GUILayout GetDefaultAlertUIEdge]+hlabel;
            CGRect rt = CGRectMake((w-width)*0.5, (h-height)*0.5, width, height);
            [self setFrame:rt];
            CGRect rt2 = CGRectMake((width-wlabel)/2.0, [GUILayout GetDefaultAlertUIEdge]*2.0, wlabel, hlabel);
            m_Label.frame = rt2;
            m_Label.hidden = NO;
        }
    }
}

-(void)CalculateMutliChoiceLayoutWithText:(int)nBtnNumber
{
    int nButtonsHeight = (nBtnNumber-1)*([GUILayout GetOptionalAlertButtonHeight]+[GUILayout GetDefaultAlertUIEdge])+[GUILayout GetDefaultAlertButtonHeight];
    float w =[GUILayout GetMainUIWidth];
    float h = [GUILayout GetContentViewHeight];
    float width, height;
    float fCharWidth = [GUILayout GetDefaultAlertLabelLineHeight];
    if(!m_Label || !m_Label.text || [m_Label.text length] == 0)
    {
        width = [GUILayout GetDefaultAlertWidth:NO];
        height = nButtonsHeight + 4.0*[GUILayout GetDefaultAlertUIEdge];
        CGRect rt = CGRectMake((w-width)*0.5, (h-height)*0.5, width, height);
        [self setFrame:rt];
        if(m_Label)
            m_Label.hidden = YES;
    }
    else
    {
        
        BOOL bReleaseContext = NO;
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGColorSpaceRef colorSpace = NULL;
        if(context == NULL)
        {
            bReleaseContext = YES;
            colorSpace = CGColorSpaceCreateDeviceRGB();
            context = CGBitmapContextCreate(nil, w, h, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
            
        }
        CGContextSaveGState(context);
        CGPoint ptLeft = CGContextGetTextPosition(context);
        const char *pText = [m_Label.text UTF8String];
        //float fCharspce = 3;
        float fFontSize = [GUILayout GetDefaultAlertFontSize];
        int nLength = strlen(pText);
		CGContextSetTextDrawingMode(context, kCGTextInvisible);
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);		
        CGContextSelectFont(context, "Times New Roman",  fFontSize, kCGEncodingMacRoman);
        CGContextShowText(context, pText, nLength);
		CGPoint ptRight = CGContextGetTextPosition(context);
        float nTextLength = ptRight.x-ptLeft.y;
        CGContextRestoreGState(context);
        
        if(bReleaseContext)
        {
            if(colorSpace)
                CGColorSpaceRelease(colorSpace);
            CGContextRelease(context);
        }
        
        if(![self isLandscape] || [ApplicationConfigure iPADDevice])
        {
            width = [GUILayout GetDefaultAlertWidth:NO];
            float wlabel = width - 4.0*[GUILayout GetDefaultAlertUIEdge]; 
            int nLabelLines = (int)(nTextLength/wlabel + 1.0);
            float hlabel = nLabelLines*fCharWidth;
            height = nButtonsHeight + 5.0*[GUILayout GetDefaultAlertUIEdge]+hlabel;
            CGRect rt = CGRectMake((w-width)*0.5, (h-height)*0.5, width, height);
            [self setFrame:rt];
            CGRect rt2 = CGRectMake((width-wlabel)/2.0, [GUILayout GetDefaultAlertUIEdge]*2.0, wlabel, hlabel);
            m_Label.frame = rt2;
            m_Label.hidden = NO;
        }
        else
        {
            float minWidth = [GUILayout GetDefaultAlertWidth:NO];
            float maxWidth = [GUILayout GetDefaultAlertWidth:YES];
            float wlabel = minWidth - 4.0*[GUILayout GetDefaultAlertUIEdge]; 
            int nLabelLines;
            if(nTextLength/wlabel <= 2.0)
            {    
                nLabelLines = (int)(nTextLength/wlabel + 1.0);
                width = minWidth;
            }
            else
            {
                width = maxWidth;
                wlabel = width - 4.0*[GUILayout GetDefaultAlertUIEdge];
                nLabelLines = (int)(nTextLength/wlabel + 1.0);
            }
            float hlabel = nLabelLines*fCharWidth;
            height = nButtonsHeight + 5.0*[GUILayout GetDefaultAlertUIEdge]+hlabel;
            CGRect rt = CGRectMake((w-width)*0.5, (h-height)*0.5, width, height);
            [self setFrame:rt];
            CGRect rt2 = CGRectMake((width-wlabel)/2.0, [GUILayout GetDefaultAlertUIEdge]*2.0, wlabel, hlabel);
            m_Label.frame = rt2;
            m_Label.hidden = NO;
        }
    }
    
}

//- (void)deviceOrientationDidChange:(void*)object 
-(void)UpdateSubViewsOrientation
{
    float w = [GUILayout GetMainUIWidth];
    float h = [GUILayout GetContentViewHeight];
    float width, height;
    if([ApplicationConfigure iPADDevice])
    {
        width = self.frame.size.width;
        height = self.frame.size.height;
        CGRect rt = CGRectMake((w-width)*0.5, (h-height)*0.5, width, height);
        [self setFrame:rt];
    }
    else
    {
        if(!m_Label || !m_Label.text || [m_Label.text length] == 0)
        {
            width = self.frame.size.width;
            height = self.frame.size.height;
            CGRect rt = CGRectMake((w-width)*0.5, (h-height)*0.5, width, height);
            [self setFrame:rt];
        }
        else
        {
            if(m_bMultiChoice)
            {
                [self CalculateMutliChoiceLayoutWithText: m_nButtonNumber];
            }
            else
            {    
                [self CalculateLayoutWithText];
            }    
        }
    }
    if(m_nButtonNumber == 1)
    {
        int nCount = [self.subviews count];
        for(int i = 0; i < nCount; ++i)
        {
            id pSubView = [self.subviews objectAtIndex:i];
            if(pSubView && [pSubView isKindOfClass:[CustomGlossyButton class]])
            {
                float w = self.frame.size.width;
                float h = self.frame.size.height;
                float dy = [GUILayout GetDefaultAlertUIEdge]*2.0;//[GUILayout GetDefaultAlertUIConner];
                float bw = [GUILayout GetDefaultAlertButtonWidth];
                float bh = [GUILayout GetDefaultAlertButtonHeight];
                CGRect rt = CGRectMake((w-bw)/2.0, h-bh-dy, bw, bh);
                [(CustomGlossyButton*)pSubView setFrame:rt];
                break;
            }
        }
    }
    else if(m_nButtonNumber == 2)
    {
        int nCount = [self.subviews count];
        for(int i = 0; i < nCount; ++i)
        {
            id pSubView = [self.subviews objectAtIndex:i];
            if(pSubView && [pSubView isKindOfClass:[CustomGlossyButton class]])
            {
                float w = self.frame.size.width;
                float h = self.frame.size.height;
                float dy = [GUILayout GetDefaultAlertUIEdge]*2.0;//[GUILayout GetDefaultAlertUIConner];
                float bw = [GUILayout GetDefaultAlertButtonWidth];
                float bh = [GUILayout GetDefaultAlertButtonHeight];
                CGRect rt = CGRectMake((w*0.5-bw)/2.0, h-bh-dy, bw, bh);
                if([(CustomGlossyButton*)pSubView GetID] == ALERT_CANCEL)
                    rt = CGRectMake(w*0.5+(w*0.5-bw)/2.0, h-bh-dy, bw, bh);
                [(CustomGlossyButton*)pSubView setFrame:rt];
            }
        }
    }
    else if(m_bMultiChoice)
    {
        float w = self.frame.size.width;
        float h = self.frame.size.height;
        int nCount = m_nButtonNumber-1;
        float yStep = ([GUILayout GetOptionalAlertButtonHeight]+[GUILayout GetDefaultAlertUIEdge]);
        float bw;
        float bh;
        float sy;
        CGRect rt;
        int nStep;
        float btnChoiceHeight = nCount*yStep;
        float cancelY = h - [GUILayout GetDefaultAlertButtonHeight] - [GUILayout GetDefaultAlertUIEdge]*2.0;
        for(int i = 0; i < [self.subviews count]; ++i)
        {
            id pSubView = [self.subviews objectAtIndex:i];
            if(pSubView && [pSubView isKindOfClass:[CustomGlossyButton class]])
            {
                if([(CustomGlossyButton*)pSubView GetID] == ALERT_CANCEL)
                {    
                    bw = [GUILayout GetDefaultAlertButtonWidth];
                    bh = [GUILayout GetDefaultAlertButtonHeight];
                    sy = cancelY;
                    rt = CGRectMake((w-bw)/2.0, sy, bw, bh);
                }   
                else
                {
                    nStep = [(CustomGlossyButton*)pSubView GetID] - ALERT_CANCEL -1; 
                    sy = cancelY-btnChoiceHeight + yStep*nStep;
                    bw = [GUILayout GetOptionalAlertButtonWidth];
                    bh = [GUILayout GetOptionalAlertButtonHeight];
                    rt = CGRectMake((w-bw)/2.0, sy, bw, bh);
                }
                [(CustomGlossyButton*)pSubView setFrame:rt];
            }
        }
               
    }
        
    [self setNeedsDisplay];
}

/*- (void)addObservers 
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationDidChange:)
                                                 name:@"UIDeviceOrientationDidChangeNotification" object:nil];
}

- (void)removeObservers 
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UIDeviceOrientationDidChangeNotification" object:nil];
}*/

-(id)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) 
    {
        // Initialization code
        m_Label = [[UILabel alloc] initWithFrame:CGRectZero];
        m_Label.backgroundColor = [UIColor clearColor];
        [m_Label setTextColor:[UIColor blackColor]];
        CGFloat fontSize = [GUILayout GetDefaultAlertFontSize];
        m_Label.font = [UIFont fontWithName:@"Times New Roman" size:fontSize];
        [m_Label setTextAlignment:UITextAlignmentCenter];
        m_Label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        m_Label.adjustsFontSizeToFitWidth = YES;
        //m_Label.lineBreakMode = UILineBreakModeWordWrap;
        m_Label.numberOfLines = 0;
        [self addSubview:m_Label];
        [m_Label release];
        m_Delegate = nil;
        m_BackgroundView = [[CustomModalAlertBackgroundView alloc] init];
        m_BackgroundView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.hidden = YES;
        m_nButtonNumber = 0;
        m_bMultiChoice = NO;
    }
    return self;
}

-(void)dealloc
{
    [m_BackgroundView release];
    [super dealloc];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if(rect.size.width == 0)
        return;
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    float fsize = [GUILayout GetDefaultAlertUIConner];
    AddRoundRectToPath(context, rect, CGSizeMake(fsize, fsize), 0.5);
    CGContextClip(context);
    [DrawHelper2 DrawDefaultAlertBackground:context at:rect];
    CGContextRestoreGState(context);
    CGContextSaveGState(context);
    float foffset = [GUILayout GetDefaultAlertUIEdge]/2.0;
    CGRect rt2 = CGRectInset(rect, foffset, foffset);
    AddRoundRectToPath(context, rt2, CGSizeMake(fsize-foffset*2, fsize-foffset*2), 0.5);
    [DrawHelper2 DrawDefaultAlertBackgroundDecoration:context];
    CGContextRestoreGState(context);
}

- (void)postDismissCleanup 
{
    //[self removeObservers];
    [self removeFromSuperview];
    [m_BackgroundView removeFromSuperview];
}


-(void)DismissMe:(BOOL)bAnimated
{
    if (bAnimated) 
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(postDismissCleanup)];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
        self.hidden = YES;
        [UIView commitAnimations];
    } 
    else 
    {
        [self postDismissCleanup];
    }
}

-(void)OnButtonClick:(int)nButtonID
{
    if(m_Delegate)
        [m_Delegate SetClickedButtonID:nButtonID];
    [self DismissMe:YES];
}

-(void)CreateDefaultSingleButton:(NSString*)caption
{
    float w = self.frame.size.width;
    float h = self.frame.size.height;
    float dy = [GUILayout GetDefaultAlertUIEdge]*2.0;//[GUILayout GetDefaultAlertUIConner];
    float bw = [GUILayout GetDefaultAlertButtonWidth];
    float bh = [GUILayout GetDefaultAlertButtonHeight];
    CGRect rt = CGRectMake((w-bw)/2.0, h-bh-dy, bw, bh);
    CustomGlossyButton* okBtn = [[CustomGlossyButton alloc] initWithFrame:rt];
    [okBtn SetGreenDisplay];
    [okBtn RegisterButton:self withID:0 withLabel:caption];
    [self addSubview:okBtn];
    [okBtn release];
    m_nButtonNumber = 1;
}

-(void)CreateDefaultDoubleButtons:(NSString*)btnCaption1 withButton2:(NSString*)btnCaption2
{
    float w = self.frame.size.width;
    float h = self.frame.size.height;
    float dy = [GUILayout GetDefaultAlertUIEdge]*2.0;//[GUILayout GetDefaultAlertUIConner];
    float bw = [GUILayout GetDefaultAlertButtonWidth];
    float bh = [GUILayout GetDefaultAlertButtonHeight];
    CGRect rt = CGRectMake(w*0.5+(w*0.5-bw)/2.0, h-bh-dy, bw, bh);
    CustomGlossyButton* cancelBtn = [[CustomGlossyButton alloc] initWithFrame:rt];
    [cancelBtn RegisterButton:self withID:ALERT_CANCEL withLabel:btnCaption1];
    [self addSubview:cancelBtn];
    [cancelBtn release];

    rt = CGRectMake((w*0.5-bw)/2.0, h-bh-dy, bw, bh);
    CustomGlossyButton* okBtn = [[CustomGlossyButton alloc] initWithFrame:rt];
    [okBtn SetGreenDisplay];
    [okBtn RegisterButton:self withID:ALERT_OK withLabel:btnCaption2];
    [self addSubview:okBtn];
    [okBtn release];
    
    m_nButtonNumber = 2;
}

-(void)CreateMutliChoiceButtons:(NSString*)btnCancel withChoice:(NSArray*)btnChoice
{
    float w = self.frame.size.width;
    float h = self.frame.size.height;
    float dy = [GUILayout GetDefaultAlertUIEdge]*2.0;//[GUILayout GetDefaultAlertUIConner];
    float bw = [GUILayout GetDefaultAlertButtonWidth];
    float bh = [GUILayout GetDefaultAlertButtonHeight];
    float sy = h-bh-dy;
    CGRect rt = CGRectMake((w-bw)/2.0, sy, bw, bh);
    CustomGlossyButton* cancelBtn = [[CustomGlossyButton alloc] initWithFrame:rt];
    [cancelBtn RegisterButton:self withID:ALERT_CANCEL withLabel:btnCancel];
    [self addSubview:cancelBtn];
    [cancelBtn release];
     
    float yStep = ([GUILayout GetOptionalAlertButtonHeight]+[GUILayout GetDefaultAlertUIEdge]);
    
    sy = sy-[btnChoice count]*yStep;
    bw = [GUILayout GetOptionalAlertButtonWidth];
    bh = [GUILayout GetOptionalAlertButtonHeight];
    for(int i = 0; i < [btnChoice count]; ++i)
    {
        rt = CGRectMake((w-bw)/2.0, sy, bw, bh);
        CustomGlossyButton* optionBtn = [[CustomGlossyButton alloc] initWithFrame:rt];
        [optionBtn RegisterButton:self withID:(ALERT_CANCEL+i+1) withLabel:[btnChoice objectAtIndex:i]];
        [optionBtn SetGreenDisplay];
        [self addSubview:optionBtn];
        [optionBtn release];
        sy += yStep;
    }
}

-(void)OnAlertShow
{
    //[self addObservers];
    [self setNeedsDisplay];
}

-(void)Flyin
{
    self.hidden = NO;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(OnAlertShow)];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
    [UIView commitAnimations];
}


-(void)ShowSimpleMessage:(NSString*)msg closeButton:(NSString*)closeBtn
{
    if(msg)
        [m_Label setText:msg];
    else
        [m_Label setText:@""];
        
    [self CalculateLayoutWithText];
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window) 
    {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    m_BackgroundView.frame = window.frame;
    [m_BackgroundView addSubview:self];
    
    [[GUILayout GetMainViewController].view addSubview:m_BackgroundView];
    [self release];
    [self CreateDefaultSingleButton:closeBtn]; 
    [self Flyin];
}

-(void)ShowConfirmMessage:(NSString*)msg withButton1:(NSString*)btnCaption1 withButton2:(NSString*)btnCaption2
{
    if(msg)
        [m_Label setText:msg];
    else
        [m_Label setText:@""];
    
    [self CalculateLayoutWithText];
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window) 
    {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    m_BackgroundView.frame = window.frame;
    [m_BackgroundView addSubview:self];
    
    [[GUILayout GetMainViewController].view addSubview:m_BackgroundView];
    [self release];
    [self CreateDefaultDoubleButtons:btnCaption1 withButton2:btnCaption2]; 
    [self Flyin];
}

-(void)ShowMultiChoice:(NSString*)msg withCancel:(NSString*)btnCancel withChoice:(NSArray*)btnChoice
{
    if(msg)
        [m_Label setText:msg];
    else
        [m_Label setText:@""];
    
    m_bMultiChoice = YES;
     m_nButtonNumber = 1;
    if(btnChoice)
         m_nButtonNumber = [btnChoice count]+1;
    [self CalculateMutliChoiceLayoutWithText: m_nButtonNumber];
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window) 
    {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    m_BackgroundView.frame = window.frame;
    [m_BackgroundView addSubview:self];
    
    [[GUILayout GetMainViewController].view addSubview:m_BackgroundView];
    [self release];
    [self CreateMutliChoiceButtons:btnCancel withChoice:btnChoice]; 
    [self Flyin];
}

-(void)SetMsgText:(NSString*)text
{
    [m_Label setText:text];
}

-(void)RegisterDelegate:(id<CustomModalAlertDelegate>)delegate
{
    m_Delegate = delegate;
}

+(int)SimpleSay:(NSString*)msg closeButton:(NSString*)closeBtn
{
	CFRunLoopRef currentLoop = CFRunLoopGetCurrent();
	
	// Create Alert
	CustomModalAlertDelegateClass *Alertdelegate = [[CustomModalAlertDelegateClass alloc] initWithRunLoop:currentLoop];
    //Don't manually release it
    CustomModalAlertView* pAlert = [[CustomModalAlertView alloc] init];
    [pAlert RegisterDelegate:Alertdelegate];
    [pAlert ShowSimpleMessage:msg closeButton:closeBtn];

	CFRunLoopRun();
	
	// Retrieve answer
	int  nRetID = [Alertdelegate GetClickedButtonID];
	[Alertdelegate release];
	return nRetID;
}

+(int)SimpleSay:(NSString *)closeBtn withMsg:(id)formatstring,...
{
	va_list arglist;
	va_start(arglist, formatstring);
	id statement = [[NSString alloc] initWithFormat:formatstring arguments:arglist];
	va_end(arglist);
	int nRet = [CustomModalAlertView SimpleSay:statement closeButton:closeBtn];
	[statement release];
    return nRet;
}

+(int)Ask:(NSString*)msg withButton1:(NSString*)btnCaption1 withButton2:(NSString*)btnCaption2
{
	CFRunLoopRef currentLoop = CFRunLoopGetCurrent();
	
	// Create Alert
	CustomModalAlertDelegateClass *Alertdelegate = [[CustomModalAlertDelegateClass alloc] initWithRunLoop:currentLoop];
    //Don't manually release it
    CustomModalAlertView* pAlert = [[CustomModalAlertView alloc] init];
    [pAlert RegisterDelegate:Alertdelegate];
    [pAlert ShowConfirmMessage:msg withButton1:btnCaption1 withButton2:btnCaption2];
    
	CFRunLoopRun();
	
	// Retrieve answer
	int  nRetID = [Alertdelegate GetClickedButtonID];
	[Alertdelegate release];
	return nRetID;
}

+(int)Ask:(NSString*)btnCaption1 andButton2:(NSString*)btnCaption2 forMessage:(id)formatstring,...
{
	va_list arglist;
	va_start(arglist, formatstring);
	id statement = [[NSString alloc] initWithFormat:formatstring arguments:arglist];
	va_end(arglist);
	int nRet = [CustomModalAlertView Ask:statement withButton1:btnCaption1 withButton2:btnCaption2];
	[statement release];
    return nRet;
}

+(int)MultChoice:(NSString*)msg withCancel:(NSString*)btnCancel withChoice:(NSArray*)btnChoice
{
	CFRunLoopRef currentLoop = CFRunLoopGetCurrent();
	
	// Create Alert
	CustomModalAlertDelegateClass *Alertdelegate = [[CustomModalAlertDelegateClass alloc] initWithRunLoop:currentLoop];
    //Don't manually release it
    CustomModalAlertView* pAlert = [[CustomModalAlertView alloc] init];
    [pAlert RegisterDelegate:Alertdelegate];
    [pAlert ShowMultiChoice:msg withCancel:btnCancel withChoice:btnChoice];
    
	CFRunLoopRun();
	
	// Retrieve answer
	int  nRetID = [Alertdelegate GetClickedButtonID];
	[Alertdelegate release];
	return nRetID;
}

@end
