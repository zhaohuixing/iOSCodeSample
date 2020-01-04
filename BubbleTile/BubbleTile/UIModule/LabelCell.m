//
//  LabelCell.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LabelCell.h"
#import "ImageLoader.h"

@implementation LabelCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        float fDelta = frame.size.height/10.0;
        CGRect innerRect = CGRectMake(fDelta*2.0, 3*fDelta, frame.size.width, frame.size.height-3.0*fDelta);
		m_Text = [[UILabel alloc] initWithFrame:innerRect];
		m_Text.backgroundColor = [UIColor clearColor];
		[m_Text setTextColor:[UIColor blackColor]];
        m_Text.highlightedTextColor = [UIColor grayColor];
        [m_Text setTextAlignment:UITextAlignmentLeft];
        m_Text.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
        m_Text.adjustsFontSizeToFitWidth = YES;
		m_Text.font = [UIFont fontWithName:@"Times New Roman" size:16];//[UIFont systemFontOfSize:18];//[UIFont fontWithName:@"Georgia" size:18];
		[m_Text setText:@"test123"];
		[self addSubview:m_Text];
		[m_Text release];
        m_Icon = nil;
        
    }
    return self;
}

-(id)initWithImageSource:(NSString*)srcImage withFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        float fDelta = frame.size.height/10.0;
        CGRect innerRect = CGRectMake(fDelta*3.0+frame.size.height, 3*fDelta, frame.size.width, frame.size.height-3.0*fDelta);
		m_Text = [[UILabel alloc] initWithFrame:innerRect];
		m_Text.backgroundColor = [UIColor clearColor];
		[m_Text setTextColor:[UIColor blackColor]];
        m_Text.highlightedTextColor = [UIColor grayColor];
        [m_Text setTextAlignment:UITextAlignmentLeft];
        m_Text.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        m_Text.adjustsFontSizeToFitWidth = YES;
		m_Text.font = [UIFont fontWithName:@"Times New Roman" size:frame.size.height/2.0];//[UIFont systemFontOfSize:18];//[UIFont fontWithName:@"Georgia" size:18];
		[m_Text setText:@"test123"];
		[self addSubview:m_Text];
		[m_Text release];
    
        m_Icon = [ImageLoader LoadResourceImage:srcImage];
        
        /*float fSize = frame.size.height - fDelta*2.0; 
        innerRect = CGRectMake(fDelta*2.0, fDelta, fSize, fSize);
		UIImage* iconImage = [UIImage imageNamed:srcImage];
		m_Icon = [[UIImageView alloc] initWithImage:iconImage];
		[m_Icon setFrame:innerRect];
		[self addSubview:m_Icon];
        [m_Icon release];*/
        
    }
    return self;
}

-(id)initWithImage:(CGImageRef)srcImage withFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        float fDelta = frame.size.height/10.0;
        CGRect innerRect = CGRectMake(fDelta*2.0+frame.size.height, 3*fDelta, frame.size.width, frame.size.height-6.0*fDelta);
		m_Text = [[UILabel alloc] initWithFrame:innerRect];
		m_Text.backgroundColor = [UIColor clearColor];
		[m_Text setTextColor:[UIColor blackColor]];
        m_Text.highlightedTextColor = [UIColor grayColor];
        [m_Text setTextAlignment:UITextAlignmentLeft];
        m_Text.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        m_Text.adjustsFontSizeToFitWidth = YES;
		m_Text.font = [UIFont fontWithName:@"Times New Roman" size:frame.size.height/2.0];//[UIFont systemFontOfSize:18];//[UIFont fontWithName:@"Georgia" size:18];
		[m_Text setText:@"test123"];
		[self addSubview:m_Text];
		[m_Text release];
        
        m_Icon = srcImage;
        
        /*float fSize = frame.size.height - fDelta*2.0; 
        innerRect = CGRectMake(fDelta*2.0, fDelta, fSize, fSize);
		UIImage* iconImage = [UIImage imageWithCGImage:srcImage];
		m_Icon = [[UIImageView alloc] initWithImage:iconImage];
		[m_Icon setFrame:innerRect];
		[self addSubview:m_Icon];
        [m_Icon release];*/ 
    }
    return self;
}


- (void)dealloc
{
    if(m_Icon != NULL)
        CGImageRelease(m_Icon);
    [super dealloc];
}

- (void)drawRect:(CGRect)rect 
{
    if(m_Icon != NULL)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        float fDelta = rect.size.height/10.0;
        float fSize = rect.size.height;//-fDelta*2.0
        ; 
        CGRect innerRect = CGRectMake(fDelta*2.0, 0, fSize, fSize);
        CGContextDrawImage(context, innerRect, m_Icon);
    }
}

-(enLISTCELLTYPE)GetListCellType
{
    return enLISTCELLTYPE_TITLE;
}

-(BOOL)IsSelectable
{
	return NO;
}

-(void)SetSelectable:(BOOL)bSelectable
{
}

-(void)SetSelectionState:(BOOL)bSelected
{
}

-(BOOL)GetSelectionState
{
	return NO; 
}

-(BOOL)HasCheckBox
{
    return YES; 
}

-(void)SetCheckBoxState:(BOOL)bChecked
{
}

-(BOOL)GetCheckBoxState
{
    return NO;
}

-(BOOL)HasSwitch
{
    return NO; 
}
-(BOOL)GetSwitchState
{
    return NO;
}

-(void)SetCellData:(id<ListCellDataTemplate>)data
{
}

-(id<ListCellDataTemplate>)GetCellData
{
    return nil;
}

-(float)GetCellHeight
{
    return self.frame.size.height;
}

-(void)OffsetYCell:(float)Y
{
	CGRect rect = self.frame;
	rect.origin.y += Y;
	[self setFrame:rect];
	[self setNeedsDisplay];
}	

-(CGRect)GetFrame
{
	return self.frame;
}

-(void)SetFrame:(CGRect)rect
{
	[self setFrame:rect];
    [self setNeedsDisplay];
}	

-(void)SetTitle:(NSString*)text
{
    [m_Text setText: text];
}

-(NSString*)GetTitle
{
    return m_Text.text;
}

@end
