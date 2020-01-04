//
//  ScrollListView.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScrollListView.h"
#import "GUILayout.h"
#import "ListCellBasic.h"
#import "TextCheckboxCell.h"
#import "LabelCell.h"
#import "GroupCell.h"
#import "SwitchCell.h"

@implementation ScrollListView

-(void)TestCells
{
	float w = self.frame.size.width;
	float h = [GUILayout GetDefaultListCellHeight];
	
	CGRect rect = CGRectMake(0, 0, w, h);
	for(int i = 0; i < 20; ++i)
	{	
		//TextCheckboxCell* pCell = [[TextCheckboxCell alloc] initWithFrame:rect];
		if(i%2 == 0)
        {    
            GroupCell* pCell = [[GroupCell alloc] initWithFrame:rect];
		
        //pCell.m_szTitle = [NSString stringWithFormat:@" Cell %i", i]; 
		//ListCellDataString* pData = [[ListCellDataString alloc] init];
		//pData.m_sData = [session.m_PeerCandidateList objectAtIndex:i];
		//pCell.m_DataStorage = pData;
		//[pData release];
            [m_ContentView AddCell:pCell];
            [pCell SetTitle:[NSString stringWithFormat:@" Title of Cell %i", i]]; 
          
            for(int j = 0; j < 5; ++j)
            {
                TextCheckboxCell* p = [[TextCheckboxCell alloc] initWithFrame:rect];
                [p SetTitle:[NSString stringWithFormat:@" Cell %i of Group %i",j, i]]; 
                [pCell AddCell:p];
            }
            
            [pCell release];
        }
        else
        {
            //TextCheckboxCell* pCell = [[TextCheckboxCell alloc] initWithFrame:rect];
            SwitchCell* pCell = [[SwitchCell alloc] initWithFrame:rect];
            [m_ContentView AddCell:pCell];
            [pCell SetTitle:[NSString stringWithFormat:@" Cell %i", i]]; 
            [pCell release];
        }
	}
    [m_ContentView OnLayoutChange];
    [self UpdateContentSizeByContentView];	
}	

- (id)initWithFrame:(CGRect)frame 
{
    
    self = [super initWithFrame:frame];
    if (self) 
	{
        // Initialization code.
		self.backgroundColor = [UIColor clearColor];
        self.showsVerticalScrollIndicator = YES;
        self.showsHorizontalScrollIndicator = YES;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
		self.clipsToBounds = YES;		// default is NO, we want to restrict drawing within our scrollview
		self.scrollEnabled = YES;
		[self setCanCancelContentTouches:NO];
		self.indicatorStyle = UIScrollViewIndicatorStyleWhite;
		m_ContentView = [[ListContentView alloc] initWithParent:self];
		CGRect rect = m_ContentView.frame;
		//rect.origin.y += 100;
		[m_ContentView setFrame:rect];
		[self addSubview:m_ContentView];
		
		[m_ContentView release];
		
		//[self TestCells];
		[self becomeFirstResponder];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code.
}
*/

- (void)dealloc 
{
    [super dealloc];
}

-(void)ResetContent
{
}

-(void)UpdateContentSizeByContentView
{
	float w = m_ContentView.frame.size.width;
	float h = m_ContentView.frame.size.height;
	if(h <= 0)
		h = [GUILayout GetDefaultListCellHeight];
    if(h <= 1.5*[GUILayout GetMainUIHeight])
        h = 1.5*[GUILayout GetMainUIHeight]; 
	
	[self setContentSize:CGSizeMake(w, h)];
	[m_ContentView setNeedsDisplay];
	[self setNeedsDisplay];
}	

-(CGSize)GetContainerSize
{
	return self.frame.size;
}	

// A UIScrollView delegate callback, called when the user starts zooming. 
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return m_ContentView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	CGPoint	p = scrollView.contentOffset;
	NSLog(@"x = %f, y = %f", p.x, p.y);
	[self setNeedsDisplay];
}	

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
	return NO;
}	

-(void)OnLayoutChange
{
	CGRect rect = m_ContentView.frame;
    rect.size.width = self.frame.size.width;
    [m_ContentView setFrame:rect];
    [m_ContentView OnLayoutChange];
}	

-(void)AddCell:(id<ListCellTemplate>)cell
{
    [m_ContentView AddCell:cell];
}

-(void)RemoveCellAt:(int)pos
{
    [m_ContentView RemoveCellAt:pos];
}

-(void)RemoveCell:(id<ListCellTemplate>)cell
{
    [m_ContentView RemoveCell:cell];
}

-(void)RemoveAllCells
{
    [m_ContentView RemoveAllCells];
}

-(int)GetCellCount
{
    return [m_ContentView GetCellCount];
}

-(id<ListCellTemplate>)GetCell:(int)index
{
    return [m_ContentView GetCell:index];
}

-(void)OnCellSelectedEvent:(id)sender
{
    if([self.superview respondsToSelector:@selector(OnCellSelectedEvent:)])
    {
        //[self.superview OnCellSelectedEvent:sender];
        [self.superview performSelector:@selector(OnCellSelectedEvent:) withObject:sender];
    }
}

@end
