//
//  NOMNewsMapObjectController.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-28.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMapViewDelegate.h"
#import "NOMNewsMetaDataRecord.h"

@interface NOMNewsMapObjectController : NSObject

-(void)RegisterMapView:(id<IMapViewDelegate>)mapView;
-(void)HandleNewsData:(NOMNewsMetaDataRecord*)newsData;
-(NOMNewsMetaDataRecord*)GetNewsRecord:(NSString*)pNewsID;
-(void)RemoveNewsData:(NOMNewsMetaDataRecord*)newsData;
-(void)RemoveNewsDataByNewsID:(NSString*)newsID;
-(void)RemoveNewsDataByMainCate:(int16_t)nMainCate;
-(void)RemoveNewsDataByMainCate:(int16_t)nMainCate subCate:(int16_t)nSubCate;
-(void)RemoveNewsDataByMainCate:(int16_t)nMainCate subCate:(int16_t)nSubCate thirdCate:(int16_t)nThirdCate;
-(void)RemoveAllNewsDataFromMap;

-(void)UpdateAnnotationDrawState;

-(void)RemoveNewsRecordByTimeStamp:(int64_t)nTimeBefore;

//
//Collect Data to Apple Watch open reqest
//
-(void)CollectNewsDataForAppleWatch:(NSMutableDictionary*)collectionSet storageKey:(NSString*)szKey;
-(void)CollectNewsDataFromSocialMediaForAppleWatch:(NSMutableDictionary*)collectionSet storageKey:(NSString*)szKey;
-(BOOL)CanHandleAppleWatchRequest;

@end
