//
//  NOMQueryLocationPin.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-07-15.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//

#import "NOMQueryLocationPin.h"
#import "NOMQueryAnnotation.h"
#import "NOMReferenceAnnotation.h"
#import "NOMGEOConfigration.h"
#import "CustomMapViewPinItem.h"
#include "NOMMapConstants.h"

#import "ImageLoader.h"
#import "GUIEventLoop.h"
#import "DrawHelper2.h"
#import "NOMAppInfo.h"


@interface NOMQueryLocationPin ()
{
    int                 m_PinType;
    int                 m_SubType;
    BOOL                m_bFromTwitterTweet;
    
    id<INOMCustomListCalloutDelegate>    m_NewListCalloutDelegate;
    
    MKMapView*              m_ParentMap;
    
    CGSize              m_BaseSize;
}

@end

@implementation NOMQueryLocationPin

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier withSize:(CGSize)size 
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.centerOffset = CGPointMake(0.0, size.height*-0.5);
        CGRect frame = self.frame;
        m_BaseSize = size;
        frame.size = size;
        self.frame = frame;
        m_PinType = NOM_QUERYPIN_TYPE_MIXED;
        m_SubType = -1;
        m_ParentMap = nil;
        
        //?????????????????????????
        //!!!!!!!!!!!!!!!!!!!!!!!!!
        //?????????????????????????
        //!!!!!!!!!!!!!!!!!!!!!!!!!
        //?????????????????????????
        //!!!!!!!!!!!!!!!!!!!!!!!!!
        m_bFromTwitterTweet = YES;
        //?????????????????????????
        //!!!!!!!!!!!!!!!!!!!!!!!!!
        //?????????????????????????
        //!!!!!!!!!!!!!!!!!!!!!!!!!
        //?????????????????????????
        //!!!!!!!!!!!!!!!!!!!!!!!!!
        //?????????????????????????
        //!!!!!!!!!!!!!!!!!!!!!!!!!
        
        [self ReloadInformation];
        m_NewListCalloutDelegate = nil;
        [self becomeFirstResponder];
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

- (void)UpdateZoomSize
{
    if([NOMAppInfo CanScaleMapElement] == NO)
    {
        return;
    }
    double dZoom = [self GetZoomFactor]/MAX_MKMAPVIEW_ZOOM;//[NOMGEOConfigration GetMapZoomFactor]/MAX_MKMAPVIEW_ZOOM;
    
    if(0.6 < dZoom)
        dZoom = 1.0;
    
    if(dZoom <= 0.36)
        dZoom = 0.36;
    if(1.0 < dZoom)
        dZoom = 1.0;

    CGSize size = CGSizeMake(m_BaseSize.width*dZoom, m_BaseSize.height*dZoom);
    
    self.centerOffset = CGPointMake(0.0, size.height*-0.5);
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
    
    [self setNeedsDisplay];
    if(m_ParentMap != nil)
    {
        [m_ParentMap setNeedsLayout];
        [m_ParentMap setNeedsDisplay];
    }
}

- (void)ReloadInformation
{
    if(self.annotation == nil)
    {
        //[m_NumberLabel setText:@""];
        m_PinType = NOM_QUERYPIN_TYPE_MIXED;
        [self UpdateZoomSize];
    }
    else
    {
        if([self.annotation isKindOfClass:[NOMQueryAnnotation class]] == YES)
        {
            NOMQueryAnnotation* myAnnotation = (NOMQueryAnnotation*)self.annotation;
            m_PinType = [myAnnotation CheckPinType];
            m_SubType = [myAnnotation GetSubType:m_PinType];
            m_bFromTwitterTweet = [myAnnotation IsTwitterTweet];
            [self UpdateZoomSize];
        }
        else if([self.annotation isKindOfClass:[NOMReferenceAnnotation class]] == YES)
        {
            NOMReferenceAnnotation* myAnnotation = (NOMReferenceAnnotation*)self.annotation;
            m_PinType = [myAnnotation GetPinType];
            m_SubType = [myAnnotation GetPinSubType];
            m_bFromTwitterTweet = [myAnnotation IsTwitterTweet];
            [self UpdateZoomSize];
        }
        else
        {
            //[m_NumberLabel setText:@""];
            m_PinType = NOM_QUERYPIN_TYPE_MIXED;
            m_SubType = -1;
            m_bFromTwitterTweet = NO;
            [self UpdateZoomSize];
        }
        [self setNeedsDisplay];
    }
}

