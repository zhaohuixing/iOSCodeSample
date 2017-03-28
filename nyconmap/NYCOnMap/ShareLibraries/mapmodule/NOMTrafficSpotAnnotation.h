//
//  NOMTrafficSpotAnnotation.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-10-18.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//

#import "NOMAnnotationBase.h"

@class NOMTrafficSpotRecord;
@class NOMTrafficSpotPin;

@interface NOMTrafficSpotAnnotation : NOMAnnotationBase
{
@private
    NOMTrafficSpotRecord*           _m_NOMTrafficSpot;
    int                             _m_Index;
    NOMTrafficSpotPin*              _m_MyPin;
}

@property NOMTrafficSpotRecord*           m_NOMTrafficSpot;

-(void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

-(void)RegisterMyPin:(NOMTrafficSpotPin*)pin;

-(void)SetIndex:(int)index;
-(int)GetIndex;
-(void)Reset;
-(void)AddData:(NOMTrafficSpotRecord*)data;
-(int)CheckPinType;
-(NSString*)GetSpotName;
-(double)GetSpotPrice;
-(int64_t)GetSpotPriceTime;

-(int16_t)GetSubType;
-(int16_t)GetThirdType;
-(void)DrawAnnotationView;

@end
