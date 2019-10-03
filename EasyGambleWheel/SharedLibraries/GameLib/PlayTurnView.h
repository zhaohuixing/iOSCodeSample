//
//  PlayTurnView.h
//  XXXXXX
//
//  Created by Zhaohui Xing on 11-12-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface PlayTurnView : UIView<UIPickerViewDelegate, UIPickerViewDataSource> 
{
    UILabel*                m_Label;
    UIPickerView*			m_MethodPicker;
}

-(void)OpenView;

@end