-(void)RegisterCallout:(id<INOMCustomListCalloutDelegate>)callout
{
    m_NewListCalloutDelegate = callout;
}

-(BOOL)PrepareCalloutList:(id<INOMCustomListCalloutDelegate>)callout
{
    //?????????????????????????????????
    m_NewListCalloutDelegate = callout;
    if(m_NewListCalloutDelegate == nil)
        return NO;
    
    BOOL bRet = NO;
    if(self.annotation != nil && [self.annotation isKindOfClass:[NOMQueryAnnotation class]] == YES && 0 < ((NOMQueryAnnotation*)self.annotation).m_NOMMetaDataList.count)
    {
       for(int i = 0; i < ((NOMQueryAnnotation*)self.annotation).m_NOMMetaDataList.count; ++i)
        {
            CustomMapViewPinItem* item = (CustomMapViewPinItem*)[m_NewListCalloutDelegate CreateCustomeCalloutItem];
            NOMNewsMetaDataRecord* data = [((NOMQueryAnnotation*)self.annotation).m_NOMMetaDataList objectAtIndex:i];
            if(item != nil && data != nil)
            {
                if([item LoadItemData:data] == YES)
                {
                    [m_NewListCalloutDelegate AddCalloutItem:item];
                    bRet = YES;
                }
            }
        }
    }
    else
    {
        return NO;
    }
    return bRet;
}

-(CGPoint)GetViewPointFromCurrentLocation
{
    CGPoint pt = CGPointMake(0, 0);
    
    if(m_NewListCalloutDelegate != nil && self.annotation != nil)
    {
        pt = [m_NewListCalloutDelegate ConvertLocationToViewPoint:[self.annotation coordinate]];
        //???pt.y += m_BaseSize.height*0.5;
    }
    
    return pt;
}

