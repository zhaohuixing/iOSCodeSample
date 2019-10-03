//
//  FacebookPoster.h
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "FBConnect.h"

@interface FacebookPoster : NSObject <FBRequestDelegate,FBDialogDelegate,FBSessionDelegate>
{
	Facebook*	_m_Facebook;
	NSArray*	_m_Permissions;
}

@property(readonly) Facebook *m_Facebook;

- (void)FaceBookShareLastWin;
- (void)FaceBookShareTotalWin;


@end
