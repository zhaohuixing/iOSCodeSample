//
//  NOMGEOPlanUndoRecord.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-03.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMGEOPlanUndoRecord.h"
#import "NOMMapPoint.h"

@interface NOMGEOPlanUndoRecord ()
{
    NSMutableArray*     m_Points;
}

@end

@implementation NOMGEOPlanUndoRecord

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        m_Points = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(void)SetCoordinates:(CLLocationCoordinate2D*)pts count:(int)nCount
{
    [m_Points removeAllObjects];
    if(0 < nCount && pts != NULL)
    {
        for(int i = 0; i < nCount; ++i)
        {
            NOMMapPoint* pt = [[NOMMapPoint alloc] initWithCoordinate:pts[i]];
            [m_Points addObject:pt];
        }
    }
}

-(NSArray*)GetPoints
{
    return m_Points;
}


@end
