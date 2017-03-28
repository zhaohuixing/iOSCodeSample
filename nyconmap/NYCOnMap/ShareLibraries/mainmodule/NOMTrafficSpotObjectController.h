//
//  NOMTrafficSpotObjectController.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-28.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMapViewDelegate.h"
#import "NOMTrafficSpotRecord.h"
//#import "NOMWatchCommunicationManager.h"

@interface NOMTrafficSpotObjectController : NSObject

-(void)RegisterMapView:(id<IMapViewDelegate>)mapView;
-(void)HandleSearchTrafficSpotList:(NSArray*)spotList;
-(void)HandleTrafficSpotData:(NOMTrafficSpotRecord*)spot;
-(NOMTrafficSpotRecord*)GetSpotRecord:(NSString*)pSotID;

-(void)RemoveRedlightCameraSpotFromMap;
-(void)RemoveSpeedCameraSpotFromMap;
-(void)RemoveAllPhotoRadarSpotsFromMap;
-(void)RemoveSchoolZoneSpotFromMap;
-(void)RemovePlayGroundSpotFromMap;
-(void)RemoveAllSpeedLimitSpotsFromMap;
-(void)RemoveGasStationSpotFromMap;
-(void)RemoveParkingGroundSpotFromMap;
-(void)RemoveAllTrafficSpotFromMap;

-(void)DrawAnnotions;

//
//Collect Data to Apple Watch open reqest
//
-(void)CollectSpotDataForAppleWatch:(NSMutableDictionary*)collectionSet;
-(BOOL)CanHandleAppleWatchRequest;

@end
