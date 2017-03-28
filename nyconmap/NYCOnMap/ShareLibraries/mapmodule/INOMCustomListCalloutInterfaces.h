//
//  INOMCustomListCalloutInterfaces.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-09-01.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol INOMCustomListCalloutCaller;
@protocol INOMCustomListCalloutItem;


@protocol INOMCustomListCalloutDelegate <NSObject>

-(void)OpenListCallout:(id<INOMCustomListCalloutCaller>)caller;
-(void)AddCalloutItem:(id<INOMCustomListCalloutItem>)calloutItem;
-(id<INOMCustomListCalloutDelegate>)GetCalloutDelegate;
-(id<INOMCustomListCalloutItem>)CreateCustomeCalloutItem;
-(CGPoint)ConvertLocationToViewPoint:(CLLocationCoordinate2D)location;

@end


@protocol INOMCustomListCalloutCaller <NSObject>

-(BOOL)PrepareCalloutList:(id<INOMCustomListCalloutDelegate>)callout;
-(CGPoint)GetViewPointFromCurrentLocation;
-(CLLocationCoordinate2D)GetCurrentLocation;

@optional
-(void)RegisterCallout:(id<INOMCustomListCalloutDelegate>)callout;

@end


@protocol INOMCustomListCalloutItem <NSObject>

@optional
-(BOOL)LoadItemData:(id)data;

@end
