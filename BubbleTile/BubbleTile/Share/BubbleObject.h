//
//  BubbleObject.h
//  BubbleTile
//
//  Created by Zhaohui Xing on 11-05-07.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameConstants.h"


@interface BubbleObject : NSObject 
{
    int         m_nCurrentLocationIndex;
    CGImageRef  m_Bubble;
    BOOL        m_bIconTemplate;
    int         m_nLabelValue;
    BOOL         m_bShowQmark;
    enBubbleType    m_BubbleType;
}

@property (nonatomic) int m_nCurrentLocationIndex;

-(id)init:(enBubbleType)bType;
-(id)initBubble:(int)nLabel isTemplate:(BOOL)bNo withType:(enBubbleType)bType;
-(void)SetLabel:(int)nLabel;
-(void)DrawBubble:(CGContextRef)context inRect:(CGRect)rect inMotion:(BOOL)bMotion;
-(void)SetIconTemplate:(BOOL)bIcon;
-(int)GetLabelValue;
-(void)SetQMark:(BOOL)bShow;

@end
