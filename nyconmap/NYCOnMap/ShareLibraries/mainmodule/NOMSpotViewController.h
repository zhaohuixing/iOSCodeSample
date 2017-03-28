//
//  NOMSpotViewController.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-06-14.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "NOMDocumentController.h"
#import "ISpotUIInterfaces.h"
#import "NOMTrafficSpotRecord.h"

@interface NOMSpotViewController : NSObject<ISpotUIController>

-(void)RegisterParent:(NOMDocumentController*)controller;
-(void)InitializeSpotViews:(UIView*)pMainView;
-(void)UpdateSpotViewLayout;
-(void)AddNewSpotDetailForPosting:(int16_t)spotType withSubType:(int16_t)spotSubType;
-(void)UpdateSpotData:(NOMTrafficSpotRecord*)pSpot;

@end
