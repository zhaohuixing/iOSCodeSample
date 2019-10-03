//
//  PledgeView.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-12-15.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "AnimalThemePledgeView.h"
#import "Configuration.h"
#import "ApplicationResource.h"
#import "GameViewController.h"
#import "GUIEventLoop.h"
#import "GUILayout.h"
#import "GameUtiltyObjects.h"
#import "GameConstants.h"
#import "ApplicationConfigure.h"
#import "UIColor+GameColor.h"

@implementation AnimalThemePledgeView

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
    m_PledgePicker.tintColor = [UIColor GamePickerDarkGrayColor];
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

-(void)InitAnimalIconList
{
    UIImage* image1 = [UIImage imageNamed:@"alicon1.png"];
    UIImage* image2 = [UIImage imageNamed:@"alicon2.png"];
    UIImage* image3 = [UIImage imageNamed:@"alicon3.png"];
    UIImage* image4 = [UIImage imageNamed:@"alicon4.png"];
    UIImage* image5 = [UIImage imageNamed:@"alicon5.png"];
    UIImage* image6 = [UIImage imageNamed:@"alicon6.png"];
    UIImage* image7 = [UIImage imageNamed:@"alicon7.png"];
    UIImage* image8 = [UIImage imageNamed:@"alicon8.png"];
    
    UIImageView* view1 = [[UIImageView alloc] initWithImage:image1];
    UIImageView* view2 = [[UIImageView alloc] initWithImage:image2];
    UIImageView* view3 = [[UIImageView alloc] initWithImage:image3];
    UIImageView* view4 = [[UIImageView alloc] initWithImage:image4];
    UIImageView* view5 = [[UIImageView alloc] initWithImage:image5];
    UIImageView* view6 = [[UIImageView alloc] initWithImage:image6];
    UIImageView* view7 = [[UIImageView alloc] initWithImage:image7];
    UIImageView* view8 = [[UIImageView alloc] initWithImage:image8];
    
    m_AnimalIconList = [[NSArray alloc] initWithObjects: view1, view2, view3, view4, view5, view6, view7, view8, nil];
}


-(void)InitFoodIconList
{
    UIImage* image1 = [UIImage imageNamed:@"fdicon1.png"];
    UIImage* image2 = [UIImage imageNamed:@"fdicon2.png"];
    UIImage* image3 = [UIImage imageNamed:@"fdicon3.png"];
    UIImage* image4 = [UIImage imageNamed:@"fdicon4.png"];
    UIImage* image5 = [UIImage imageNamed:@"fdicon5.png"];
    UIImage* image6 = [UIImage imageNamed:@"fdicon6.png"];
    UIImage* image7 = [UIImage imageNamed:@"fdicon7.png"];
    UIImage* image8 = [UIImage imageNamed:@"fdicon8.png"];
    
    UIImageView* view1 = [[UIImageView alloc] initWithImage:image1];
    UIImageView* view2 = [[UIImageView alloc] initWithImage:image2];
    UIImageView* view3 = [[UIImageView alloc] initWithImage:image3];
    UIImageView* view4 = [[UIImageView alloc] initWithImage:image4];
    UIImageView* view5 = [[UIImageView alloc] initWithImage:image5];
    UIImageView* view6 = [[UIImageView alloc] initWithImage:image6];
    UIImageView* view7 = [[UIImageView alloc] initWithImage:image7];
    UIImageView* view8 = [[UIImageView alloc] initWithImage:image8];
    
    m_FruitIconList = [[NSArray alloc] initWithObjects: view1, view2, view3, view4, view5, view6, view7, view8, nil];
}


-(void)InitFlowerIconList
{
    UIImage* image1 = [UIImage imageNamed:@"flicon1.png"];
    UIImage* image2 = [UIImage imageNamed:@"flicon2.png"];
    UIImage* image3 = [UIImage imageNamed:@"flicon3.png"];
    UIImage* image4 = [UIImage imageNamed:@"flicon4.png"];
    UIImage* image5 = [UIImage imageNamed:@"flicon5.png"];
    UIImage* image6 = [UIImage imageNamed:@"flicon6.png"];
    UIImage* image7 = [UIImage imageNamed:@"flicon7.png"];
    UIImage* image8 = [UIImage imageNamed:@"flicon8.png"];
    
    UIImageView* view1 = [[UIImageView alloc] initWithImage:image1];
    UIImageView* view2 = [[UIImageView alloc] initWithImage:image2];
    UIImageView* view3 = [[UIImageView alloc] initWithImage:image3];
    UIImageView* view4 = [[UIImageView alloc] initWithImage:image4];
    UIImageView* view5 = [[UIImageView alloc] initWithImage:image5];
    UIImageView* view6 = [[UIImageView alloc] initWithImage:image6];
    UIImageView* view7 = [[UIImageView alloc] initWithImage:image7];
    UIImageView* view8 = [[UIImageView alloc] initWithImage:image8];
    
    m_FlowerIconList = [[NSArray alloc] initWithObjects: view1, view2, view3, view4, view5, view6, view7, view8, nil];
    
}

