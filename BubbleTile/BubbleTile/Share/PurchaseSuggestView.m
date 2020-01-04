//
//  PurchaseSuggestView.m
//  BubbleTile
//
//  Created by Zhaohui Xing on 12-03-31.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "PurchaseSuggestView.h"
#import "ApplicationResource.h"
#import "GUILayout.h"
#import "GUIEventLoop.h"
#import "DrawHelper2.h"
#import "drawhelper.h"
#import "StringFactory.h"
#import "ApplicationConfigure.h"

@implementation PurchaseSuggestView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        [m_btnCancel SetLabel:[StringFactory GetString_No]];
        [m_btnOK SetLabel:[StringFactory GetString_Yes]];
        [m_Label setTextColor:[UIColor yellowColor]];
        [m_Label setText:[StringFactory GetString_PurchaseSuggestion]];
        float fontSize = 12;
        if([ApplicationConfigure iPADDevice])
            fontSize = 20;
        m_Label.font = [UIFont fontWithName:@"Times New Roman" size:fontSize];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
-(void)drawBackground:(CGContextRef)context inRect:(CGRect)rect;
{
    CGContextSaveGState(context);
    float fsize = [GUILayout GetDefaultAlertUIConner]/2.0;
    AddRoundRectToPath(context, rect, CGSizeMake(fsize, fsize), 0.5);
    CGContextClip(context);
    [DrawHelper2 DrawRedTextureRect:context at:rect];
    CGContextRestoreGState(context);
    CGContextSaveGState(context);
    float foffset = [GUILayout GetDefaultAlertUIEdge]/4.0;
    CGRect rt2 = CGRectInset(rect, foffset, foffset);
    AddRoundRectToPath(context, rt2, CGSizeMake(fsize-foffset*2, fsize-foffset*2), 0.5);
    [DrawHelper2 DrawHalfSizeGrayBackgroundDecoration:context];
    CGContextRestoreGState(context);
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	[self drawBackground:context inRect: rect];
}

-(void)OnViewClose
{
	[[self superview] sendSubviewToBack:self];
}	


-(void)OnButtonClick:(int)nButtonID
{
    m_nClickedButton = nButtonID;
    [self CloseView:YES];
    if(nButtonID == ALERT_YES)
        [GUIEventLoop SendEvent:GUIID_EVENT_PURCHASE eventSender:self];
}



@end
