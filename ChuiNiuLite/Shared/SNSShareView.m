//
//  SNSShareView.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#include "libinc.h"

#import "SNSShareView.h"
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
#import "DualTextCell.h"
#import "ScoreRecord.h"
#import "GameCenterConstant.h" 
#import "CustomModalAlertView.h"
#import "GameCenterConstant.h"
#import "RenderHelper.h"

@implementation SNSShareView


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
        
        [self InitializePostList];
        //m_FacebookPoster = [[FacebookPoster alloc] init];
        m_bDefaultLanguage = NO;

    }
    return self;
}

- (void)dealloc 
{
	//CGPatternRelease(m_Pattern);
    //[m_FacebookPoster release];
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

-(void)OnFacebookPostLast:(NSNotification *)notification
{
    //NSLog(@"FB Post Last");
    //[m_FacebookPoster FaceBookShareLastWin];
	NSString* szTitle =  [StringFactory GetString_MyLastWin:NO];
	NSString* szBody = @"";
	int nSkill = [ScoreRecord getLastWinSkill];
	int nLevel = [ScoreRecord getLastWinLevel];
	
	if(nSkill == -1 || nLevel == -1)
	{
		//[ModalAlert say:[StringFactory GetString_NoRecordPostWarn:NO]];
        [CustomModalAlertView SimpleSay:[StringFactory GetString_NoRecordPostWarn:NO] closeButton:[StringFactory GetString_Close]];
		return;
	}	
	NSString* szSkill = [StringFactory GetString_SkillString:nSkill withDefault:NO];
	NSString* szLevel = [StringFactory GetString_LevelString:nLevel withDefault:NO];
	szBody = [NSString stringWithFormat:@"%@/%@", szLevel, szSkill];
	NSString* szPost = [NSString stringWithFormat:@"%@: %@", szTitle, szBody];
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate)
    {
        [pGKDelegate FaceBookPostMessage:szPost];
    }
}

-(void)OnFacebookPostAll:(id)sender
{
	BOOL bUseEn = NO;
	
	NSString* szTitle = [StringFactory GetString_MyTotalWin:bUseEn];
	NSString* szBody = @"";
    
	BOOL bHasRecord = NO;
	NSString* szSkill = @"";//[StringFactory GetString_SkillString:nSkill withDefault:bUseEn];
	NSString* szLevel = @"";//[StringFactory GetString_LevelString:nLevel withDefault:bUseEn];
	NSString* szScore = @"";//[StringFactory GetString_LevelString:nLevel withDefault:bUseEn];
	int nScore = 0;
	for(int i = GAME_PLAY_LEVEL_ONE; i <= GAME_PLAY_LEVEL_FOUR; ++i)
	{
		szLevel = [StringFactory GetString_LevelString:i withDefault:bUseEn];
		for(int j = GAME_SKILL_LEVEL_ONE; j <= GAME_SKILL_LEVEL_THREE; ++j)
		{
			szSkill = [StringFactory GetString_SkillString:j withDefault:bUseEn];
			nScore = [ScoreRecord getScore:j atLevel:i];
			if(0 < nScore)
			{
				szScore = [NSString stringWithFormat:@"%@/%@(%i).  ", szLevel, szSkill, nScore];
				bHasRecord = YES;	
				szBody = [szBody stringByAppendingString:szScore]; 
			}	
		}	
	}	
    
	if(bHasRecord == NO)
	{
        //		[ModalAlert say:[StringFactory GetString_NoRecordPostWarn:NO]];
        [CustomModalAlertView SimpleSay:[StringFactory GetString_NoRecordPostWarn:NO] closeButton:[StringFactory GetString_Close]];
		return;
	}	
	
	NSString* szPost = [NSString stringWithFormat:@"%@: %@", szTitle, szBody];
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate)
    {
        [pGKDelegate FaceBookPostMessage:szPost];
    }
}

-(void)OnFacebookPostGameScore:(id)sender
{
    int nScore = [ScoreRecord getTotalWinScore];
	NSString* szPost = [NSString stringWithFormat:@"%@: %i", [StringFactory GetString_GameTotalScoreTitle], nScore];
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate)
    {
        [pGKDelegate FaceBookPostMessage:szPost];
    }
}

