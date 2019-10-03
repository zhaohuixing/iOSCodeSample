//
//  ConfigurationView.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#include "libinc.h"
#import "ConfigurationView.h"
#import "GUIEventLoop.h"
#import "ImageLoader.h"
#import "ApplicationConfigure.h"
#import "Configuration.h"
#import "GUILayout.h"
#import "TextCheckboxCell.h"
#import "LabelCell.h"
#import "GroupCell.h"
#import "SwitchCell.h"
#import "SwitchIconCell.h"
#import "ApplicationResource.h"
#import "StringFactory.h"
#import "ListCellData.h"
#import "ScoreRecord.h"
#import "CustomModalAlertView.h"
#import "RenderHelper.h"
#import "GameCenterConstant.h"
#import "UIDevice-Reachability.h"

@implementation ConfigurationView


-(void)OnReloadConfigure
{
    [self LoadSkill];
    [self LoadLevel];
    m_bReloadList = NO;
}

- (id)initWithFrame:(CGRect)frame 
{
    
    self = [super initWithFrame:frame];
    if (self) 
	{
        // Initialization code.
		self.backgroundColor = [ImageLoader GetDefaultViewBackgroundColor];
		float size = 80;
		if([ApplicationConfigure iPADDevice])
			size = 120;
		
		//m_Pattern = [ImageLoader CreateImageFillPattern:@"iTunesArtwork.png" withWidth:size withHeight:size isFlipped:YES];
       // [GUIEventLoop RegisterEvent:GUIID_RELOADCONFIGURATIONLIST eventHandler:@selector(OnReloadConfigure) eventReceiver:self eventSender:nil];
        [self IntializeCongfigureList];
        m_bReloadList = NO;
    }
    return self;
}

- (void)dealloc 
{
	//CGPatternRelease(m_Pattern);
    [super dealloc];
}

-(void)UpdateViewLayout
{
	[super UpdateViewLayout];
	[self setNeedsDisplay];
}	

- (void)drawBackground:(CGContextRef)context inRect:(CGRect)rect
{
	CGFloat fAlpha = [ImageLoader GetDefaultViewFillAlpha];
    [RenderHelper DrawFlyingCowIconPatternFill:context withAlpha:fAlpha atRect:rect];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	[self drawBackground:context inRect: rect];
}

-(BOOL)CanSetLevel:(int)nCurrentLevel
{
    BOOL bRet = YES;
    int nTotalScore = [ScoreRecord getTotalWinScore];
    int nCurrentSkill = [Configuration getGameSkill];
    int nScoreMaxSkill = [Configuration getCanGamePlaySkillAtScore:nTotalScore];
    int nScoreMaxLevel = [Configuration getCanGamePlayLevelAtScore:nTotalScore];
    
    int nCurrent = nCurrentSkill + nCurrentLevel*3;
    int nThreshold = nScoreMaxSkill + nScoreMaxLevel*3;
    
    if(nThreshold < nCurrent)
    {
        [CustomModalAlertView SimpleSay:[StringFactory GetString_CannotPlayerSelectedGame] closeButton:[StringFactory GetString_Close]];
        bRet = NO;
    }
    
    return bRet;
}

-(BOOL)CanSetSkill:(int)nCurrentSkill
{
    BOOL bRet = YES;
    int nTotalScore = [ScoreRecord getTotalWinScore];
    int nCurrentLevel = [Configuration getGameLevel];
    int nScoreMaxSkill = [Configuration getCanGamePlaySkillAtScore:nTotalScore];
    int nScoreMaxLevel = [Configuration getCanGamePlayLevelAtScore:nTotalScore];
    
    int nCurrent = nCurrentSkill + nCurrentLevel*3;
    int nThreshold = nScoreMaxSkill + nScoreMaxLevel*3;
    
    if(nThreshold < nCurrent)
    {
        [CustomModalAlertView SimpleSay:[StringFactory GetString_CannotPlayerSelectedGame] closeButton:[StringFactory GetString_Close]];
        bRet = NO;
    }
    
    return bRet;
}

-(void)OnCellSelectedEvent:(id)sender
{
    id<ListCellTemplate> p = sender;
    if(p)
    {
        id<ListCellDataTemplate> data = [p GetCellData];
        if(data)
        {
            if([data GetDataType] == enLISTCELLDATA_INT)
            {
                int nData = [(ListCellDataInt*)data GetData];
                if(10 <= nData) //Level data
                {
                    int nLevel = nData -10;
                    BOOL bOK = [self CanSetLevel:nLevel];
                    if(bOK)
                    {    
                        [Configuration setGameLevel:nLevel];
                        [super OnCellSelectedEvent:sender];
                    } 
                    else
                    {
                        //[GUIEventLoop SendEvent:GUIID_RELOADCONFIGURATIONLIST eventSender:nil];
                        m_bReloadList = YES;
                    }
                }
                else //Skill data
                {
                    BOOL bOK = [self CanSetSkill:nData];
                    if(bOK)
                    {    
                        [Configuration setGameSkill:nData];
                        [super OnCellSelectedEvent:sender];
                    }    
                    else
                    {
                        //[GUIEventLoop SendEvent:GUIID_RELOADCONFIGURATIONLIST eventSender:nil];
                        m_bReloadList = YES;
                    }
                }
            }
        }
    }
}

