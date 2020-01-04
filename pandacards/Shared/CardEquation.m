//
//  CardEquation.m
//  MindFire
//
//  Created by Zhaohui Xing on 10-04-24.
//  Copyright 2010 Zhaohui Xing. All rights reserved.
//
#import "CardEquation.h"
#import "RenderHelper.h"
#include "GameUtility.h"


@implementation CardEquation

@synthesize		m_Operand1Card;  //This the card index, not card value
@synthesize		m_Operand2Card;  //This the card index, not card value
@synthesize		m_ResultCard;  //This the card index, not card value
@synthesize		m_nOperation;

- (id)init
{
    if ((self = [super init])) 
	{
		m_Operand1Card = -1;  //This the card index, not card value
		m_Operand2Card = -1;  //This the card index, not card value
		m_ResultCard = -1;  //This the card index, not card value
		m_nOperation = -1;
	}
	return self;
}	

- (BOOL)IsValid
{
	if(m_Operand1Card < 0)
		return NO;
	
	if(m_Operand2Card < 0)
		return NO;
	
	if(m_ResultCard < 0)
		return NO;
	
	if(m_nOperation != GAME_CALCULATION_PLUS && m_nOperation != GAME_CALCULATION_MINUES &&
	   m_nOperation != GAME_CALCULATION_TIME && m_nOperation != GAME_CALCULATION_DIVIDE)
		return NO;
	   
	return YES;
}	

- (void)Reset
{
	m_Operand1Card = -1;  //This the card index, not card value
	m_Operand2Card = -1;  //This the card index, not card value
	m_ResultCard = -1;  //This the card index, not card value
	m_nOperation = -1;
}

- (void)ToFormatDictionary:(NSMutableDictionary*)dict
{
    NSNumber* card1 = [[[NSNumber alloc] initWithInt:m_Operand1Card] autorelease];
    NSNumber* card2 = [[[NSNumber alloc] initWithInt:m_Operand2Card] autorelease];
    NSNumber* operator = [[[NSNumber alloc] initWithInt:m_nOperation] autorelease];
    NSNumber* result = [[[NSNumber alloc] initWithInt:m_ResultCard] autorelease];
    
    [dict setObject:card1 forKey:@"card1"];
    [dict setObject:card2 forKey:@"card2"];
    [dict setObject:operator forKey:@"operator"];
    [dict setObject:result forKey:@"result"];
}

- (void)FromFormatDictionary:(NSDictionary*)dict
{
    if(dict == nil)
        return;
    
    NSNumber* card1 = [dict valueForKey:@"card1"];
    if(card1 != nil)
    {
        m_Operand1Card = [card1 intValue]; 
    }

    NSNumber* card2 = [dict valueForKey:@"card2"];
    if(card2 != nil)
    {
        m_Operand2Card = [card2 intValue]; 
    }

    NSNumber* operator = [dict valueForKey:@"operator"];
    if(operator != nil)
    {
        m_nOperation = [operator intValue]; 
    }
    
    NSNumber* result = [dict valueForKey:@"result"];
    if(result != nil)
    {
        m_ResultCard = [result intValue];
    }
}

- (CGImageRef)GetSnapshot:(float)width withHeight:(float)height
{
    float sw = width*0.2;
    float sh = height;
    float smarge = sw*0.1;
    float sx = 0;
    float sy = 0;
    float ssize = sw*0.6; 
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	
    sx = smarge;
    sy = smarge;
	CGRect rect = CGRectMake(sx, sy, sw-2.0*smarge, sh-2.0*smarge);

    [RenderHelper DrawSimpleCardNumber:bitmapContext withCard:m_Operand1Card inRect:rect];
	
    sx = sw+(sw-ssize)*0.5;
    sy = (sh-ssize)*0.5;
	rect = CGRectMake(sx, sy, ssize, ssize);
    [RenderHelper DrawSingleSign:bitmapContext withSign:m_nOperation witHit:YES inRect:rect];
    
    sx = sw*2 + smarge;
    sy = smarge;
	rect = CGRectMake(sx, sy, sw-2.0*smarge, sh-2.0*smarge);
    [RenderHelper DrawSimpleCardNumber:bitmapContext withCard:m_Operand2Card inRect:rect];

    sx = 3*sw+(sw-ssize)*0.5;
    sy = (sh-ssize)*0.5;
	rect = CGRectMake(sx, sy, ssize, ssize);
    [RenderHelper DrawSingleSign:bitmapContext withSign:GAME_CALCULATION_EQUALTO witHit:YES inRect:rect];
    
    sx = sw*4 + smarge;
    sy = smarge;
	rect = CGRectMake(sx, sy, sw-2.0*smarge, sh-2.0*smarge);
    [RenderHelper DrawSimpleCardNumber:bitmapContext withCard:m_ResultCard inRect:rect];
    
    CGImageRef retImage = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
    
    return retImage;
}

@end
