//
//  MultiChoiceGlossyMenuItem.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-08.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MultiChoiceGlossyMenuItem.h"


@implementation MultiChoiceGlossyMenuItem


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

-(id)initWithMeueID:(int)nID withFrame:(CGRect)frame withContainer:(id<MenuHolderTemplate>)p
{
    self = [super initWithMeueID:nID withFrame:frame withContainer:p];
    if (self) 
	{
		m_NormalImages = [[[NSMutableArray alloc] init] retain];
		m_HighLightImages = [[[NSMutableArray alloc] init] retain];
		m_nActiveChoice = 0;
	}
	
	return self;
}	

-(void)RegisterMenuImages:(NSString*)image1 withHigLight:(NSString*)image2
{
	//UIImage* srcImagge1 = [[UIImage imageNamed:image1] retain];
	//UIImage* srcImagge2 = [[UIImage imageNamed:image2] retain];
	UIImage* srcImagge1 = [UIImage imageNamed:image1];
	UIImage* srcImagge2 = [UIImage imageNamed:image2];
	if(srcImagge1 != nil && srcImagge2 != nil)
	{
		[m_NormalImages addObject:srcImagge1];
		[m_HighLightImages addObject:srcImagge2];
	}	
}

-(void)SetActiveChoice:(int)index
{
	m_nActiveChoice = index;
}

-(int)GetActiveChoice
{
	return m_nActiveChoice;
}

- (void)dealloc 
{
    for(int i = 0; i < [m_NormalImages count]; ++i)
    {
        [((UIImage*)[m_NormalImages objectAtIndex:i]) release];
    }
 	[m_NormalImages removeAllObjects];
	[m_NormalImages release];
    
    for(int j = 0; j < [m_HighLightImages count]; ++j)
    {
        [(UIImage*)[m_HighLightImages objectAtIndex:j] release];
    }
 	[m_HighLightImages removeAllObjects];
	[m_HighLightImages release];
	[super dealloc];
}

- (void)DrawButtonHighLight:(CGContextRef)context inRect:(CGRect)rect
{
	CGImageRef image = NULL;
	if(0 <= m_nActiveChoice && m_nActiveChoice < [m_HighLightImages count])
	{
		image = ((UIImage*)[m_HighLightImages objectAtIndex:m_nActiveChoice]).CGImage;
	}
	
	if(image)
	{	
		CGContextDrawImage(context, rect, image);
	}
	image = NULL;
}	

- (void)DrawButtonNormal:(CGContextRef)context inRect:(CGRect)rect
{
	CGImageRef image = NULL;
	if(0 <= m_nActiveChoice && m_nActiveChoice < [m_NormalImages count])
	{
		image = ((UIImage*)[m_NormalImages objectAtIndex:m_nActiveChoice]).CGImage;
	}
	
	if(image)
	{	
		CGContextDrawImage(context, rect, image);
	}	
}	

- (void)DrawButton:(CGContextRef)context inRect:(CGRect)rect
{
	if(m_bSelected)
	{
		[self DrawButtonHighLight:context inRect: rect];
	}
	else 
	{
		[self DrawButtonNormal:context inRect: rect];
	}
}	


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code.
	CGContextRef context = UIGraphicsGetCurrentContext();
	[self DrawButton:context inRect: rect];
}

@end
