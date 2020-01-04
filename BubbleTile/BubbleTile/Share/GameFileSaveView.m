//
//  GameFileSaveView.m
//  BubbleTile
//
//  Created by Zhaohui Xing on 12-02-07.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "GameFileSaveView.h"
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
#import "ApplicationConfigure.h"


@implementation GameFileSaveView

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
        
		rect = CGRectMake(xOffset+(bw+[GUILayout GetDefaultAlertUIEdge])*2.0, sy, bw, bh);
        m_btnShare = [[CustomGlossyButton alloc] initWithFrame:rect];
        [m_btnShare SetGreenDisplay];
        [m_btnShare RegisterButton:self withID:FILEUI_SHARE withLabel:[StringFactory GetString_Share]];
        [self addSubview:m_btnShare];
        if(![ApplicationConfigure CanSendEmail])
            m_btnShare.hidden = YES;
        [m_btnShare release];
        
		rect = frame;
		rect.origin.x = [GUILayout GetDefaultAlertUIEdge]*1.5;
        rect.size.width = rect.size.width-[GUILayout GetDefaultAlertUIEdge]*3.0;
		rect.origin.y += sy+bh+[GUILayout GetDefaultAlertUIEdge]/2.0;
		rect.size.height -= rect.origin.y+[GUILayout GetDefaultAlertUIEdge]*1.5;
		m_ListView = [[ScrollListView alloc] initWithFrame:rect];
		[self addSubview:m_ListView];
		
		[m_ListView release];
		[self bringSubviewToFront:m_ListView];
        
        
		rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        m_MapView = [[LocationView alloc] initWithFrame:rect];
        [self addSubview:m_MapView];
        m_MapView.hidden = YES;
        [self sendSubviewToBack:m_MapView];
        [m_MapView release];
        m_Timer = nil;
        m_UserLocationUI = nil;
        m_ActiveEditingCell = nil;
        m_TextEditor = [[SimpleTextEditor alloc] initWithFrame:rect];
        [m_TextEditor SetButtonCaptions:[StringFactory GetString_OK] cancelString:[StringFactory GetString_Cancel]];
        m_TextEditor.hidden = YES;
        [self addSubview:m_TextEditor];
        [self sendSubviewToBack:m_TextEditor];
        [m_TextEditor release];
    }
    return self;
}

-(void)dealloc
{
    if(m_Timer != nil)
	{
		[m_Timer invalidate];
		[m_Timer release];
		m_Timer = nil;
	}
    [super dealloc];
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
    [m_MapView setFrame:rect];
    [m_MapView UpdateViewLayout];
    
    [m_TextEditor setFrame:rect];
    [m_TextEditor UpdateViewLayout];
    
    [self setNeedsDisplay];
}	

- (void)handleTimer:(NSTimer*)timer 
{
    if(m_bNewGame)
    {
        ApplicationController* pController = (ApplicationController*)[GUILayout GetMainViewController];
        if(pController && [pController GetFileManager].m_PlayingFile && [pController GetFileManager].m_PlayingFile.m_FileHeader && [pController GetFileManager].m_PlayingFile.m_FileHeader.m_AutherData && m_UserLocationUI != nil)
        {
            if(([m_UserLocationUI IsSelectable] || [m_UserLocationUI GetSwitchOnOff]) && [[pController GetFileManager].m_PlayingFile.m_FileHeader.m_AutherData IsLocationEnable] == NO)
            {
                [m_UserLocationUI SetSelectionState:NO];
                [m_UserLocationUI SetSelectable:NO];
                [m_UserLocationUI SetSwitch:NO];
            }
        }    
    }
}	

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	[self drawBackground:context inRect: rect];
}

-(void)HandleFileBackupiCloud
{
    if(m_bNewGame)
    {
    }
    else 
    {
        
    }
}

