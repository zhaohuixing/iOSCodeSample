//
//  BetMethodView.m
//  XXXXXXX
//
//  Created by Zhaohui Xing on 11-12-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "BetMethodView.h"
#import "Configuration.h"
#import "ApplicationResource.h"
#import "GameViewController.h"
#import "GUIEventLoop.h"
#import "GUILayout.h"
#import "GameUtiltyObjects.h"
#import "GameConstants.h"
#import "StringFactory.h"
#import "UIColor+GameColor.h"

@implementation BetMethodView


-(void)initPickerView:(id)pDelegate
{
    float fSize = [GUILayout GetFullScreenAdLabelFont];
    
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, fSize);
    m_Label = [[UILabel alloc] initWithFrame:rect];
    m_Label.backgroundColor = [UIColor lightGrayColor];
    [m_Label setTextColor:[UIColor darkTextColor]];
    m_Label.font = [UIFont fontWithName:@"Times New Roman" size:fSize];
    [m_Label setTextAlignment:NSTextAlignmentCenter];
    m_Label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    m_Label.adjustsFontSizeToFitWidth = YES;
    [m_Label setText:[StringFactory GetString_RoPaPledgeMethodLabel]];
    [self addSubview:m_Label];
    
    float h = self.frame.size.height-fSize;
    float sx = 0.0;
    float sy = fSize;
	m_MethodPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(sx, sy, self.frame.size.width, h)];
    m_MethodPicker.backgroundColor = [UIColor GamePickerLightGrayColor]; //[UIColor clearColor];
	m_MethodPicker.contentMode = UIViewContentModeScaleToFill;
	[m_MethodPicker setAlpha:1.0];
	m_MethodPicker.delegate = pDelegate;
	m_MethodPicker.dataSource = pDelegate;
	m_MethodPicker.showsSelectionIndicator = YES;
	m_MethodPicker.clearsContextBeforeDrawing = YES;
	
    float r = h/m_MethodPicker.bounds.size.height;
    
    if(r < 1.0)
    {    
        CGAffineTransform t0 = CGAffineTransformMakeTranslation(0, m_MethodPicker.bounds.size.height/2);
        CGAffineTransform s0 = CGAffineTransformMakeScale(1.0, r);
        CGAffineTransform t1 = CGAffineTransformMakeTranslation (0, -m_MethodPicker.bounds.size.height/2);
        m_MethodPicker.transform = CGAffineTransformConcat(t0, CGAffineTransformConcat(s0, t1));    
    }
    
    [self addSubview:m_MethodPicker];
	[self bringSubviewToFront:m_MethodPicker];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        [self initPickerView:self];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    
}

-(void)UpdateViewLayout
{
	//[self UpdatePickerViewLayout];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1; 
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    int nRet = 2;
	return nRet;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSString* str = @"";
    if((int)row == 0)
        str = [StringFactory GetString_Automatically];
    else
        str = [StringFactory GetString_Manually];
        
	return str;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if((int)row == 0)
        [Configuration setRoPaAutoBet:YES];
    else
        [Configuration setRoPaAutoBet:NO];
}

-(void)OpenView
{
    int nIndex = 0;
    if([Configuration isRoPaAutoBet])
        nIndex = 0;
    else
        nIndex = 1;
    [m_MethodPicker reloadAllComponents];
    [m_MethodPicker selectRow:nIndex inComponent:0 animated:YES];
}	


@end
