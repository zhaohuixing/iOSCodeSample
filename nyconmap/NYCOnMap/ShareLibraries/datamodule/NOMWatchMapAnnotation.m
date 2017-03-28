//
//  NOMWatchMapAnnotation.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2015-04-03.
//  Copyright (c) 2015 Zhaohui Xing. All rights reserved.
//

#import "NOMWatchMapAnnotation.h"

@interface NOMWatchMapAnnotation ()
{
    NSString*                      _m_AnnotationID;
    double                         _m_Latitude;
    double                         _m_Longitude;
    int16_t                        _m_AnnotationType;
}

@end

@implementation NOMWatchMapAnnotation

@synthesize m_AnnotationID = _m_AnnotationID;
@synthesize m_Latitude = _m_Latitude;
@synthesize m_Longitude = _m_Longitude;
@synthesize m_AnnotationType = _m_AnnotationType;

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        _m_AnnotationID = @"";
        _m_Latitude = 0;
        _m_Longitude = 0;
        _m_AnnotationType = 0;
    }
    
    return self;
}

@end