-(void)OnThunderSwitch:(NSNotification *)notification
{
    if(notification)
    {    
        SwitchIconCell* pCell = [notification object];
        BOOL bOn = [pCell GetSwitchOnOff];
        [Configuration setThunderTheme:bOn];
    }    
}

-(void)OnLineStateSwitch:(NSNotification *)notification
{
    if(notification)
    {    
        SwitchIconCell* pCell = [notification object];
        BOOL bOn = [pCell GetSwitchOnOff];
        [ScoreRecord setAWSServiceEnable:bOn];
        if(bOn)
        {    
            id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
            if(pGKDelegate)
            {
                [pGKDelegate InitAWSMessager];
            }
        }    
    }    
}

-(void)InitializeThunderState
{
	float w = self.frame.size.width;
	float h = [GUILayout GetDefaulSwitchIconCellHeight];
	
	CGRect rect = CGRectMake(0, 0, w, h);
    SwitchIconCell* pCell = [[SwitchIconCell alloc] initWithFrame:rect withImage:@"flashicon.png"];
    [pCell RegisterControlID:GUIID_EVENT_THUNDERTHENEBUTTON];
    [GUIEventLoop RegisterEvent:GUIID_EVENT_THUNDERTHENEBUTTON eventHandler:@selector(OnThunderSwitch:) eventReceiver:self eventSender:pCell];
    
    BOOL bOn = [Configuration getThunderTheme];
    [pCell SetSwitch:bOn]; 
    
    [self AddCell:pCell];
    [pCell release];
    
    
    SwitchIconCell* pCell2 = [[SwitchIconCell alloc] initWithFrame:rect withImage:@"onlinestate.png"];
    [pCell2 RegisterControlID:GUIID_EVENT_ONLINESTATUSBUTTON];
    [GUIEventLoop RegisterEvent:GUIID_EVENT_ONLINESTATUSBUTTON eventHandler:@selector(OnLineStateSwitch:) eventReceiver:self eventSender:pCell2];
    
    BOOL bOn2 = [Configuration getThunderTheme];
    [pCell2 SetSwitch:bOn2]; 
    
    [self AddCell:pCell2];
    [pCell2 release];
    
}

-(void)InitializeSkillList
{
	float w = self.frame.size.width;
	float h = [GUILayout GetDefaultListCellHeight];
	
	CGRect rect = CGRectMake(0, 0, w, h);
    GroupCell* pCell = [[GroupCell alloc] initWithFrame:rect];
    [pCell SetTitle:[StringFactory GetString_Skill]]; 
    
    TextCheckboxCell* p1 = [[TextCheckboxCell alloc] initWithFrame:rect];
    [p1 SetTitle:[StringFactory GetString_SkillOne: NO]]; 
    ListCellDataInt* pData = [[ListCellDataInt alloc] init];
    pData.m_nData = GAME_SKILL_LEVEL_ONE;
    p1.m_Data = pData;
    [pData release];
    [pCell AddCell:p1];

    TextCheckboxCell* p2 = [[TextCheckboxCell alloc] initWithFrame:rect];
    [p2 SetTitle:[StringFactory GetString_SkillTwo: NO]]; 
    ListCellDataInt* pData2 = [[ListCellDataInt alloc] init];
    pData2.m_nData = GAME_SKILL_LEVEL_TWO;
    p2.m_Data = pData2;
    [pData2 release];
    [pCell AddCell:p2];
    
    TextCheckboxCell* p3 = [[TextCheckboxCell alloc] initWithFrame:rect];
    [p3 SetTitle:[StringFactory GetString_SkillThree: NO]]; 
    ListCellDataInt* pData3 = [[ListCellDataInt alloc] init];
    pData3.m_nData = GAME_SKILL_LEVEL_THREE;
    p3.m_Data = pData3;
    [pData3 release];
    [pCell AddCell:p3];
    
    [self AddCell:pCell];
    [pCell release];
}