-(void)OnTwitterPostLast:(id)sender
{
	BOOL bUseEn = NO;
    
	if([StringFactory IsOSLangEN] == YES)
		bUseEn = YES;
	
	NSString* szTitle =  [StringFactory GetString_MyLastWin:bUseEn];
	NSString* szBody = @"";
	int nSkill = [ScoreRecord getLastWinSkill];
	int nLevel = [ScoreRecord getLastWinLevel];
	
	if(nSkill == -1 || nLevel == -1)
	{
		//[ModalAlert say:[StringFactory GetString_NoRecordPostWarn:NO]];
        [CustomModalAlertView SimpleSay:[StringFactory GetString_NoRecordPostWarn:NO] closeButton:[StringFactory GetString_Close]];
		return;
	}	
	NSString* szSkill = [StringFactory GetString_SkillString:nSkill withDefault:bUseEn];
	NSString* szLevel = [StringFactory GetString_LevelString:nLevel withDefault:bUseEn];
	szBody = [NSString stringWithFormat:@"%@/%@", szLevel, szSkill];
	NSString* szPost = [NSString stringWithFormat:@"%@: %@", szTitle, szBody];
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate)
    {
        [pGKDelegate PostTwitterMessage:szPost];
    }
}

-(void)OnTwitterPostAll:(id)sender
{
	BOOL bUseEn = NO;
	if([StringFactory IsOSLangEN] == YES)
		bUseEn = YES;
	
	NSString* szTitle = [StringFactory GetString_MyTotalWin:bUseEn];
	NSString* szBody = @"";
    
	BOOL bHasRecord = NO;
	NSString* szSkill = @"";//[StringFactory GetString_SkillString:nSkill withDefault:bUseEn];
	NSString* szLevel = @"";//[StringFactory GetString_LevelString:nLevel withDefault:bUseEn];
	NSString* szScore = @"";//[StringFactory GetString_LevelString:nLevel withDefault:bUseEn];
	int nScore = 0;
	for(int i = GAME_PLAY_LEVEL_ONE; i <= GAME_PLAY_LEVEL_FOUR; ++i)
	{
		szLevel = [StringFactory GetString_LevelString:i withDefault:bUseEn];
		for(int j = GAME_SKILL_LEVEL_ONE; j <= GAME_SKILL_LEVEL_THREE; ++j)
		{
			szSkill = [StringFactory GetString_SkillString:j withDefault:bUseEn];
			nScore = [ScoreRecord getScore:j atLevel:i];
			if(0 < nScore)
			{
				szScore = [NSString stringWithFormat:@"%@/%@(%i).  ", szLevel, szSkill, nScore];
				bHasRecord = YES;	
				szBody = [szBody stringByAppendingString:szScore]; 
			}	
		}	
	}	
    
	if(bHasRecord == NO)
	{
		//[ModalAlert say:[StringFactory GetString_NoRecordPostWarn:NO]];
        [CustomModalAlertView SimpleSay:[StringFactory GetString_NoRecordPostWarn:NO] closeButton:[StringFactory GetString_Close]];
		return;
	}	
	
	NSString* szPost = [NSString stringWithFormat:@"%@: %@", szTitle, szBody];
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate)
    {
        [pGKDelegate PostTwitterMessage:szPost];
    }
}

- (void)OnTwitterPostGameScore:(id)sender
{
    int nScore = [ScoreRecord getTotalWinScore];
	NSString* szPost = [NSString stringWithFormat:@"%@: %i", [StringFactory GetString_GameTotalScoreTitle], nScore];
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate)
    {
        [pGKDelegate PostTwitterMessage:szPost];
    }
}

- (void)InitializeLanguage
{
	NSString* szTitle = @"";
    szTitle = [StringFactory GetString_SharingLang];
	float w = self.frame.size.width;
	float h = [GUILayout GetDefaultListCellHeight];
	
    CGRect rect = CGRectMake(0, 0, w, h);
    GroupCell* pCell = [[GroupCell alloc] initWithFrame:rect];
    [pCell SetTitle:szTitle]; 
    
	NSString* strText = [StringFactory GetString_SharingLangName];
    TextCheckboxCell* p = [[TextCheckboxCell alloc] initWithFrame:rect];
    [p SetTitle:strText]; 
	if([StringFactory IsOSLangEN] == YES)
    {
        [p SetToggleable:NO];
        [p SetSelectable:NO];
    }
    else
    {    
        [p SetToggleable:YES];
    }    
    [pCell AddCell:p];
    [self AddCell:pCell];
    [pCell release];
}

