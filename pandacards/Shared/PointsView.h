//
//  PointsView.h
//  MindFire
//
//  Created by Zhaohui Xing on 2010-03-17.
//  Copyright 2010 Zhaohui Xing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrameView.h"

@interface PointsView : FrameView<UIPickerViewDelegate, UIPickerViewDataSource> 
{
	UIPickerView*			m_pointPicker;
	NSMutableArray*         m_MajorPoints;
}

/*- (id)initView:(CGRect)frame withParent:(GameController*)pParent withPickerDelegate:(PointSetupController*)pDelegate;*/
- (int)GetViewType;
- (void)UpdateViewLayout;
- (void)UpdatePickerViewSelection:(NSInteger)nRow atComponent:(NSInteger)nComponent animated:(BOOL)bYes;

- (void)OnTimerEvent;

+(void)InitCustomizedpoints;
+(int)CustomizedpointIndex:(int)nPoint;
+(int)GetCustomizedpointAtIndex:(int)Index;


@end
