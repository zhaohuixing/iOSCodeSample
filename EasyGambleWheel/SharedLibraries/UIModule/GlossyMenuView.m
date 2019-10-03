//
//  GlossyMenuView.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GlossyMenuView.h"
#import "GUILayout.h"
#include <math.h> 

@implementation GlossyMenuView


- (id)initWithFrame:(CGRect)frame 
{
    
    self = [super initWithFrame:frame];
    if (self) 
	{
        // Initialization code.
		m_Menu = [[GlossyMenu alloc] initByParent:self];
		m_bMenuShow = NO;
		
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

-(void)awakeFromNib
{
    [super awakeFromNib];
    m_Menu = [[GlossyMenu alloc] initByParent:self];
    m_bMenuShow = NO;
}

- (void)dealloc 
{
}

-(void)AssignControlID:(int)nID
{
	if(m_Menu)
		[m_Menu AssignControlID:nID];
}

-(int)GetControlID
{
	if(m_Menu)
		return [m_Menu GetControlID];
	else
		return -1;
}	

//The handler for close button event
-(void)OnCloseEvent:(id)sender
{
}

-(void)OnMenuEvent:(int)menuID
{
}

-(void)OnOrientationChange
{
	[self UpdateMenuLayout];
}

-(CGPoint)GetViewCenter
{
	CGPoint pt = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
	return pt;
}

-(CGSize)GetViewSize
{
	return self.frame.size;
}

-(void)OnMenuHide
{
	m_bMenuShow = NO;
}

-(void)OnMenuShow
{
	m_bMenuShow = YES;
}	

-(void)AddMenuItem:(GlossyMenuItem*)item
{
	[m_Menu AddMenuItem:item];
	[self addSubview:item];
}

-(void)UpdateMenuLayout
{
	int nCount = (int)[m_Menu GetMenuItemCount];
	if(0 < nCount)
	{
		float dAngle = 360.0/((float)nCount);
		CGPoint centerPt = [self GetViewCenter];
		float dRadium = [GUILayout GetDefaultGlossyMenuLayoutRadium];
		for(int i = 0; i < nCount; ++i)
		{
			float a = (dAngle*((float)i)+180)*(-1.0);
			float dx = dRadium*sinf(a*M_PI/180.0f);
			float dy = dRadium*cosf(a*M_PI/180.0f);
			float cx = centerPt.x + dx;
			float cy = centerPt.y +dy;
			[m_Menu SetMenuItem:i atCenter:CGPointMake(cx, cy)];
		}	
	}	
}	


@end
