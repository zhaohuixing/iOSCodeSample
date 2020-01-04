//
//  GroupCell.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "GroupCell.h"
#import "GUILayout.h"

@implementation GroupCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        float h = [GUILayout GetDefaultListCellHeight];
        CGRect rect = CGRectMake(0, 0, frame.size.width, h);
        m_Title = [[LabelCell alloc] initWithFrame:rect];
		[self addSubview:m_Title];
		[m_Title release];
        m_bSelectable = YES;
    }
    return self;
}

-(id)initWithLabelImageSource:(NSString*)srcImage withFrame:(CGRect)frame withLabelHeight:(float)lHeight
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        CGRect rect = CGRectMake(0, 0, frame.size.width, lHeight);
        m_Title = [[LabelCell alloc] initWithImageSource:srcImage withFrame:rect];
		[self addSubview:m_Title];
		[m_Title release];
        m_bSelectable = YES;
    }
    return self;
}

-(id)initWithLabelImage:(CGImageRef)srcImage withFrame:(CGRect)frame withLabelHeight:(float)lHeight
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        CGRect rect = CGRectMake(0, 0, frame.size.width, lHeight);
        m_Title = [[LabelCell alloc] initWithImage:srcImage withFrame:rect];
		[self addSubview:m_Title];
		[m_Title release];
        m_bSelectable = YES;
    }
    return self;
}


- (void)dealloc
{
    [super dealloc];
}

-(enLISTCELLTYPE)GetListCellType
{
    return enLISTCELLTYPE_GROUP;
}

-(BOOL)IsSelectable
{
	return m_bSelectable;
}

-(void)SetSelectable:(BOOL)bSelectable
{
    m_bSelectable = bSelectable;

    int nCount = [self.subviews count];
    if(0 < nCount)
    {
        for(int i = 0; i < nCount; ++i)
        {
            id<ListCellTemplate> p = [self.subviews objectAtIndex:i];
            if(p)
            {
                [p SetSelectable:bSelectable];
            }
        }
    }
}

-(void)SetSelectionState:(BOOL)bSelected
{
    if(m_bSelectable == NO)
        return;
    
    if(bSelected == NO)
    {
        int nCount = [self.subviews count];
        if(0 < nCount)
        {
            for(int i = 0; i < nCount; ++i)
            {
                id<ListCellTemplate> p = [self.subviews objectAtIndex:i];
                if(p)
                {
                    [p SetSelectionState:NO];
                }
            }
        }
        
    }
}

-(BOOL)GetSelectionState
{
    int nCount = [self.subviews count];
    if(0 < nCount)
    {
        for(int i = 0; i < nCount; ++i)
        {
            id<ListCellTemplate> p = [self.subviews objectAtIndex:i];
            if(p && [p GetSelectionState] == YES)
            {
                return YES;
            }
        }
    }
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
    return [self GetGroupHeight]+[GUILayout GetDefaultListCellHeight]*0.5; //self.frame.size.height;
}

-(void)OffsetYCell:(float)Y
{
	CGRect rect = self.frame;
	rect.origin.y += Y;
	[self SetFrame:rect];
	[self setNeedsDisplay];
}	

-(CGRect)GetFrame
{
	return self.frame;
}

-(void)SetFrame:(CGRect)rect
{
    int nCount = [self.subviews count];
    if(0 < nCount)
    {
        for(int i = 0; i < nCount; ++i)
        {
            id<ListCellTemplate> p = [self.subviews objectAtIndex:i];
            if(p)
            {
                CGRect rt = [p GetFrame];
                rt.size.width = rect.size.width;
                [p SetFrame:rt];
            }
        }
    }
    
    CGRect newRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, [self GetGroupHeight]);
	[self setFrame:newRect];
    [self setNeedsDisplay];
}	

-(void)SetTitle:(NSString*)text
{
    [m_Title SetTitle:text];
}

-(NSString*)GetTitleText
{
    return [m_Title GetTitle];   
}

-(NSString*)GetTitle
{
    return [m_Title GetTitle];   
}

