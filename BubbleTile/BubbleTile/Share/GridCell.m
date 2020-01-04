//
//  GridCell.m
//  BubbleTile
//
//  Created by Zhaohui Xing on 11-05-10.
//  Copyright 2011 xgadget. All rights reserved.
//
#include "stdinc.h"
#import "GridCell.h"


@implementation GridCell

@synthesize _m_Center = m_Center;

-(id)init
{
    if((self = [super init]))
    {
        m_Center = CGPointMake(0, 0);
    }
    
    return self;
}

-(id)initWithX:(float)x withY:(float)y
{
    if((self = [super init]))
    {
        m_Center = CGPointMake(x, y);
    }
    
    return self;
}

-(id)initWithPoint:(CGPoint)pt;
{
    if((self = [super init]))
    {
        m_Center = CGPointMake(pt.x, pt.y);
    }
    
    return self;
}

-(void)SetCenter:(CGPoint)pt
{
    m_Center.x = pt.x;
    m_Center.y = pt.y;
}

-(void)SetCenter:(float)x withY:(float)y
{
    m_Center.x = x;
    m_Center.y = y;
}

-(void)dealloc
{
    [super dealloc];
}

@end
