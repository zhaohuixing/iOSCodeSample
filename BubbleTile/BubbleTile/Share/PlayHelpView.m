//
//  PlayHelpView.m
//  XXXXXX
//
//  Created by Zhaohui Xing on 11-07-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "PlayHelpView.h"
#import "GUILayout.h"
#import "GUIEventLoop.h"
#import "GUIBasicConstant.h"
#import "ApplicationController.h"
#import "DualTextCell.h"
#import "ListCellData.h"
#import "DrawHelper2.h"
#import "BTFile.h"
#import "RenderHelper.h"
#import "GameConfiguration.h"
#include "drawhelper.h"

@implementation PlayHelpView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        m_AchorPoint = CGPointMake(frame.size.width*0.5, 0);
        
        float roundSize = [GUILayout GetDefaultAlertUIConner];
        float archorSize = roundSize/2.0;
        
        float sx = roundSize/4.0;
        float sy = archorSize+roundSize/4.0;  
        float w = frame.size.width - roundSize/2.0;
        float h = frame.size.height - (archorSize+roundSize/2.0);
        
        CGRect rect = CGRectMake(sx, sy, w, h);
        
        m_ItemListView = [[PlayHelpItemListView alloc] initWithFrame:rect];
        [self addSubview:m_ItemListView];
        [m_ItemListView release];
        
        [self UpdateViewLayout];
    }
    return self;
}

-(void)SetAchorAtTop:(float)fPostion
{
    m_AchorPoint = CGPointMake(self.frame.size.width*fPostion, 0);
    [self UpdateViewLayout];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawBackGround:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
    float roundSize = [GUILayout GetDefaultAlertUIConner];
    float archorSize = roundSize/2.0;
    CGRect archorRect = CGRectMake(0, 0, rect.size.width, archorSize);
   
    CGContextSaveGState(context);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, m_AchorPoint.x, m_AchorPoint.y);
    CGContextAddLineToPoint(context, m_AchorPoint.x-archorSize*0.5, archorSize);
    CGContextAddLineToPoint(context, m_AchorPoint.x+archorSize*0.5, archorSize);
    CGContextAddLineToPoint(context, m_AchorPoint.x, m_AchorPoint.y);
    CGContextClosePath(context);
    CGContextClip(context);
    [DrawHelper2 DrawDefaultFrameViewBackground:context at:archorRect];
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    CGRect innerRect = CGRectMake(0, archorSize, rect.size.width, rect.size.height-archorSize);
    AddRoundRectToPath(context, innerRect, CGSizeMake(roundSize, roundSize), 0.5);
	CGContextClip(context);
    [DrawHelper2 DrawDefaultFrameViewBackground:context at:innerRect];
    CGContextRestoreGState(context);
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self drawBackGround:rect];
}

-(void)UpdateViewLayout
{
//    float roundSize = self.frame.size.height*[GUILayout GetTMSViewRoundRatio];
//    float archorSize = self.frame.size.width*[GUILayout GetTMSViewAchorRatio];
}

-(void)OnViewClose
{
	[[self superview] sendSubviewToBack:self];
    if([[self superview] respondsToSelector:@selector(OnGamePlayHelpViewClosed)])
    {
        [[self superview] performSelector:@selector(OnGamePlayHelpViewClosed)];
    }
}	

-(void)CloseView:(BOOL)bAnimation
{
	if(bAnimation)
	{
		CGContextRef context = UIGraphicsGetCurrentContext();
		[UIView beginAnimations:nil context:context];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1.0];
        self.hidden = YES;
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(OnViewClose)];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
		[UIView commitAnimations];
	}	
	else
	{
        self.hidden = YES;
		[self OnViewClose];
	}
}

-(void)OnViewOpen
{
}	

-(void)OpenView:(BOOL)bAnimation
{
	[[self superview] bringSubviewToFront:self];
	self.hidden = NO;
    [m_ItemListView OpenView:NO];
	if(bAnimation)
	{
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		[UIView beginAnimations:nil context:context];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(OnViewOpen)];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self cache:YES];
		[UIView commitAnimations];
	}
	else 
	{
		[self OnViewOpen];
	}
}

