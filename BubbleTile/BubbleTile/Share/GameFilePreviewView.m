//
//  GameFilePreviewView.m
//  BubbleTile
//
//  Created by Zhaohui Xing on 12-02-07.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "GameFilePreviewView.h"
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
#import "ApplicationResource.h"

@implementation GameFilePreviewView

-(void)HandleFileEmail
{
    ApplicationController* pController = (ApplicationController*)[GUILayout GetMainViewController];
    if(!pController || m_OpenFile == nil || m_OpenFile._FileURL == nil)
    {
        return;
    }    
    [pController ShareGameByEmail:m_OpenFile._FileURL];
}

-(void)OnButtonClick:(int)nButtonID
{
    if(nButtonID == FILEUI_SHARE)
    {
        [self HandleFileEmail];
    }
    [self CloseView:YES];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];

		CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        m_MapView = [[LocationView alloc] initWithFrame:rect];
        [self addSubview:m_MapView];
        m_MapView.hidden = YES;
        [m_MapView HideMeAndAllButtons];
        [self sendSubviewToBack:m_MapView];
        [m_MapView release];
        m_OpenFile = nil;
  
        float xOffset = [GUILayout GetDefaultAlertUIConner]/2.0;
        float sy = [GUILayout GetDefaultAlertUIEdge]*1.5;
        float bw = [GUILayout GetFileSaveUIButtonWidth];
        float bh = [GUILayout GetFileSaveUIButtonHeight];
		rect = CGRectMake(xOffset, sy, bw, bh);
        m_btnShare = [[CustomGlossyButton alloc] initWithFrame:rect];
        [m_btnShare SetGreenDisplay];
        [m_btnShare RegisterButton:self withID:FILEUI_SHARE withLabel:[StringFactory GetString_Share]];
        [self addSubview:m_btnShare];
        if(![ApplicationConfigure CanSendEmail])
            m_btnShare.hidden = YES;
        [m_btnShare release];
    }
    return self;
}

-(void)dealloc
{
    if(m_OpenFile)
    {
        [m_OpenFile release];
    }
    [super dealloc];
}

-(void)UpdateViewLayout
{
	[super UpdateViewLayout];
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [m_MapView setFrame:rect];
    [m_MapView UpdateViewLayout];
}	

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	[self drawBackground:context inRect: rect];
}


-(void)UpdateLocationView:(BTFile*)pGameFile
{
    if(!pGameFile || !pGameFile.m_FileHeader)
        return;
    
    [m_MapView ResetMap];
    if(pGameFile.m_FileHeader.m_AutherData.m_bLocationEnable)
    {
        NSString* title = pGameFile.m_FileHeader.m_AutherData.m_Auther;//[pGameFile.m_FileHeader.m_AutherData.m_Auther copy];
        NSString* text = [StringFactory GetString_GameCreator];
        float fLatitude = pGameFile.m_FileHeader.m_AutherData.m_fLatitude;
        float fLongitude = pGameFile.m_FileHeader.m_AutherData.m_fLongitude;
        [m_MapView AddMapAnnotation:nil withTitle:title withText:text withLatitude:fLatitude withLongitude:fLongitude isMaster:YES isMe:NO];
    }
    int nCount = 0;
    if(pGameFile.m_PlayRecordList)
        nCount = [pGameFile.m_PlayRecordList count];
    
    if(0 < nCount)
    {
        for(int i = 0; i < nCount; ++i)
        {
            BTFilePlayRecord* pRecord = [pGameFile.m_PlayRecordList objectAtIndex:i];
            if(pRecord && pRecord.m_PlayerData.m_bLocationEnable)
            {
                NSString* title = pRecord.m_PlayerData.m_Auther;
                NSString* text = [StringFactory GetString_GamePlayer];
                float fLatitude = pRecord.m_PlayerData.m_fLatitude;
                float fLongitude = pRecord.m_PlayerData.m_fLongitude;
                [m_MapView AddMapAnnotation:nil withTitle:title withText:text withLatitude:fLatitude withLongitude:fLongitude isMaster:NO isMe:NO];
            }
        }
    }
}

