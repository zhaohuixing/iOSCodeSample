//
//  PointsView.m
//  MindFire
//
//  Created by Zhaohui Xing on 2010-03-17.
//  Copyright 2010 Zhaohui Xing. All rights reserved.
//
#import "GameBaseView.h"
#import "PointsView.h"
#import "StringFactory.h"
#import "GUIEventLoop.h"
#import "ApplicationResource.h"
#include "GameUtility.h"
#include "GameState.h"

#define MF_GAMESPEEDWHEEL			0
#define MF_MAJORPOINTWHEEL			1
#define MF_CUSTOMIZEDPOINTWHEEL		2

static int  m_OtherPoints[28554];


@implementation PointsView

+(void)InitCustomizedpoints
{
	int n = 0;
	for(int i = 0; i < 28554; ++i)
	{
		if(n == 18 || n == 21 || n == 24 || n == 27)
		{
			++n;
		}	
		m_OtherPoints[i] = n;
		++n;
	}	
}	

+(int)CustomizedpointIndex:(int)nPoint
{
	int index = 0;
	for(index = 0; index < 28554; ++index)
	{
		if(m_OtherPoints[index] == nPoint)
		{
			return index;
		}	
	}	
	return 0;
}	

+(int)GetCustomizedpointAtIndex:(int)Index
{
    int nPoint = -1;
    if(0 <= Index && Index < 28554)
    {
        nPoint = m_OtherPoints[Index];
    }
    return nPoint;
}

-(void)initPointsArray
{
	m_MajorPoints = [[NSMutableArray array] retain];
	[m_MajorPoints addObject:[StringFactory GetString_PointTitle:24]];
	[m_MajorPoints addObject:[StringFactory GetString_PointTitle:21]];
	[m_MajorPoints addObject:[StringFactory GetString_PointTitle:18]];
	[m_MajorPoints addObject:[StringFactory GetString_PointTitle:27]];
	[m_MajorPoints addObject:[StringFactory GetString_CustomizedPoints]];
}	

-(void)selectPointView
{
	int nPoint = GetGamePoint();
	NSInteger nCompoment; 
	NSInteger nRow;
	if(nPoint == 24 || nPoint == 21 || nPoint == 18 || nPoint == 27)
	{
		nCompoment = MF_MAJORPOINTWHEEL;
		switch (nPoint) 
		{
			case 24:
				nRow = 0;
				break;
			case 21:
				nRow = 1;
				break;
			case 18:
				nRow = 2;
				break;
			case 27:
				nRow = 3;
				break;
			default:
				nRow = 0;
				break;
		}
        [self UpdatePickerViewSelection:nRow atComponent:nCompoment  animated:YES];
	}
	else
	{
		[self UpdatePickerViewSelection:4 atComponent:MF_MAJORPOINTWHEEL  animated:NO];
		nCompoment = MF_CUSTOMIZEDPOINTWHEEL;
		nRow = [PointsView CustomizedpointIndex:nPoint]; 
        [self UpdatePickerViewSelection:nRow atComponent:nCompoment  animated:YES];
	}	
    
    
    nCompoment = MF_GAMESPEEDWHEEL;
    nRow = GetGameSpeed();
	[self UpdatePickerViewSelection:nRow atComponent:nCompoment  animated:YES];
    
	[self setNeedsDisplay];
}



- (int)GetViewType
{
	return GAME_VIEW_POINT;
}	

-(void)UpdatePickerViewLayout
{
	double cx = self.frame.size.width/2;
	double cy = self.frame.size.height/2;
	[m_pointPicker setCenter:CGPointMake(cx, cy)];
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
    
	m_pointPicker = [[[UIPickerView alloc] initWithFrame:CGRectMake(sx, sy, w, h)] autorelease];
	m_pointPicker.backgroundColor = [UIColor clearColor];//lightGrayColor];
	m_pointPicker.contentMode = UIViewContentModeScaleToFill;
	[m_pointPicker setAlpha:1.0];
	m_pointPicker.delegate = pDelegate;
	m_pointPicker.dataSource = pDelegate;
	m_pointPicker.showsSelectionIndicator = YES;
	m_pointPicker.clearsContextBeforeDrawing = YES;
	
    float r = h/m_pointPicker.bounds.size.height;
    
    if(r < 1.0)
    {    
        CGAffineTransform t0 = CGAffineTransformMakeTranslation(0, m_pointPicker.bounds.size.height/2);
        CGAffineTransform s0 = CGAffineTransformMakeScale(1.0, r);
        CGAffineTransform t1 = CGAffineTransformMakeTranslation (0, -m_pointPicker.bounds.size.height/2);
        m_pointPicker.transform = CGAffineTransformConcat(t0, CGAffineTransformConcat(s0, t1));    
    }
    
    [self addSubview:m_pointPicker];
	[self bringSubviewToFront:m_pointPicker];
    [self initPointsArray];
	[self UpdatePickerViewLayout];
}


- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) 
	{
        // Initialization code
        [PointsView InitCustomizedpoints];
        [self initPointsArray];
		[self initPickerView:self];
		[self setNeedsDisplay];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
	CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawBackground:context  inRect:rect];	
/*	CGContextRef layerDC;
	CGLayerRef   layerObj;
	layerObj = CGLayerCreateWithContext(context, rect.size, NULL);
	layerDC = CGLayerGetContext(layerObj);
	
	CGContextSaveGState(layerDC);
	
	
	CGGradientRef gradientFill;
	CGColorSpaceRef fillColorspace;
	
	fillColorspace = CGColorSpaceCreateDeviceRGB();
	
	CGFloat colors[] =
	{
		0.6, 0.6, 0.6, 1.00,
		0.1, 0.1, 0.1, 1.00,
	};
	
	gradientFill = CGGradientCreateWithColorComponents(fillColorspace, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
	
	CGPoint pt1, pt2;
	pt1.x = rect.origin.x;
	pt1.y = rect.origin.y;
	pt2.x = rect.origin.x;//+rect.size.width;
	pt2.y = rect.origin.y+rect.size.height;
	CGContextDrawLinearGradient (layerDC, gradientFill, pt1, pt2, 0);
	
	CGColorSpaceRelease(fillColorspace);
	CFRelease(gradientFill);
	
	CGContextRestoreGState(layerDC);
	CGContextSaveGState(context);
	CGContextDrawLayerAtPoint(context, CGPointMake(0.0f, 0.0f), layerObj);
	CGContextRestoreGState(context);
	CGLayerRelease(layerObj);
*/	
}

- (void)UpdatePickerViewSelection:(NSInteger)nRow atComponent:(NSInteger)nComponent animated:(BOOL)bYes
{
	[m_pointPicker selectRow:nRow inComponent:nComponent animated:bYes];
	[m_pointPicker reloadComponent:nComponent];
	[m_pointPicker setNeedsDisplay];
}

- (void)dealloc 
{
    [super dealloc];
}

- (void)UpdateViewLayout
{
	[super UpdateViewLayout];
	[self UpdatePickerViewLayout];
}	

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == MF_GAMESPEEDWHEEL)
        return 3;
	else if(component == MF_MAJORPOINTWHEEL)
		return 5;
	else 
		return 28554;
}

- (NSString *)arrangeCustomziedPoint:(UIPickerView *)pickerView atRow:(NSInteger)row
{
	NSString* str = @"";
	
	NSInteger nCompoment = MF_MAJORPOINTWHEEL;
	NSInteger n = [pickerView selectedRowInComponent:nCompoment];
	if(n == 4)
	{
		int index = row;
		str = [StringFactory GetString_PointString:m_OtherPoints[index]];
	}
	return str;
}

- (NSString *)GetameSpeedString:(int)nIndex
{
	NSString* str = @"";

    if(nIndex == 0)
        str = [StringFactory GetString_None];
    else if(nIndex == 1)
        str = [StringFactory GetString_Slow];
    else if(nIndex == 2)
        str = [StringFactory GetString_Fast];
        
    
	return str;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSString* str = @"";
	
	if(component == MF_GAMESPEEDWHEEL)
	{
		str = [self GetameSpeedString:row];
	}
	else if(component == MF_MAJORPOINTWHEEL)
	{
		str = [m_MajorPoints objectAtIndex:row];
	}
	else
	{
		str = [self arrangeCustomziedPoint:pickerView atRow: row];
	}	
	return str;
}

- (void)UpdateGamePoints:(int)nPoint
{
	SetGamePoint(nPoint);
    [GUIEventLoop SendEvent:GUIID_EVENT_POINTSCHANGED eventSender:nil];
}


