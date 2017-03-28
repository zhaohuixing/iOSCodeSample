//
//  CustomMapViewPinDisplayView.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-07-17.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
#import "CustomMapViewPinDisplayView.h"
#import "CustomMapViewPinCallout.h"

@implementation CustomMapViewPinDisplayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGRect rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
        m_ItemListView = [[CustomMapViewPinItemListView alloc] initWithFrame:rect];
        [self addSubview:m_ItemListView];
    }
    return self;
}

-(int)GetCalloutItemCount
{
    int nRet = [m_ItemListView GetItemCount];
    return nRet;
}

-(float)GetCalloutItemHeight
{
    int nCount = [self GetCalloutItemCount];
    if(nCount < [CustomMapViewPinCallout GetMinDisplayCalloutItemNumber])
        nCount = [CustomMapViewPinCallout GetMinDisplayCalloutItemNumber];
    
    if([CustomMapViewPinCallout GetMaxDisplayCalloutItemNumber] < nCount)
        nCount = [CustomMapViewPinCallout GetMaxDisplayCalloutItemNumber];
    
    float h = nCount*[CustomMapViewPinCallout GetCalloutItemHeight];
    
    return h;
}

-(float)GetAllCalloutItemHeight
{
    int nCount = [self GetCalloutItemCount];
    float h = nCount*[CustomMapViewPinCallout GetCalloutItemHeight];
    return h;
}

-(void)UpdateLayout
{
    [m_ItemListView UpdateLayout];
}

-(void)RemoveAllPinItems
{
    [m_ItemListView RemoveAllItems];
}

-(void)AddPinItem:(CustomMapViewPinItem*)item
{
    [m_ItemListView AddItem:item];
}


@end
