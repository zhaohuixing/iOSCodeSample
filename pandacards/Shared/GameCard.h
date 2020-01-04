//
//  GameCard.h
//  MindFire
//
//  Created by ZXing on 24/10/2009.
//  Copyright Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameBaseView.h"

//The GameCard is a view object to rendering the card graphic in the deal view layout
@interface GameCard : GameBaseView 
{
	int				m_Card;
	CGImageRef		m_TempCardImage;
	BOOL			m_bHighlight;
	BOOL			m_bDragDrop;
	CGPoint			m_ptCursor;
	int				m_CardState;
}

@property int m_Card;

- (id)initCard:(int)nCard withRect:(CGRect)frame;
- (void)SetCard:(int)nCard;
- (int)GetCard;
- (int)GetCardIndex;
- (int)GetCardValue;
- (int)GetCardtype;
- (BOOL)IsValid;
- (BOOL)IsBasicCard;
- (BOOL)IsTempCard;
- (int)GetViewType;
- (void)OnTimerEvent;
- (void)LoadTempCardImages;
//- (void)UpdateGameViewLayout;
- (void)SetHighlight:(BOOL)bHighlight;
- (BOOL)HitCard:(CGPoint)point;
- (void)EnterDragAndDrop:(CGPoint)ptCur;
- (void)MoveCursorTo:(CGPoint)ptCur;
- (void)CleanCursor;
- (BOOL)IsDragAndDrop;
- (CGPoint)GetCursorPoint;
- (void)SetCursorPoint:(CGPoint)ptCur;
- (void)UpdateGameViewLayoutWithIndex:(int)i;
- (void)Hide;
- (void)ShowAt:(CGRect)rect;
- (void)Show;
- (void)ShowWithAlpha:(double)alpha;
- (BOOL)IsLive;
- (BOOL)IsInOperand1;
- (BOOL)IsInOperand2;
- (BOOL)IsInResult;
- (BOOL)IsInBasicSpace:(int)index;

- (BOOL)IsCloseToOperand1;
- (BOOL)IsCloseToOperand2;

- (void)MoveToOperand1;
- (void)MoveToOperand2;
- (void)MoveToResult;

- (int)GetCardState;
- (BOOL)AsOperand1;
- (BOOL)AsOperand2;
- (BOOL)AsResult;
- (BOOL)AsNoUsed;
- (void)ClearCardState;
- (void)SwitchTheme;
@end
