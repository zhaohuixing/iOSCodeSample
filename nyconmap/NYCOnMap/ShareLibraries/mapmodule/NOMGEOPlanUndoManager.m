//
//  NOMGEOPlanUndoManager.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-03.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMGEOPlanUndoManager.h"

@interface NOMGEOPlanUndoManager ()
{
    NSMutableArray*                             m_UndoList;
}

@end

@implementation NOMGEOPlanUndoManager

-(id)init
{
    self = [super init];

    if(self != nil)
    {
        m_UndoList = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(NOMGEOPlanUndoRecord*)Popup
{
    NOMGEOPlanUndoRecord* pRecord = nil;
    
    if(0 < m_UndoList.count)
    {
        pRecord = [m_UndoList objectAtIndex:(m_UndoList.count - 1)];
        [m_UndoList removeLastObject];
    }
    
    return pRecord;
}

-(void)Push:(NOMGEOPlanUndoRecord*)record
{
    [m_UndoList addObject:record];
}

-(void)Reset
{
    [m_UndoList removeAllObjects];
}

-(BOOL)CanUndo
{
    if(0 < m_UndoList.count)
        return YES;
    
    return NO;
}

@end
