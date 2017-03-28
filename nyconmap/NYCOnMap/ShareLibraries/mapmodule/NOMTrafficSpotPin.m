//
//  NOMTrafficSpotPin.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-10-18.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
#import "NOMTrafficSpotPin.h"
#import "NOMTrafficSpotAnnotation.h"
#import "NOMSystemConstants.h"
#import "NOMMapConstants.h"
#import "AmazonClientManager.h"
#import "DrawHelper2.h"
#import "NOMAppInfo.h"


@interface NOMTrafficSpotPin ()
{
@private
    int                 m_TrafficSpotType;
    double              m_dPrice;
    
    int16_t             m_SubType;
    int16_t             m_ThirdType;
    
    MKMapView*          m_ParentMap;
    CGSize              m_BaseSize;

}
@end

@implementation NOMTrafficSpotPin

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier withSize:(CGSize)size
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.centerOffset = CGPointMake(0.0, size.height*-0.5);
        CGRect frame = self.frame;
        frame.size = size;
        m_BaseSize = size;
        self.frame = frame;
        m_TrafficSpotType = -1;
        m_SubType = -1;
        m_ThirdType = -1;
        
        m_ParentMap = nil;
        m_dPrice = 0.0;
        [self ReloadInformation];
    }
    return self;
}

-(double)GetZoomFactor
{
    if(m_ParentMap == nil)
        return 1.0;
    
    CLLocationDegrees longitudeDelta = m_ParentMap.region.span.longitudeDelta;
    CGFloat mapWidthInPixels = self.bounds.size.width;
    double zoomScale = longitudeDelta * MERCATOR_RADIUS * M_PI / (180.0 * mapWidthInPixels);
    double zoomer = MAX_GOOGLE_LEVELS - log2( zoomScale );
    if ( zoomer < 0.0 )
        zoomer = 0.0;
    return zoomer;
}


- (void)RegisterMap:(MKMapView*)map
{
    m_ParentMap = map;
}

- (void)ReloadInformation
{
    m_dPrice = 0.0;
    m_SubType = -1;
    m_ThirdType = -1;
    if(self.annotation == nil)
    {
        m_TrafficSpotType = -1;
        m_SubType = -1;
        m_ThirdType = -1;
        [self setNeedsDisplay];
    }
    else
    {
        if([self.annotation isKindOfClass:[NOMTrafficSpotAnnotation class]] == YES)
        {
            NOMTrafficSpotAnnotation* myAnnotation = (NOMTrafficSpotAnnotation*)self.annotation;
            m_TrafficSpotType = [myAnnotation CheckPinType];
//            if(m_TrafficSpotType == NOM_TRAFFICSPOT_GASSTATION)
//            {
                m_dPrice = [myAnnotation GetSpotPrice];
//            }
            m_SubType = [myAnnotation GetSubType];
            m_ThirdType = [myAnnotation GetThirdType];
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            self.rightCalloutAccessoryView = rightButton;
            [self setNeedsDisplay];
        }
        else
        {
            //[m_NumberLabel setText:@""];
            m_TrafficSpotType = -1;
            [self setNeedsDisplay];
        }
    }
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat rtwidth = rect.size.width;
    CGFloat rtheight = rtwidth;
    
    CGFloat sx = rect.origin.x + (rect.size.width - rtwidth)/2.0;
    CGFloat sy = rect.origin.y + (rect.size.height - rtheight);
    
    CGRect rt = CGRectMake(sx, sy, rtwidth, rtheight);
    
    if(m_TrafficSpotType == NOM_TRAFFICSPOT_PHOTORADAR)
    {
        if(m_SubType == NOM_PHOTORADAR_TYPE_SPEEDCAMERA)
        {
            [DrawHelper2 DrawSpeedCameraSpot:context at:rt];
        }
        else
        {
            [DrawHelper2 DrawPhotoRadarSpot:context at:rt];
        }
    }
    else if(m_TrafficSpotType == NOM_TRAFFICSPOT_SCHOOLZONE)
    {
        [DrawHelper2 DrawSchoolZoneSpot:context at:rt];
    }
    else if(m_TrafficSpotType == NOM_TRAFFICSPOT_PLAYGROUND)
    {
        [DrawHelper2 DrawPlaygroundSpot:context at:rt];
    }
    else if(m_TrafficSpotType == NOM_TRAFFICSPOT_PARKINGGROUND)
    {
        [DrawHelper2 DrawParkingSpot:context at:rt];
    }
    else if(m_TrafficSpotType == NOM_TRAFFICSPOT_GASSTATION)
    {
        if(0 < m_dPrice)
        {
            if(m_SubType == NOM_GASSTATION_CARWASH_TYPE_HAVE)
                [DrawHelper2 DrawGasStationCarWashSpot:context at:rt];
            else
                [DrawHelper2 DrawGasStationSpot:context at:rt];
            
            float size = rt.size.width/3.0;
            CGRect rt2 = CGRectMake(sx, sy, size, size);
            [DrawHelper2 DrawDollarSign:context at:rt2];
        }
        else
        {
            if(m_SubType == NOM_GASSTATION_CARWASH_TYPE_HAVE)
                [DrawHelper2 DrawGasStationCarWashSpot:context at:rt];
            else
                [DrawHelper2 DrawGasStationSpot:context at:rt];
        }
    }
}

- (NSString*)GetSpotName
{
    NSString* szRet = @"";
   
    if(self.annotation != nil && [self.annotation isKindOfClass:[NOMTrafficSpotAnnotation class]] == YES)
    {
        NOMTrafficSpotAnnotation* myAnnotation = (NOMTrafficSpotAnnotation*)self.annotation;
        if(myAnnotation != nil && myAnnotation.m_NOMTrafficSpot != nil)
        {
            NSString* szName = [myAnnotation GetSpotName];
            if(szName != nil && 0 < szName.length)
            {
                szRet = [szName copy];
            }
        }
    }
    
    return szRet;
}

- (void)UpdateZoomSize
{
    if([NOMAppInfo CanScaleMapElement] == NO)
        return;
    
    double dZoom = [self GetZoomFactor]/MAX_MKMAPVIEW_ZOOM;
    
    if(0.6 < dZoom)
        dZoom = 1.0;
    
    if(dZoom <= MIN_MKMAPOBJECT_ZOOM*2)
        dZoom = MIN_MKMAPOBJECT_ZOOM*2;
    if(1.0 < dZoom)
        dZoom = 1.0;
    
    CGSize size = CGSizeMake(m_BaseSize.width*dZoom, m_BaseSize.height*dZoom);
    
    self.centerOffset = CGPointMake(0.0, size.height*-0.5);
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
    
    //[self setNeedsDisplay];
}

@end
