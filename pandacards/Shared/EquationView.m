//
//  EquationView.m
//  MindFire
//
//  Created by Zhaohui Xing on 2010-04-24.
//  Copyright 2010 Zhaohui Xing. All rights reserved.
//
#import "EquationView.h"
#import "CGameLayout.h"
#import "GUILayout.h"
#import "RenderHelper.h"

#include "GameUtility.h"
#include "GameState.h"

@implementation EquationView

- (void)ClearImages
{
	if(m_EquationImage != NULL)
	{
		CGImageRelease(m_EquationImage);
		m_EquationImage = NULL;
	}	
}

- (void)drawCard:(CGContextRef)context withCard:(int)index inRect:(CGRect)rect asOperand:(int)cardState
{
	if(IsBasicCard(index) == 1)
	{
		[RenderHelper DrawBasicCardAnimation:context withCard:index inRect:rect witHit:NO];
	}
	else if(IsTempCard(index) == 1)
	{
        CGImageRef tempCardImage = [RenderHelper GetTempCardImage_p:index];
		[RenderHelper DrawTempCard:context withImage:tempCardImage inRect:rect witHit:NO];
        CGImageRelease(tempCardImage);
	}	
}	

- (void)drawEquation:(CGContextRef)context inRect:(CGRect)rect
{
	float fcardw = [CGameLayout GetCardWidth]; 
	float fcardh = [CGameLayout GetCardHeight]; 
	//float fcardm = GetCardMargin();
	CGRect rt = CGRectMake(rect.origin.x, rect.origin.y, fcardw, fcardh);
	//Drawing Operand1:
	[self drawCard:context withCard:m_Equation.m_Operand1Card inRect:rt asOperand:GAME_CARD_STATE_OPERAND1];

	//Drawing Result:
	rt = CGRectMake(rect.origin.x+rect.size.width-fcardw, rect.origin.y, fcardw, fcardh);
	[self drawCard:context withCard:m_Equation.m_ResultCard inRect:rt asOperand:GAME_CARD_STATE_RESULT];
	
	float sw = (rect.size.width - 3*fcardw)*0.5;

	//Drawing Operand2:
	rt = CGRectMake(rect.origin.x+fcardw+sw, rect.origin.y, fcardw, fcardh);
	[self drawCard:context withCard:m_Equation.m_Operand2Card inRect:rt asOperand:GAME_CARD_STATE_OPERAND2];

	//Drawing Operator:
	float signSize = GAME_SIGNS_IMAGE_UNIT_SIZE;
	float sx = rect.origin.x+fcardw+(sw-signSize)*0.5;
	float sy = rect.origin.y+(rect.size.height-signSize)*0.5;
	
	rt = CGRectMake(sx, sy, signSize, signSize);
	[RenderHelper DrawSingleSign:context withSign:m_Equation.m_nOperation witHit:YES inRect:rt];

	//Drawing "=":
	sx = rect.origin.x+2.0*fcardw+sw+(sw-signSize)*0.5;
	
	rt = CGRectMake(sx, sy, signSize, signSize);
	[RenderHelper DrawSingleSign:context withSign:GAME_CALCULATION_EQUALTO witHit:YES inRect:rt];
 
}	

- (void)drawRect:(CGRect)rect 
{
    // Drawing code
	if(m_Equation != nil && [m_Equation IsValid] == YES && m_EquationImage != NULL)
	{
		CGContextRef context = UIGraphicsGetCurrentContext();
	    CGContextSaveGState(context);
        CGContextDrawImage(context, rect, m_EquationImage);
        CGContextRestoreGState(context);
    }	
}

- (id)initView:(CGRect)frame// withRoot:(UIView*)root
{
    if ((self = [super initWithFrame:frame])) 
	{
        // Initialization code
		m_Equation = [[CardEquation alloc] init];
		[self setBackgroundColor:[UIColor clearColor]];
	}
    return self;
}

- (void)LoadImages
{
	[self ClearImages];
	float width = [CGameLayout GetEqnImageWidth]; 
	float height = [CGameLayout GetEqnImageHeight];
	
	CGRect rect = CGRectMake(0.0, 0.0, width, height);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	[self drawEquation:bitmapContext inRect:rect];	
	
	m_EquationImage = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
	
}

- (void)SetEquation:(CardEquation*)eqn
{
	m_Equation.m_Operand1Card = eqn.m_Operand1Card;  //This the card index, not card value
	m_Equation.m_Operand2Card = eqn.m_Operand2Card;  //This the card index, not card value
	m_Equation.m_ResultCard = eqn.m_ResultCard;  //This the card index, not card value
	m_Equation.m_nOperation = eqn.m_nOperation;
	[self LoadImages];
	[self setNeedsDisplay];
}

- (void)SetEquation:(int)op1 withOprand2:(int)op2 withResult:(int)res withOperator:(int)oper
{
	m_Equation.m_Operand1Card = op1;  //This the card index, not card value
	m_Equation.m_Operand2Card = op2;  //This the card index, not card value
	m_Equation.m_ResultCard = res;  //This the card index, not card value
	m_Equation.m_nOperation = oper;
	[self LoadImages];
	[self setNeedsDisplay];
}	

- (void)OnTimerEvent
{
	[self setNeedsDisplay];
}

- (void)UpdateGameViewLayout
{
	[self setNeedsDisplay];
}

- (int)GetViewType
{
	return GAME_VIEW_EQNVIEW;
}	

- (void)Reset
{
	[self ClearImages];
	[m_Equation Reset];
}

- (void)dealloc 
{
	[m_Equation release];
	[self ClearImages];
    [super dealloc];
}


@end
