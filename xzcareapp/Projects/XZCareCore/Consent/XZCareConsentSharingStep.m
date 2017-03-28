//
//  XZCareConsentSharingStep.m
//  XZCareOneDown
//
//  Created by Zhaohui Xing on 2015-09-23.
//  Copyright (c) 2015 zhaohuixing. All rights reserved.
//

#import <XZCareCore/XZCareCore.h>
#import <ResearchKit/ORKConsentReviewStepViewController.h>

@implementation XZCareConsentSharingStep

- (BOOL)showsProgress {
    return NO;
}

- (BOOL)useSurveyMode {
    return NO;
}

- (void)setUseSurveyMode:(BOOL) __unused YesNo
{
}

- (instancetype)initWithIdentifier:(NSString *)identifier
      investigatorShortDescription:(NSString *)investigatorShortDescription
       investigatorLongDescription:(NSString *)investigatorLongDescription
     localizedLearnMoreHTMLContent:(NSString *)localizedLearnMoreHTMLContent
{
    self = [super initWithIdentifier:identifier];
    if (self) {
        if ( [investigatorShortDescription length] == 0 )
        {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"investigatorShortDescription should not be empty." userInfo:nil];
        }
        if ( [investigatorLongDescription length] == 0 )
        {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"investigatorLongDescription should not be empty." userInfo:nil];
        }
        if ( [localizedLearnMoreHTMLContent length] == 0 )
        {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"localizedLearnMoreHTMLContent should not be empty." userInfo:nil];
        }
       
#ifdef __USING_SINGLESHARING_OPTION__
        self.answerFormat = [ORKAnswerFormat choiceAnswerFormatWithStyle:ORKChoiceAnswerStyleSingleChoice textChoices:
                             @[[ORKTextChoice choiceWithText:[NSString stringWithFormat:NSLocalizedString(@"XZCARE_CONSENT_SHARE_%@",@""), investigatorShortDescription] detailText:@" " value:@(YES) exclusive:YES],
                               ]];
#else
        self.answerFormat = [ORKAnswerFormat choiceAnswerFormatWithStyle:ORKChoiceAnswerStyleSingleChoice textChoices:
                             @[[ORKTextChoice choiceWithText:[NSString stringWithFormat:ORKLocalizedString(@"CONSENT_SHARE_WIDELY_%@",nil), investigatorShortDescription] detailText:nil value:@(YES)],
                               [ORKTextChoice choiceWithText:[NSString stringWithFormat:ORKLocalizedString(@"CONSENT_SHARE_ONLY_%@",nil), investigatorLongDescription] detailText:nil value:@(NO)],
                               ]];
#endif
        self.optional = NO;
        self.useSurveyMode = NO;
        self.title = ORKLocalizedString(@"CONSENT_SHARING_TITLE",nil);
        self.text = [NSString stringWithFormat:ORKLocalizedString(@"CONSENT_SHARING_DESCRIPTION_%@", @" "), investigatorLongDescription];
        
        self.localizedLearnMoreHTMLContent = localizedLearnMoreHTMLContent;
    }
    return self;
}

@end
