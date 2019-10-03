//
//  PledgeView.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-12-15.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "PledgeView.h"
#import "Configuration.h"
#import "ApplicationResource.h"
#import "GameViewController.h"
#import "GUIEventLoop.h"
#import "GUILayout.h"
#import "GameUtiltyObjects.h"
#import "GameConstants.h"
#import "ApplicationConfigure.h"
#import "UIColor+GameColor.h"

@implementation PledgeView

-(float)GetCloseButtonSize
{
    if([ApplicationConfigure iPADDevice])
        return 40;
    else
        return 30;
}


-(void)CloseButtonClick
{
    if([self.superview respondsToSelector:@selector(OnClosePlayerPledgeView)])
    {
        [self.superview performSelector:@selector(OnClosePlayerPledgeView)];
    }    
}

-(void)initPickerView:(id)pDelegate
{
    float w = [GUILayout GetLuckyNumberPickViewWidth];
    float h = [GUILayout GetLuckyNumberPickViewHeight];
    float iconw = [GUILayout GetCashEarnDislayWidth];
    float iconh = [GUILayout GetLuckyNumberPickViewIconHeight];
    float labelh = [GUILayout GetLuckyNumberPickViewLabelHeight];
    float sx, sy;
    CGRect rt;
    sx = (w - iconw)/2.0;
    sy = 0;
    rt = CGRectMake(sx, sy, iconw, iconh);
    m_PlayerIcon = [[CashEarnDisplay alloc] initWithFrame:rt];
    [m_PlayerIcon SetPlayerIndex:0];
    [self addSubview:m_PlayerIcon];
    
    sy = iconh;
 	rt = CGRectMake(sx, sy, iconw, labelh);
	m_PlayerLabel = [[UILabel alloc] initWithFrame:rt];
	m_PlayerLabel.backgroundColor = [UIColor clearColor];
	[m_PlayerLabel setTextColor:[UIColor darkTextColor]];
	m_PlayerLabel.font = [UIFont fontWithName:@"Times New Roman" size:iconh*0.15];
    [m_PlayerLabel setTextAlignment:NSTextAlignmentCenter];
    m_PlayerLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    m_PlayerLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:m_PlayerLabel];
    
    float ph = [GUILayout GetLuckyNumberPickViewPikcerHeight];
    sx = 0.0;
    sy = h - ph;
	m_PledgePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(sx, sy, w, ph)];
    
    m_PledgePicker.backgroundColor = [UIColor GamePickerLightGrayColor];
    m_PledgePicker.tintColor = [UIColor GamePickerLightGrayColor]; 
    m_PledgePicker.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed; //[UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.0]; //??[UIColor
    
    m_PledgePicker.contentMode = UIViewContentModeScaleToFill;
	[m_PledgePicker setAlpha:1.0];
	m_PledgePicker.delegate = pDelegate;
	m_PledgePicker.dataSource = pDelegate;
	m_PledgePicker.showsSelectionIndicator = YES;
	m_PledgePicker.clearsContextBeforeDrawing = YES;
    m_PledgePicker.multipleTouchEnabled = YES;
    float r = ph/m_PledgePicker.bounds.size.height;

    if(r < 1.0)
    {    
        CGAffineTransform t0 = CGAffineTransformMakeTranslation(0, m_PledgePicker.bounds.size.height/2);
        CGAffineTransform s0 = CGAffineTransformMakeScale(1.0, r);
        CGAffineTransform t1 = CGAffineTransformMakeTranslation (0, -m_PledgePicker.bounds.size.height/2);
        m_PledgePicker.transform = CGAffineTransformConcat(t0, CGAffineTransformConcat(s0, t1));    
    }
    
    //[m_PledgePicker sizeToFit];
    m_PledgePicker.autoresizesSubviews = YES;
	[self addSubview:m_PledgePicker];
	[self bringSubviewToFront:m_PledgePicker];
    
    
    float size = [self GetCloseButtonSize]*1.5;
    m_CloseButton = [[UIButton alloc] initWithFrame:CGRectMake(0, h-ph-size, size, size)];
    m_CloseButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_CloseButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [m_CloseButton setBackgroundImage:[UIImage imageNamed:@"closeicon.png"] forState:UIControlStateNormal];
    [m_CloseButton setBackgroundImage:[UIImage imageNamed:@"closeiconhi.png"] forState:UIControlStateHighlighted];
    [m_CloseButton addTarget:self action:@selector(CloseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:m_CloseButton];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        [self initPickerView:self];
        m_bEnable = NO;
        m_bActive = NO;
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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 2; 
}