-(BOOL)SaveFileToLocal
{
    ApplicationController* pController = (ApplicationController*)[GUILayout GetMainViewController];
    if(!pController || ![pController GetFileManager])
    {
        return NO;
    }    
    if(m_bNewGame || [pController GetFileManager].m_PlayingFile._FileURL == nil)
    {
        NSString* newFileNoExt = [pController GetFileManager].m_PlayingFile.m_FileHeader.m_OriginalFileName;
        NSString* newFile = [NSString stringWithFormat:@"%@.%@", newFileNoExt, [BTFileManager GetBTFileExtension]];
        NSURL* appFolder = [BTFileManager GetAppGameFilesFolderPath];
        NSURL* newFileURL = [appFolder URLByAppendingPathComponent:newFile isDirectory:NO];
        BOOL bFileExist = [BTFileManager FileExist:newFileURL];
        if(bFileExist)
        {
            NSString* warnText = [StringFactory GetString_FileExistWarn];
            NSString* overwrite = [StringFactory GetString_Overwrite];
            NSString* keepboth = [StringFactory GetString_KeepBoth];
            int nRet = [CustomModalAlertView Ask:warnText withButton1:overwrite withButton2:keepboth];
            if(nRet != 0)
            {
                NSString* newFile1 = [BTFileManager GetAvaliableLocalFileName:newFileNoExt withFileExtenson:NO];
                [[pController GetFileManager].m_PlayingFile.m_FileHeader SetFileName:[NSString stringWithFormat:@"%@", newFile1]];
                newFile = [NSString stringWithFormat:@"%@.%@", newFile1, [BTFileManager GetBTFileExtension]];
                newFileURL = [appFolder URLByAppendingPathComponent:newFile isDirectory:NO];
            }    
        }
        [[pController GetFileManager].m_PlayingFile SetFileURL:newFileURL];
    }
    [[pController GetFileManager].m_PlayingFile SaveDocument];
    
    return YES;
}


-(void)HandleFileSave
{
    ApplicationController* pController = (ApplicationController*)[GUILayout GetMainViewController];
    if(!pController || ![pController GetFileManager])
    {
        return;
    }    
    if([self SaveFileToLocal])
    {    
        if([[pController GetFileManager] CanAccessiClound])
        {
            [self HandleFileBackupiCloud];
        }
    }
}

-(void)HandleFileSaveAndEmail
{
    ApplicationController* pController = (ApplicationController*)[GUILayout GetMainViewController];
    if(!pController || ![pController GetFileManager])
    {
        return;
    }    
    if([self SaveFileToLocal])
    {
        NSURL* fileName = [[pController GetFileManager].m_PlayingFile._FileURL copy];
        [pController ShareGameByEmail:fileName];
    }
}

-(void)OnButtonClick:(int)nButtonID
{
    if(nButtonID == FILEUI_OK)
    {
        [self HandleFileSave];
    }
    else if(nButtonID == FILEUI_SHARE)
    {
        [self HandleFileSaveAndEmail];
    }
    [self CloseView:YES];
}

-(void)UpdateLocationView:(BTFile*)pGameFile
{
    if(!pGameFile || !pGameFile.m_FileHeader)
        return;
    
    [m_MapView ResetMap];
    if(m_bNewGame && [pGameFile.m_FileHeader.m_AutherData IsLocationEnable])
    {
        NSString* title = pGameFile.m_FileHeader.m_AutherData.m_Auther;//[pGameFile.m_FileHeader.m_AutherData.m_Auther copy];
        NSString* text = [StringFactory GetString_GameCreator];
        float fLatitude = pGameFile.m_FileHeader.m_AutherData.m_fLatitude;
        float fLongitude = pGameFile.m_FileHeader.m_AutherData.m_fLongitude;
        [ApplicationConfigure SetupLocationData:fLatitude withLongitude:fLongitude];
        [m_MapView AddMapAnnotation:nil withTitle:title withText:text withLatitude:fLatitude withLongitude:fLongitude isMaster:YES isMe:YES];
    }
    else
    {    
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
                    if(i == nCount-1)
                        [m_MapView AddMapAnnotation:nil withTitle:title withText:text withLatitude:fLatitude withLongitude:fLongitude isMaster:NO isMe:YES];
                    else
                        [m_MapView AddMapAnnotation:nil withTitle:title withText:text withLatitude:fLatitude withLongitude:fLongitude isMaster:NO isMe:NO];
                }
            }
        }
    }
}

