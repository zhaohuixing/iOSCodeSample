//
//  PlayerPopupMenu.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-12-23.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "PlayerPopupMenu.h"
#import "PlayerPopupMenuItem.h"
#import "GUILayout.h"

#define PLAYERMENU_BALANCE_DISPLAY_TIME 5

@implementation PlayerPopupMenu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        //Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.hidden = YES;
    }
    return self;
}

-(void)OpenMenu
{
    if(self.hidden == NO)
        return;
    
    self.hidden = NO;
    [self.superview bringSubviewToFront:self];
    m_TimeStartShowBalance = [[NSProcessInfo  processInfo] systemUptime];    
}

-(void)CloseMenu
{
    self.hidden = YES;
    int nCount = (int)[self.subviews count];
    if(0 < nCount)
    {    
        for (int i = nCount-1; 0<=i; --i) 
        {
            PlayerPopupMenuItem* pItem = ((PlayerPopupMenuItem*)[self.subviews objectAtIndex:i]);
            if(pItem && [pItem respondsToSelector:@selector(OnCloseMenuItem)])
            {
                [pItem performSelector:@selector(OnCloseMenuItem)];
            }
        }
    }  
    CGRect rect = self.frame;
    float fWidht = rect.size.width;
    float fHeight = fWidht*[GUILayout GetPlayerPopuoMenueHeightRatio];
    rect.size.height = fHeight;
    [self setFrame:rect];
    [self.superview sendSubviewToBack:self];
}

-(void)AddMenuItem:(int)nEventID withLabel:(NSString*)label
{
    int nCount = (int)[self.subviews count];
    nCount = nCount+1;
    CGRect rect = self.frame;
    float fWidht = rect.size.width;
    float fHeight = fWidht*[GUILayout GetPlayerPopuoMenueHeightRatio];
    rect.size.height = fHeight*((float)nCount);
    [self setFrame:rect];
    float sx = 0;
    float sy = fHeight*((float)(nCount-1));
    rect = CGRectMake(sx, sy, fWidht, fHeight);
    PlayerPopupMenuItem* pItem = [[PlayerPopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterMenuItem:nEventID withLabel:label];
    [self addSubview:pItem];
}

-(void)AddOnlinePlayerMenuItem:(int)nEventID withLabel:(NSString*)label withDelegate:(id<IOnlineGamePlayerPopupMenuDelegate>)delegate
{
    int nCount = (int)[self.subviews count];
    nCount = nCount+1;
    CGRect rect = self.frame;
    float fWidht = rect.size.width;
    float fHeight = fWidht*[GUILayout GetPlayerPopuoMenueHeightRatio];
    rect.size.height = fHeight*((float)nCount);
    [self setFrame:rect];
    float sx = 0;
    float sy = fHeight*((float)(nCount-1));
    rect = CGRectMake(sx, sy, fWidht, fHeight);
    PlayerPopupMenuItem* pItem = [[PlayerPopupMenuItem alloc] initWithFrame:rect];
    [pItem RegisterOnlinePlayerMenuItem:nEventID withLabel:label withDelegate:delegate];
    [self addSubview:pItem];
}

-(void)OnTimerEvent
{
    if(self.hidden == NO)
    {
        NSTimeInterval currentTime = [[NSProcessInfo processInfo] systemUptime];
        if(PLAYERMENU_BALANCE_DISPLAY_TIME <= (currentTime - m_TimeStartShowBalance))
        {
            [self CloseMenu];
        }    
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



@end
