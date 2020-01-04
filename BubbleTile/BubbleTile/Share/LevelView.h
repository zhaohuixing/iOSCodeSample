//
//  LevelView.h
//  BubbleTile
//
//  Created by Zhaohui Xing on 11-09-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LevelView : UIView<UIPickerViewDelegate, UIPickerViewDataSource> 
{
	UIPickerView*			m_LevelPicker;
}

-(void)UpdateViewLayout;
-(void)UpdatePickerViewSelection:(NSInteger)nRow atComponent:(NSInteger)nComponent animated:(BOOL)bYes;
-(void)OpenView;

@end