-(void)OnLocationSwitch:(NSNotification *)notification
{
    ApplicationController* pController = (ApplicationController*)[GUILayout GetMainViewController];
    if(!pController || ![pController GetFileManager].m_PlayingFile || ![pController GetFileManager].m_PlayingFile.m_FileHeader)
    {
        return;
    }    
    
    if(notification)
    {    
        SwitchIconCell* pCell = [notification object];
        BOOL bOn = [pCell GetSwitchOnOff];
        if(bOn)
        {
            if ([CustomModalAlertView Ask:[StringFactory GetString_GPSSharingWarning] withButton1:[StringFactory GetString_No] withButton2:[StringFactory GetString_Yes]] == ALERT_NO)
            {
                [pCell SetSwitch:NO];
                [pCell SetSelectionState:NO];
                [pCell SetSelectable:NO];
                if(m_bNewGame && [pCell GetControlID] == FILEUI_CREATORLOCATION)
                {
                    [[pController GetFileManager].m_PlayingFile.m_FileHeader.m_AutherData SetLocationEnable:NO];
                } 
                else if(!m_bNewGame && [pCell GetControlID] == FILEUI_MYLASTPLAYLOCATION)
                {
                    int nCount = [[pController GetFileManager].m_PlayingFile.m_PlayRecordList count];
                    if(0 < nCount)
                    {
                        [((BTFilePlayRecord*)[[pController GetFileManager].m_PlayingFile.m_PlayRecordList objectAtIndex:(nCount-1)]).m_PlayerData SetLocationEnable:NO];
                    }
 
                }
            }
            else 
            {
                [pCell SetSelectable:YES];
                if(m_bNewGame && [pCell GetControlID] == FILEUI_CREATORLOCATION)
                {
                    [[pController GetFileManager].m_PlayingFile.m_FileHeader.m_AutherData SetLocationEnable:YES];
                    BOOL bRet = [[pController GetFileManager].m_PlayingFile.m_FileHeader.m_AutherData FetchLocation];
                    if(!bRet || ![[pController GetFileManager].m_PlayingFile.m_FileHeader.m_AutherData IsLocationEnable])
                    {
                        [pCell SetSwitch:NO];
                        [pCell SetSelectionState:NO];
                        [pCell SetSelectable:NO];
                        [[pController GetFileManager].m_PlayingFile.m_FileHeader.m_AutherData SetLocationEnable:NO];
                    }
                }
                else if(!m_bNewGame && [pCell GetControlID] == FILEUI_MYLASTPLAYLOCATION)
                {
                    int nCount = [[pController GetFileManager].m_PlayingFile.m_PlayRecordList count];
                    if(0 < nCount)
                    {    
                        [((BTFilePlayRecord*)[[pController GetFileManager].m_PlayingFile.m_PlayRecordList objectAtIndex:(nCount-1)]).m_PlayerData SetLocationEnable:YES];
                        BOOL bRet = [((BTFilePlayRecord*)[[pController GetFileManager].m_PlayingFile.m_PlayRecordList objectAtIndex:(nCount-1)]).m_PlayerData FetchLocation];
                        if(!bRet || ![((BTFilePlayRecord*)[[pController GetFileManager].m_PlayingFile.m_PlayRecordList objectAtIndex:(nCount-1)]).m_PlayerData IsLocationEnable])
                        {
                            [pCell SetSwitch:NO];
                            [pCell SetSelectionState:NO];
                            [pCell SetSelectable:NO];
                            [((BTFilePlayRecord*)[[pController GetFileManager].m_PlayingFile.m_PlayRecordList objectAtIndex:(nCount-1)]).m_PlayerData SetLocationEnable:NO];
                        }
                    }    
                }
                
            }
        }
        else 
        {
            [pCell SetSelectionState:NO];
            [pCell SetSelectable:NO];
            if(m_bNewGame && [pCell GetControlID] == FILEUI_CREATORLOCATION)
            {
                [[pController GetFileManager].m_PlayingFile.m_FileHeader.m_AutherData SetLocationEnable:NO];
            }    
            else if(!m_bNewGame && [pCell GetControlID] == FILEUI_MYLASTPLAYLOCATION)
            {
                int nCount = [[pController GetFileManager].m_PlayingFile.m_PlayRecordList count];
                if(0 < nCount)
                {    
                    [((BTFilePlayRecord*)[[pController GetFileManager].m_PlayingFile.m_PlayRecordList objectAtIndex:(nCount-1)]).m_PlayerData SetLocationEnable:NO];
                }
            }
        }
    }    
}