-(void)InitEasterEggIconList
{
    UIImage* image1 = [UIImage imageNamed:@"ebicon1.png"];
    UIImage* image2 = [UIImage imageNamed:@"ebicon2.png"];
    UIImage* image3 = [UIImage imageNamed:@"ebicon3.png"];
    UIImage* image4 = [UIImage imageNamed:@"ebicon4.png"];
    UIImage* image5 = [UIImage imageNamed:@"ebicon5.png"];
    UIImage* image6 = [UIImage imageNamed:@"ebicon6.png"];
    UIImage* image7 = [UIImage imageNamed:@"ebicon7.png"];
    UIImage* image8 = [UIImage imageNamed:@"ebicon8.png"];
    
    UIImageView* view1 = [[UIImageView alloc] initWithImage:image1];
    UIImageView* view2 = [[UIImageView alloc] initWithImage:image2];
    UIImageView* view3 = [[UIImageView alloc] initWithImage:image3];
    UIImageView* view4 = [[UIImageView alloc] initWithImage:image4];
    UIImageView* view5 = [[UIImageView alloc] initWithImage:image5];
    UIImageView* view6 = [[UIImageView alloc] initWithImage:image6];
    UIImageView* view7 = [[UIImageView alloc] initWithImage:image7];
    UIImageView* view8 = [[UIImageView alloc] initWithImage:image8];
    
    m_EasterEggIconList = [[NSArray alloc] initWithObjects: view1, view2, view3, view4, view5, view6, view7, view8, nil];
    
}


-(void)InitKuloIconList
{
    UIImage* image1 = [UIImage imageNamed:@"klicon1.png"];
    UIImage* image2 = [UIImage imageNamed:@"klicon2.png"];
    UIImage* image3 = [UIImage imageNamed:@"klicon3.png"];
    UIImage* image4 = [UIImage imageNamed:@"klicon4.png"];
    UIImage* image5 = [UIImage imageNamed:@"klicon5.png"];
    UIImage* image6 = [UIImage imageNamed:@"klicon6.png"];
    UIImage* image7 = [UIImage imageNamed:@"klicon7.png"];
    UIImage* image8 = [UIImage imageNamed:@"klicon8.png"];
    
    UIImageView* view1 = [[UIImageView alloc] initWithImage:image1];
    UIImageView* view2 = [[UIImageView alloc] initWithImage:image2];
    UIImageView* view3 = [[UIImageView alloc] initWithImage:image3];
    UIImageView* view4 = [[UIImageView alloc] initWithImage:image4];
    UIImageView* view5 = [[UIImageView alloc] initWithImage:image5];
    UIImageView* view6 = [[UIImageView alloc] initWithImage:image6];
    UIImageView* view7 = [[UIImageView alloc] initWithImage:image7];
    UIImageView* view8 = [[UIImageView alloc] initWithImage:image8];
    
    m_KuloIconList = [[NSArray alloc] initWithObjects: view1, view2, view3, view4, view5, view6, view7, view8, nil];
    
}

-(void)InitAnimal1IconList
{
    UIImage* image1 = [UIImage imageNamed:@"abicon1.png"];
    UIImage* image2 = [UIImage imageNamed:@"abicon2.png"];
    UIImage* image3 = [UIImage imageNamed:@"abicon3.png"];
    UIImage* image4 = [UIImage imageNamed:@"abicon4.png"];
    UIImage* image5 = [UIImage imageNamed:@"abicon5.png"];
    UIImage* image6 = [UIImage imageNamed:@"abicon6.png"];
    UIImage* image7 = [UIImage imageNamed:@"abicon7.png"];
    UIImage* image8 = [UIImage imageNamed:@"abicon8.png"];
    
    UIImageView* view1 = [[UIImageView alloc] initWithImage:image1];
    UIImageView* view2 = [[UIImageView alloc] initWithImage:image2];
    UIImageView* view3 = [[UIImageView alloc] initWithImage:image3];
    UIImageView* view4 = [[UIImageView alloc] initWithImage:image4];
    UIImageView* view5 = [[UIImageView alloc] initWithImage:image5];
    UIImageView* view6 = [[UIImageView alloc] initWithImage:image6];
    UIImageView* view7 = [[UIImageView alloc] initWithImage:image7];
    UIImageView* view8 = [[UIImageView alloc] initWithImage:image8];
    
    m_Animal1IconList = [[NSArray alloc] initWithObjects: view1, view2, view3, view4, view5, view6, view7, view8, nil];
    
}

