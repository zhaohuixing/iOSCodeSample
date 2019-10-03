//
//  TransactionView.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-12-15.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CashEarnDisplay.h"

@interface TransactionView : UIView<UIPickerViewDelegate, UIPickerViewDataSource>
{
    int                     m_nSeatID;
    int                     m_nCurrentChip;
    int                     m_nReceiverID;
    int                     m_nTransactionChips;
    BOOL                    m_bEnable;
	
    
    CashEarnDisplay*        m_PlayerIcon;
    UILabel*                m_PlayerLabel;
    UIPickerView*			m_PledgePicker;
	UIButton*               m_CloseButton;
    
    BOOL                    m_bActive;
}

-(void)OpenView:(int)nSeat;
-(void)CloseView;
-(int)GetSeatID;
-(int)GetReceiverID;
-(int)GetTransactionChips;
-(void)OnTimerEvent;
@end
