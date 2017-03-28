//
//  NOMWatchCommunicationManager.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2015-04-01.
//  Copyright (c) 2015 Zhaohui Xing. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "NOMWatchMapAnnotation.h"

@interface NOMWatchCommunicationManager : NSObject

-(id)initWithDcoumentController:(id)document;
-(void)RegisterDocumentController:(id)document;
-(void)BroadcastMapViewCenter:(double)dLatitude withLongitude:(double)dLongitude;
-(void)BroadcastRemoveAllAnnotations;
-(void)BroadcastRemoveTrafficAnnotations;
-(void)BroadcastRemoveSpotAnnotations;
-(void)BroadcastRemoveTaxiAnnotations;

//-(void)BroadcastAddAnnotation:(NOMWatchMapAnnotation*)pAnnotation;
//-(void)BroadcastAnnotations:(NSArray*)pAnnotations;

-(void)BroadcastGasStattionList:(NSArray*)pAnnotations;
-(void)BroadcastPhotoRadarList:(NSArray*)pAnnotations;
-(void)BroadcastSchoolZoneList:(NSArray*)pAnnotations;
-(void)BroadcastPlayGroundList:(NSArray*)pAnnotations;
-(void)BroadcastParkingGroundList:(NSArray*)pAnnotations;

-(void)BroadcastTafficMessage:(NSArray*)pAnnotations;
-(void)BroadcastTaxiMessage:(NSArray*)pAnnotations;
-(void)BroadcastSocialTafficMessage:(NSArray*)pAnnotations;

-(void)BroadcastContainerAppRunMode:(BOOL)bBackgroundMode;


-(void)BroadcastLocationNotSuppotPostingWarnMessage;
-(void)BroadcastDebugAlertMessage:(NSString*)message;

@end