-(void)InitAnimal2IconList
{
    UIImage* image1 = [UIImage imageNamed:@"acicon1.png"];
    UIImage* image2 = [UIImage imageNamed:@"acicon2.png"];
    UIImage* image3 = [UIImage imageNamed:@"acicon3.png"];
    UIImage* image4 = [UIImage imageNamed:@"acicon4.png"];
    UIImage* image5 = [UIImage imageNamed:@"acicon5.png"];
    UIImage* image6 = [UIImage imageNamed:@"acicon6.png"];
    UIImage* image7 = [UIImage imageNamed:@"acicon7.png"];
    UIImage* image8 = [UIImage imageNamed:@"acicon8.png"];
    
    UIImageView* view1 = [[UIImageView alloc] initWithImage:image1];
    UIImageView* view2 = [[UIImageView alloc] initWithImage:image2];
    UIImageView* view3 = [[UIImageView alloc] initWithImage:image3];
    UIImageView* view4 = [[UIImageView alloc] initWithImage:image4];
    UIImageView* view5 = [[UIImageView alloc] initWithImage:image5];
    UIImageView* view6 = [[UIImageView alloc] initWithImage:image6];
    UIImageView* view7 = [[UIImageView alloc] initWithImage:image7];
    UIImageView* view8 = [[UIImageView alloc] initWithImage:image8];
    
    m_Animal2IconList = [[NSArray alloc] initWithObjects: view1, view2, view3, view4, view5, view6, view7, view8, nil];
    
}

-(void)InitIconLists
{
    [self InitKuloIconList];
    [self InitAnimal1IconList];
    [self InitAnimal2IconList];

    [self InitAnimalIconList];
    [self InitFoodIconList];
    [self InitFlowerIconList];
    [self InitEasterEggIconList];
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
        [self InitIconLists];
    }
    return self;
}

-(void)dealloc
{
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
        int nMinBet = (int)[GameUitltyHelper GetGameBetPledgeThreshold:m_nCurrentGameType];
        m_nBetMoney = nMinBet + (int)row;
        int nLeftMoney = m_nCurrentChip - m_nBetMoney;
        [m_PlayerIcon SetCurrentMoney:nLeftMoney];
        [m_PledgePicker selectRow:row inComponent:1 animated:YES];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if(component == 1)
    {
        if(view == nil)
        {
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
            label.backgroundColor = [UIColor clearColor];
            NSString* szText = [NSString stringWithFormat:@"%i", (int)row + 1];
            [label setText:szText];
            return label;
        }
        else
        {
            [(UILabel*)view setText:[NSString stringWithFormat:@"%i", (int)row + 1]];
        }
        return view;
    }
    else
    {
        int nTheme = [Configuration getCurrentGameTheme];
        UIView * myView = nil;
        if(nTheme == GAME_THEME_KULO)
        {
            myView = [m_KuloIconList objectAtIndex:row];
        }
        else if(nTheme == GAME_THEME_ANIMAL1)
        {
            myView = [m_Animal1IconList objectAtIndex:row];
        }
        else if(nTheme == GAME_THEME_ANIMAL2)
        {
            myView = [m_Animal2IconList objectAtIndex:row];
        }
        else if(nTheme == GAME_THEME_ANIMAL)
        {
            myView = [m_AnimalIconList objectAtIndex:row];
        }
        else if(nTheme == GAME_THEME_FLOWER)
        {
            myView = [m_FlowerIconList objectAtIndex:row];
        }
        else if(nTheme == GAME_THEME_FOOD)
        {
            myView = [m_FruitIconList objectAtIndex:row];
        }
        else //if(nTheme == GAME_THEME_EASTEREGG)
        {
            myView = [m_EasterEggIconList objectAtIndex:row];
        }
        UIGraphicsBeginImageContextWithOptions(myView.bounds.size, NO, 0);
        
        [myView.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        // then convert back to a UIImageView and return it
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        
        return imageView;
        //return view;
    }
}


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    if(component == 1)
    {
        return 50;
    }
    else
    {
        return 80;
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
