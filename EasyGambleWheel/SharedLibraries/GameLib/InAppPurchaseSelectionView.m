//
//  InAppPurchaseSelectionView.m
//  XXXXXXXXXX
//
//  Created by Zhaohui Xing on 12-10-14.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "InAppPurchaseSelectionView.h"
#import "GUILayout.h"
#import "StringFactory.h"
#import "GameViewController.h"
#import "LabelCell.h"
#import "GroupCell.h"
#import "ApplicationResource.h"
#import "ListCellData.h"
#import "StringFactory.h"
#import "GameConstants.h"
#import "RenderHelper.h"
#import "SwitchCell.h"
#import "GUIEventLoop.h"
#import "CustomModalAlertView.h"
#import "ButtonCell.h"
#import "GameScore.h"
#import "DualTextCell.h"
#import "drawhelper.h"
#import "DrawHelper2.h"
#import "ApplicationMainView.h"

#define INVITATION_RESEND_TIME          30

@implementation InAppPurchaseSelectionView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initBlankUIWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        float xOffset = [GUILayout GetDefaultAlertUIConner]/2.0;
        float sy = [GUILayout GetDefaultAlertUIEdge]*1.5;
        float bw = [GUILayout GetFileSaveUIButtonWidth];
        float bh = [GUILayout GetFileSaveUIButtonHeight];
        
		CGRect rect = CGRectMake(xOffset, sy, bw, bh);
        m_btnCancel = [[CustomGlossyButton alloc] initWithFrame:rect];
        [m_btnCancel RegisterButton:self withID:PLAYERUI_CANCEL withLabel:[StringFactory GetString_NoThanks]];
        [self addSubview:m_btnCancel];
        
		rect = CGRectMake(xOffset+bw+[GUILayout GetDefaultAlertUIEdge], sy, bw, bh);
        m_btnOK = [[CustomGlossyButton alloc] initWithFrame:rect];
        [m_btnOK SetGreenDisplay];
        [m_btnOK RegisterButton:self withID:PLAYERUI_BUYIT withLabel:[StringFactory GetString_Purchase]];
        [self addSubview:m_btnOK];
        
		rect = frame;
		rect.origin.x = [GUILayout GetDefaultAlertUIEdge]*1.5;
        rect.size.width = rect.size.width-[GUILayout GetDefaultAlertUIEdge]*3.0;
		rect.origin.y += sy+bh+[GUILayout GetDefaultAlertUIEdge]/2.0;
		rect.size.height -= rect.origin.y+[GUILayout GetDefaultAlertUIEdge]*1.5;
		m_ListView = [[ScrollListView alloc] initWithFrame:rect];
		[self addSubview:m_ListView];
		
		[self bringSubviewToFront:m_ListView];
        m_nSelectedItem = -1;
        
        m_Parent = nil;
    }
    return self;
}

-(void)dealloc
{
     m_Parent = nil;
    
}

-(void)SetParent:(ApplicationMainView*)parent
{
    m_Parent = parent;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	[self drawBackground:context inRect: rect];
}

-(void)UpdateViewLayout
{
    float size = [GUILayout GetDefaultCloseButtonSize];
    CGRect rect = CGRectMake(self.frame.size.width-size, 0, size, size);
	[m_CloseButton setFrame:rect];
    
    
	rect = m_ListView.frame;
	rect.size.width = self.frame.size.width-[GUILayout GetDefaultAlertUIEdge]*3.0;
    rect.size.height = self.frame.size.height - rect.origin.y - [GUILayout GetDefaultAlertUIEdge]*1.5;
	[m_ListView setFrame:rect];
	[m_ListView OnLayoutChange];
	[super UpdateViewLayout];
    [self setNeedsDisplay];
}	

-(void)OnViewClose
{
    [super OnViewClose];
}

-(void)PurchaseCancelled
{
    [self CloseView:YES];
}

-(void)PurchaseSelectedItem
{
    if(0 <= m_nSelectedItem && m_Parent != nil)
    {
        [self CloseView:YES];
        [m_Parent PurchaseInAppItem: m_nSelectedItem];
    }
}

-(void)OnButtonClick:(int)nButtonID
{
    if(nButtonID == PLAYERUI_CANCEL)
    {
        [self PurchaseCancelled];
    }
    else
    {    
        [self PurchaseSelectedItem];
    }
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
                m_nSelectedItem = [(ListCellDataInt*)data GetData];
                if(0 <= m_nSelectedItem && m_Parent != nil)
                    m_btnOK.hidden = NO;
            }
        }
    }
}

-(void)LoadInAppPurchaseList
{
    float w = self.frame.size.width;
    float h = [GUILayout GetDefaultListCellHeight];
    
    CGRect rect = CGRectMake(0, 0, w, h);
    
    for(int i = 0; i < 10; ++i)
    {
        NSString* szLable = [StringFactory GetString_InAppPurchaseItemName:i];
        DualTextCell* p = [[DualTextCell alloc] initWithFrame:rect];
        [p SetTitle:szLable];
        [p SetText:@""];
        [p SetAsSingleSingle];
        [p SetSelectable:YES];
            
        ListCellDataInt* pData = [[ListCellDataInt alloc] init];
        pData.m_nData = i;
        p.m_DataStorage = pData;
        
        [self AddCell:p];
    }
    [m_ListView UpdateContentSizeByContentView];
}

-(void)OnViewOpen
{
    m_nSelectedItem = -1;
    m_btnOK.hidden = YES;
	[super OnViewOpen];
    [self RemoveAllCells];
    [self LoadInAppPurchaseList];
}	

-(void)CloseView:(BOOL)bAnimation
{
    [super CloseView:bAnimation];
}


@end
