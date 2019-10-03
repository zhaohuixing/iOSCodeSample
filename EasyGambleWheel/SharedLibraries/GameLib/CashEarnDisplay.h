//
//  CashEarnDisplay.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-12-04.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CashEarnDisplay : UIView
{
@private
    CGImageRef                  m_ImageNumber;
    int                         m_nSeatID;
    BOOL                        m_bEnable;
}

-(void)SetPlayerIndex:(int)nSeat;
-(void)SetCurrentMoney:(int)nChip;
-(void)ClearCurrentMoney;
-(void)Open;
-(void)Close;
-(BOOL)IsOpen;
-(BOOL)IsEnable;
-(void)SetEnable:(BOOL)bEnable;
@end
