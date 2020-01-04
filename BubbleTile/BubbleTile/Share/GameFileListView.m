//
//  GameFileListView.m
//  BubbleTile
//
//  Created by Zhaohui Xing on 12-02-26.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "GameFileListView.h"
#import "GUILayout.h"
#import "StringFactory.h"
#import "GameLayout.h"
#import "ApplicationController.h"
#import "LabelCell.h"
#import "GroupCell.h"
#import "ApplicationResource.h"
#import "ListCellData.h"
#import "StringFactory.h"
#import "GameConstants.h"
#import "GameConfiguration.h"
#import "CPuzzleGrid.h"
#import "RenderHelper.h"
#import "SwitchCell.h"
#import "GUIEventLoop.h"
#import "CustomModalAlertView.h"
#import "ButtonCell.h"
#import "GameScore.h"

@implementation GameFileListView

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
        [m_btnCancel RegisterButton:self withID:FILEUI_CANCEL withLabel:[StringFactory GetString_Cancel]];
        [self addSubview:m_btnCancel];
        [m_btnCancel release];
        
		rect = CGRectMake(xOffset+bw+[GUILayout GetDefaultAlertUIEdge], sy, bw, bh);
        m_btnOK = [[CustomGlossyButton alloc] initWithFrame:rect];
        [m_btnOK SetGreenDisplay];
        [m_btnOK RegisterButton:self withID:FILEUI_OK withLabel:[StringFactory GetString_OK]];
        [self addSubview:m_btnOK];
        [m_btnOK release];
        
		rect = frame;
		rect.origin.x = [GUILayout GetDefaultAlertUIEdge]*1.5;
        rect.size.width = rect.size.width-[GUILayout GetDefaultAlertUIEdge]*3.0;
		rect.origin.y += sy+bh+[GUILayout GetDefaultAlertUIEdge]/2.0;
		rect.size.height -= rect.origin.y+[GUILayout GetDefaultAlertUIEdge]*1.5;
		m_ListView = [[ScrollListView alloc] initWithFrame:rect];
		[self addSubview:m_ListView];
		
		[m_ListView release];
		[self bringSubviewToFront:m_ListView];
        
		rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
        m_GamePreviewView = [[GameFilePreviewView alloc] initWithFrame:rect];
        m_GamePreviewView.hidden = YES;
        [self addSubview:m_GamePreviewView];
        [self sendSubviewToBack:m_GamePreviewView];
        [m_GamePreviewView release];
        m_bCloseForPurchase = NO;
        m_bGameShareMode = NO;
        m_FileList = nil;
    }
    return self;
}

-(void)dealloc
{
    m_FileList = nil;
    [super dealloc];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
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
    rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [m_GamePreviewView setFrame:rect];
    [m_GamePreviewView UpdateViewLayout];
    [self setNeedsDisplay];
}	

-(void)OnViewClose
{
    [super OnViewClose];
    
    if(m_bGameShareMode == YES)
        return;
    
    if(m_nSelectedIndex == -1)
    {    
        if([self.superview respondsToSelector:@selector(OnFileOpenViewCancelled)])
        {
            [self.superview performSelector:@selector(OnFileOpenViewCancelled)];
        }
    }
    else 
    {
        if(m_bCloseForPurchase)
        {
            if([self.superview respondsToSelector:@selector(OnFileOpenViewClosedForInAppPurchase)])
            {
                [self.superview performSelector:@selector(OnFileOpenViewClosedForInAppPurchase)];
            }
        }
        else 
        {
            if([self.superview respondsToSelector:@selector(OnFileOpenViewClosedWithSelectedGameFile)])
            {
                [self.superview performSelector:@selector(OnFileOpenViewClosedWithSelectedGameFile)];
            }
        }
    }
}

-(void)FileSelectionCancelled
{
    m_nSelectedIndex = -1;
    [self CloseView:YES];
}

-(void)FileSelectionOK
{
    NSString* fileName = [m_FileList objectAtIndex:m_nSelectedIndex];
    NSURL* appFolder = [BTFileManager GetAppGameFilesFolderPath];
    NSURL* fileURL = [appFolder URLByAppendingPathComponent:fileName isDirectory:NO];
    BTFile* TestFile = [[[BTFile alloc] init] autorelease];
    [TestFile SetFileURL:fileURL];
    [TestFile LoadDocument];
    
    enGridType enType = (enGridType)TestFile.m_FileHeader.m_GameData.m_GridType;
    int nEdge = TestFile.m_FileHeader.m_GameData.m_GridEdge;
    int nStart = [GameConfiguration GetMinBubbleUnit:enType];
    if(enType == PUZZLE_GRID_TRIANDLE || ([GameScore CheckPaymentState] == YES || [ApplicationConfigure CanTemporaryAccessPaidFeature]))
    {    
        m_bCloseForPurchase = NO;
        [self CloseView:YES];
        return;
    }    
    else if(enType == PUZZLE_GRID_SQUARE && [GameScore CheckSquarePaymentState] == YES)
    {    
        m_bCloseForPurchase = NO;
        [self CloseView:YES];
        return;
    }    
    else if(enType == PUZZLE_GRID_DIAMOND && [GameScore CheckDiamondPaymentState] == YES)
    {    
        m_bCloseForPurchase = NO;
        [self CloseView:YES];
        return;
    }    
    else if(enType == PUZZLE_GRID_HEXAGON && [GameScore CheckHexagonPaymentState] == YES)
    {    
        m_bCloseForPurchase = NO;
        [self CloseView:YES];
        return;
    }   
    if(nEdge <= nStart)
    {
        m_bCloseForPurchase = NO;
        [self CloseView:YES];
        return;
    }
    
    int nRet = [CustomModalAlertView Ask:[StringFactory GetString_PaidFeatureInGameAsk] withButton1:[StringFactory GetString_No] withButton2:[StringFactory GetString_Yes]];
    
    if(nRet == ALERT_NO)
    {
        [self FileSelectionCancelled];
    }    
    else
    {    
        m_bCloseForPurchase = YES;
        [self CloseView:YES];
        return;
    }    
    
}