-(CLLocationCoordinate2D)GetCurrentLocation
{
    CLLocationCoordinate2D loc;
    
    if(self.annotation != nil)
        return [self.annotation coordinate];
    
    return loc;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rectSrc
{
    CGFloat rtwidth = rectSrc.size.width;
    CGFloat rtheight = rectSrc.size.height;
    
    CGFloat sx = rectSrc.origin.x;
    CGFloat sy = rectSrc.origin.y;
    
    CGRect rect = CGRectMake(sx, sy, rtwidth, rtheight);
    
	CGContextRef context = UIGraphicsGetCurrentContext();
    if(m_PinType == NOM_QUERYPIN_TYPE_PUBLIC)
    {
        CGRect rt;
        [DrawHelper2 DrawBlankPublicSignRect:context at:rect];
        rt = CGRectMake(sx, sy, rect.size.width, rect.size.width);
        
        switch(m_SubType)
        {
            case NOM_QUERYPIN_SUBTYPE_PUBLIC_PUBLICISSUE:
                [DrawHelper2 DrawPublicIssueSign:context at:rt];
                break;
            case NOM_QUERYPIN_SUBTYPE_PUBLIC_POLITICS:
                [DrawHelper2 DrawPoliticsSign:context at:rt];
                break;
            case NOM_QUERYPIN_SUBTYPE_PUBLIC_BUSINESS:
                [DrawHelper2 DrawBusinessSign:context at:rt];
                break;
            case NOM_QUERYPIN_SUBTYPE_PUBLIC_MONEY:
                [DrawHelper2 DrawMoneySign:context at:rt];
                break;
            case NOM_QUERYPIN_SUBTYPE_PUBLIC_HEALTH:
                [DrawHelper2 DrawHealthSign:context at:rt];
                break;
            case NOM_QUERYPIN_SUBTYPE_PUBLIC_SPORTS:
                [DrawHelper2 DrawSportsSign:context at:rt];
                break;
            case NOM_QUERYPIN_SUBTYPE_PUBLIC_ARTANDENTERTAINMENT:
                [DrawHelper2 DrawArtSign:context at:rt];
                break;
            case NOM_QUERYPIN_SUBTYPE_PUBLIC_EDUCATION:
                [DrawHelper2 DrawEducationSign:context at:rt];
                break;
            case NOM_QUERYPIN_SUBTYPE_PUBLIC_TECHNOLOGYANDSCIENCE:
                [DrawHelper2 DrawScienceSign:context at:rt];
                break;
            case NOM_QUERYPIN_SUBTYPE_PUBLIC_FOODANDDRINK:
                [DrawHelper2 DrawDrinkSign:context at:rt];
                break;
            case NOM_QUERYPIN_SUBTYPE_PUBLIC_TRAVELANDTOURISM:
                [DrawHelper2 DrawTourSign:context at:rt];
                break;
            case NOM_QUERYPIN_SUBTYPE_PUBLIC_LIFESTYLE:
                [DrawHelper2 DrawStyleSign:context at:rt];
                break;
            case NOM_QUERYPIN_SUBTYPE_PUBLIC_REALESTATE:
                [DrawHelper2 DrawHouseSign:context at:rt];
                break;
            case NOM_QUERYPIN_SUBTYPE_PUBLIC_AUTO:
                [DrawHelper2 DrawAutoSign:context at:rt];
                break;
            case NOM_QUERYPIN_SUBTYPE_PUBLIC_CRIMEANDDISASTER:
                [DrawHelper2 DrawCrimeSign:context at:rt];
                break;
            case NOM_QUERYPIN_SUBTYPE_PUBLIC_WEATHER:
                [DrawHelper2 DrawWeatherSign:context at:rt];
                break;
            case NOM_QUERYPIN_SUBTYPE_PUBLIC_CHARITY:
                [DrawHelper2 DrawCharitySign:context at:rt];
                break;
            case NOM_QUERYPIN_SUBTYPE_PUBLIC_CULTURE:
                [DrawHelper2 DrawCultureSign:context at:rt];
                break;
            case NOM_QUERYPIN_SUBTYPE_PUBLIC_RELIGION:
                [DrawHelper2 DrawReligionSign:context at:rt];
                break;
            case NOM_QUERYPIN_SUBTYPE_PUBLIC_PET:
                [DrawHelper2 DrawPetSign:context at:rt];
                break;
            case NOM_QUERYPIN_SUBTYPE_PUBLIC_MISC:
                [DrawHelper2 DrawMiscSign:context at:rt];
                break;
            default:
                {
                    if(m_bFromTwitterTweet == YES)
                    {
                        [DrawHelper2 DrawTweetPinRect:context at:rt];
                    }
                    else
                    {
                        [DrawHelper2 DrawMiscSign:context at:rt];
                    }
                }
                break;
        }
        if(m_bFromTwitterTweet == YES)
        {
            double w = (rect.size.height - rect.size.width);//*dRatio;
            rt = CGRectMake(sx + (rect.size.width - w)*0.5, sy + rect.size.width, w, w);
            [DrawHelper2 DrawTwitterBirdRect:context at:rt];
        }
    }
    else if(m_PinType == NOM_QUERYPIN_TYPE_COMMUNIT)
    {
        CGRect rt;
        rt = CGRectMake(sx, sy, rect.size.width, rect.size.height);
        if(m_SubType == NOM_QUERYPIN_SUBTYPE_COMMUNITY_EVENT)
        {
            [DrawHelper2 DrawCommunityEventSignRect:context at:rt];
        }
        else if(m_SubType == NOM_QUERYPIN_SUBTYPE_COMMUNITY_YARDSALE)
        {
            [DrawHelper2 DrawCommunityYardSaleSignRect:context at:rt];
        }
        else if(m_SubType == NOM_QUERYPIN_SUBTYPE_COMMUNITY_WIKI)
        {
            [DrawHelper2 DrawCommunityWikiSignRect:context at:rt];
        }
        else
        {
            [DrawHelper2 DrawCommunityMixSignRect:context at:rt];
        }
        if(m_bFromTwitterTweet == YES)
        {
            //rt = CGRectMake(sx, sy, rect.size.height*(1.0 -dRatio), rect.size.height*(1.0 -dRatio));
            rt = CGRectMake(sx, sy, rect.size.height, rect.size.height);
            [DrawHelper2 DrawTwitterBirdRect:context at:rt];
        }
    }
    else if(m_PinType == NOM_QUERYPIN_TYPE_TRAFFIC)
    {
        CGRect rt;
        [DrawHelper2 DrawTrafficBKRect:context at:rect];
        rt = CGRectMake(sx, sy, rect.size.width, rect.size.width);
        
        //if(m_SubType == NOM_QUERYPIN_SUBTYPE_TRAFFIC_DELAY)
        //{
        //    [DrawHelper2 DrawDelayPinRect:context at:rt];
        //}
        if(m_SubType == NOM_QUERYPIN_SUBTYPE_TRAFFIC_BUS_DELAY)
        {
            [DrawHelper2 DrawBusDelayPinRect:context at:rt];
        }
        else if(m_SubType == NOM_QUERYPIN_SUBTYPE_TRAFFIC_TRAIN_DELAY)
        {
            [DrawHelper2 DrawTrainDelayPinRect:context at:rt];
        }
        else if(m_SubType == NOM_QUERYPIN_SUBTYPE_TRAFFIC_FLIGHT_DELAY)
        {
            [DrawHelper2 DrawFlightDelayPinRect:context at:rt];
        }
        else if(m_SubType == NOM_QUERYPIN_SUBTYPE_TRAFFIC_PASSENGERSTUCK)
        {
            [DrawHelper2 DrawCrowdPinRect:context at:rt];
        }
        else if(m_SubType == NOM_QUERYPIN_SUBTYPE_TRAFFIC_JAM)
        {
            [DrawHelper2 DrawJamPinRect:context at:rt];
        }
        else if(m_SubType == NOM_QUERYPIN_SUBTYPE_TRAFFIC_CRASH)
        {
            [DrawHelper2 DrawCrashPinRect:context at:rt];
        }
        else if(m_SubType == NOM_QUERYPIN_SUBTYPE_TRAFFIC_POLICE)
        {
            [DrawHelper2 DrawPolicePinRect:context at:rt];
        }
        else if(m_SubType == NOM_QUERYPIN_SUBTYPE_TRAFFIC_CONSTRUCTION)
        {
            [DrawHelper2 DrawConstructPinRect:context at:rt];
        }
        else if(m_SubType == NOM_QUERYPIN_SUBTYPE_TRAFFIC_ROADCLOSURE)
        {
            [DrawHelper2 DrawRoadClosurePinRect:context at:rt];
        }
        else if(m_SubType == NOM_QUERYPIN_SUBTYPE_TRAFFIC_BROKENTRAFFICLIGHT)
        {
            [DrawHelper2 DrawBrokenLightPinRect:context at:rt];
        }
        else if(m_SubType == NOM_QUERYPIN_SUBTYPE_TRAFFIC_STALLEDCAR)
        {
            [DrawHelper2 DrawStalledCarPinRect:context at:rt];
        }
        else if(m_SubType == NOM_QUERYPIN_SUBTYPE_TRAFFIC_FOG)
        {
            [DrawHelper2 DrawFogPinRect:context at:rt];
        }
        else if(m_SubType == NOM_QUERYPIN_SUBTYPE_TRAFFIC_DANGEROUSCONDITION)
        {
            [DrawHelper2 DrawDangerousConditionPinRect:context at:rt];
        }
        else if(m_SubType == NOM_QUERYPIN_SUBTYPE_TRAFFIC_RAIN)
        {
            [DrawHelper2 DrawRainPinRect:context at:rt];
        }
        else if(m_SubType == NOM_QUERYPIN_SUBTYPE_TRAFFIC_ICE)
        {
            [DrawHelper2 DrawIcePinRect:context at:rt];
        }
        else if(m_SubType == NOM_QUERYPIN_SUBTYPE_TRAFFIC_WIND)
        {
            [DrawHelper2 DrawWindPinRect:context at:rt];
        }
        else if(m_SubType == NOM_QUERYPIN_SUBTYPE_TRAFFIC_LANECLOSURE)
        {
            [DrawHelper2 DrawLaneClosurePinRect:context at:rt];
        }
        else if(m_SubType == NOM_QUERYPIN_SUBTYPE_TRAFFIC_SLIPROADCLOSURE)
        {
            [DrawHelper2 DrawSlipRoadClosurePinRect:context at:rt];
        }
        else if(m_SubType == NOM_QUERYPIN_SUBTYPE_TRAFFIC_DETOUR)
        {
            [DrawHelper2 DrawDetourPinRect:context at:rt];
        }
        else
        {
            if(m_bFromTwitterTweet == YES)
            {
                [DrawHelper2 DrawTweetPinRect:context at:rt];
            }
            else
            {
                [DrawHelper2 DrawTrafficPinRect:context at:rt];
            }
        }
        if(m_bFromTwitterTweet == YES)
        {
            double w = (rect.size.height - rect.size.width);//*dRatio;
            rt = CGRectMake(sx + (rect.size.width - w)*0.5, sy + rect.size.width, w, w);
            [DrawHelper2 DrawTwitterBirdRect:context at:rt];
        }
    }
    else if(m_PinType == NOM_QUERYPIN_TYPE_TAXI)
    {
        CGRect rt;
        rt = CGRectMake(sx, sy, rect.size.width, rect.size.height);
        if(m_SubType == NOM_QUERYPIN_SUBTYPE_TAXI_PASSENGER)
        {
            [DrawHelper2 DrawPassengerPin:context at:rt];
        }
        else
        {
            [DrawHelper2 DrawTaxiPin:context at:rt];
        }
    }
    else
    {
        CGRect rt;
        [DrawHelper2 DrawBlankPublicSignRect:context at:rect];
        //if(m_bFromTwitterTweet == YES)
        {
            double w = (rect.size.height - rect.size.width);//*dRatio;
            rt = CGRectMake(sx + (rect.size.width - w)*0.5, sy + rect.size.width, w, w);
            [DrawHelper2 DrawTwitterBirdRect:context at:rt];
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(m_NewListCalloutDelegate != nil)
        [m_NewListCalloutDelegate OpenListCallout:self];
    else
        [super touchesEnded:touches withEvent:event];
}

- (NSString*)GetCountryCode
{
    NSString* szCode = @"__";
    
    if(self.annotation != nil && [self.annotation isKindOfClass:[NOMQueryAnnotation class]] == YES)
    {
        NOMQueryAnnotation* myAnnotation = (NOMQueryAnnotation*)self.annotation;
        szCode = [myAnnotation GetCountryCode];
    }
    
    return szCode;
}

- (NSString*)GetCity
{
    NSString* szCity = @"__";
    
    if(self.annotation != nil && [self.annotation isKindOfClass:[NOMQueryAnnotation class]] == YES)
    {
        NOMQueryAnnotation* myAnnotation = (NOMQueryAnnotation*)self.annotation;
        szCity = [myAnnotation GetCity];
    }
    
    return szCity;
}


- (NSString*)GetCommunity
{
    NSString* szCommunity = @"__";
    
    if(self.annotation != nil && [self.annotation isKindOfClass:[NOMQueryAnnotation class]] == YES)
    {
        NOMQueryAnnotation* myAnnotation = (NOMQueryAnnotation*)self.annotation;
        szCommunity = [myAnnotation GetCommunity];
    }
    
    return szCommunity;
}

- (void)RegisterMap:(MKMapView*)map
{
    m_ParentMap = map;
}

-(void)ShowAlert
{
//    if(m_ParentMap != nil && self.annotation != nil)
//    {
//        MKCircle* AlertOverlay = [MKCircle circleWithCenterCoordinate:self.annotation.coordinate radius:[NOMGEOConfigration GetTrafficAlertParameter]];
//        [m_ParentMap addOverlay:AlertOverlay];
//    }
}



@end
