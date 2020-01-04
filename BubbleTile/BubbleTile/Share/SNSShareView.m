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
#import "GameCenterPostDelegate.h"
#import "RenderHelper.h"
#import "ApplicationController.h"

@implementation SNSShareView


- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
	{
        // Initialization code.
		self.backgroundColor = [ImageLoader GetDefaultViewBackgroundColor];
		//float size = 80;
		//if([ApplicationConfigure iPADDevice])
		//	size = 120;
		
        [self InitializePostList];
        //m_FacebookPoster = [[FacebookPoster alloc] init];
        m_bDefaultLanguage = NO;

    }
    return self;
}

- (void)dealloc 
{
    [super dealloc];
}

-(void)UpdateViewLayout
{
	[super UpdateViewLayout];
	[self setNeedsDisplay];
}	

/*- (void)drawBackground:(CGContextRef)context inRect:(CGRect)rect
{
	CGContextSaveGState(context);
    float fAlpha = 1.0;
    [RenderHelper DefaultPatternFill:context withAlpha:fAlpha atRect:rect];
	CGContextRestoreGState(context);
}*/

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	[self drawBackground:context inRect: rect];
}

-(NSString*) GetScoreInfo:(ScoreRecord*)score
{
    NSString* sRet = nil;
    if(score == nil)
        return sRet;
    
    NSString* szTitle = [StringFactory GetString_PuzzleString:score.m_nGridType withLayout:score.m_nGridlayout withEdge:score.m_nEdge];
    
    NSString* szTime = [NSString stringWithFormat:@"(%i-%i-%i)", score.m_nYear4Least, score.m_nMonth4Least, score.m_nDay4Least];
    NSString* sStep = [NSString stringWithFormat:@"%@(%@)=%i. ", [StringFactory GetString_LeastStepLabel], szTime, score.m_nLeastRecord];
    
    NSString* sWinCount = [NSString stringWithFormat:@"%@=%i.", [StringFactory GetString_WinCountLabel], 
                           score.m_nTotalWinCount]; 
    
    sRet = [NSString stringWithFormat:@"%@: %@%@", szTitle, sStep, sWinCount];
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
            if([data GetDataType] == enLISTCELLDATA_INT)
            {
                int index = [(ListCellDataInt*)data GetData];
                ScoreRecord* pScore = [GameScore GetScoreAt:index];
                if(pScore != nil)
                {
                    NSString* sScore = [self  GetScoreInfo:pScore]; 
                    //[m_FacebookPoster FaceBookPostScore:sScore];
                    ApplicationController* pController = (ApplicationController*)[GUILayout GetMainViewController];
                    if(pController)
                    {
                        [pController FaceBookPostScore:sScore];
                    }
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
            if([data GetDataType] == enLISTCELLDATA_INT)
            {
                int index = [(ListCellDataInt*)data GetData];
                ScoreRecord* pScore = [GameScore GetScoreAt:index];
                if(pScore != nil)
                {
                    NSString* sScore = [self  GetScoreInfo:pScore]; 
                    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
                    if(pGKDelegate)
                    {
                        [pGKDelegate PostTwitterMessage:sScore];
                    }
                }
            }
        }
        data = nil;
    }    
    pPostCell = nil;
}

- (void)InitializePost:(ScoreRecord*)score withIndex:(int)i
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
    
    
    [pPostCell SetTitle:[StringFactory GetString_PuzzleString:score.m_nGridType withLayout:score.m_nGridlayout withEdge:score.m_nEdge]];
    ListCellDataInt* pData = [[[ListCellDataInt alloc] init] retain];
    pData.m_nData = i;
    [pPostCell SetCellData:pData];
    [pData release];
    
    [self AddCell:pPostCell];
    [pPostCell release];
}

- (void)InitializePostList
{
    [self RemoveAllCells];
    
 	int nCount = [GameScore GetScoreCount];//[Scores GetScoreCount];
    
    if(0 < nCount)
    {
        for(int i = 0; i < nCount; ++i)
        {
			ScoreRecord* score = nil;
            score = [GameScore GetScoreAt:i];
            if(score != nil)
            {
                [self InitializePost:score withIndex:i];
            }
        }
    }
    
    [self UpdateViewLayout];
    [m_ListView UpdateContentSizeByContentView];	
}

-(void)OnViewOpen
{
    [self InitializePostList];
    [super OnViewOpen];
}	

@end
