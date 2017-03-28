//
//  NOMAnnotationBase.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-07-05.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
#import <MapKit/MapKit.h>
#import "NOMMapConstants.h"

@interface NOMAnnotationBase : NSObject <MKAnnotation>
{
@protected
    CLLocationCoordinate2D              m_Coordinate;
    NSString*                           m_Title;
    NSString*                           m_CountryCode;
    NSString*                           m_City;
    NSString*                           m_Community;
}


//@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

-(int)GetAnnotationType;
-(CLLocationCoordinate2D)GetCoordinate;
-(void)SetCoordinate:(CLLocationCoordinate2D)coordinate;
-(void)SetCoordinate:(double)longitude withLatitude:(double)latitude;
-(void)SetTitle:(NSString*)title;

//-(void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

-(NSString*)GetCountryCode;
-(NSString*)GetCity;
-(NSString*)GetCommunity;

@end
