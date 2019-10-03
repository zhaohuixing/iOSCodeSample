//
//  RenRenPoster.h
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-03-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "RRConnect.h"


@interface RenRenPoster : NSObject <RRInstanceDelegate>
{
	RRInstance*				_m_RRPoster;
}

-(void)RenRenShareActionLastWin;
-(void)RenRenShareActionTotalWin;	
-(void)RenRenShareActionTellFriend;	


@end