-(void)InitializeLevelList
{
	float w = self.frame.size.width;
	float h = [GUILayout GetDefaultListCellHeight];
	
	CGRect rect = CGRectMake(0, 0, w, h);
    GroupCell* pCell = [[GroupCell alloc] initWithFrame:rect];
    [pCell SetTitle:[StringFactory GetString_Level]]; 


    TextCheckboxCell* p1 = [[TextCheckboxCell alloc] initWithFrame:rect];
    [p1 SetTitle:[StringFactory GetString_LevelOne: NO]]; 
    ListCellDataInt* pData = [[ListCellDataInt alloc] init];
    pData.m_nData = GAME_PLAY_LEVEL_ONE+10;
    p1.m_Data = pData;
    [pData release];
    [pCell AddCell:p1];
    
    TextCheckboxCell* p2 = [[TextCheckboxCell alloc] initWithFrame:rect];
    [p2 SetTitle:[StringFactory GetString_LevelTwo: NO]]; 
    ListCellDataInt* pData2 = [[ListCellDataInt alloc] init];
    pData2.m_nData = GAME_PLAY_LEVEL_TWO+10;
    p2.m_Data = pData2;
    [pData2 release];
    [pCell AddCell:p2];
    
    TextCheckboxCell* p3 = [[TextCheckboxCell alloc] initWithFrame:rect];
    [p3 SetTitle:[StringFactory GetString_LevelThree: NO]]; 
    ListCellDataInt* pData3 = [[ListCellDataInt alloc] init];
    pData3.m_nData = GAME_PLAY_LEVEL_THREE+10;
    p3.m_Data = pData3;
    [pData3 release];
    [pCell AddCell:p3];

    TextCheckboxCell* p4 = [[TextCheckboxCell alloc] initWithFrame:rect];
    [p4 SetTitle:[StringFactory GetString_LevelFour: NO]]; 
    ListCellDataInt* pData4 = [[ListCellDataInt alloc] init];
    pData4.m_nData = GAME_PLAY_LEVEL_FOUR+10;
    p4.m_Data = pData4;
    [pData4 release];
    [pCell AddCell:p4];
    
    [self AddCell:pCell];
    [pCell release];
}

-(void)IntializeCongfigureList
{
    [self InitializeThunderState];
    [self InitializeSkillList];
    [self InitializeLevelList];
    
    [self UpdateViewLayout];
    [m_ListView UpdateContentSizeByContentView];	
}


-(void)OnViewClose
{
	[super OnViewClose];
    [ScoreRecord saveRecord];
}	

-(void)LoadThunderTheme
{
    id<ListCellTemplate> pCell = [m_ListView GetCell:0];
    if(pCell && [pCell GetListCellType] == enLISTCELLTYPE_SWITCH)
    {
        SwitchIconCell* pSwitchCell = (SwitchIconCell*)pCell;
        if(pSwitchCell)
        {
            [pSwitchCell SetSwitch:[Configuration getThunderTheme]];
        }
    }

    pCell = [m_ListView GetCell:1];
    if(pCell && [pCell GetListCellType] == enLISTCELLTYPE_SWITCH)
    {
        SwitchIconCell* pSwitchCell = (SwitchIconCell*)pCell;
        if(pSwitchCell)
        {
            id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
            if(pGKDelegate && [pGKDelegate IsAWSMessagerEnabled])
            {
                [pSwitchCell SetSwitch:YES];
            }
            else
            {
                [pSwitchCell SetSwitch:NO];
            }
            if([UIDevice networkAvailable] == NO)
            {
                [pSwitchCell SetSelectable:NO];  
            }
        }
    }
    
}

-(void)LoadSkill
{
    id<ListCellTemplate> pCell = [m_ListView GetCell:2];
    if(pCell && [pCell GetListCellType] == enLISTCELLTYPE_GROUP)
    {
        GroupCell* pGroupCell = (GroupCell*)pCell;
        if(pGroupCell)
        {
            int nSkill = [Configuration getGameSkill];
            int nCount = [pGroupCell GetCellCount];
            if(1 < nCount)
            {
                for(int i = 1; i < nCount; ++i)
                {
                    if((i-1) == nSkill)
                    {
                        [[pGroupCell GetCellAt:i] SetCheckBoxState:YES];
                    }
                    else
                    {
                        [[pGroupCell GetCellAt:i] SetCheckBoxState:NO];
                    }
                }
            }
        }
    }
}

-(void)LoadLevel
{
    id<ListCellTemplate> pCell = [m_ListView GetCell:3];
    if(pCell && [pCell GetListCellType] == enLISTCELLTYPE_GROUP)
    {
        GroupCell* pGroupCell = (GroupCell*)pCell;
        if(pGroupCell)
        {
            int nLevel = [Configuration getGameLevel];
            int nCount = [pGroupCell GetCellCount];
            if(1 < nCount)
            {
                for(int i = 1; i < nCount; ++i)
                {
                    if((i-1) == nLevel)
                    {
                        [[pGroupCell GetCellAt:i] SetCheckBoxState:YES];
                    }
                    else
                    {
                        [[pGroupCell GetCellAt:i] SetCheckBoxState:NO];
                    }
                }
            }
        }
    }
}

-(void)LoadConfiguration
{
    int nCount = [m_ListView GetCellCount];
    if(0 < nCount)
    {
        [self LoadThunderTheme];
        [self LoadSkill];
        [self LoadLevel];
    }
}

-(void)OnViewOpen
{
	[super OnViewOpen];
    [self LoadConfiguration];
    m_bReloadList = NO;
}	

-(void)OnTimerEvent
{
    if(m_bReloadList == YES)
    {
        [self OnReloadConfigure];
    }
}


@end