-(void)OnDeviceSwitch:(NSNotification *)notification
{
    ApplicationController* pController = (ApplicationController*)[GUILayout GetMainViewController];
    if(!pController || ![pController GetFileManager].m_PlayingFile || ![pController GetFileManager].m_PlayingFile.m_FileHeader)
    {
        return;
    }    
    
    if(notification)
    {    
        SwitchCell* pCell = [notification object];
        BOOL bOn = [pCell GetSwitchOnOff];
        int nDevice = -1;
        if(bOn)
        {
            NSString* title = [ApplicationConfigure GetDeviceTypeString];
            [pCell SetTitle:title];
            nDevice = [ApplicationConfigure GetDeviceID];
        }
        else 
        {
            [pCell SetTitle:[StringFactory GetString_Device]];
        }
        if(m_bNewGame)
        {    
            [pController GetFileManager].m_PlayingFile.m_FileHeader.m_DeviceData.m_nDeviceID = nDevice;
        }    
        else 
        {
            int nCount = [[pController GetFileManager].m_PlayingFile.m_PlayRecordList count];
            if(0 < nCount)
            {    
                ((BTFilePlayRecord*)[[pController GetFileManager].m_PlayingFile.m_PlayRecordList objectAtIndex:(nCount-1)]).m_DeviceData.m_nDeviceID = nDevice;
            }
        }
    }    
}

-(void)OpenGamePreview
{
    ApplicationController* pController = (ApplicationController*)[GUILayout GetMainViewController];
    if(pController && [pController GetFileManager].m_PlayingFile && [pController GetFileManager].m_PlayingFile.m_FileHeader)
    {
        BOOL bEasy = ([pController GetFileManager].m_PlayingFile.m_FileHeader.m_GameData.m_GameLevel == 0);
        enGridType enType = (enGridType)[pController GetFileManager].m_PlayingFile.m_FileHeader.m_GameData.m_GridType;
        enGridLayout enLayout = [pController GetFileManager].m_PlayingFile.m_FileHeader.m_GameData.m_GridLayout;
        enBubbleType enBubbleType = [pController GetFileManager].m_PlayingFile.m_FileHeader.m_GameData.m_Bubble;
        int nEdge = [pController GetFileManager].m_PlayingFile.m_FileHeader.m_GameData.m_GridEdge;
        NSArray* setting = [pController GetFileManager].m_PlayingFile.m_FileHeader.m_GameData.m_GameSet;
        [pController OpenPreviewView:enType withLayout:enLayout withSize:nEdge withLevel:bEasy withBubble:enBubbleType withSetting:setting];
    }    
}

-(void)OpenLocationView
{
    ApplicationController* pController = (ApplicationController*)[GUILayout GetMainViewController];
    if(!pController || ![pController GetFileManager].m_PlayingFile || ![pController GetFileManager].m_PlayingFile.m_FileHeader)
    {
        return;
    }  
    [[pController GetFileManager].m_PlayingFile.m_FileHeader.m_AutherData FetchLocation];
    [self UpdateLocationView:[pController GetFileManager].m_PlayingFile];
    
    if(0 < [m_MapView GetMapLocations])
    {    
        [m_MapView OpenView];
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
                    case FILEUI_FILENAME:
                    case FILEUI_CREATORNAME:
                    case FILEUI_CREATOREMAIL:
                    case FILEUI_MYLASTPLAYNAME:
                    case FILEUI_MYLASTPLAYEMAIL:
                    {
                        if([p isKindOfClass:[DualTextCell class]])
                        {
                            m_ActiveEditingCell = (DualTextCell*)p;
                            [m_ActiveEditingCell SetTextEditing:&m_TextEditor];
                            [m_TextEditor OpenTextEditor:m_ActiveEditingCell withText:[m_ActiveEditingCell GetText]];
                        }
                        break;
                    }    
                    case FILEUI_GAMEPREVIEW:
                        [self OpenGamePreview];
                        break;
                    case FILEUI_CREATORLOCATION:
                    case FILEUI_MYLASTPLAYLOCATION:    
                        [self OpenLocationView];
                        break;
                    default:
                        if(FILEUI_LASTFIXEDID < nCellEventID)
                        {
                            [self OpenLocationView];
                        }
                        break;
                }
            }
        }
    }
}

