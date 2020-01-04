//
//  CardEquation.h
//  MindFire
//
//  Created by Zhaohui Xing on 2010-04-24.
//  Copyright 2010 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CardEquation : NSObject 
{
	int		m_Operand1Card;  //This the card index, not card value
	int		m_Operand2Card;  //This the card index, not card value
	int		m_ResultCard;  //This the card index, not card value
	int		m_nOperation;
}

@property int		m_Operand1Card;  //This the card index, not card value
@property int		m_Operand2Card;  //This the card index, not card value
@property int		m_ResultCard;  //This the card index, not card value
@property int		m_nOperation;

- (BOOL)IsValid;
- (void)Reset;
- (void)ToFormatDictionary:(NSMutableDictionary*)dict;
- (void)FromFormatDictionary:(NSDictionary*)dict;
- (CGImageRef)GetSnapshot:(float)width withHeight:(float)height;

@end
