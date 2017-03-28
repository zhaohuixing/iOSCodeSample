//
//  XZBaseSurveyAnswerBase.h
//  XZCareOneDown
//
//  Created by Zhaohui Xing on 2015-08-30.
//  Copyright (c) 2015 zhaohuixing. All rights reserved.
//

#import <Foundation/Foundation.h>

 typedef NS_ENUM(NSInteger, XZBaseSurveyAnswerType)
 {
     XZBaseSurveyAnswerTypeUnknown = -1,
     XZBaseSurveyAnswerTypeBoolean = 0,
     XZBaseSurveyAnswerTypeString,
     XZBaseSurveyAnswerTypeDate,
     XZBaseSurveyAnswerTypeInteger,
     XZBaseSurveyAnswerTypeFloat
 };


@protocol XZBaseSurveyAnswerBase

-(XZBaseSurveyAnswerType)GetAnswerType;
-(void)DebugLog;
- (NSDictionary *)dictionaryRepresentation;

@end
