//
//  AdViewConstants.h
//  XXXXXX
//
//  Created by Zhaohui Xing on 11-10-23.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ADVIEW_DISPLAY_TIME         30

#define ADVIEW_TYPE_NONE            -1
#define ADVIEW_TYPE_MOBCLIX         0
#define ADVIEW_TYPE_GOOGLE          1
#define ADVIEW_TYPE_APPLE           2

#define ADVIEW_CLICK_EARN_DEFAULT           1 //10
#define ADVIEW_CLICK_EARN_FULLSCREENAD      20

#define CONGRATULATION_SHOW_TIME       1
#define ANIMATION_FLASH_TIME           0.3
#define REDEEMADVIEW_IDLE_TIME         20

#define REDEEMTYPE_ONLINE               0
#define REDEEMTYPE_SCOREPOST            1
#define REDEEMTYPE_INVITATION           2


@protocol AdViewHolderDelegate <NSObject>
-(void)AdViewClicked:(int)nType;
-(void)AdViewClosed:(int)nType;
-(void)AdViewLoaded:(int)nType;
-(void)AdViewFailed;
@end

@protocol AdInterstitialHolderDelegate <NSObject>
-(void)AdLoadSucceed;
-(void)AdLoadFailed;
@end


@protocol AdViewTemplate <NSObject>
-(void)CloseAdView;
-(void)OpenAdView;
@end