- (void)InitializePost
{
	NSString* szTitle = [StringFactory GetString_SharingOption];
	
    float w = self.frame.size.width;
	float h = [GUILayout GetDefaultListCellHeight]+10;

    CGRect rect = CGRectMake(0, 0, w, h-10);
    GroupCell* pCell = [[GroupCell alloc] initWithFrame:rect];
    [pCell SetTitle:szTitle]; 
    
	rect = CGRectMake(0, 0, w, h);
    m_pPostCell1  = [[MultiButtonCell alloc] initWithFrame:rect]; 
    [m_pPostCell1 RegisterButtonResouce1:GUIID_EVENT_FACEBOOKSHARELAST withImage:@"flogo.png" withHighLightImage:@"flogoh.png"];
    [GUIEventLoop RegisterEvent:GUIID_EVENT_FACEBOOKSHARELAST eventHandler:@selector(OnFacebookPostLast:) eventReceiver:self eventSender:m_pPostCell1];
    [m_pPostCell1 RegisterButtonResouce2:GUIID_EVENT_TWITTERSHARELAST withImage:@"ticon.png" withHighLightImage:@"ticonhi.png"];
    [GUIEventLoop RegisterEvent:GUIID_EVENT_TWITTERSHARELAST eventHandler:@selector(OnTwitterPostLast:) eventReceiver:self eventSender:m_pPostCell1];
    
    
    [m_pPostCell1 SetTitle:[StringFactory GetString_MyLastWin:m_bDefaultLanguage]];
    [pCell AddCell:m_pPostCell1];
    
	rect = CGRectMake(0, 0, w, h);
    m_pPostCell2 = [[MultiButtonCell alloc] initWithFrame:rect];
    [m_pPostCell2 RegisterButtonResouce1:GUIID_EVENT_FACEBOOKSHAREALL withImage:@"flogo.png" withHighLightImage:@"flogoh.png"];
    [GUIEventLoop RegisterEvent:GUIID_EVENT_FACEBOOKSHAREALL eventHandler:@selector(OnFacebookPostAll:) eventReceiver:self eventSender:m_pPostCell2];
    
    [m_pPostCell2 RegisterButtonResouce2:GUIID_EVENT_TWITTERSHAREALL withImage:@"ticon.png" withHighLightImage:@"ticonhi.png"];
    [GUIEventLoop RegisterEvent:GUIID_EVENT_TWITTERSHAREALL eventHandler:@selector(OnTwitterPostAll:) eventReceiver:self eventSender:m_pPostCell2];
    [m_pPostCell2 SetTitle:[StringFactory GetString_MyTotalWin:m_bDefaultLanguage]];
    [pCell AddCell:m_pPostCell2];
    
    m_pPostCell3 = [[MultiButtonCell alloc] initWithFrame:rect];
    [m_pPostCell3 RegisterButtonResouce1:GUIID_EVENT_FACEBOOKSHARETOTALGAMESCORE withImage:@"flogo.png" withHighLightImage:@"flogoh.png"];
    [GUIEventLoop RegisterEvent:GUIID_EVENT_FACEBOOKSHARETOTALGAMESCORE eventHandler:@selector(OnFacebookPostGameScore:) eventReceiver:self eventSender:m_pPostCell3];
    
    [m_pPostCell3 RegisterButtonResouce2:GUIID_EVENT_TWITTERSHARETOTALGAMESCORE withImage:@"ticon.png" withHighLightImage:@"ticonhi.png"];
    [GUIEventLoop RegisterEvent:GUIID_EVENT_TWITTERSHARETOTALGAMESCORE eventHandler:@selector(OnTwitterPostGameScore:) eventReceiver:self eventSender:m_pPostCell3];
    [m_pPostCell3 SetTitle:[StringFactory GetString_GameTotalScoreTitle]];
    [pCell AddCell:m_pPostCell3];
    
    
    
    [self AddCell:pCell];
    [pCell release];
}

- (void)InitializePostList
{
    [self InitializeLanguage];
    [self InitializePost];
}
@end
