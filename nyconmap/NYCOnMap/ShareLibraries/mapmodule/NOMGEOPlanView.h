//
//  NOMGEOPlanView.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-03-26.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "KML.h"
#import "NOMGEOPlanAnnotationView.h"

#define NOMGEOPLAN_EDITMODE_NONE                0
#define NOMGEOPLAN_EDITMODE_LINE                1
#define NOMGEOPLAN_EDITMODE_ROUTE               2
#define NOMGEOPLAN_EDITMODE_POLY                3
#define NOMGEOPLAN_EDITMODE_RECT                4


@interface NOMGEOPlanView : UIView<MKMapViewDelegate, IGEOPlanAnnotationViewHost>

+(CGFloat)GetControlPanelSize:(BOOL)bProtrait;

-(void)CloseView:(BOOL)bAnimation;
-(void)OpenView:(BOOL)bAnimation;
-(void)UpdateLayout;

-(void)SetMapTypeStandard;
-(void)SetMapTypeSatellite;
-(void)SetMapTypeHybrid;

-(void)OpenReminderBar;
-(void)CloseReminderBar;

-(void)SetPlanEditMode:(int)nEditMode;

-(void)Reset;
-(void)ClearMap;

-(void)Undo;

-(double)GetZoomFactor;
-(void)SetPinDragState:(BOOL)bDragging;

-(void)UpdateOverlay;

-(void)RemoveOverlay:(id <MKOverlay>)overlay;
-(void)RemoveOverlays:(NSArray *)overlays;
-(void)AddOverlay:(id <MKOverlay>)overlay;

-(CLLocationCoordinate2D)GetTouchCoordinate:(UITouch*)touch;

-(KMLRoot*)GetKMLObject;

-(void)OnPlanCompleted;
-(void)SetReferencePoint:(double)dLat withLongitude:(double)dLong withSpan:(double)Span;
-(void)ClearReferencePoint;
-(void)SetReferenceInfo:(int16_t)nMainCate withSubType:(int16_t)nSubCate withThirdType:(int16_t)nThirdType isTTweet:(BOOL)bTwitterTweet;
@end
