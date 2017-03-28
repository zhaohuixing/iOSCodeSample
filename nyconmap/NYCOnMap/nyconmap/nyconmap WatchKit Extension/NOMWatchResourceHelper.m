//
//  NOMWatchResourceHelper.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2015-04-05.
//  Copyright (c) 2015 Zhaohui Xing. All rights reserved.
//
#import "NOMWatchResourceHelper.h"
#import "NOMAppWatchConstants.h"

@implementation NOMWatchResourceHelper

+(UIImage*)GetWatchAnnotationImageFromType:(int16_t)nType
{
    UIImage* pSrcImage = nil;
    
    switch(nType)
    {
        //
        //Traffic
        //
        case NOM_WATCH_ANNOTATION_TRAFFIC_DC_JAM:
            pSrcImage = [UIImage imageNamed:@"wkjam.png"];
            break;
        case NOM_WATCH_ANNOTATION_TRAFFIC_DC_CRASH:
            pSrcImage = [UIImage imageNamed:@"wkcrash.png"];
            break;
        case NOM_WATCH_ANNOTATION_TRAFFIC_DC_POLICE:
            pSrcImage = [UIImage imageNamed:@"wkpolice.png"];
            break;
        case NOM_WATCH_ANNOTATION_TRAFFIC_DC_CONSTRUCTION:
            pSrcImage = [UIImage imageNamed:@"wkconstruct.png"];
            break;
        case NOM_WATCH_ANNOTATION_TRAFFIC_DC_ROADCLOSURE:
            pSrcImage = [UIImage imageNamed:@"wkroadclose.png"];
            break;
        case NOM_WATCH_ANNOTATION_TRAFFIC_DC_BROKENTRAFFICLIGHT:
            pSrcImage = [UIImage imageNamed:@"wkbrokenlight.png"];
            break;
        case NOM_WATCH_ANNOTATION_TRAFFIC_DC_STALLEDCAR:
            pSrcImage = [UIImage imageNamed:@"wkstalledcar.png"];
            break;
        case NOM_WATCH_ANNOTATION_TRAFFIC_DC_FOG:
            pSrcImage = [UIImage imageNamed:@"wkfog.png"];
            break;
        case NOM_WATCH_ANNOTATION_TRAFFIC_DC_DANGEROUSCONDITION:
            pSrcImage = [UIImage imageNamed:@"wkdanger.png"];
            break;
        case NOM_WATCH_ANNOTATION_TRAFFIC_DC_RAIN:
            pSrcImage = [UIImage imageNamed:@"wkrainy.png"];
            break;
        case NOM_WATCH_ANNOTATION_TRAFFIC_DC_ICE:
            pSrcImage = [UIImage imageNamed:@"wkicy.png"];
            break;
        case NOM_WATCH_ANNOTATION_TRAFFIC_DC_WIND:
            pSrcImage = [UIImage imageNamed:@"wkwindy.png"];
            break;
        case NOM_WATCH_ANNOTATION_TRAFFIC_DC_LANECLOSURE:
            pSrcImage = [UIImage imageNamed:@"wklaneclose.png"];
            break;
        case NOM_WATCH_ANNOTATION_TRAFFIC_DC_SLIPROADCLOSURE:
            pSrcImage = [UIImage imageNamed:@"wkslippy.png"];
            break;
        case NOM_WATCH_ANNOTATION_TRAFFIC_DC_DETOUR:
            pSrcImage = [UIImage imageNamed:@"wkdetour.png"];
            break;
        case NOM_WATCH_ANNOTATION_TRAFFIC_PT_BUS_DELAY:
            pSrcImage = [UIImage imageNamed:@"wkbusdly.png"];
            break;
        case NOM_WATCH_ANNOTATION_TRAFFIC_PT_TRAIN_DELAY:
            pSrcImage = [UIImage imageNamed:@"wktraindly.png"];
            break;
        case NOM_WATCH_ANNOTATION_TRAFFIC_PT_FLIGHT_DELAY:
            pSrcImage = [UIImage imageNamed:@"wkflightdly.png"];
            break;
        case NOM_WATCH_ANNOTATION_TRAFFIC_PT_PASSENGERSTUCK:
            pSrcImage = [UIImage imageNamed:@"wkcrowd.png"];
            break;
        //
        //Spots
        //
        case NOM_WATCH_ANNOTATION_SPOT_REDLIGHTCAMERA:
            pSrcImage = [UIImage imageNamed:@"wkrlcamera.png"];
            break;
        case NOM_WATCH_ANNOTATION_SPOT_SPEEDCAMERA:
            pSrcImage = [UIImage imageNamed:@"wkspcamera.png"];
            break;
        case NOM_WATCH_ANNOTATION_SPOT_SCHOOLZONE:
            pSrcImage = [UIImage imageNamed:@"wkschool.png"];
            break;
        case NOM_WATCH_ANNOTATION_SPOT_PLAYGROUND:
            pSrcImage = [UIImage imageNamed:@"wkplaygnd.png"];
            break;
        case NOM_WATCH_ANNOTATION_SPOT_GASSTATION:
            pSrcImage = [UIImage imageNamed:@"wkgas.png"];
            break;
        case NOM_WATCH_ANNOTATION_SPOT_PARKINGGROUND:
            pSrcImage = [UIImage imageNamed:@"wkparking.png"];
            break;
        //
        //Taxi
        //
        case NOM_WATCH_ANNOTATION_TAXI_TAXIAVAILABLEBYDRIVER:
            pSrcImage = [UIImage imageNamed:@"wktaxi.png"];
            break;
        case NOM_WATCH_ANNOTATION_TAXI_TAXIREQUESTBYPASSENGER:
            pSrcImage = [UIImage imageNamed:@"wkpassenger.png"];
            break;
    }
    
    if(pSrcImage == nil)
    {
        pSrcImage = [UIImage imageNamed:@"wkpinsrc.png"];
    }
    
    UIImage* pImage = [UIImage imageWithCGImage:pSrcImage.CGImage scale:2.0 orientation:UIImageOrientationUp];
    return pImage;
}

@end