-(int)GetSelectedIndex
{
    return [m_ItemListView GetSelectedIndex];
}


@end

//???????????????????
//???????????????????
//???????????????????
//???????????????????
//???????????????????
@implementation PlayHelpItemListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        m_nSelectedIndex = -1;
    }
    return self;
}

- (void)drawRect:(CGRect)rect 
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	[self drawBackground:context inRect: rect];
}


-(void)OnViewClose
{
    [((PlayHelpView*)self.superview) CloseView:YES];
}

-(void)OnCellSelectedEvent:(id)sender
{
    [super OnCellSelectedEvent:sender];
    id<ListCellTemplate> p = sender;
    if(p)
    {
        id<ListCellDataTemplate> data = [p GetCellData];
        if(data)
        {
            if([data GetDataType] == enLISTCELLDATA_INT)
            {
                m_nSelectedIndex = [(ListCellDataInt*)data GetData];
            }
        }
    }
}

-(void)LoadCompletedGamePlayRecord
{
    ApplicationController* pController = (ApplicationController*)[GUILayout GetMainViewController];
    
    if(!pController || ![pController GetFileManager] || ![pController GetFileManager].m_PlayingFile || ![[pController GetFileManager].m_PlayingFile IsValid] || [[pController GetFileManager].m_PlayingFile CurrentDocumentIsCacheFile] || ![pController GetFileManager].m_PlayingFile.m_PlayRecordList || [[pController GetFileManager].m_PlayingFile CompletedGamePlaysNumber] <= 0)
    {    
        return;
    }
    
    int nCount = [[pController GetFileManager].m_PlayingFile.m_PlayRecordList count];
    if(0 < nCount)
    {
        float w = self.frame.size.width-[GUILayout GetDefaultAlertUIEdge]*3.0;
        float h = [GUILayout GetDefaultListCellHeight]*0.8;
        
        CGRect rect = CGRectMake(0, 0, w, h);
        CGImageRef srcImage = [RenderHelper GetPlayHelpMarkImage:[GameConfiguration GetBubbleType]];
        DualTextCell* p1 = [[DualTextCell alloc] initWithImage:srcImage withFrame:rect];
        [p1 SetTextAlignment:enCELLTEXTALIGNMENT_RIGHT];
        [p1 SetTitle:@""];
        [p1 SetText:@""]; 
        [p1 SetSelectable:YES];
        [p1 SetSelectionState:YES];
        ListCellDataInt* pIndex0 = [[ListCellDataInt alloc] init];
        pIndex0.m_nData = -1;
        [p1 SetCellData:pIndex0];
        [self AddCell:p1];
        [p1 release];
        
        for (int i = 0; i < nCount; ++i) 
        {
            BTFilePlayRecord* pRecord = [[pController GetFileManager].m_PlayingFile.m_PlayRecordList objectAtIndex:i];
            if(pRecord && pRecord.m_bCompleted)
            {
                DualTextCell* p = [[DualTextCell alloc] initWithFrame:rect];
                [p SetTextAlignment:enCELLTEXTALIGNMENT_RIGHT];
                [p SetTitle:pRecord.m_PlayerData.m_Auther];
                [p SetText:[NSString stringWithFormat:@"%i", [pRecord.m_PlaySteps count]]]; 
                [p SetSelectable:YES];
                ListCellDataInt* pIndex = [[ListCellDataInt alloc] init];
                pIndex.m_nData = i;
                [p SetCellData:pIndex];
                [self AddCell:p];
                [p release];
            }
        }
    }
    [m_ListView UpdateContentSizeByContentView];	
}

-(void)OnViewOpen
{
    m_nSelectedIndex = -1;
    [self RemoveAllCells];
    [self LoadCompletedGamePlayRecord];
}

-(void)CloseView:(BOOL)bAnimation
{
    [self OnViewClose];
}

-(void)OpenView:(BOOL)bAnimation
{
    [self OnViewOpen];
}

-(int)GetSelectedIndex
{
    return m_nSelectedIndex;
}

@end