-(void)OpenGamePreview
{
    ApplicationController* pController = (ApplicationController*)[GUILayout GetMainViewController];
    if(pController && m_OpenFile && m_OpenFile.m_FileHeader)
    {
        BOOL bEasy = (m_OpenFile.m_FileHeader.m_GameData.m_GameLevel == 0);
        enGridType enType = (enGridType)m_OpenFile.m_FileHeader.m_GameData.m_GridType;
        enGridLayout enLayout = m_OpenFile.m_FileHeader.m_GameData.m_GridLayout;
        enBubbleType enBubbleType = m_OpenFile.m_FileHeader.m_GameData.m_Bubble;
        int nEdge = m_OpenFile.m_FileHeader.m_GameData.m_GridEdge;
        NSArray* setting = m_OpenFile.m_FileHeader.m_GameData.m_GameSet;
        [pController OpenPreviewView:enType withLayout:enLayout withSize:nEdge withLevel:bEasy withBubble:enBubbleType withSetting:setting];
    }    
}

-(void)OpenLocationView
{
    if(0 < [m_MapView GetMapLocations])
    {    
        [m_MapView OpenView];
        [m_MapView ShowAll];
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
                int nCellEventID = [(ListCellDataInt*)data GetData];
                switch (nCellEventID) 
                {
                    case FILEUI_GAMEPREVIEW:
                        [self OpenGamePreview];
                        break;
                    case FILEUI_CREATORLOCATION:
                        [self OpenLocationView];
                        break;
                    default:
                    {
                        if(FILEUI_LASTFIXEDID < nCellEventID)
                        {
                            [self OpenLocationView];
                        }
                    }
                    break;
                }
            }
        }
    }
}


-(void)OnViewClose
{
    [self RemoveAllCells];
    [super OnViewClose];
    [m_MapView ResetMap];
    if(m_OpenFile)
    {
        [m_OpenFile release];
        m_OpenFile = nil;
    }
}

-(void)OnViewOpen
{
	[super OnViewOpen];
}	

