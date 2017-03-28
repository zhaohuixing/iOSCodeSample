//
//  IMainViewDelegate.h
//  trafficjfk
//
//  Created by Zhaohui Xing on 2014-03-23.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NOMTrafficSpotRecord.h"

@protocol IMainViewDelegate <NSObject>

@optional

-(void)MakeAppLocationOnMap;
-(void)OnMenuEvent:(int)nMenuID;
-(void)StartFindLocationForPosting;
-(void)CloseCallout;

-(void)AddNoLocationSocialNewsData:(id)newsData;
-(void)RemoveAllNoLocationSocialNewsData;
-(void)OpenTwitterAccountSetting;


@end
