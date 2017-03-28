//
//  TTGEODecodeService.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2/20/2014.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TTGEODecodeService;

@protocol TTGEODecodeServiceDelegate <NSObject>

@optional
-(void)TTGEODecodeDone:(TTGEODecodeService*)pService withResult:(BOOL)bSucceed;

@end

@interface TTGEODecodeService : NSObject

+(TTGEODecodeService*)getSharedService;

-(BOOL)ParseLocation:(NSString*)address withStartLat:(double)startLat withEndLat:(double)endLat withStartLong:(double)startLong withEndLong:(double)endLong withResultLat:(double *)pLat withResultLong:(double *)pLong;

-(BOOL)ParseLocation:(NSString*)address;

-(void)RegisterDelegate:(id<TTGEODecodeServiceDelegate>)delegate;

-(double)GetQueryLatitude;
-(double)GetQueryLongitude;

@end
