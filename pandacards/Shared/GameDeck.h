//
//  GameDeck.h
//  MindFire
//
//  Created by ZXing on 24/10/2009.
//  Copyright 2009 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResultSet.h"

@class GameDeal;

@interface GameDeck : NSObject 
{
	NSMutableArray*		m_CardList;
	NSMutableArray*		m_TempCardList;
	ResultSet*			m_Answers;
}

@property (nonatomic, retain) ResultSet*	m_Answers;


-(void)shuffle;
-(GameDeal*)getDeal;
-(void)queryDeal:(int*)nCard1 withCard2:(int*)nCard2 withCard3:(int*)nCard3 withCard4:(int*)nCard4;
-(void)clear;
-(BOOL)isEmpty;
-(int)getDealLeft;
-(void)ToFormatArray:(NSMutableArray*)array;
-(void)FromFormatArray:(NSArray*)array;

@end
