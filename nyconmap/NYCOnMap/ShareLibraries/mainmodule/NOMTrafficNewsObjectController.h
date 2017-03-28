//
//  NOMTrafficNewsObjectController.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-28.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMapViewDelegate.h"
#import "NOMNewsMetaDataRecord.h"

@interface NOMTrafficNewsObjectController : NSObject

-(void)RegisterMapView:(id<IMapViewDelegate>)mapView;
-(void)HandleTrafficNewsData:(NOMNewsMetaDataRecord*)newsData;
-(NOMNewsMetaDataRecord*)GetTrafficNews:(NSString*)pNewsID;
-(void)RemoveTrafficNewsData:(NOMNewsMetaDataRecord*)newsData;
-(void)RemoveTrafficNewsDataByNewsID:(NSString*)newsID;
-(void)RemoveAllTrafficNewsDataFromMap;

-(void)UpdateAnnotationDrawState;

-(void)RemoveNewsRecordByTimeStamp:(int64_t)nTimeBefore;

@end
