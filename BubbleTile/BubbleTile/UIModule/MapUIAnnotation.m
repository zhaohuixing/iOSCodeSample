//
//  MapUIAnnotation.m
//  XXXXXXX
//
//  Created by Zhaohui Xing on 12-02-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapUIAnnotation.h"

@implementation MapUIAnnotation

@synthesize                     m_Icon;
@synthesize                     m_Title;
@synthesize                     m_Text;
@synthesize                     m_fLatitude;
@synthesize                     m_fLongitude;
@synthesize                     m_nAnnotionID;
@synthesize                     m_bMaster;

- (id)init
{
    self = [super init];
    if(self)
    {
        m_Icon = nil;
        m_Title = @"";
        m_Text = @"";
        m_fLatitude = -1.0;
        m_fLongitude = -1.0;
        m_nAnnotionID = -1;
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate;
{
    CLLocationCoordinate2D retLoc;
    retLoc.latitude = (CLLocationDegrees)m_fLatitude;
    retLoc.longitude = (CLLocationDegrees)m_fLongitude;
    return retLoc; 
}

- (void)dealloc
{
    if(m_Icon != nil)
        [m_Icon release];
    [super dealloc];
}

- (NSString *)title
{
    return m_Title;
}

- (NSString *)subtitle
{
    return m_Text;
}

@end