-(void)OnTextEditingDone
{
    ApplicationController* pController = (ApplicationController*)[GUILayout GetMainViewController];
    if(!pController || ![pController GetFileManager].m_PlayingFile || ![pController GetFileManager].m_PlayingFile.m_FileHeader)
    {
        return;
    }    
    if(m_ActiveEditingCell)
    {
        NSString* text = [m_ActiveEditingCell GetText];
        id<ListCellDataTemplate> data = [m_ActiveEditingCell GetCellData];
        if(data)
        {
            if([data GetDataType] == enLISTCELLDATA_INT)
            {
                int nCellEventID = [(ListCellDataInt*)data GetData];
                switch (nCellEventID) 
                {
                    case FILEUI_FILENAME:
                        [[pController GetFileManager].m_PlayingFile.m_FileHeader SetFileName:text];
                        break;
                    case FILEUI_CREATORNAME:
                        [pController GetFileManager].m_PlayingFile.m_FileHeader.m_AutherData.m_Auther = text;
                        break;
                    case FILEUI_CREATOREMAIL:
                        [pController GetFileManager].m_PlayingFile.m_FileHeader.m_AutherData.m_Email = text;
                        break;
                    case FILEUI_MYLASTPLAYNAME:
                    {
                        int nCount = [[pController GetFileManager].m_PlayingFile.m_PlayRecordList count];
                        if(0 < nCount)
                        {
                            ((BTFilePlayRecord*)[[pController GetFileManager].m_PlayingFile.m_PlayRecordList objectAtIndex:(nCount-1)]).m_PlayerData.m_Auther = text;
                        }
                        break;
                    }    
                    case FILEUI_MYLASTPLAYEMAIL:
                    {    
                        int nCount = [[pController GetFileManager].m_PlayingFile.m_PlayRecordList count];
                        if(0 < nCount)
                        {
                            ((BTFilePlayRecord*)[[pController GetFileManager].m_PlayingFile.m_PlayRecordList objectAtIndex:(nCount-1)]).m_PlayerData.m_Email = text;
                        }
                        break;
                    }    
                    default:
                        break;
                }
            }
        }
        m_ActiveEditingCell = nil;
    }
}

-(void)OnViewClose
{
    if(m_Timer != nil)
	{
		[m_Timer invalidate];
		[m_Timer release];
		m_Timer = nil;
	}
    m_UserLocationUI = nil;
    [self RemoveAllCells];
    [super OnViewClose];
    if([self.superview respondsToSelector:@selector(OnFileSaveViewClosed)])
    {
        [self.superview performSelector:@selector(OnFileSaveViewClosed)];
    }
}

-(void)OnViewOpen
{
	[super OnViewOpen];
    [self RemoveAllCells];
    m_UserLocationUI = nil;
    [m_MapView ResetMap];
    [self HandleGameData];
	if(m_Timer == nil)
	{	
		srandom(time(0));
		m_Timer = [[NSTimer scheduledTimerWithTimeInterval:1000 
													target:self 
												  selector:@selector(handleTimer:)
												  userInfo:nil
												   repeats: YES 
					] retain]; 
	}
}	

