//
//  PlayerOnlineStatusView.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 2011-04-02.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//#include "libinc.h"
#import "PlayerOnlineStatusView.h"
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
#import <GameKit/GameKit.h>
#import "RenderHelper.h"
#import "AWSMessageService.h"
#import "BTFileConstant.h"
#import "GameConfiguration.h"
#import "GameCenterPostDelegate.h"

@implementation PlayerOnlineStatusView

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
		float size = 80;
		if([ApplicationConfigure iPADDevice])
			size = 120;
	
        CGRect rect = CGRectMake(0, 0, 250, 30);
		m_Label2012 = [[UILabel alloc] initWithFrame:rect];
		m_Label2012.backgroundColor = [UIColor clearColor];
		[m_Label2012 setTextColor:[UIColor redColor]];
		m_Label2012.font = [UIFont fontWithName:@"Georgia" size:16];
        [m_Label2012 setTextAlignment:UITextAlignmentLeft];
        m_Label2012.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        m_Label2012.adjustsFontSizeToFitWidth = YES;
		[m_Label2012 setText:@""];
		[self addSubview:m_Label2012];
		[m_Label2012 release];
        
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
	CGFloat fAlpha = [ImageLoader GetDefaultViewFillAlpha];
    [RenderHelper DrawFlyingCowIconPatternFill:context withAlpha:fAlpha atRect:rect];
}*/

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	[self drawBackground:context inRect: rect];
}

-(void)LoadFriendsData:(NSArray*)friends
{
    if(friends && 0 < friends.count)
    {
        for(int i = 0; i < friends.count; ++i)
        {
            SQSMessage *message = [friends objectAtIndex:i];
            if (message != nil && message.body != nil) 
            {
                NSError *error = nil;
                SBJSON *jsonParser = [[SBJSON new] autorelease];
                NSDictionary* msgSQSInfo = [jsonParser objectWithString:message.body error:(NSError**)&error];
                if(msgSQSInfo != nil && 0 < msgSQSInfo.count)
                {
                    NSString* timestamp = [msgSQSInfo valueForKey:@"Timestamp"];
                    NSLog(@"timestamp:%@", timestamp);
                    NSString*  timeString = [timestamp stringByReplacingOccurrencesOfString:@"T"
                                                                                            withString:@" "];
                    timeString = [timeString stringByReplacingOccurrencesOfString:@"Z"
                                                                                 withString:@" "];
                    
                    
                    
                    NSString* msgMessage = [msgSQSInfo valueForKey:@"Message"];
                    SBJSON *jsonParser2 = [[SBJSON new] autorelease];
                    NSDictionary* msgInfo = [jsonParser2 objectWithString:msgMessage error:(NSError**)&error];
                    
                    if(msgInfo != nil && 0 < msgInfo.count)
                    {    
                    NSString* msgName = [msgInfo valueForKey:AWS_MESSAGE_GAMER_NICKNAME_KEY];
                    NSNumber* msgGrid = [msgInfo valueForKey:AWS_MESSAGE_GAME_GRID_KEY];
                    enGridType enType = 0;
                    if(msgGrid)
                    {
                         enType = (enGridType)[msgGrid intValue];
                    }
                        
                    NSNumber* msgLayout = [msgInfo valueForKey:AWS_MESSAGE_GAME_LAYOUT_KEY];
                    enGridLayout enLayout = 0;
                    if(msgLayout)
                    {
                        enLayout = (enGridLayout)[msgLayout intValue];
                    }
                        
                    NSNumber* msgEdge = [msgInfo valueForKey:AWS_MESSAGE_GAME_UNIT_KEY];
                    int nEdge = 0;
                    if(msgEdge)
                    {
                        nEdge = [msgEdge intValue];
                    }
                        
                    NSNumber* msgScore = [msgInfo valueForKey:AWS_MESSAGE_GAME_TOTALSCORE_KEY];
                    int nScore = 0;
                    if(msgScore)
                    {
                        nScore = [msgScore intValue];
                    }
                    NSNumber* msgDevice = [msgInfo valueForKey:AWS_MESSAGE_GAME_DEVICETYPE_KEY];
                    int nDevice = 0;
                    if(msgDevice)
                    {
                        nDevice = [msgDevice intValue];
                    }
                    if(nDevice == 0)
                    {
                        msgName = [NSString stringWithFormat:@"%@ (iOS)", msgName];
                    }
                    else if(nDevice == 1)
                    {
                        msgName = [NSString stringWithFormat:@"%@ (Android)", msgName];
                    }
                    NSString* text = nil;
                    text = [NSString stringWithFormat:@"%@:%@。%@:%i (%@)", msgName, [StringFactory GetString_PuzzleString:(int)enType withLayout:(int)enLayout withEdge:nEdge], [StringFactory GetString_Score], nScore, timeString];
                    float w = self.frame.size.width;
                    float h = [GUILayout GetDefaultListCellHeight];
                    CGRect rect = CGRectMake(0, 0, w, h);
                    DualTextCell* p = [[DualTextCell alloc] initWithFrame:rect];
                    [p SetAsSingleSingle];
                    [p SetTitle:text]; 
                        //[p SetTitle:message.body]; 
                    [p SetText:@""];
                    [p SetSelectable:NO];
                    [self AddCell:p];
                    [p release];
                        
                    //NSLog(@"msg:%@", message.body);
                    }    
                }
            }
        }
    }
}

-(void)InitializeFriendList
{
    id<GameCenterPostDelegate> pGKDelegate = (id<GameCenterPostDelegate>)[GUILayout GetMainViewController];
    if(pGKDelegate && [pGKDelegate IsAWSMessagerEnabled])
    {
        NSMutableArray* pArray = [pGKDelegate GetAWSMessagesQueue];
        if(pArray && 0 < pArray.count)
        {
            [self LoadFriendsData:pArray];
        }
    }
    
    [self ShowHideCloseButton:YES];
    [self HideSpinner];
}    


-(void)IntializeAllLists
{
    [self InitializeFriendList];
    [self UpdateViewLayout];
    [m_ListView UpdateContentSizeByContentView];	
}

-(void)LoadFriends
{
    [self ShowHideCloseButton:NO];
    [self ShowSpinner];
    [self RemoveAllCells];
    [self IntializeAllLists];
}
-(void)OnViewOpen
{
	[super OnViewOpen];
    [self LoadFriends];
}	

@end