-(void)LoadFileHeader:(BTFileHeader*)pFileHeader
{
    if(pFileHeader && [pFileHeader IsVaid])
    {
        float w = self.frame.size.width-[GUILayout GetDefaultAlertUIEdge]*3.0;
        float h = [GUILayout GetDefaultListCellHeight];
        CGRect rect = CGRectMake(0, 0, w, h);
        GroupCell* pCell = [[GroupCell alloc] initWithFrame:rect];
        [pCell SetTitle:[StringFactory GetString_Game]]; 

        DualTextCell* p1 = [[DualTextCell alloc] initWithFrame:rect];
        [p1 SetLongerText];
        [p1 SetTextAlignment:enCELLTEXTALIGNMENT_RIGHT];
        [p1 SetTitle:[StringFactory GetString_GameFileName]]; 
        [p1 SetText:pFileHeader.m_OriginalFileName];
        [p1 SetSelectable:NO];
        [pCell AddCell:p1];

        DualTextCell* p2 = [[DualTextCell alloc] initWithFrame:rect];
        [p2 SetTextAlignment:enCELLTEXTALIGNMENT_RIGHT];
        [p2 SetTitle:[StringFactory GetString_CreatTime]]; 
        [p2 SetText:pFileHeader.m_CreationTime]; 
        [p2 SetSelectable:NO];
        [pCell AddCell:p2];

        DualTextCell* p3 = [[DualTextCell alloc] initWithFrame:rect];
        [p3 SetTextAlignment:enCELLTEXTALIGNMENT_RIGHT];
        [p3 SetTitle:[StringFactory GetString_LastUpdateTime]]; 
        [p3 SetText:pFileHeader.m_LastUpdateTime]; 
        [p3 SetSelectable:NO];
        [pCell AddCell:p3];
        
        BOOL bEasy = (pFileHeader.m_GameData.m_GameLevel == 0);
        enGridType enType = (enGridType)pFileHeader.m_GameData.m_GridType;
        enGridLayout enLayout = pFileHeader.m_GameData.m_GridLayout;
        enBubbleType enBubbleType = pFileHeader.m_GameData.m_Bubble;
        int nEdge = pFileHeader.m_GameData.m_GridEdge;
        NSString* textEdge = [NSString stringWithFormat:@"%i", nEdge];
        int nNumber = [GameConfiguration GetMinBubbleUnit:enType];
        CGImageRef srcIMage = [CPuzzleGrid GetDefaultLayoutImage:enType withLayout:enLayout withSize:nNumber withLevel:bEasy withBubble:enBubbleType];
        DualTextCell* p4 = [[DualTextCell alloc] initWithImage:srcIMage withFrame:rect];
        [p4 SetTextAlignment:enCELLTEXTALIGNMENT_RIGHT];
        [p4 SetTitle:@""]; 
        [p4 SetText:textEdge]; 
        [p4 SetSelectable:YES];
        ListCellDataInt* pPreviewID = [[ListCellDataInt alloc] init];
        pPreviewID.m_nData = FILEUI_GAMEPREVIEW;
        [p4 SetCellData:pPreviewID];
        [pCell AddCell:p4];
        

        
        DualTextCell* p5 = [[DualTextCell alloc] initWithFrame:rect];
        [p5 SetLongerText];
        [p5 SetTextAlignment:enCELLTEXTALIGNMENT_RIGHT];
        [p5 SetTitle:[StringFactory GetString_Creator]]; 
        [p5 SetText:pFileHeader.m_AutherData.m_Auther]; 
        [p5 SetSelectable:NO];
        [pCell AddCell:p5];

        DualTextCell* p6 = [[DualTextCell alloc] initWithFrame:rect];
        [p6 SetLongerText];
        [p6 SetTextAlignment:enCELLTEXTALIGNMENT_RIGHT];
        [p6 SetTitle:[StringFactory GetString_CreatorEmail]]; 
        [p6 SetText:pFileHeader.m_AutherData.m_Email]; 
        [p6 SetSelectable:NO];
        [pCell AddCell:p6];
        if(pFileHeader.m_AutherData.m_bLocationEnable)
        {    
            DualTextCell* p7 = [[DualTextCell alloc] initWithResource:@"locicon.png" withFrame:rect];
            [p7 SetTextAlignment:enCELLTEXTALIGNMENT_RIGHT];
            [p7 SetTitle:@""]; 
            [p7 SetText:@""]; 
            [p7 SetSelectable:YES];
            ListCellDataInt* pLocationID = [[ListCellDataInt alloc] init];
            pLocationID.m_nData = FILEUI_CREATORLOCATION;
            [p7 SetCellData:pLocationID];
            [pCell AddCell:p7];
        }    
        
        DualTextCell* p8 = [[DualTextCell alloc] initWithFrame:rect];
        [p8 SetTextAlignment:enCELLTEXTALIGNMENT_RIGHT];
        [p8 SetTitle:[StringFactory GetString_Device]]; 
        NSString* text = [StringFactory GetString_DeviceString:pFileHeader.m_DeviceData.m_nDeviceID];
        [p8 SetText:text]; 
        [p8 SetSelectable:NO];
        [pCell AddCell:p8];
        
        DualTextCell* p9 = [[DualTextCell alloc] initWithFrame:rect];
        [p9 SetLongerText];
        [p9 SetTextAlignment:enCELLTEXTALIGNMENT_RIGHT];
        [p9 SetTitle:[StringFactory GetString_AppVersion]]; 
        [p9 SetText:pFileHeader.m_DeviceData.m_AppVersion]; 
        [p9 SetSelectable:NO];
        [pCell AddCell:p9];
        
        [self AddCell:pCell];
        [pCell release];
        
    }
}


