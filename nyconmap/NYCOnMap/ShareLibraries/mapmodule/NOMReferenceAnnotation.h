//
//  NOMReferenceAnnotation.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-06-19.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import "NOMAnnotationBase.h"

@interface NOMReferenceAnnotation : NOMAnnotationBase

-(void)SetNewsDataMainType:(int16_t)nMainCate withSubType:(int16_t)nSubCate withThirdType:(int16_t)nThirdType;
-(void)SetTwitterTweet:(BOOL)bTweet;
-(BOOL)IsTwitterTweet;
-(int16_t)GetPinType;
-(int16_t)GetPinSubType;

@end
