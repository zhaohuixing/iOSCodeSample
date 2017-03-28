//
//  InterfaceController.h
//  nyconmap WatchKit Extension
//
//  Created by Zhaohui Xing on 2015-03-26.
//  Copyright (c) 2015 Zhaohui Xing. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import "NOMWatchMapAnnotation.h"

@interface InterfaceController : WKInterfaceController

+(void)SetForceCleanupMapViewFlag:(BOOL)bCleanup;
+(BOOL)GetForceCleanupMapViewFlag;

-(void)SetMapViewCenter:(double)dLatitude withLongitude:(double)dLongitude;
-(double)GetMapViewCenterLatitude;
-(double)GetMapViewCenterLongitude;

//
//MainApp/Watch messaging handler functions
//
-(void)SetMapViewVisableRegionSpan:(double)dSpan;
//-(void)AddAnnotation:(NOMWatchMapAnnotation*)pAnnotation;
-(void)RemoveAllAnnotations;
-(void)RemoveTrafficAnnotations;
-(void)RemoveSpotAnnotations;
-(void)RemoveTaxiAnnotations;

//-(void)AddAnnotations:(NSArray*)pAnnotations;

-(void)AddGasStationList:(NSArray*)pAnnotations;
-(void)AddPhotoRadarList:(NSArray*)pAnnotations;
-(void)AddSchoolZoneList:(NSArray*)pAnnotations;
-(void)AddPlayGroundList:(NSArray*)pAnnotations;
-(void)AddParkingGroundList:(NSArray*)pAnnotations;

-(void)AddTrafficMessage:(NSArray*)pAnnotations;
-(void)AddTaxiMessage:(NSArray*)pAnnotations;
-(void)AddSocialTrafficMessage:(NSArray*)pAnnotations;

-(void)ShowAlertMessage:(NSString*)szAlertMessage;

-(void)InitializeWithMainReplyData:(NSDictionary*)replyInfo withRemovePeviousObject:(BOOL)bRemove withEmptyAlert:(BOOL)bShow;
-(void)HandlePostAnnotation:(NSDictionary*)pData withRemovePeviousObject:(BOOL)bRemove;

@end
