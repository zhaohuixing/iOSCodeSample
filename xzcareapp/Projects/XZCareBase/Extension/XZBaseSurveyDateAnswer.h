//
//  XZBaseSurveyDateAnswer.h
//  XZCareOneDown
//
//  Created by Zhaohui Xing on 2015-08-30.
//  Copyright (c) 2015 zhaohuixing. All rights reserved.
//
#import "XZBaseSurveyAnswerBase.h"
#import <XZCareBase/XZBaseObject.h>

@interface XZBaseSurveyDateAnswer : XZBaseObject<XZBaseSurveyAnswerBase>

@property (nonatomic, strong) NSDate* answerDate;

-(XZBaseSurveyAnswerType)GetAnswerType;

#ifdef DEBUG
- (void)DebugLog;
#endif

@end
