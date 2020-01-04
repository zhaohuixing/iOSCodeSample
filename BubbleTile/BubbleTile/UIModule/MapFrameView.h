//
//  MapFrameView.h
//  BubbleTile
//
//  Created by Zhaohui Xing on 12-02-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <MapKit/MapKit.h>
#import "FrameView.h"

@interface MapFrameView : FrameView <MKMapViewDelegate>
{
    MKMapView*              m_MapView;
    NSMutableArray*         m_MapAnnotationList;
}

-(void)Reset;
-(void)AddMKAnnotation:(UIImage*)icon withTitle:(NSString*)title withText:(NSString*)text withLatitude:(float)fLatitude withLongitude:(float)fLongitude withID:(int)nID isMaster:(BOOL)bMaster;
-(void)ShowAnnotation:(int)nID;
-(void)ShowAllAnnotation;
-(void)DisplayStandardMap;
-(void)DisplaySatelliteMap;
-(void)DisplayHybridMap;
-(int)GetMKAnnotationCount;
@end
