//
//  LevelView.m
//  BubbleTile
//
//  Created by Zhaohui Xing on 11-09-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "LevelView.h"
#import "GameConfiguration.h"
#import "GameConstants.h"
#import "GameScore.h"
#import "ApplicationResource.h"
#import "GUIEventLoop.h"
#import "StringFactory.h"

@implementation LevelView


-(void)UpdatePickerViewLayout
{
	//float fSize = fminf(self.frame.size.width, self.frame.size.height);
    //CGRect rect = CGRectMake(0, 0, fSize, fSize);
    //[m_LevelPicker setFrame:rect];
    double cx = self.frame.size.width/2;
	double cy = self.frame.size.height/2;
	[m_LevelPicker setCenter:CGPointMake(cx, cy)];
}	

-(void)initPickerView:(id)pDelegate
{
    float w = 400;
    float h = 300;
    if([ApplicationConfigure iPhoneDevice])
    {
        w = 300;
        h = 225;
    }
    float sx = (self.frame.size.width-w)/2.0;
    float sy = (self.frame.size.height-h)/2.0;
    
	m_LevelPicker = [[[UIPickerView alloc] initWithFrame:CGRectMake(sx, sy, w, h)] autorelease];
	m_LevelPicker.backgroundColor = [UIColor clearColor];//lightGrayColor];
	m_LevelPicker.contentMode = UIViewContentModeScaleToFill;
	[m_LevelPicker setAlpha:1.0];
	m_LevelPicker.delegate = pDelegate;
	m_LevelPicker.dataSource = pDelegate;
	m_LevelPicker.showsSelectionIndicator = YES;
	m_LevelPicker.clearsContextBeforeDrawing = YES;
    
    float r = h/m_LevelPicker.bounds.size.height;
    
    if(r < 1.0)
    {    
        CGAffineTransform t0 = CGAffineTransformMakeTranslation(0, m_LevelPicker.bounds.size.height/2);
        CGAffineTransform s0 = CGAffineTransformMakeScale(1.0, r);
        CGAffineTransform t1 = CGAffineTransformMakeTranslation (0, -m_LevelPicker.bounds.size.height/2);
        m_LevelPicker.transform = CGAffineTransformConcat(t0, CGAffineTransformConcat(s0, t1));    
    }
    
	[self addSubview:m_LevelPicker];
	[self bringSubviewToFront:m_LevelPicker];
	[self UpdatePickerViewLayout];
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
    [super dealloc];
}

-(void)UpdateViewLayout
{
	[self UpdatePickerViewLayout];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1; 
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSString* str = @"";
	
    if(row == 0)
    {    
        str = [StringFactory GetString_Easy];
    }
    else
    {
        str = [StringFactory GetString_Difficult];
    }
	return str;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	int index = row;
    
    if(index == 0)
    {
        [GameConfiguration SetGameDifficulty:NO];
    }
    else
    {
        [GameConfiguration SetGameDifficulty:YES];
    }
}

-(void)OpenView
{
    [m_LevelPicker reloadAllComponents];
    
    if([GameConfiguration IsGameDifficulty])
    {
        [m_LevelPicker selectRow:1 inComponent:0 animated:NO];
    }
    else
    {
        [m_LevelPicker selectRow:0 inComponent:0 animated:NO];
    }
}	

-(void)UpdatePickerViewSelection:(NSInteger)nRow atComponent:(NSInteger)nComponent animated:(BOOL)bYes
{
    
}

@end
