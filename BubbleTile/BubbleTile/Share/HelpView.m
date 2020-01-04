//
//  HelpView.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 2011-04-02.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "HelpView.h"
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
#import "RenderHelper.h"
#import "GameConfiguration.h"
#import "GameScore.h"
#import "SwitchIconCell.h"
#import "GameCenterConstant.h"
#import "GameCenterPostDelegate.h"
#import "UIDevice-Reachability.h"


@implementation HelpView

- (void)dealloc 
{
    [super dealloc];
}

-(void)UpdateViewLayout
{
	[super UpdateViewLayout];
	[self setNeedsDisplay];
}	

//- (void)drawBackground:(CGContextRef)context inRect:(CGRect)rect
//{
//	CGFloat fAlpha = [ImageLoader GetDefaultViewFillAlpha];
//    [RenderHelper DrawFlyingCowIconPatternFill:context withAlpha:fAlpha atRect:rect];
//}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	[self drawBackground:context inRect: rect];
}

-(void)InitializeTriangleWinScoreList
{
	float w = self.frame.size.width;
	float h = [GUILayout GetDefaultListCellHeight];
	
    CGRect rect = CGRectMake(0, 0, w, h);
    GroupCell* pCell = [[GroupCell alloc] initWithFrame:rect];
    [pCell SetTitle:[StringFactory GetString_Triangle]]; 
    NSString* szLabel = [NSString stringWithFormat:@"%@: %@", [StringFactory GetString_WinningScore], [StringFactory GetString_Easy]];
    NSString* szScore = [NSString stringWithFormat:@"(%@) - 2", [StringFactory GetString_EdgeUnit]];
    DualTextCell* p = [[DualTextCell alloc] initWithFrame:rect];
    [p SetTitle:szLabel]; 
    [p SetText:szScore]; 
    [pCell AddCell:p];
    
    szLabel = [NSString stringWithFormat:@"%@: %@", [StringFactory GetString_WinningScore], [StringFactory GetString_Difficult]];
    szScore = [NSString stringWithFormat:@"((%@) - 2) x 2", [StringFactory GetString_EdgeUnit]];
    p = [[DualTextCell alloc] initWithFrame:rect];
    [p SetTitle:szLabel]; 
    [p SetText:szScore]; 
    [pCell AddCell:p];

    [pCell SetSelectable:NO];
    [self AddCell:pCell];
    [pCell release];
}

-(void)InitializeSquareWinScoreList
{
	float w = self.frame.size.width;
	float h = [GUILayout GetDefaultListCellHeight];
	
    CGRect rect = CGRectMake(0, 0, w, h);
    GroupCell* pCell = [[GroupCell alloc] initWithFrame:rect];
    [pCell SetTitle:[StringFactory GetString_Square]]; 
    NSString* szLabel = [NSString stringWithFormat:@"%@: %@", [StringFactory GetString_WinningScore], [StringFactory GetString_Easy]];
    NSString* szScore = [NSString stringWithFormat:@"(%@)", [StringFactory GetString_EdgeUnit]];
    DualTextCell* p = [[DualTextCell alloc] initWithFrame:rect];
    [p SetTitle:szLabel]; 
    [p SetText:szScore]; 
    [pCell AddCell:p];
    
    szLabel = [NSString stringWithFormat:@"%@: %@", [StringFactory GetString_WinningScore], [StringFactory GetString_Difficult]];
    szScore = [NSString stringWithFormat:@"(%@) x (%@)", [StringFactory GetString_EdgeUnit], [StringFactory GetString_EdgeUnit]];
    p = [[DualTextCell alloc] initWithFrame:rect];
    [p SetTitle:szLabel]; 
    [p SetText:szScore]; 
    [pCell AddCell:p];
    
    [pCell SetSelectable:NO];
    [self AddCell:pCell];
    [pCell release];
}

