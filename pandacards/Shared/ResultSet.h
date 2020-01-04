//
//  ResultSet.h
//  MindFire
//
//  Created by Zhaohui Xing on 2010-04-24.
//  Copyright 2010 Zhaohui Xing. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "DealResult.h"

@interface ResultSet : NSObject 
{
	NSMutableArray*		m_AnswerList;
}

- (void)AddAnswer:(DealResult*)answer;
- (DealResult*)GetAnswer:(int)index;
- (int)GetSize;
- (void)Clear;

@end
