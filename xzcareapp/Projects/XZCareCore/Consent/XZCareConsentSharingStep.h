//
//  XZCareConsentSharingStep.h
//  XZCareOneDown
//
//  Created by Zhaohui Xing on 2015-09-23.
//  Copyright (c) 2015 zhaohuixing. All rights reserved.
//

#import <ResearchKit/ResearchKit.h>

@interface XZCareConsentSharingStep : ORKConsentSharingStep

- (instancetype)initWithIdentifier:(NSString *)identifier
      investigatorShortDescription:(NSString *)investigatorShortDescription
       investigatorLongDescription:(NSString *)investigatorLongDescription
     localizedLearnMoreHTMLContent:(NSString *)localizedLearnMoreHTMLContent;

@end
