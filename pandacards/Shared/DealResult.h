//
//  DealResult.h
//  MindFire
//
//  Created by Zhaohui Xing on 2010-04-24.
//  Copyright 2010 Zhaohui Xing. All rights reserved.
//
#import <Foundation/Foundation.h>

@class CardEquation;

@interface DealResult : NSObject 
{
	NSMutableArray*		m_EquationList;
}

- (void)AddEquation:(CardEquation*)card;
- (CardEquation*)GetEquation:(int)index;
- (int)GetSize;
- (void)Clear;
- (void)ToFormatArray:(NSMutableArray*)array;
- (void)FromFormatArray:(NSArray*)array;

@end
