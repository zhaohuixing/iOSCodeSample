//
//  SNSShareView.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SNSShareView.h"
#import "GUIEventLoop.h"
#import "ImageLoader.h"
#import "ApplicationConfigure.h"
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
#import "GameScore.h"
#import "ScoreRecord.h"
#import "ButtonCell.h"
#import "GameCenterConstant.h"
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
		
        [self InitializePostList];
//        m_FacebookPoster = [[FacebookPoster alloc] init];
        m_RenRenPoster = [[RenRenPoster alloc] init];
        m_QQPoster = [[QQPoster alloc] initWithParent:self withFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        m_bDefaultLanguage = NO;

    }
    return self;
}

- (void)dealloc 
{
//    [m_FacebookPoster release];
    [m_RenRenPoster release]; 
    [m_QQPoster release];
    [super dealloc];
}

-(void)UpdateViewLayout
{
	[super UpdateViewLayout];
    float w = self.frame.size.width;
    float h = self.frame.size.height;
    [m_QQPoster AdjusetViewLocation:w withHeight:h];
	[self setNeedsDisplay];
}	

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	[self drawBackground:context inRect:rect];
}

-(NSString*) GetScoreInfo:(ScoreRecord*)score
{
    NSString* sRet = nil;
    sRet = [NSString stringWithFormat:@"%@:%@(%i); %@(%i, %i-%i-%i); %@(%i); %@(%i)",
            [StringFactory GetString_ScoreTitleString:score.m_nPoint withSpeed:score.m_nSpeed],
            [StringFactory GetString_LastScoreLabel], (int)score.m_nLastScore,
            [StringFactory GetString_HighScoreLabel], (int)score.m_nAveHighestScore, 
            score.m_nYear4Highest, score.m_nMonth4Highest, score.m_nDay4Highest,
            [StringFactory GetString_AveScoreLabel],(int)score.m_nAveAveScore, 
            [StringFactory GetString_PlaysLabel], score.m_nAvePlayCount];
    return sRet;
}

-(NSString*) QueryScore:(int)nPoint
{
    NSString* sRet = nil;
    
    GameScore* Scores = [[GameScore alloc] init];
    [Scores LoadScoresFromPreference:NO];
    
 	int nCount = [Scores GetScoreCount];
    
    if(0 < nCount)
    {
        for(int i = 0; i < nCount; ++i)
        {
			ScoreRecord* score = nil;
            score = [Scores GetScoreRecord:i];
            if(score != nil && score.m_nPoint == nPoint)
            {
                sRet = [self GetScoreInfo:score];
                break;
            }
        }
    }
    
    
    [Scores release];
    
    return sRet;
}

-(void)OnFacebookPost:(NSNotification *)notification
{
    MultiButtonCell* pPostCell = (MultiButtonCell*)[notification object];
    if(pPostCell != nil)
    {    
        id<ListCellDataTemplate> data = [pPostCell GetCellData];
        if(data)
        {
            if([data GetDataType] == enLISTCELLTYPE_OBJECT)
            {
                ScoreRecord* pScore = [(ListCellDataObject*)data GetData];
                NSString* sScore = [self GetScoreInfo:pScore];
                id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
                if(pGKDelegate)
                {
                    [pGKDelegate FaceBookPostMessage:sScore];
                }
            }
        }
        data = nil;
    }    
    pPostCell = nil;
}

-(void)OnTwitterPost:(NSNotification *)notification
{
    MultiButtonCell* pPostCell = (MultiButtonCell*)[notification object];
    if(pPostCell != nil)
    {    
        id<ListCellDataTemplate> data = [pPostCell GetCellData];
        if(data)
        {
            if([data GetDataType] == enLISTCELLTYPE_OBJECT)
            {
                ScoreRecord* pScore = [(ListCellDataObject*)data GetData];
                NSString* sScore = [self GetScoreInfo:pScore];
                id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
                if(pGKDelegate)
                {
                    [pGKDelegate PostTwitterMessage:sScore];
                }
            }
        }
        data = nil;
    }    
    pPostCell = nil;
}

