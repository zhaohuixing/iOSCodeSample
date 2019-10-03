//
//  PlayModeView.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "PlayModeView.h"
#import "GUIEventLoop.h"
#import "ImageLoader.h"
#import "ApplicationConfigure.h"
#import "Configuration.h"
#import "GUILayout.h"
#import "ApplicationResource.h"
#import "StringFactory.h"
//#import "ListCellData.h"
//#import "ScoreRecord.h"
#import "RenderHelper.h"
#include "drawhelper.h"

@implementation PlayModeView


- (id)initWithFrame:(CGRect)frame 
{
    
    self = [super initWithFrame:frame];
    if (self) 
	{
		self.backgroundColor = [UIColor clearColor];
        //[self IntializePlayModeList];
    }
    return self;
}

- (void)dealloc 
{
    
}

-(void)UpdateViewLayout
{
	[self setNeedsDisplay];
}	

- (void)drawBackground:(CGContextRef)context inRect:(CGRect)rect
{
    [RenderHelper DrawOnLineGroupIcon:context at:rect];
}

- (void)drawOnlineState:(CGContextRef)context inRect:(CGRect)rect
{
    float fSize = rect.size.width/7.5;
    float sy = rect.origin.y;
    float sx = rect.origin.x;// + (rect.size.width-fSize)/2.0;
    CGRect rt = CGRectMake(sx, sy, fSize, fSize);
    BOOL bEnable = [Configuration isOnline];
    [RenderHelper DrawEnableDisableSign:context at:rt sign:bEnable];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
    
    [self drawBackground:context inRect:rect];
    [self drawOnlineState:context inRect:rect];
    
	CGContextRestoreGState(context);
}


-(void)OnViewClose
{
//	[super OnViewClose];
//    [ScoreRecord saveRecord];
}	


-(void)OnViewOpen
{
    self.hidden = NO;
    [self setNeedsDisplay];
}	

-(void)OpenView
{
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    BOOL bEnable = [Configuration isOnline];
    [Configuration setOnline:!bEnable];
    [self setNeedsDisplay];
}

@end
