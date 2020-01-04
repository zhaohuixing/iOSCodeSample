//
//  NumericView.h
//  BubbleTile
//
//  Created by Zhaohui Xing on 11-05-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NumericView : UIView<UIPickerViewDelegate, UIPickerViewDataSource> 
{
	UIPickerView*			m_EdgePicker;
}

-(void)UpdateViewLayout;
-(void)UpdatePickerViewSelection:(NSInteger)nRow atComponent:(NSInteger)nComponent animated:(BOOL)bYes;
-(void)OpenView;

@end
