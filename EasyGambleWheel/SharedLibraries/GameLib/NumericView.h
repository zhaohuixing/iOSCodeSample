//
//  NumericView.h
//  XXXXXXXX
//
//  Created by Zhaohui Xing on 11-05-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CashEarnDisplay.h"

@interface NumericView : UIView<UIPickerViewDelegate, UIPickerViewDataSource> 
{
	CashEarnDisplay*        m_PlayerIcons[4];
    UILabel*                m_PlayerLabel[4];
    UIPickerView*			m_LuckyNumberPicker;
}

-(void)OpenView;
-(void)OnTimerEvent;
@end