-(void)LoadNormalPlayRecord:(BTFilePlayRecord*) pRecord withIndex:(int)index
{
    if(pRecord)
    {
        float w = self.frame.size.width-[GUILayout GetDefaultAlertUIEdge]*3.0;
        float h = [GUILayout GetDefaultListCellHeight];
        CGRect rect = CGRectMake(0, 0, w, h);
        GroupCell* pCell = [[GroupCell alloc] initWithFrame:rect];
        NSString* title = [NSString stringWithFormat:@"%@ %i",[StringFactory GetString_Record], index+1];
        [pCell SetTitle:title]; 
        
        DualTextCell* p1 = [[DualTextCell alloc] initWithFrame:rect];
        [p1 SetTextAlignment:enCELLTEXTALIGNMENT_RIGHT];
        [p1 SetTitle:[StringFactory GetString_CreatTime]]; 
        [p1 SetText:pRecord.m_PlayerTime]; 
        [p1 SetSelectable:NO];
        [pCell AddCell:p1];
        
        DualTextCell* p2 = [[DualTextCell alloc] initWithFrame:rect];
        [p2 SetLongerText];
        [p2 SetTextAlignment:enCELLTEXTALIGNMENT_RIGHT];
        [p2 SetTitle:[StringFactory GetString_GamePlayer]]; 
        [p2 SetText:pRecord.m_PlayerData.m_Auther]; 
        [p2 SetSelectable:NO];
        [pCell AddCell:p2];
        
        DualTextCell* p3 = [[DualTextCell alloc] initWithFrame:rect];
        [p3 SetLongerText];
        [p3 SetTextAlignment:enCELLTEXTALIGNMENT_RIGHT];
        [p3 SetTitle:[StringFactory GetString_CreatorEmail]]; 
        [p3 SetText:pRecord.m_PlayerData.m_Email]; 
        [p3 SetSelectable:NO];
        [pCell AddCell:p3];
        
        if(pRecord.m_PlayerData.m_bLocationEnable)
        {    
            DualTextCell* p4 = [[DualTextCell alloc] initWithResource:@"locicon.png" withFrame:rect];
            [p4 SetTextAlignment:enCELLTEXTALIGNMENT_RIGHT];
            [p4 SetTitle:@""]; 
            [p4 SetText:@""]; 
            [p4 SetSelectable:YES];
            ListCellDataInt* pLocationID = [[ListCellDataInt alloc] init];
            pLocationID.m_nData = FILEUI_LASTFIXEDID+index;
            [p4 SetCellData:pLocationID];
            [pCell AddCell:p4];
        }    
        
        DualTextCell* p5 = [[DualTextCell alloc] initWithFrame:rect];
        [p5 SetTextAlignment:enCELLTEXTALIGNMENT_RIGHT];
        [p5 SetTitle:[StringFactory GetString_Device]]; 
        NSString* text = [StringFactory GetString_DeviceString:pRecord.m_DeviceData.m_nDeviceID];
        [p5 SetText:text]; 
        [p5 SetSelectable:NO];
        [pCell AddCell:p5];
        
        DualTextCell* p6 = [[DualTextCell alloc] initWithFrame:rect];
        [p6 SetLongerText];
        [p6 SetTextAlignment:enCELLTEXTALIGNMENT_RIGHT];
        [p6 SetTitle:[StringFactory GetString_AppVersion]]; 
        [p6 SetText:pRecord.m_DeviceData.m_AppVersion]; 
        [p6 SetSelectable:NO];
        [pCell AddCell:p6];

        DualTextCell* p7 = [[DualTextCell alloc] initWithFrame:rect];
        [p7 SetTextAlignment:enCELLTEXTALIGNMENT_RIGHT];
        [p7 SetTitle:[StringFactory GetString_PlayingStep]];
        NSString* stepstring = [NSString stringWithFormat:@"%i", [pRecord.m_PlaySteps count]];
        [p7 SetText:stepstring]; 
        [p7 SetSelectable:NO];
        [pCell AddCell:p7];

        DualTextCell* p8 = [[DualTextCell alloc] initWithFrame:rect];
        [p8 SetTextAlignment:enCELLTEXTALIGNMENT_RIGHT];
        [p8 SetTitle:[StringFactory GetString_Completion]];
        if(pRecord.m_bCompleted == NO)
            [p8 SetText:[StringFactory GetString_No]]; 
        else
            [p8 SetText:[StringFactory GetString_Yes]]; 
        [p8 SetSelectable:NO];
        [pCell AddCell:p8];
        
        [self AddCell:pCell];
        [pCell release];
    }    
}

-(void)LoadFilePlayRecord:(BTFile*)pGameFile
{
    int nCount = 0;
    if(pGameFile && pGameFile.m_PlayRecordList)
        nCount = [pGameFile.m_PlayRecordList count];
    
    if(0 < nCount)
    {
        for(int i = 0; i < nCount; ++i)
        {
            BTFilePlayRecord* pRecord = [pGameFile.m_PlayRecordList objectAtIndex:i];
            if(pRecord)
            {
                [self LoadNormalPlayRecord:pRecord withIndex:i];
            }
        }
    }
    
}

-(void)LoadFileInformation:(BTFile*)pGameFile
{
    [self UpdateViewLayout];    
    if(pGameFile && [pGameFile IsValid])
    {
        [self LoadFileHeader:pGameFile.m_FileHeader];
        [self LoadFilePlayRecord:pGameFile];
        [self UpdateLocationView:pGameFile];
    }
    [m_ListView UpdateContentSizeByContentView];	
}

-(void)OpenFile:(NSURL*)file
{
    if(m_OpenFile)
    {
        [m_OpenFile release];
        m_OpenFile = nil;
    }
    m_OpenFile = [[BTFile alloc] init];
    [m_OpenFile SetFileURL:file];
    [m_OpenFile LoadDocument];
    [self LoadFileInformation:m_OpenFile];
}


@end