-(void)OnRenRenPost:(NSNotification *)notification
{
    MultiButtonCell* pPostCell = (MultiButtonCell*)[notification object];
    id<ListCellDataTemplate> data = [pPostCell GetCellData];
    if(data)
    {
        if([data GetDataType] == enLISTCELLTYPE_OBJECT)
        {
            ScoreRecord* pScore = [(ListCellDataObject*)data GetData];
            NSString* sScore = [self GetScoreInfo:pScore];
            [m_RenRenPoster RenRenPostScore:sScore];
        }
    }
    pPostCell = nil;
    data = nil;
}

-(void)OnQQPost:(NSNotification *)notification
{
    MultiButtonCell* pPostCell = (MultiButtonCell*)[notification object];
    id<ListCellDataTemplate> data = [pPostCell GetCellData];
    if(data)
    {
        if([data GetDataType] == enLISTCELLTYPE_OBJECT)
        {
            ScoreRecord* pScore = [(ListCellDataObject*)data GetData];
            NSString* sScore = [self GetScoreInfo:pScore];
            [m_QQPoster QQTPostScore:sScore];
        }
    }
    pPostCell = nil;
    data = nil;
}

- (void)InitializePost:(ScoreRecord*)score
{
    float w = self.frame.size.width;
	float h = [GUILayout GetDefaultListCellHeight]+10;

    CGRect rect = CGRectMake(0, 0, w, h);
    MultiButtonCell*         pPostCell;
   
    pPostCell = [[MultiButtonCell alloc] initWithFrame:rect];
    [pPostCell RegisterButtonResouce1:GUIID_EVENT_FACEBOOKSHARELAST withImage:@"flogo.png" withHighLightImage:@"flogoh.png"];
    [GUIEventLoop RegisterEvent:GUIID_EVENT_FACEBOOKSHARELAST eventHandler:@selector(OnFacebookPost:) eventReceiver:self eventSender:pPostCell];

    [pPostCell RegisterButtonResouce2:GUIID_EVENT_TWITTERSHARELAST withImage:@"ticon.png" withHighLightImage:@"ticonhi.png"];
    [GUIEventLoop RegisterEvent:GUIID_EVENT_TWITTERSHARELAST eventHandler:@selector(OnTwitterPost:) eventReceiver:self eventSender:pPostCell];
    
    if([StringFactory IsOSLangZH])
    {    
        [pPostCell RegisterButtonResouce3:GUIID_EVENT_RENRENSHARELAST withImage:@"renren1.png" withHighLightImage:@"renren2.png"];
        [GUIEventLoop RegisterEvent:GUIID_EVENT_RENRENSHARELAST eventHandler:@selector(OnRenRenPost:) eventReceiver:self eventSender:pPostCell];
    
        [pPostCell RegisterButtonResouce4:GUIID_EVENT_QQSHARELAST withImage:@"qq1.png" withHighLightImage:@"qq2.png"];
        [GUIEventLoop RegisterEvent:GUIID_EVENT_QQSHARELAST eventHandler:@selector(OnQQPost:) eventReceiver:self eventSender:pPostCell];

    }
    
    [pPostCell SetTitle:[StringFactory GetString_ScoreTitleString:score.m_nPoint withSpeed:score.m_nSpeed]];
    ListCellDataObject* pData = [[[ListCellDataObject alloc] init] retain];
    pData.m_objData = score;
    [pPostCell SetCellData:pData];
    [pData release];
    
    [self AddCell:pPostCell];
    [pPostCell release];
}

- (void)InitializePostList
{
    [self RemoveAllCells];
    
    GameScore* Scores = [[GameScore alloc] init];
    [Scores LoadScoresFromPreference:NO];
    
 	int nCount = [Scores GetScoreCount];
    
    if(0 < nCount)
    {
        for(int i = 0; i < nCount; ++i)
        {
			ScoreRecord* score = nil;
            score = [Scores GetScoreRecord:i];
            if(score != nil)
            {
                [self InitializePost:[score retain]];
            }
        }
    }
    
    
    [Scores release];
    
    [self UpdateViewLayout];
    [m_ListView UpdateContentSizeByContentView];	
}

-(void)OnViewOpen
{
    [self InitializePostList];
    [super OnViewOpen];
}	

@end
