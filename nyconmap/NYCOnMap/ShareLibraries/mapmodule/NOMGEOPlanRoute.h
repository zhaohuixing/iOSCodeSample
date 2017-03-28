//
//  NOMGEOPlanRoute.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-04.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NOMOperationCompleteDelegate.h"
#import "NOMGEOPlanView.h"
#import "IIDGEOOverlay.h"

@interface NOMGEOPlanRoute : NSObject<NOMOperationCompleteDelegate, IIDGEOOverlay>

-(void)OperationDone:(NSOperation *)operation;
-(void)RegisterParent:(NOMGEOPlanView*)parent;
-(NSArray*)GetRoutes;
-(void)AddRoute:(CLLocationCoordinate2D)startPoint end:(CLLocationCoordinate2D)endPoint;
-(void)Undo;
-(void)Reset;
-(void)SetID:(NSString*)overlayID;
-(NSString*)GetID;

@end
