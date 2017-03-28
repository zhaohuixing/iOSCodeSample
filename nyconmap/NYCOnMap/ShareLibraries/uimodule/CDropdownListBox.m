//
//  CDropdownListBox.m
//  newsonmap
//
//  Created by Zhaohui Xing on 1/11/2014.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import "CDropdownListBox.h"

@interface CDropdownListBox ()
{
    CDropdownListContainer*         m_DropdownList;
    int                             m_nCtrlID;
    
    BOOL                            m_bListEnable;
    
    float                           m_originXContainer;
    float                           m_originYContainer;
    
    UILabel*                        m_Label;
    UIButton*                       m_ArrowButton;
    
    int                             m_nSelectItemID;
}

@end

@implementation CDropdownListBox

-(float)DropdownListTopEdge
{
    return 2;
}

-(void)NotifyParentCloseAllDropdownList
{
    if([self.superview respondsToSelector:@selector(CloseDropdownList)])
    {
        [self.superview performSelector:@selector(CloseDropdownList)];
    }
}

-(void)ArrowButtonClick
{
    if(m_DropdownList != nil && m_DropdownList.hidden == NO)
    {
        [m_DropdownList Close];
    }
    else
    {
        float sx = m_originXContainer;
        float sy = m_originYContainer + self.frame.size.height + [self DropdownListTopEdge];
        [self NotifyParentCloseAllDropdownList];
        if(m_DropdownList != nil)
        {
            [m_DropdownList UpdateLayout:sx withY:sy];
            [m_DropdownList SetSelectedItem:m_nSelectItemID];
            [m_DropdownList Open];
        }
    }
}

-(void)UpdateControlLayout
{
    if(m_bListEnable == YES)
    {
        m_ArrowButton.hidden = NO;
        CGRect rect = m_Label.frame;
        rect.size.width = self.frame.size.width - self.frame.size.height;
        [m_Label setFrame:rect];
    }
    else
    {
        m_ArrowButton.hidden = YES;
        CGRect rect = m_Label.frame;
        rect.size.width = self.frame.size.width;
        [m_Label setFrame:rect];
    }
}

-(void)InitializeControls
{
    float sx = 0;
    float sy = 0;
    float h = self.frame.size.height;
    float w = self.frame.size.width;
    
    CGRect rect = CGRectMake(sx, sy, w, h);
    m_Label = [[UILabel alloc] initWithFrame:rect];
    m_Label.backgroundColor = [UIColor whiteColor];
    [m_Label setTextColor:[UIColor blackColor]];
    m_Label.highlightedTextColor = [UIColor grayColor];
    [m_Label setTextAlignment:NSTextAlignmentCenter];
    m_Label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    m_Label.adjustsFontSizeToFitWidth = YES;
    m_Label.font = [UIFont systemFontOfSize:h*0.5];
    [self addSubview:m_Label];
  
    
    float size = 1;
    w = h - 2*size;
    sx = self.frame.size.width - (w + size);
    sy = size;
    rect = CGRectMake(sx, sy, w, w);
    m_ArrowButton = [[UIButton alloc] initWithFrame:rect];
    m_ArrowButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_ArrowButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [m_ArrowButton addTarget:self action:@selector(ArrowButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [m_ArrowButton setBackgroundImage:[UIImage imageNamed:@"downarrow.png"] forState:UIControlStateNormal];
    [self addSubview:m_ArrowButton];
    
    [self UpdateControlLayout];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        m_DropdownList = nil;
        m_nCtrlID = -1;
        m_originXContainer = 0;
        m_originYContainer = 0;
        m_nSelectItemID = -1;
        m_bListEnable = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self InitializeControls];
    }
    return self;
}

-(void)UpdateLayout
{
    [self UpdateControlLayout];
    float sx = m_originXContainer;
    float sy = m_originYContainer + self.frame.size.height + [self DropdownListTopEdge];
    if(m_DropdownList != nil)
    {
        [m_DropdownList UpdateLayout:sx withY:sy];
    }
}

-(void)SetOriginInContainer:(float)x withY:(float)y
{
    m_originXContainer = x;
    m_originYContainer = y;
}

-(void)RegisterCtrlID:(int)nCtrlID
{
    m_nCtrlID = nCtrlID;
    if(m_DropdownList != nil)
    {
        [m_DropdownList RegisterCtrlID:m_nCtrlID];
    }
}

-(void)RegisterDropdownList:(CDropdownListContainer*)list
{
    m_DropdownList = list;
    if(m_DropdownList != nil)
    {
        [m_DropdownList RegisterCtrlID:m_nCtrlID];
        [m_DropdownList Close];
    }
}

-(int)GetCtrlID
{
    return m_nCtrlID;
}

-(void)OnListItemSelected:(CDropdownListItem*)item
{
    if(item == nil)
        return;
    
    m_nSelectItemID = [item  GetItemID];
    [m_Label setText:[item GetText]];
    if(m_DropdownList != nil)
    {
        [m_DropdownList Close];
    }
    if([self.superview respondsToSelector:@selector(OnSelectedListItemChange:)])
    {
        [self.superview performSelector:@selector(OnSelectedListItemChange:) withObject:self];
    }
}

-(void)SetEnable:(BOOL)bEnable
{
    m_bListEnable = bEnable;
    if(m_bListEnable == NO)
    {
        if(m_DropdownList != nil)
        {
            [m_DropdownList Close];
        }
    }
    [self UpdateControlLayout];
}

-(BOOL)IsEnable
{
    return m_bListEnable;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(m_bListEnable == NO)
        return;
    
    [self ArrowButtonClick];
}

-(void)SetLabel:(NSString*)szLabel
{
    [m_Label setText:szLabel];
}

-(void)SetSelectedItem:(int)nItemID
{
    m_nSelectItemID = nItemID;
    if(m_bListEnable == YES && m_DropdownList != nil)
    {
        [m_DropdownList SetSelectedItem:nItemID];
    }
}

-(int)GetSelectedItem
{
    return m_nSelectItemID;
}

-(void)CloseDropdownList
{
    if(m_DropdownList != nil)
    {
        [m_DropdownList Close];
    }
}

@end
