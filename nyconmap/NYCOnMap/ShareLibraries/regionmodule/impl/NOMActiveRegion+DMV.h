//
//  NOMActiveRegion+DMV.h
//  newsonmap
//
//  Created by Zhaohui Xing on 2015-02-05.
//  Copyright (c) 2015 Zhaohui Xing. All rights reserved.
//

#import "NOMActiveRegion.h"

@interface NOMActiveRegion (WashingtonDC)

+(NSString*)GetDMVKey;
-(void)InternalCreateWashingtonDCRegion;

@end