- (void)UpdateMajorPoint:(int)index
{
	int nPoint = 24;
	switch(index)
	{
		case 0:
			nPoint = 24;
			break;	
		case 1:
			nPoint = 21;
			break;	
		case 2:
			nPoint = 18;
			break;	
		case 3:
			nPoint = 27;
			break;	
	}
    [self UpdateGamePoints:nPoint];
}	

- (void)UpdateOtherPoint:(int)index
{
	int nPoint = 0;
	if(0 <= index && index < 28554)
	{
		nPoint = m_OtherPoints[index];
        [self UpdateGamePoints:nPoint];
	}	
}	

- (void)UpdateGameSpeed:(int)index
{
    SetGameSpeed(index);
    [GUIEventLoop SendEvent:GUIID_EVENT_POINTSCHANGED eventSender:nil];
    int nRow = [m_pointPicker selectedRowInComponent:MF_CUSTOMIZEDPOINTWHEEL];
    [m_pointPicker selectRow:nRow inComponent:MF_CUSTOMIZEDPOINTWHEEL animated:YES];
    [m_pointPicker reloadComponent:MF_CUSTOMIZEDPOINTWHEEL];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	int index = row;
	if (component == MF_GAMESPEEDWHEEL)
	{
		[self UpdateGameSpeed:index];
	}
	else if (component == MF_MAJORPOINTWHEEL)
	{
		if (row < 4) 
		{
			[pickerView selectRow:0 inComponent:MF_CUSTOMIZEDPOINTWHEEL animated:YES];
			[pickerView reloadComponent:MF_CUSTOMIZEDPOINTWHEEL];
			[self UpdateMajorPoint:index];
		}
		else if(row == 4)
		{
			[pickerView selectRow:0 inComponent:MF_CUSTOMIZEDPOINTWHEEL animated:YES];
			[pickerView reloadComponent:MF_CUSTOMIZEDPOINTWHEEL];
			[self UpdateOtherPoint:0];
		}	
	}
	else 
	{
		[self UpdateOtherPoint:index];
	}
}

- (void)OnTimerEvent
{
    if(self.hidden == YES)
        return;
    
    int nRow = [m_pointPicker selectedRowInComponent:MF_MAJORPOINTWHEEL];
    if(nRow == 4)
    {
        int nIndex = [m_pointPicker selectedRowInComponent:MF_CUSTOMIZEDPOINTWHEEL];
        int nPoint = [PointsView GetCustomizedpointAtIndex:nIndex];
        int nCurrentPoint = GetGamePoint();
        if(nCurrentPoint != nPoint)
        {
            [self UpdateGamePoints:nPoint];
            [m_pointPicker selectRow:nIndex inComponent:MF_CUSTOMIZEDPOINTWHEEL animated:YES];
            [m_pointPicker reloadComponent:MF_CUSTOMIZEDPOINTWHEEL];
        }
    }
    else if(nRow < 4 && 0 <= nRow)
    {
        int nPoint = 24;
        switch(nRow)
        {
            case 0:
                nPoint = 24;
                break;	
            case 1:
                nPoint = 21;
                break;	
            case 2:
                nPoint = 18;
                break;	
            case 3:
                nPoint = 27;
                break;	
        }
        int nCurrentPoint = GetGamePoint();
        if(nCurrentPoint != nPoint)
        {
            [self UpdateGamePoints:nPoint];
            [m_pointPicker selectRow:nRow inComponent:MF_MAJORPOINTWHEEL animated:YES];
            [m_pointPicker reloadComponent:MF_MAJORPOINTWHEEL];
        }
        [m_pointPicker selectRow:0 inComponent:MF_CUSTOMIZEDPOINTWHEEL animated:YES];
    }
    nRow = [m_pointPicker selectedRowInComponent:MF_GAMESPEEDWHEEL];
    int nSpeed = GetGameSpeed();
    if(nRow != nSpeed)
    {
        [self UpdateGameSpeed:nRow];
        [m_pointPicker selectRow:nRow inComponent:MF_GAMESPEEDWHEEL animated:YES];
        [m_pointPicker reloadComponent:MF_GAMESPEEDWHEEL];
    }
}

-(void)OpenView:(BOOL)bAnimation
{
    [self selectPointView];
	[super OpenView:bAnimation];
}

@end
