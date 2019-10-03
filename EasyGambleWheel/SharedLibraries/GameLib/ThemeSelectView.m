//
//  ThemeSelectView.m
//  XXXXXXX
//
//  Created by Zhaohui Xing on 11-05-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "ThemeSelectView.h"
#import "Configuration.h"
//#import "GameConstants.h"
//#import "GameScore.h"
#import "ApplicationResource.h"
#import "GameViewController.h"
#import "GUIEventLoop.h"
#import "GUILayout.h"
#import "GameUtiltyObjects.h"
#import "GameConstants.h"
#import "ScoreRecord.h"
#import "UIColor+GameColor.h"

@implementation ThemeSelectView


-(void)initPickerView:(id)pDelegate
{
    float w = [GUILayout GetLuckyNumberPickViewWidth];
    if([ApplicationConfigure iPhoneDevice])
        w = 300;
    
    float h = [GUILayout GetLuckyNumberPickViewHeight];
    float unitw = w/4.0;
    float iconw = [GUILayout GetCashEarnDislayWidth];
    float iconh = [GUILayout GetLuckyNumberPickViewIconHeight];
    float labelh = [GUILayout GetLuckyNumberPickViewLabelHeight];
    float sx, sy;
    CGRect rt;
        sx = (unitw - iconw)/2.0;
        sy = 0;
        rt = CGRectMake(sx, sy, iconw, iconh);
        m_PlayerIcons = [[CashEarnDisplay alloc] initWithFrame:rt];
        [m_PlayerIcons SetPlayerIndex:0];
        [self addSubview:m_PlayerIcons];
    
        //sx = unitw*i;
        sy = iconh;
 		rt = CGRectMake(sx, sy, unitw, labelh);
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
	m_LuckyNumberPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(sx, sy, w, ph)];
	m_LuckyNumberPicker.backgroundColor = [UIColor GamePickerLightGrayColor];
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

-(void)InitImageViews
{
    UIImage* imageAnimal = [UIImage imageNamed:@"abanner.png"];
    UIImage* imageFruit = [UIImage imageNamed:@"ftbanner.png"];
    UIImage* imageFlower = [UIImage imageNamed:@"frbanner.png"];
    UIImage* imageEasterEgg = [UIImage imageNamed:@"etbanner.png"];
    UIImage* imageNumeric = [UIImage imageNamed:@"nbanner.png"];

    viewAnimal = [[UIImageView alloc] initWithImage:imageAnimal];
    viewFruit = [[UIImageView alloc] initWithImage:imageFruit];
    viewFlower = [[UIImageView alloc] initWithImage:imageFlower];
    
    viewEasterEgg = [[UIImageView alloc] initWithImage:imageEasterEgg];
    viewNumeric = [[UIImageView alloc] initWithImage:imageNumeric];
    
    UIImage* imageKulo = [UIImage imageNamed:@"klbanner.png"];
    
    viewKulo = [[UIImageView alloc] initWithImage:imageKulo];
    
    UIImage* imageAnimal1 = [UIImage imageNamed:@"a1banner.png"];
    viewAnimal1 = [[UIImageView alloc] initWithImage:imageAnimal1];

    UIImage* imageAnimal2 = [UIImage imageNamed:@"a2banner.png"];
    viewAnimal2 = [[UIImageView alloc] initWithImage:imageAnimal2];
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        [self initPickerView:self];
        [self InitImageViews];
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
    int nRet = 5+3;//[GameConfiguration GetEnabledBubbleUnitCount:enType];
	return nRet;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSString* str = @"";
    int nValue = [GameUitltyHelper GetGameLuckNumberThreshold:(int)row];
    str = [NSString stringWithFormat:@"%i", nValue];
    
	return str;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 60;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    GameViewController* pController = (GameViewController*)[GUILayout GetGameViewController];
    if(!pController)
        return;
	
    int nType = (int)row;
    [Configuration setCurrentGameTheme:nType];
    [ScoreRecord SetGameTheme:nType];
    [ScoreRecord SaveScore];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UIView * myView = nil;
    
    if(row == GAME_THEME_KULO)
    {
        myView = viewKulo;
    }
    else if(row == GAME_THEME_ANIMAL1)
    {
        myView = viewAnimal1;
    }
    else if(row == GAME_THEME_ANIMAL2)
    {
        myView = viewAnimal2;
    }
    else if(row == GAME_THEME_ANIMAL)
    {
        myView = viewAnimal;
    }
    else if(row == GAME_THEME_FLOWER)
    {
        myView = viewFlower;
    }
    else if(row == GAME_THEME_FOOD)
    {
        myView = viewFruit;
    }
    else if(row == GAME_THEME_EASTEREGG)
    {
        myView = viewEasterEgg;
    }
    else
    {
        myView = viewNumeric;
    }
    
    UIGraphicsBeginImageContextWithOptions(myView.bounds.size, NO, 0);
    
    [myView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    // then convert back to a UIImageView and return it
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    return imageView;
}


-(void)OpenView
{
    GameViewController* pController = (GameViewController*)[GUILayout GetGameViewController];
    if(!pController)
        return;
    
    int nType = [Configuration getCurrentGameTheme];
    [m_LuckyNumberPicker reloadAllComponents];
    [m_LuckyNumberPicker selectRow:nType inComponent:0 animated:YES];
    //for(int i = 0; i < 4; ++i)
    //{
    int nChips = [pController GetPlayerCurrentMoney:0];
    [m_PlayerIcons SetCurrentMoney:nChips];
    //    BOOL bEnable = [pController CanPlayerPlayGame:nType inSeat:0];
    //    [m_PlayerIcons SetEnable:bEnable];
	[m_PlayerLabel setText:[pController GetPlayerName:0]];
    //}
}	

-(void)OnTimerEvent
{
    if(self.hidden == YES)
        return;

    GameViewController* pController = (GameViewController*)[GUILayout GetGameViewController];
    if(!pController)
        return;
    
    int nRow = (int)[m_LuckyNumberPicker selectedRowInComponent: 0];
    if(0 <= nRow)
    {
        int nType = [Configuration getCurrentGameTheme];
        if(nType != nRow)
        {
            nType = nRow;
            [Configuration setCurrentGameTheme:nType];
            [ScoreRecord SetGameTheme:nType];
            [ScoreRecord SaveScore];
        }
    }
    
}
@end