-(int)GetCellCount
{
    return [self.subviews count];
}

-(void)AddCell:(id<ListCellTemplate>)pCell
{
    float f = [self GetGroupHeight];
    CGRect rect = CGRectMake(0, f, self.frame.size.width, [pCell GetCellHeight]);
    [pCell SetFrame:rect];
    [(UIView*)pCell becomeFirstResponder];
    [(UIView*)pCell setUserInteractionEnabled:YES];
    [self addSubview:(UIView*)pCell];
    [self bringSubviewToFront:(UIView*)pCell];
    [(UIView*)pCell release];
    [(UIView*)pCell setNeedsDisplay];
    [self setNeedsDisplay];
}

-(id<ListCellTemplate>)GetCellAt:(int)index
{
    id<ListCellTemplate> pCell = nil;
    int nCount = [self.subviews count];
    if(1 <= index && index < nCount)
    {
        pCell = [self.subviews objectAtIndex:index];
    }
    return pCell;
}

-(void)RemoveCellAt:(int)index
{
    int nCount = [self.subviews count];
    if(1 <= index && index < nCount)
    {
        id<ListCellTemplate> p = [self.subviews objectAtIndex:index];
        float fOffset = -1.0*[p GetCellHeight];
        for(int i = index; i < nCount; ++i)
        {
            id<ListCellTemplate> pCell = [self.subviews objectAtIndex:i];
            [pCell OffsetYCell:fOffset];
        }
        [(UIView*)p removeFromSuperview];
    }
}

-(int)FindCellIndex:(id<ListCellTemplate>)pCell
{
    int nCount = [self.subviews count];
    if(1 < nCount)
    {
        for(int i = 1; i < nCount; ++i)
        {
            id<ListCellTemplate> p = [self.subviews objectAtIndex:i];
            if(p == pCell)
            {
               return i;
            }
        }
    }
    
    return -1;
}

-(CGSize)GetSize
{
    CGSize size = CGSizeMake(self.frame.size.width, [self GetGroupHeight]);
    return size;
}

-(float)GetGroupHeight
{
    float fRet = m_Title.frame.size.height;
    
    int nCount = [self.subviews count];
    if(0 < nCount)
    {
        for(int i = 1; i < nCount; ++i)
        {
            id<ListCellTemplate> pCell = [self.subviews objectAtIndex:i];
            if(pCell)
            {
                fRet += [pCell GetCellHeight];
            }
        }
    }
    
    return fRet;
}

-(void)UnCellsCheckBox:(id)sender
{
    id<ListCellTemplate> cellExcept = (id<ListCellTemplate>)sender; //[sender object];
    int nCount = [self.subviews count];
    if(0 < nCount)
    {
        for(int i = 0; i < nCount; ++i)
        {
            id<ListCellTemplate> pCell = [self.subviews objectAtIndex:i];
            if(pCell != cellExcept)
            {
                [pCell SetCheckBoxState:NO];
            }
        }
    }
}

-(void)OnUnCheckAllCells:(id)sender
{
    int nCount = [self.subviews count];
    if(0 < nCount)
    {
        for(int i = 0; i < nCount; ++i)
        {
            id<ListCellTemplate> pCell = [self.subviews objectAtIndex:i];
            if(pCell != nil)
                [pCell SetCheckBoxState:NO];
        }
    }
}

-(void)OnUnSelectAllCells:(id)sender
{
	int nCount = self.subviews.count;
	if(0 < nCount)
	{
		for(int i = 0; i < nCount; ++i)
		{	
			id<ListCellTemplate> pCell = (id<ListCellTemplate>)[self.subviews objectAtIndex:i];
			if(pCell)
			{	
				[pCell SetSelectionState:NO];
			}	
		}	
	}	
}

-(void)OnCellSelectedEvent:(id)sender
{
    if([self.superview respondsToSelector:@selector(OnCellSelectedEvent:)])
    {
        [self.superview performSelector:@selector(OnCellSelectedEvent:) withObject:sender]; 
    }
}

-(void)OnUnCellsCheckBox:(id)sender
{
    
}


@end
