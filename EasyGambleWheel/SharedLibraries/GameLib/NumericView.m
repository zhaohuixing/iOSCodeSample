//
//  NumericView.m
//  XXXXXXX
//
//  Created by Zhaohui Xing on 11-05-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "NumericView.h"
#import "Configuration.h"
#import "GameConstants.h"
#import "GameScore.h"
#import "ApplicationResource.h"
#import "GameViewController.h"
#import "GUIEventLoop.h"
#import "GUILayout.h"
#import "GameUtiltyObjects.h"
#import "GameConstants.h"
#import "ScoreRecord.h"
#import "UIColor+GameColor.h"

@implementation NumericView


-(void)initPickerView:(id)pDelegate
{
    float w = [GUILayout GetLuckyNumberPickViewWidth];
    float h = [GUILayout GetLuckyNumberPickViewHeight];
    float unitw = w/4.0;
    float iconw = [GUILayout GetCashEarnDislayWidth];
    float iconh = [GUILayout GetLuckyNumberPickViewIconHeight];
    float labelh = [GUILayout GetLuckyNumberPickViewLabelHeight];
    float sx, sy;
    CGRect rt;
    for(int i = 0; i < 4; ++i)
    {
        sx = unitw*i + (unitw - iconw)/2.0;
        sy = 0;
        rt = CGRectMake(sx, sy, iconw, iconh);
        m_PlayerIcons[i] = [[CashEarnDisplay alloc] initWithFrame:rt];
        [m_PlayerIcons[i] SetPlayerIndex:i];
        [self addSubview:m_PlayerIcons[i]];
        
        //sx = unitw*i;
        sy = iconh;
 		rt = CGRectMake(sx, sy, unitw, labelh);
		m_PlayerLabel[i] = [[UILabel alloc] initWithFrame:rt];
		m_PlayerLabel[i].backgroundColor = [UIColor clearColor];
		[m_PlayerLabel[i] setTextColor:[UIColor darkTextColor]];
		m_PlayerLabel[i].font = [UIFont fontWithName:@"Times New Roman" size:iconh*0.15];
        [m_PlayerLabel[i] setTextAlignment:NSTextAlignmentCenter];
        m_PlayerLabel[i].baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        m_PlayerLabel[i].adjustsFontSizeToFitWidth = YES;
		[self addSubview:m_PlayerLabel[i]];
    }
    
    float ph = [GUILayout GetLuckyNumberPickViewPikcerHeight];
    sx = 0.0;
    sy = h - ph;
	m_LuckyNumberPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(sx, sy, w, ph)];
    m_LuckyNumberPicker.backgroundColor = [UIColor GamePickerLightGrayColor]; //[UIColor clearColor];//lightGrayColor];
	m_LuckyNumberPicker.contentMode = UIViewContentModeScaleToFill;
	[m_LuckyNumberPicker setAlpha:1.0];
	m_LuckyNumberPicker.delegate = pDelegate;
	m_LuckyNumberPicker.dataSource = pDelegate;
	m_LuckyNumberPicker.showsSelectionIndicator = YES;
	m_LuckyNumberPicker.clearsContextBeforeDrawing = YES;
    
    float r = ph/m_LuckyNumberPicker.bounds.size.height;
    
    if(r < 1.0)
    {    
        CGAffineTransform t0 = CGAffineTransformMakeTranslation(0, m_LuckyNumberPicker.bounds.size.height/2);
        CGAffineTransform s0 = CGAffineTransformMakeScale(1.0, r);
        CGAffineTransform t1 = CGAffineTransformMakeTranslation (0, -m_LuckyNumberPicker.bounds.size.height/2);
        m_LuckyNumberPicker.transform = CGAffineTransformConcat(t0, CGAffineTransformConcat(s0, t1));    
    }
    
	[self addSubview:m_LuckyNumberPicker];
	[self bringSubviewToFront:m_LuckyNumberPicker];
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
//    enGridType enType = [GameConfiguration GetGridType];
    int nRet = 4;//[GameConfiguration GetEnabledBubbleUnitCount:enType];
	return nRet;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSString* str = @"";
    int nValue = [GameUitltyHelper GetGameLuckNumberThreshold:(int)row];
    str = [NSString stringWithFormat:@"%i", nValue];
    
	return str;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    GameViewController* pController = (GameViewController*)[GUILayout GetGameViewController];
    if(!pController)
        return;
	
    int nType = row;
    [Configuration setCurrentGameType:nType];
    [ScoreRecord SetGameType:nType];
    [ScoreRecord SaveScore];
    for(int i = 0; i < 4; ++i)
    {
        BOOL bEnable = [pController CanPlayerPlayGame:nType inSeat:i];
        [m_PlayerIcons[i] SetEnable:bEnable];
    }
}

-(void)OpenView
{
    GameViewController* pController = (GameViewController*)[GUILayout GetGameViewController];
    if(!pController)
        return;
    
    int nType = [Configuration getCurrentGameType];
    [m_LuckyNumberPicker reloadAllComponents];
    [m_LuckyNumberPicker selectRow:nType inComponent:0 animated:YES];
    for(int i = 0; i < 4; ++i)
    {
        int nChips = [pController GetPlayerCurrentMoney:i];
        [m_PlayerIcons[i] SetCurrentMoney:nChips];
        BOOL bEnable = [pController CanPlayerPlayGame:nType inSeat:i];
        [m_PlayerIcons[i] SetEnable:bEnable];
		[m_PlayerLabel[i] setText:[pController GetPlayerName:i]];
    }
}	

-(void)OnTimerEvent
{
    if(self.hidden == YES)
        return;

    GameViewController* pController = (GameViewController*)[GUILayout GetGameViewController];
    if(!pController)
        return;
    
    int nRow = [m_LuckyNumberPicker selectedRowInComponent: 0];
    if(0 <= nRow)
    {
        int nType = [Configuration getCurrentGameType];
        if(nType != nRow)
        {
            nType = nRow;
            [Configuration setCurrentGameType:nType];
            [ScoreRecord SetGameType:nType];
            [ScoreRecord SaveScore];
            for(int i = 0; i < 4; ++i)
            {
                BOOL bEnable = [pController CanPlayerPlayGame:nType inSeat:i];
                [m_PlayerIcons[i] SetEnable:bEnable];
            }
        }
    }
    
}
@end
