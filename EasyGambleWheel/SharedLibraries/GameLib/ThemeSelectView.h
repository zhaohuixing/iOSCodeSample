//
//  ThemeSelectView.h
//  XXXXXXXX
//
//  Created by Zhaohui Xing on 11-05-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CashEarnDisplay.h"

@interface ThemeSelectView : UIView<UIPickerViewDelegate, UIPickerViewDataSource> 
{
	CashEarnDisplay*        m_PlayerIcons;
    UILabel*                m_PlayerLabel;
    UIPickerView*			m_LuckyNumberPicker;

    UIImageView* viewKulo;
    UIImageView* viewAnimal1;
    UIImageView* viewAnimal2;
    
    UIImageView* viewAnimal;
    UIImageView* viewFruit;
    UIImageView* viewFlower;
    UIImageView* viewEasterEgg;
    UIImageView* viewNumeric;
    
}

-(void)OpenView;
-(void)OnTimerEvent;
@end