-(void)InitializeDiamondWinScoreList
{
	float w = self.frame.size.width;
	float h = [GUILayout GetDefaultListCellHeight];
	
    CGRect rect = CGRectMake(0, 0, w, h);
    GroupCell* pCell = [[GroupCell alloc] initWithFrame:rect];
    [pCell SetTitle:[StringFactory GetString_Diamond]]; 
    NSString* szLabel = [NSString stringWithFormat:@"%@: %@", [StringFactory GetString_WinningScore], [StringFactory GetString_Easy]];
    NSString* szScore = [NSString stringWithFormat:@"(%@) - 1", [StringFactory GetString_EdgeUnit]];
    DualTextCell* p = [[DualTextCell alloc] initWithFrame:rect];
    [p SetTitle:szLabel]; 
    [p SetText:szScore]; 
    [pCell AddCell:p];
    
    szLabel = [NSString stringWithFormat:@"%@: %@", [StringFactory GetString_WinningScore], [StringFactory GetString_Difficult]];
    szScore = [NSString stringWithFormat:@"((%@) - 1) x 3", [StringFactory GetString_EdgeUnit]];
    p = [[DualTextCell alloc] initWithFrame:rect];
    [p SetTitle:szLabel]; 
    [p SetText:szScore]; 
    [pCell AddCell:p];
    
    [pCell SetSelectable:NO];
    [self AddCell:pCell];
    [pCell release];
}

-(void)InitializeHexagonWinScoreList
{
	float w = self.frame.size.width;
	float h = [GUILayout GetDefaultListCellHeight];
	
    CGRect rect = CGRectMake(0, 0, w, h);
    GroupCell* pCell = [[GroupCell alloc] initWithFrame:rect];
    [pCell SetTitle:[StringFactory GetString_Hexagon]]; 
    NSString* szLabel = [NSString stringWithFormat:@"%@: %@", [StringFactory GetString_WinningScore], [StringFactory GetString_Easy]];
    NSString* szScore = [NSString stringWithFormat:@"(%@) + 1", [StringFactory GetString_EdgeUnit]];
    DualTextCell* p = [[DualTextCell alloc] initWithFrame:rect];
    [p SetTitle:szLabel]; 
    [p SetText:szScore]; 
    [pCell AddCell:p];
    
    szLabel = [NSString stringWithFormat:@"%@: %@", [StringFactory GetString_WinningScore], [StringFactory GetString_Difficult]];
    szScore = [NSString stringWithFormat:@"((%@) + 1) x 4", [StringFactory GetString_EdgeUnit]];
    p = [[DualTextCell alloc] initWithFrame:rect];
    [p SetTitle:szLabel]; 
    [p SetText:szScore]; 
    [pCell AddCell:p];
    
    [pCell SetSelectable:NO];
    [self AddCell:pCell];
    [pCell release];
}

-(void)InitializeSwitch
{
    id<ListCellTemplate> pCell = [m_ListView GetCell:0];
    if([pCell isKindOfClass:[SwitchIconCell class]] == YES)
        NSLog(@"Yes");
    if([pCell isKindOfClass:[ScrollListView class]] == YES)
        NSLog(@"ScrollListView");
    
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


-(void)IntializeAllLists
{
//    [self InitializeSwitch];
    [self InitializeTriangleWinScoreList];
    [self InitializeSquareWinScoreList];
    [self InitializeDiamondWinScoreList];
    [self InitializeHexagonWinScoreList];
    [self UpdateViewLayout];
    [m_ListView UpdateContentSizeByContentView];	
}

-(void)LoadInformation
{
    [self IntializeAllLists];
}
-(void)OnViewOpen
{
    [self InitializeSwitch];
	[super OnViewOpen];
}	

-(void)OnLineStateSwitch:(NSNotification *)notification
{
    if(notification)
    {
        SwitchIconCell* pCell = [notification object];
        BOOL bOn = [pCell GetSwitchOnOff];
        [GameScore setAWSServiceEnable:bOn];
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

- (void)CreateSwitch
{
	float w = self.frame.size.width;
	float h = [GUILayout GetDefaulSwitchIconCellHeight];
	
	CGRect rect = CGRectMake(0, 0, w, h);
    SwitchIconCell* pCell2 = [[SwitchIconCell alloc] initWithFrame:rect withImage:@"onlinestate.png" withDisableImage:@"onlinestatedisable.png"];
    [pCell2 RegisterControlID:GUIID_EVENT_ONLINESTATUSBUTTON];
    [GUIEventLoop RegisterEvent:GUIID_EVENT_ONLINESTATUSBUTTON eventHandler:@selector(OnLineStateSwitch:) eventReceiver:self eventSender:pCell2];
    
    BOOL bOn2 = [GameScore isAWSServiceEnabled];
    [pCell2 SetSwitch:bOn2];
    
    [self AddCell:pCell2];
    [pCell2 release];

}

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
	{
        // Initialization code.
		self.backgroundColor = [ImageLoader GetDefaultViewBackgroundColor];
        [self CreateSwitch];
        [self LoadInformation];
    }
    return self;
}


@end
