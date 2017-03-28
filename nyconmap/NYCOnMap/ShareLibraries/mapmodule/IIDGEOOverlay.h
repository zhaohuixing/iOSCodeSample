//
//  IIDGEOOverlay.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-08-13.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#ifndef __IIDGEOOVERLAY_H__
#define __IIDGEOOVERLAY_H__

@protocol IIDGEOOverlay <NSObject>

@optional
-(void)SetID:(NSString*)overlayID;
-(NSString*)GetID;

@end


#endif