-(void)FileSelectionToShare
{
    NSString* fileName = [m_FileList objectAtIndex:m_nSelectedIndex];
    NSURL* appFolder = [BTFileManager GetAppGameFilesFolderPath];
    NSURL* fileURL = [appFolder URLByAppendingPathComponent:fileName isDirectory:NO];
    ApplicationController* pController = (ApplicationController*)[GUILayout GetMainViewController];
    if(pController)
       [pController ShareGameByEmail:fileURL];
}

-(void)OnButtonClick:(int)nButtonID
{
    if(nButtonID == FILEUI_CANCEL)
    {
        [self FileSelectionCancelled];
    }
    else
    {    
        if(m_bGameShareMode == NO)
            [self FileSelectionOK];
        else    
            [self FileSelectionToShare];
    }
}    

-(void)OnPreviewButtonClick:(NSNotification *)notification
{
    [m_ListView UnSelectllCells];
    ButtonCell* pFileCell = (ButtonCell*)[notification object];
    if(pFileCell != nil)
    {    
        [pFileCell SetSelectionState:YES];
        id<ListCellDataTemplate> data = [pFileCell GetCellData];
        if(data)
        {
            if([data GetDataType] == enLISTCELLDATA_INT)
            {
                int index = [(ListCellDataInt*)data GetData];
                m_nSelectedIndex = index;
                if(0 <= m_nSelectedIndex)
                    m_btnOK.hidden = NO;
                if(0 <= index && m_FileList && 0 < [m_FileList count])
                {    
                    NSString* fileName = [m_FileList objectAtIndex:index];
                    NSURL* appFolder = [BTFileManager GetAppGameFilesFolderPath];
                    NSURL* fileURL = [appFolder URLByAppendingPathComponent:fileName isDirectory:NO];
                    [m_GamePreviewView OpenFile:fileURL];
                    [m_GamePreviewView OpenView:YES];
                }    
            }
        }
        data = nil;
    }    
    pFileCell = nil;
    
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
                int index = [(ListCellDataInt*)data GetData];
                m_nSelectedIndex = index;
                if(0 <= m_nSelectedIndex)
                    m_btnOK.hidden = NO;
            }
        }
    }
}

-(void)LoadGameFileList
{
    m_FileList = [[NSArray alloc] initWithArray:[BTFileManager GetFileList] copyItems:YES];
    if(m_FileList && 0 < [m_FileList count])
    {
        float w = self.frame.size.width-[GUILayout GetDefaultAlertUIEdge]*3.0;
        float h = [GUILayout GetDefaultListCellHeight];
        CGRect rect = CGRectMake(0, 0, w, h);
        for(int i = 0; i < [m_FileList count]; ++i)
        {
            ButtonCell*  pFileCell;
            
            pFileCell = [[ButtonCell alloc] initWithFrame:rect withImage:@"icon4.png" withHighLightImage:@"icon4.png"];
            [pFileCell RegisterControlID:GUIID_EVENT_FILELISTPREVIEWCLICK];
            [GUIEventLoop RegisterEvent:GUIID_EVENT_FILELISTPREVIEWCLICK eventHandler:@selector(OnPreviewButtonClick:) eventReceiver:self eventSender:pFileCell];
            [pFileCell SetTitle:[m_FileList objectAtIndex:i]];
            ListCellDataInt* pData = [[ListCellDataInt alloc] init];
            pData.m_nData = i;
            [pFileCell SetCellData:pData];
            [pFileCell SetSelectable:YES];
            [self AddCell:pFileCell];
            [pFileCell release];
        }
    }
    [m_ListView UpdateContentSizeByContentView];	
}

-(void)OnViewOpen
{
    if(m_FileList)
    {
        [m_FileList release];
        m_FileList = nil;
    }
    m_nSelectedIndex = -1;
    m_btnOK.hidden = YES;
    m_bCloseForPurchase = NO;
	[super OnViewOpen];
    [self RemoveAllCells];
    [self LoadGameFileList];
}	

-(void)CloseView:(BOOL)bAnimation
{
    [super CloseView:bAnimation];
}

-(NSURL*)GetSelectedFile
{
    NSURL* strRet = nil;
    if(0 <= m_nSelectedIndex && m_nSelectedIndex < [m_FileList count])
    {    
        NSString* fileName = [m_FileList objectAtIndex:m_nSelectedIndex];
        NSURL* appFolder = [BTFileManager GetAppGameFilesFolderPath];
        strRet = [appFolder URLByAppendingPathComponent:fileName isDirectory:NO];
    }    
    return strRet;
}
    
-(void)SetGameShareMode:(BOOL)bShare
{
    m_bGameShareMode = bShare;
    if(m_bGameShareMode)
    {
        [m_btnOK SetLabel:[StringFactory GetString_Share]];
    }
    else
    {
        [m_btnOK SetLabel:[StringFactory GetString_OK]];
    }
}

@end
