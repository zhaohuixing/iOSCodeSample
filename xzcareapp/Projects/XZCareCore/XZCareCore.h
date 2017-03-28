//
//  XZCareCore.h
//  XZCareCore
//
//  Created by Zhaohui Xing on 2015-07-15.
//  Copyright (c) 2015 Zhaohui Xing. All rights reserved.
//

//#ifndef __XZCARECORE_H__
//#define __XZCARECORE_H__

@import XZCareBase;
@import XZCareUICore;

#import <XZCareCore/XZCareConfigure.h>

#import <XZCareCore/XZCareConstants.h>
#import <XZCareCore/XZCareInterfaces.h>


#import <XZCareCore/XZCareCoreAppDelegate.h>

#import <XZCareCore/NSBundle+XZCareCore.h>

#import <XZCareCore/HKHealthStore+XZCareCore.h>
#import <XZCareCore/HKWorkout+XZCareCore.h>
#import <XZCareCore/NSBundle+XZCareCore.h>

#import <XZCareCore/ORKAnswerFormat+XZCareCore.h>
#import <XZCareCore/ORKQuestionResult+XZCareCore.h>

#import <XZCareCore/XZCareConsentSharingStep.h>
#import <XZCareCore/XZCareConsentQuestion.h>
#import <XZCareCore/XZCareConsentBooleanQuestion.h>
#import <XZCareCore/XZCareConsentInstructionQuestion.h>
#import <XZCareCore/XZCareConsentRedirector.h>
#import <XZCareCore/XZCareConsentTask.h>
#import <XZCareCore/XZCareConsentTextChoiceQuestion.h>



#import <XZCareCore/XZCareScoring.h>
#import <XZCareCore/XZCareInsights.h>
#import <XZCareCore/XZCareFoodInsight.h>

#import <XZCareCore/XZCareMedicationColor.h>



//?????????????
//?????????????
#import <XZCareCore/XZCareOnboardingTask.h>
#import <XZCareCore/XZCareSignInTask.h>
#import <XZCareCore/XZCareSignUpTask.h>
#import <XZCareCore/XZCareOnboarding.h>



#import <XZCareCore/XZCareDefaultWindow.h>

//????????????????????
#import <XZCareCore/XZCareCoreBaseTabBarViewController.h>

#import <XZCareCore/XZCareStudyOverviewViewController.h>
#import <XZCareCore/XZCareIntroVideoViewController.h>
#import <XZCareCore/XZCareStudyOverviewCollectionViewController.h>

#import <XZCareCore/XZCareScheduler.h>
#import <XZCareCore/XZCareDataMonitor.h>
#import <XZCareCore/XZCareCoreModel.h>

#import <XZCareCore/XZCareGroupedScheduledTask.h>
#import <XZCareCore/XZCarePermissionsManager.h>
#import <XZCareCore/XZCareTaskReminder.h>
#import <XZCareCore/XZCareTasksReminderManager.h>
#import <XZCareCore/XZCareMotionHistoryData.h>
#import <XZCareCore/XZCareMotionHistoryReporter.h>
#import <XZCareCore/XZCareJSONSerializer.h>

#import <XZCareCore/XZCareParametersUserDefaultCell.h>
#import <XZCareCore/XZCareParametersCell.h>
#import <XZCareCore/XZCareParametersCoreDataCell.h>
#import <XZCareCore/XZCareParametersDashboardTableViewController.h>

#import <XZCareCore/XZCareDebugWindow.h>

#import <XZCareCore/XZCareFitnessAllocation.h>
#import <XZCareCore/XZCareActivityTrackingStepViewController.h>


#import <XZCareCore/XZCareBaseTaskViewController.h>
#import <XZCareCore/XZCareBaseWithProgressTaskViewController.h>
#import <XZCareCore/XZCareStepViewController.h>
#import <XZCareCore/XZCareSimpleTaskSummaryViewController.h>
#import <XZCareCore/XZCareInstructionStepViewController.h>
#import <XZCareCore/XZCareIntroductionViewController.h>
#import <XZCareCore/XZCareGenericSurveyTaskViewController.h>

#import <XZCareCore/XZCareShareViewController.h>
#import <XZCareCore/XZCareSpinnerViewController.h>
#import <XZCareCore/XZCareStudyDetailsViewController.h>
#import <XZCareCore/XZCareIntroVideoViewController.h>
#import <XZCareCore/XZCareStudyOverviewCollectionViewCell.h>
#import <XZCareCore/XZCareStudyOverviewCollectionViewController.h>

#import <XZCareCore/XZCareChangeEmailViewController.h>
#import <XZCareCore/XZCareEmailVerifyViewController.h>

#import <XZCareCore/XZCareForgotPasswordViewController.h>
#import <XZCareCore/XZCareSignInViewController.h>

#import <XZCareCore/XZCareSignUpProgressing.h>
#import <XZCareCore/XZCareAllSetContentViewController.h>
#import <XZCareCore/XZCareAllSetTableViewCell.h>
#import <XZCareCore/XZCareConsentTaskViewController.h>
#import <XZCareCore/XZCareEligibleViewController.h>
#import <XZCareCore/XZCareInclusionCriteriaViewController.h>
#import <XZCareCore/XZCareInEligibleViewController.h>
#import <XZCareCore/XZCarePermissionPrimingViewController.h>
#import <XZCareCore/XZCareSignUpGeneralInfoViewController.h>
#import <XZCareCore/XZCareSignUpInfoViewController.h>
#import <XZCareCore/XZCareSignUpMedicalInfoViewController.h>
#import <XZCareCore/XZCareSignupPasscodeViewController.h>
#import <XZCareCore/XZCareSignUpPermissionsViewController.h>
#import <XZCareCore/XZCareTermsAndConditionsViewController.h>
#import <XZCareCore/XZCareThankYouViewController.h>

#import <XZCareCore/XZCareActivitiesViewWithNoTask.h>
#import <XZCareCore/XZCareActivitiesViewController.h>


#import <XZCareCore/XZCareCorrelationsSelectorViewController.h>
#import <XZCareCore/XZCareDashboardEditViewController.h>
#import <XZCareCore/XZCareDashboardMoreInfoViewController.h>
#import <XZCareCore/XZCareDashboardViewController.h>
#import <XZCareCore/XZCareGraphViewController.h>
#import <XZCareCore/XZCareLearnMasterViewController.h>
#import <XZCareCore/XZCareLearnStudyDetailsViewController.h>

#import <XZCareCore/XZCareChangePasscodeViewController.h>
#import <XZCareCore/XZCareDemographicUploader.h>
#import <XZCareCore/XZCareLicenseInfoViewController.h>
#import <XZCareCore/XZCareProfileViewController.h>
#import <XZCareCore/XZCareProfileViewController+Cloud.h>
#import <XZCareCore/XZCareSettingsViewController.h>
#import <XZCareCore/XZCareSharingOptionsViewController.h>
#import <XZCareCore/XZCareWithdrawCompleteViewController.h>
#import <XZCareCore/XZCareWithdrawDescriptionViewController.h>
#import <XZCareCore/XZCareWithdrawSurveyViewController.h>

#import <XZCareCore/XZCareTasksAndSchedulesMigrationUtility.h>

//#endif
