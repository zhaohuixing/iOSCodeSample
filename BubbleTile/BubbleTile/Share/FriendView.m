//
//  FriendView.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 2011-04-02.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "FriendView.h"
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
#import "TextCheckboxCell.h"
#import "ScoreRecord.h"
#import "GameCenterConstant.h"
#import "GameCenterPostDelegate.h"
#import <GameKit/GameKit.h>
#import "RenderHelper.h"

@implementation FriendView

-(void)ShowSpinner
{
    [self bringSubviewToFront:m_Spinner];
    m_Spinner.hidden = NO;
    [m_Spinner sizeToFit];
    [m_Spinner startAnimating];
    m_Spinner.center = CGPointMake([GUILayout GetContentViewWidth]/2, [GUILayout GetContentViewHeight]/2);
}

-(void)HideSpinner
{
    [m_Spinner stopAnimating];
    m_Spinner.hidden = YES;
}

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
	{
        // Initialization code.
		self.backgroundColor = [ImageLoader GetDefaultViewBackgroundColor];
        
        m_Spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        m_Spinner.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
        | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:m_Spinner];
        [m_Spinner release];
        
       // [self IntializeScoreList];
    }
    return self;
}

- (void)dealloc 
{
    [super dealloc];
}

-(void)UpdateViewLayout
{
    m_Spinner.center = CGPointMake([GUILayout GetContentViewWidth]/2, [GUILayout GetContentViewHeight]/2);
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

-(void)OnCellSelectedEvent:(id)sender
{
    [super OnCellSelectedEvent:sender];
    id<ListCellTemplate> p = sender;
    if(p)
    {
        id<ListCellDataTemplate> data = [p GetCellData];
        if(data)
        {
            if([data GetDataType] == enLISTCELLDATA_STRING)
            {
                NSString* playerID = [(ListCellDataString*)data GetData];
                NSLog(@"Selected player ID:%@\n", playerID);
                NSArray *fIDList = [NSArray arrayWithObject: playerID];
                id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
                if(pGKDelegate)
                {
                    [pGKDelegate InviteFriends:fIDList];
                }
                
            }
        }
    }
}

-(void)LoadFriendsData:(NSArray*)friends
{
    if(friends && 0 < friends.count)
    {
        [GKPlayer loadPlayersForIdentifiers: friends withCompletionHandler:^(NSArray *playerArray, NSError *error)
         {
             if(playerArray != nil && 0 < playerArray.count)
             {
                 float w = self.frame.size.width;
                 float h = [GUILayout GetDefaultListCellHeight];
                 CGRect rect = CGRectMake(0, 0, w, h);
                 GroupCell* pBaseCell = [[GroupCell alloc] initWithFrame:rect];
                 [pBaseCell SetTitle:[StringFactory GetString_FriendLabel]]; 
                 
                 for (GKPlayer* tempPlayer in playerArray)
                 {
                     NSString* szName = [NSString stringWithFormat:@"%@", tempPlayer.alias];
                     DualTextCell* p = [[DualTextCell alloc] initWithFrame:rect];
                     [p SetTitle:szName]; 
                     [p SetText:@""];
                     [pBaseCell AddCell:p];
                 }
                 [pBaseCell SetSelectable:NO];
                 [self AddCell:pBaseCell];
                 [pBaseCell release];
                 
             }    
             [self UpdateViewLayout];
         }];
    }
}

-(void)InitializeFriendList
{
    GKLocalPlayer* pPlayer = [GKLocalPlayer localPlayer];
    if(pPlayer == nil)
        return;
    
	if(pPlayer.authenticated == YES)
	{
        
       [pPlayer loadFriendsWithCompletionHandler:^(NSArray *friends, NSError *error)
        { 
            if (friends != nil) 
            {
                 [self LoadFriendsData:friends];
            } 
        }];        
    }
}

-(void)InitializePlayerList
{
    GKLocalPlayer* pPlayer = [GKLocalPlayer localPlayer];
    if(pPlayer == nil || pPlayer.authenticated == NO)
        return;
    
    NSString* category = _SQUARE3_DIFFICULT_GAME_;
	GKLeaderboard* leaderBoard= [[[GKLeaderboard alloc] init] autorelease];
	leaderBoard.category= category;
	leaderBoard.timeScope= GKLeaderboardTimeScopeAllTime;
    leaderBoard.playerScope = GKLeaderboardPlayerScopeGlobal;
	leaderBoard.range= NSMakeRange(1, 100);
    
	[leaderBoard loadScoresWithCompletionHandler:  ^(NSArray *scores, NSError *error)
    {
        if(scores != nil && 0 < scores.count)
        {
            NSMutableArray* playerIDList = [[[NSMutableArray alloc] init] autorelease];
            for(GKScore* scorerecord in scores)
            {
                if(scorerecord != nil)
                {
                    NSString* szPlayerID = scorerecord.playerID;
                    NSLog(@"LB player ID:%@\n", szPlayerID);
                    [playerIDList addObject:szPlayerID];
                }    
            }     
            if(0 < playerIDList.count)
            {
                [GKPlayer loadPlayersForIdentifiers: playerIDList withCompletionHandler:^(NSArray *playerArray, NSError *error)
                 {
                     if(playerArray != nil && 0 < playerArray.count)
                     {
                         float w = self.frame.size.width;
                         float h = [GUILayout GetDefaultListCellHeight];
                         CGRect rect = CGRectMake(0, 0, w, h);
                         GroupCell* pBaseCell = [[GroupCell alloc] initWithFrame:rect];
                         [pBaseCell SetTitle:[StringFactory GetString_PlayerListLabel]]; 
                         
                         for (GKPlayer* tempPlayer in playerArray)
                         {
                             BOOL bRepeat = NO;
                             NSComparisonResult result;
                             result = [pPlayer.playerID compare:tempPlayer.playerID];		
                             if(result == NSOrderedSame)
                             {
                                 bRepeat = YES;
                             }
                             if(bRepeat == NO)
                             {
                                 //for (NSString* friendID in pPlayer.friends)
                                 //{
                                 //    result = [friendID compare:tempPlayer.playerID];		
                                 //    if(result == NSOrderedSame)
                                 //    {
                                 //        bRepeat = YES;
                                 //        break;
                                 //    }
                                 //}
                                 bRepeat = tempPlayer.isFriend;
                             }  
                             
                             if(bRepeat == NO)
                             {    
                                 NSString* szName = [NSString stringWithFormat:@"%@", tempPlayer.alias];
                                 
                                 TextCheckboxCell* p = [[TextCheckboxCell alloc] initWithFrame:rect];
                                 [p SetTitle:szName]; 
                                 [p SetSelectable:YES];
                                 ListCellDataString* pData = [[ListCellDataString alloc] init];
                                 pData.m_sData = tempPlayer.playerID;
                                 p.m_Data = pData;
                                 [pData release];
                                 [pBaseCell AddCell:p];
                             }    
                        }
                         [self AddCell:pBaseCell];
                         [pBaseCell release];
                         //[self HideSpinner];
                         [self UpdateViewLayout];
                     }    
                 }];
            }
            
        }
        
    }];
    
}

-(void)IntializeAllLists
{
    [self InitializeFriendList];
    [self InitializePlayerList];
    [self UpdateViewLayout];
    [m_ListView UpdateContentSizeByContentView];	
}

-(void)LoadFriends
{
//    [self ShowSpinner];
    [self RemoveAllCells];
    [self IntializeAllLists];
    [self UpdateViewLayout];
}
-(void)OnViewOpen
{
	[super OnViewOpen];
    [self LoadFriends];
}	

@end
