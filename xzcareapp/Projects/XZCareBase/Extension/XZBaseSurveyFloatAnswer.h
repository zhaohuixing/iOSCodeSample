//
//  XZBaseSurveyFloatAnswer.h
//  XZCareOneDown
//
//  Created by Zhaohui Xing on 2015-08-30.
//  Copyright (c) 2015 zhaohuixing. All rights reserved.
//
#import "XZBaseSurveyAnswerBase.h"
#import <XZCareBase/XZBaseObject.h>

@interface XZBaseSurveyFloatAnswer : XZBaseObject<XZBaseSurveyAnswerBase>

@property (nonatomic, strong) NSNumber* answerFloat;
@property (nonatomic, assign) double    answerFloatValue;

@end