/*
- (CGSize)rowSizeForComponent:(NSInteger)component
{
    return CGSizeMake(10, 10);
}*/

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    int nRet = 0;
    if(m_bEnable == NO)
        return nRet;
    
    if(component == 0)
    {
        nRet = [GameUitltyHelper GetGameLuckNumberThreshold:m_nCurrentGameType];
    }
    else
    {
        int nMinBet = [GameUitltyHelper GetGameBetPledgeThreshold:m_nCurrentGameType];
        nRet = m_nCurrentChip - nMinBet+1;
    }
    
    if(nRet < 0)
        nRet = 0;
        
	return nRet;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSString* str = @"";
    if(m_bEnable == NO)
        return str;
   
    
    if(component == 0)
    {
        int nValue = (int)row+1;
        str = [NSString stringWithFormat:@"%i", nValue];
    }
    else
    {
        int nMinBet = [GameUitltyHelper GetGameBetPledgeThreshold:m_nCurrentGameType];
        int nValue = nMinBet + (int)row;
        str = [NSString stringWithFormat:@"%i", nValue];
    }
    
	return str;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(m_bEnable == NO)
        return;
    
    GameViewController* pController = (GameViewController*)[GUILayout GetGameViewController];
    if(!pController)
        return;
	
    if(component == 0)
    {
        NSLog(@"First Col selected");
        m_nLuckNumber = (int)row+1;
        [m_PledgePicker selectRow:row inComponent:0 animated:YES];
        int nRow = (int)[pickerView selectedRowInComponent: 1];
        if(0 <= nRow)
        {    
            int nMinBet = [GameUitltyHelper GetGameBetPledgeThreshold:m_nCurrentGameType];
            m_nBetMoney = nMinBet + nRow;
            int nLeftMoney = m_nCurrentChip - m_nBetMoney;
            [m_PlayerIcon SetCurrentMoney:nLeftMoney];
            [m_PledgePicker selectRow:nRow inComponent:1 animated:YES];
        }
    }
    else
    {
        NSLog(@"Second Col selected");
        int nMinBet = [GameUitltyHelper GetGameBetPledgeThreshold:m_nCurrentGameType];
        m_nBetMoney = nMinBet + (int)row;
        int nLeftMoney = m_nCurrentChip - m_nBetMoney;
        [m_PlayerIcon SetCurrentMoney:nLeftMoney];
        [m_PledgePicker selectRow:row inComponent:1 animated:YES];
    }
}

-(void)OpenView:(int)nSeat
{
    GameViewController* pController = (GameViewController*)[GUILayout GetGameViewController];
    if(!pController)
        return;

    self.hidden = NO;
    [self.superview bringSubviewToFront:self];
    
    m_nCurrentGameType = [Configuration getCurrentGameType];

    m_nSeatID = nSeat;
    m_nCurrentChip = [pController GetPlayerCurrentMoney:m_nSeatID];
    m_bEnable = [pController CanPlayerPlayGame:m_nCurrentGameType inSeat:m_nSeatID];
    [m_PlayerIcon SetEnable:m_bEnable];
    [m_PlayerLabel setText:[pController GetPlayerName:m_nSeatID]];

    [m_PledgePicker reloadAllComponents];
    
    m_nLuckNumber = 1;
    m_nBetMoney = [GameUitltyHelper GetGameBetPledgeThreshold:m_nCurrentGameType];
	[m_PledgePicker selectRow:0 inComponent:0 animated:NO];
	[m_PledgePicker selectRow:0 inComponent:1 animated:NO];
    [m_PledgePicker setNeedsLayout];
    int nLeftMoney = m_nCurrentChip - [GameUitltyHelper GetGameBetPledgeThreshold:m_nCurrentGameType];
    [m_PlayerIcon SetCurrentMoney:nLeftMoney];
    
    m_bActive = YES;
}


-(void)CloseView
{
    m_bActive = NO;
    self.hidden = YES;
    [self.superview sendSubviewToBack:self];
}

-(int)GetSeatID
{
    return m_nSeatID;
}

-(int)GetSelectedLuckNumber
{
    return m_nLuckNumber;
}

-(int)GetPledgedBet
{
    return m_nBetMoney;
}


-(void)OnTimerEvent
{
    if(m_bActive == NO)
        return;
        
    int nRow = (int)[m_PledgePicker selectedRowInComponent: 0];
    if(0 <= nRow)
    {
        if(m_nLuckNumber != nRow+1)
        {
            m_nLuckNumber = nRow+1; 
            [m_PledgePicker selectRow:nRow inComponent:0 animated:YES];
        }
    }
    
    nRow = (int)[m_PledgePicker selectedRowInComponent: 1];
    if(0 <= nRow)
    {    
        int nMinBet = [GameUitltyHelper GetGameBetPledgeThreshold:m_nCurrentGameType];
        if(m_nBetMoney != nMinBet + nRow)
        {  
            m_nBetMoney = nMinBet + nRow;
            int nLeftMoney = m_nCurrentChip - m_nBetMoney;
            [m_PlayerIcon SetCurrentMoney:nLeftMoney];
            [m_PledgePicker selectRow:nRow inComponent:1 animated:YES];
        }    
    }
}

@end