-(void)LoadFileHeader:(BTFileHeader*)pFileHeader
{
    if(pFileHeader && [pFileHeader IsVaid])
    {
        float w = self.frame.size.width-[GUILayout GetDefaultAlertUIEdge]*3.0;
        float h = [GUILayout GetDefaultListCellHeight];
    //    float lh = [GameLayout GetDefaultScoreLabelHeight];
        
    //    NSString* szTitle = @"";
        
        CGRect rect = CGRectMake(0, 0, w, h);
        GroupCell* pCell = [[GroupCell alloc] initWithFrame:rect];
        [pCell SetTitle:[StringFactory GetString_Game]]; 

        DualTextCell* p1 = [[DualTextCell alloc] initWithFrame:rect];
        [p1 SetLongerText];
        [p1 SetTextAlignment:enCELLTEXTALIGNMENT_RIGHT];
        [p1 SetTitle:[StringFactory GetString_GameFileName]]; 
        [p1 SetText:pFileHeader.m_OriginalFileName];
        if(m_bNewGame)
        {    
            [p1 SetSelectable:YES];
            ListCellDataInt* pData = [[ListCellDataInt alloc] init];
            pData.m_nData = FILEUI_FILENAME;
            [p1 SetCellData:pData];
       }    
        else
        {    
            [p1 SetSelectable:NO];
        }    
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
        if(m_bNewGame)
        {    
            [p5 SetSelectable:YES];
            ListCellDataInt* pData = [[ListCellDataInt alloc] init];
            pData.m_nData = FILEUI_CREATORNAME;
            [p5 SetCellData:pData];
        }    
        else
        {    
            [p5 SetSelectable:NO];
        }    
        [pCell AddCell:p5];

        DualTextCell* p6 = [[DualTextCell alloc] initWithFrame:rect];
        [p6 SetLongerText];
        [p6 SetTextAlignment:enCELLTEXTALIGNMENT_RIGHT];
        [p6 SetTitle:[StringFactory GetString_CreatorEmail]]; 
        [p6 SetText:pFileHeader.m_AutherData.m_Email]; 
        if(m_bNewGame)
        {    
            [p6 SetSelectable:YES];
            ListCellDataInt* pData = [[ListCellDataInt alloc] init];
            pData.m_nData = FILEUI_CREATOREMAIL;
            [p6 SetCellData:pData];
        }    
        else
        {    
            [p6 SetSelectable:NO];
        }    
        [pCell AddCell:p6];

        if(m_bNewGame)
        {    
            SwitchIconCell* p7 = [[SwitchIconCell alloc] initWithFrame:rect withImage:@"locicon.png" withDisableImage:@"locicon2.png"];
            [p7 RegisterControlID:FILEUI_CREATORLOCATION];
            [p7 RegisterControlEvent:self withHandler:@selector(OnLocationSwitch:)];
            [p7 SetSelectable:NO];
            [p7 SetSwitch:NO];
            ListCellDataInt* pLocationID = [[ListCellDataInt alloc] init];
            pLocationID.m_nData = FILEUI_CREATORLOCATION;
            [p7 SetCellData:pLocationID];
            [pCell AddCell:p7];
            m_UserLocationUI = p7;
        }    
        else
        {
            if([pFileHeader.m_AutherData IsLocationEnable])
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
            else
            {
                DualTextCell* p7 = [[DualTextCell alloc] initWithResource:@"locicon2.png" withFrame:rect];
                [p7 SetTextAlignment:enCELLTEXTALIGNMENT_RIGHT];
                [p7 SetTitle:@""]; 
                [p7 SetText:@""]; 
                [p7 SetSelectable:NO];
                [pCell AddCell:p7];
            }    
        }    
        
        if(m_bNewGame)
        {
            SwitchCell* p8 = [[SwitchCell alloc] initWithFrame:rect];
            [p8 SetTitle:[StringFactory GetString_Device]]; 
            [p8 SetSelectable:NO];
            [p8 SetSwitch:NO];
            [p8 RegisterControlID:FILEUI_CREATORLOCATION];
            [p8 RegisterControlEvent:self withHandler:@selector(OnDeviceSwitch:)];
            [pCell AddCell:p8];
        }
        else
        {
            DualTextCell* p8 = [[DualTextCell alloc] initWithFrame:rect];
            [p8 SetTextAlignment:enCELLTEXTALIGNMENT_RIGHT];
            [p8 SetTitle:[StringFactory GetString_Device]]; 
            NSString* text = [StringFactory GetString_DeviceString:pFileHeader.m_DeviceData.m_nDeviceID];
            [p8 SetText:text]; 
            [p8 SetSelectable:NO];
            [pCell AddCell:p8];
        }
        
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

-(void)LoadMyLastPlayRecord:(BTFilePlayRecord*) pRecord withIndex:(int)index
{
    if(pRecord)
    {
        float w = self.frame.size.width-[GUILayout GetDefaultAlertUIEdge]*3.0;
        float h = [GUILayout GetDefaultListCellHeight];
        CGRect rect = CGRectMake(0, 0, w, h);
        GroupCell* pCell = [[GroupCell alloc] initWithFrame:rect];
        NSString* title = [NSString stringWithFormat:@"%@ %i (%@)",[StringFactory GetString_Record], index+1, [StringFactory GetString_Me]];
        [pCell SetTitle:title]; 
        
        DualTextCell* p1 = [[DualTextCell alloc] initWithFrame:rect];
        [p1 SetTextAlignment:enCELLTEXTALIGNMENT_RIGHT];
        [p1 SetTitle:[StringFactory GetString_CreatTime]]; 
        [p1 SetText:pRecord.m_PlayerTime]; 
        [p1 SetSelectable:NO];
        [pCell AddCell:p1];

        if(m_bNewGame == NO)
        {
            DualTextCell* p2 = [[DualTextCell alloc] initWithFrame:rect];
            [p2 SetLongerText];
            [p2 SetTextAlignment:enCELLTEXTALIGNMENT_RIGHT];
            [p2 SetTitle:[StringFactory GetString_GamePlayer]]; 
            [p2 SetText:pRecord.m_PlayerData.m_Auther]; 
            ListCellDataInt* pData = [[ListCellDataInt alloc] init];
            pData.m_nData = FILEUI_MYLASTPLAYNAME;
            [p2 SetCellData:pData];
            [p2 SetSelectable:YES];
            [pCell AddCell:p2];
            
            DualTextCell* p3 = [[DualTextCell alloc] initWithFrame:rect];
            [p3 SetLongerText];
            [p3 SetTextAlignment:enCELLTEXTALIGNMENT_RIGHT];
            [p3 SetTitle:[StringFactory GetString_CreatorEmail]]; 
            [p3 SetText:pRecord.m_PlayerData.m_Email]; 
            [p3 SetSelectable:YES];
            ListCellDataInt* pData2 = [[ListCellDataInt alloc] init];
            pData2.m_nData = FILEUI_MYLASTPLAYEMAIL;
            [p3 SetCellData:pData2];
            [pCell AddCell:p3];
            
            SwitchIconCell* p4 = [[SwitchIconCell alloc] initWithFrame:rect withImage:@"locicon.png" withDisableImage:@"locicon2.png"];
            [p4 RegisterControlID:FILEUI_MYLASTPLAYLOCATION];
            [p4 RegisterControlEvent:self withHandler:@selector(OnLocationSwitch:)];
            [p4 SetSelectable:NO];
            [p4 SetSwitch:NO];
            ListCellDataInt* pLocationID = [[ListCellDataInt alloc] init];
            pLocationID.m_nData = FILEUI_MYLASTPLAYLOCATION;
            [p4 SetCellData:pLocationID];
            [pCell AddCell:p4];
            m_UserLocationUI = p4;
      
            
            SwitchCell* p5 = [[SwitchCell alloc] initWithFrame:rect];
            [p5 SetTitle:[StringFactory GetString_Device]]; 
            [p5 SetSelectable:NO];
            [p5 SetSwitch:NO];
            [p5 RegisterControlID:FILEUI_CREATORLOCATION];
            [p5 RegisterControlEvent:self withHandler:@selector(OnDeviceSwitch:)];
            [pCell AddCell:p5];
            
            DualTextCell* p6 = [[DualTextCell alloc] initWithFrame:rect];
            [p6 SetLongerText];
            [p6 SetTextAlignment:enCELLTEXTALIGNMENT_RIGHT];
            [p6 SetTitle:[StringFactory GetString_AppVersion]]; 
            [p6 SetText:pRecord.m_DeviceData.m_AppVersion]; 
            [p6 SetSelectable:NO];
            [pCell AddCell:p6];
            
        }
        
        
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
        
        if([pRecord.m_PlayerData IsLocationEnable])
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
        else
        {
            DualTextCell* p4 = [[DualTextCell alloc] initWithResource:@"locicon2.png" withFrame:rect];
            [p4 SetTextAlignment:enCELLTEXTALIGNMENT_RIGHT];
            [p4 SetTitle:@""]; 
            [p4 SetText:@""]; 
            [p4 SetSelectable:NO];
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
                if(i == nCount-1)
                {
                    [self LoadMyLastPlayRecord:pRecord withIndex:i];
                }
                else 
                {
                    [self LoadNormalPlayRecord:pRecord withIndex:i];
                }
            }
        }
    }
    
}

-(void)LoadFileInformation:(BTFile*)pGameFile
{
    if(pGameFile && [pGameFile IsValid])
    {
        [self LoadFileHeader:pGameFile.m_FileHeader];
        [self LoadFilePlayRecord:pGameFile];
        [self UpdateLocationView:pGameFile];
    }
    [m_ListView UpdateContentSizeByContentView];	
}

-(void)HandleGameData
{
    ApplicationController* pController = (ApplicationController*)[GUILayout GetMainViewController];
    if(pController)
    {
        m_bNewGame = ![pController HasGameFileData];
        if(m_bNewGame)
        {
            [pController LoadNewGameToFile];
            BTFileManager* pFileManager = [pController GetFileManager];
            if(pFileManager && pFileManager.m_PlayingFile)
            {    
                [self LoadFileInformation:pFileManager.m_PlayingFile];
            }    
        }
        else 
        {
            [pController LoadLastGamePlayToFile];
            BTFileManager* pFileManager = [pController GetFileManager];
            if(pFileManager && pFileManager.m_PlayingFile)
            {    
                [self LoadFileInformation:pFileManager.m_PlayingFile];
            }    
        }
    }
}

@end
