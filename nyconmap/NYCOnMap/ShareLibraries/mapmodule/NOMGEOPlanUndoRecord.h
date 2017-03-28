//
//  NOMGEOPlanUndoRecord.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-03.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface NOMGEOPlanUndoRecord : NSObject

-(void)SetCoordinates:(CLLocationCoordinate2D*)pts count:(int)nCount;
-(NSArray*)GetPoints;


@end
