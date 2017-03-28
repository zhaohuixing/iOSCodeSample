//
//  NOMPlanAnnotation.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-03-30.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import "NOMPlanAnnotation.h"

@interface NOMPlanAnnotation ()
{
    int             m_nID;
}

@end

@implementation NOMPlanAnnotation

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        m_nID = -1;
    }
    
    return self;
}

-(int)GetAnnotationType
{
    return NOM_MAP_ANNOTATIONTYPE_PLANMARKER;
}

-(int)GetID
{
    return m_nID;
}

-(void)SetID:(int)nID
{
    m_nID = nID;
}

@end
