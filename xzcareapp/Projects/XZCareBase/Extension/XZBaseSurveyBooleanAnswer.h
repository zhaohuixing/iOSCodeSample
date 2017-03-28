//
//  XZBaseSurveyBooleanAnswer.h
//  XZCareOneDown
//
//  Created by Zhaohui Xing on 2015-08-30.
//  Copyright (c) 2015 zhaohuixing. All rights reserved.
//
#import "XZBaseSurveyAnswerBase.h"
#import <XZCareBase/XZBaseObject.h>

@interface XZBaseSurveyBooleanAnswer : XZBaseObject<XZBaseSurveyAnswerBase>

@property (nonatomic, strong) NSNumber* answerBoolean;
@property (nonatomic, assign) BOOL answerBooleanValue;

-(XZBaseSurveyAnswerType)GetAnswerType;

#ifdef DEBUG
- (void)DebugLog;
#endif

@end
