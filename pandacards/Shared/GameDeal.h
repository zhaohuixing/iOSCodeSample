//
//  GameDeal.h
//  MindFire
//
//  Created by ZXing on 26/10/2009.
//  Copyright 2009 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GameDeal : NSObject 
{
	int		m_Card[4];
}

- (void)SetCard:(int)nIndex withValue:(int)nValue;
- (int)GetCard:(int)nIndex;


@end
