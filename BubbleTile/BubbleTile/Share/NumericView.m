//
//  NumericView.m
//  BubbleTile
//
//  Created by Zhaohui Xing on 11-05-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "NumericView.h"
#import "GameConfiguration.h"
#import "GameConstants.h"
#import "GameScore.h"
#import "ApplicationResource.h"
#import "GUIEventLoop.h"

@implementation NumericView


-(void)UpdatePickerViewLayout
{
//	float fSize = fminf(self.frame.size.width, self.frame.size.height);
//    CGRect rect = CGRectMake(0, 0, fSize, fSize);
//    [m_EdgePicker setFrame:rect];
    double cx = self.frame.size.width/2;
	double cy = self.frame.size.height/2;
	[m_EdgePicker setCenter:CGPointMake(cx, cy)];
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
    
	m_EdgePicker = [[[UIPickerView alloc] initWithFrame:CGRectMake(sx, sy, w, h)] autorelease];
	m_EdgePicker.backgroundColor = [UIColor clearColor];//lightGrayColor];
	m_EdgePicker.contentMode = UIViewContentModeScaleToFill;
	[m_EdgePicker setAlpha:1.0];
	m_EdgePicker.delegate = pDelegate;
	m_EdgePicker.dataSource = pDelegate;
	m_EdgePicker.showsSelectionIndicator = YES;
	m_EdgePicker.clearsContextBeforeDrawing = YES;
    
    float r = h/m_EdgePicker.bounds.size.height;
    
    if(r < 1.0)
    {    
        CGAffineTransform t0 = CGAffineTransformMakeTranslation(0, m_EdgePicker.bounds.size.height/2);
        CGAffineTransform s0 = CGAffineTransformMakeScale(1.0, r);
        CGAffineTransform t1 = CGAffineTransformMakeTranslation (0, -m_EdgePicker.bounds.size.height/2);
        m_EdgePicker.transform = CGAffineTransformConcat(t0, CGAffineTransformConcat(s0, t1));    
    }
    
	[self addSubview:m_EdgePicker];
	[self bringSubviewToFront:m_EdgePicker];
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
    enGridType enType = [GameConfiguration GetGridType];
    int nRet = [GameConfiguration GetEnabledBubbleUnitCount:enType];
	return nRet;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSString* str = @"";
	
    enGridType enType = [GameConfiguration GetGridType];
	int nStart = [GameConfiguration GetMinBubbleUnit:enType];
    int nValue = nStart + row;
    str = [NSString stringWithFormat:@"%i", nValue];
    
	return str;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	int index = row;

    enGridType enType = [GameConfiguration GetGridType];
    int nStart = [GameConfiguration GetMinBubbleUnit:enType];
    int nValue = nStart + index;
    if(enType == PUZZLE_GRID_TRIANDLE || ([GameScore CheckPaymentState] == YES || [ApplicationConfigure CanTemporaryAccessPaidFeature]))
    {    
        [GameConfiguration SetGridBubbleUnit:enType withUnit:nValue];
    }    
    else if(enType == PUZZLE_GRID_SQUARE && [GameScore CheckSquarePaymentState] == YES)
    {    
        [GameConfiguration SetGridBubbleUnit:enType withUnit:nValue];
    }    
    else if(enType == PUZZLE_GRID_DIAMOND && [GameScore CheckDiamondPaymentState] == YES)
    {    
        [GameConfiguration SetGridBubbleUnit:enType withUnit:nValue];
    }    
    else if(enType == PUZZLE_GRID_HEXAGON && [GameScore CheckHexagonPaymentState] == YES)
    {    
        [GameConfiguration SetGridBubbleUnit:enType withUnit:nValue];
    }   
    else
    {
        if(nStart < nValue)
        {
            [GUIEventLoop SendEvent:GUIID_EVENT_DISABLEICONVIEWCLICK eventSender:self];
        }
        [GameConfiguration SetGridBubbleUnit:enType withUnit:nStart];
        [m_EdgePicker selectRow:0 inComponent:0 animated:NO];
        
    }    
}

-(void)OpenView
{
   [m_EdgePicker reloadAllComponents];
    enGridType enType = [GameConfiguration GetGridType];
    int nStart = [GameConfiguration GetMinBubbleUnit:enType];
    int nValue = [GameConfiguration GetGridBubbleUnit:enType];
    int nRow = nValue-nStart;
    if(nRow < 0)
    {    
        nRow = 0;
    }    
    if(enType == PUZZLE_GRID_TRIANDLE || ([GameScore CheckPaymentState] == YES || [ApplicationConfigure CanTemporaryAccessPaidFeature]))
    {    
        [m_EdgePicker selectRow:nRow inComponent:0 animated:NO];
        [GameConfiguration SetGridBubbleUnit:enType withUnit:nStart+nRow];
    }    
    else if(enType == PUZZLE_GRID_SQUARE && [GameScore CheckSquarePaymentState] == YES)
    {    
        [m_EdgePicker selectRow:nRow inComponent:0 animated:NO];
        [GameConfiguration SetGridBubbleUnit:enType withUnit:nStart+nRow];
    }    
    else if(enType == PUZZLE_GRID_DIAMOND && [GameScore CheckDiamondPaymentState] == YES)
    {    
        [m_EdgePicker selectRow:nRow inComponent:0 animated:NO];
        [GameConfiguration SetGridBubbleUnit:enType withUnit:nStart+nRow];
    }    
    else if(enType == PUZZLE_GRID_HEXAGON && [GameScore CheckHexagonPaymentState] == YES)
    {    
        [m_EdgePicker selectRow:nRow inComponent:0 animated:NO];
        [GameConfiguration SetGridBubbleUnit:enType withUnit:nStart+nRow];
    }   
    else
    {
        [GameConfiguration SetGridBubbleUnit:enType withUnit:nStart];
        [m_EdgePicker selectRow:0 inComponent:0 animated:NO];
    }    
}	


@end
