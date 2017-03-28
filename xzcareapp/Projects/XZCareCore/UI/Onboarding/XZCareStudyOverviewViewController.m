// 
//  APCStudyOverviewViewController.m 
//  APCAppCore 
// 
// Copyright (c) 2015, Apple Inc. All rights reserved. 
// 
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
// 
// 1.  Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer.
// 
// 2.  Redistributions in binary form must reproduce the above copyright notice, 
// this list of conditions and the following disclaimer in the documentation and/or 
// other materials provided with the distribution. 
// 
// 3.  Neither the name of the copyright holder(s) nor the names of any contributors 
// may be used to endorse or promote products derived from this software without 
// specific prior written permission. No license is granted to the trademarks of 
// the copyright holders even if such marks are included in this software. 
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE 
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
// 
#import <ResearchKit/ResearchKit.h>
#import <XZCareCore/XZCareCore.h>

//#import "UIColor+XZCareAppearance.h"
//#import "UIFont+XZCareAppearance.h"

static NSString * const kStudyOverviewCellIdentifier = @"kStudyOverviewCellIdentifier";

@interface XZCareStudyOverviewViewController () <ORKTaskViewControllerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *joinButtonLeadingConstraint;

@end

@implementation XZCareStudyOverviewViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.items = [NSMutableArray new];
    
    [self setupTableView];
    [self setUpAppearance];
    self.items = [self prepareContent];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
  

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goBackToSignUpJoin:)
                                                 name:XZCareConsentCompletedWithDisagreeNotification
                                               object:nil];
    //??XZCareLogViewControllerAppeared();

}

- (void)dealloc
{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:XZCareConsentCompletedWithDisagreeNotification object:nil];
    _tableView.delegate = nil;
    _tableView.dataSource = nil;

}



- (void)goBackToSignUpJoin:(NSNotification *) __unused notification
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (NSArray *)prepareContent
{
    NSMutableArray *items = [NSMutableArray arrayWithArray:[self studyDetailsFromJSONFile:@"StudyOverview"]];
    
    if (self.showShareRow)
    {
        XZCareTableViewStudyDetailsItem *shareStudyItem = [XZCareTableViewStudyDetailsItem new];
        shareStudyItem.caption = NSLocalizedString(@"Share this Study", nil);
        shareStudyItem.iconImage = [UIImage imageNamed:@"share_icon"];
        shareStudyItem.tintColor = [UIColor appTertiaryGreenColor];

        XZCareTableViewRow *rowItem = [XZCareTableViewRow new];
        rowItem.item = shareStudyItem;
        rowItem.itemType = kXZCareTableViewStudyItemTypeShare;
        
        XZCareTableViewSection *section = [items firstObject];
        NSMutableArray *rowItems = [NSMutableArray arrayWithArray:section.rows];
        [rowItems addObject:rowItem];
        section.rows = [NSArray arrayWithArray:rowItems];
    }
    
    if (self.showConsentRow)
    {
        XZCareTableViewStudyDetailsItem *reviewConsentItem = [XZCareTableViewStudyDetailsItem new];
        reviewConsentItem.caption = NSLocalizedString(@"Review Consent", nil);
        reviewConsentItem.iconImage = [UIImage imageNamed:@"consent_icon"];
        reviewConsentItem.tintColor = [UIColor appTertiaryPurpleColor];
        
        XZCareTableViewRow *rowItem = [XZCareTableViewRow new];
        rowItem.item = reviewConsentItem;
        rowItem.itemType = kXZCareTableViewStudyItemTypeReviewConsent;
        
        XZCareTableViewSection *section = [items firstObject];
        NSMutableArray *rowItems = [NSMutableArray arrayWithArray:section.rows];
        [rowItems addObject:rowItem];
        section.rows = [NSArray arrayWithArray:rowItems];
    }
    
    return [NSArray arrayWithArray:items];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
//???    if ([self user].consented)
//???    {
        self.joinButtonLeadingConstraint.constant = CGRectGetWidth(self.view.frame)/2;
        [self.view layoutIfNeeded];
//???    }
     
}
- (void)setupTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.researchInstituteImageView setImage:[UIImage imageNamed:@"logo_disease_researchInstitute"]];
}

- (void)setUpAppearance
{
    self.diseaseNameLabel.font = [UIFont appMediumFontWithSize:19];
    self.diseaseNameLabel.textColor = [UIColor appSecondaryColor1];
    self.diseaseNameLabel.adjustsFontSizeToFitWidth = YES;
    self.diseaseNameLabel.minimumScaleFactor = 0.5;
}

/*????
- (XZCareOnboarding *)onboarding
{
    return ((XZCareCoreAppDelegate *)[UIApplication sharedApplication].delegate).onboarding;
}

- (XZCareUser *)user
{
    return ((XZCareCoreAppDelegate*) [UIApplication sharedApplication].delegate).dataSubstrate.currentUser;
}
??*/
 
#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *) __unused tableView
{
    return self.items.count;
}
- (NSInteger)tableView:(UITableView *) __unused tableView numberOfRowsInSection:(NSInteger)section
{
    XZCareTableViewSection *sectionItem = self.items[section];
    
    return sectionItem.rows.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XZCareTableViewStudyDetailsItem *studyDetailsItem = [self itemForIndexPath:indexPath];
    
    XZCareTintedTableViewCell *cell = (XZCareTintedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kXZCareTintedTableViewCellIdentifier];
    
    cell.textLabel.text = studyDetailsItem.caption;
    cell.imageView.image = studyDetailsItem.iconImage;
    cell.tintColor = studyDetailsItem.tintColor;
    
    return cell;
}


#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
/*
    XZCareTableViewStudyDetailsItem *studyDetails = [self itemForIndexPath:indexPath];
    
    XZCareTableViewStudyItemType itemType = [self itemTypeForIndexPath:indexPath];
    
    switch (itemType)
    {
        case kXZCareTableViewStudyItemTypeStudyDetails:
        {
            XZCareStudyDetailsViewController *detailsViewController = [[UIStoryboard storyboardWithName:@"XZCareOnboarding" bundle:[NSBundle XZCareCoreBundle]] instantiateViewControllerWithIdentifier:@"XZCareStudyDetailsViewController"];
            detailsViewController.studyDetails = studyDetails;
            [self.navigationController pushViewController:detailsViewController animated:YES];
        }
            break;
        case kXZCareTableViewStudyItemTypeShare:
        {
            XZCareShareViewController *shareViewController = [[UIStoryboard storyboardWithName:@"XZCareOnboarding" bundle:[NSBundle XZCareCoreBundle]] instantiateViewControllerWithIdentifier:@"XZCareShareViewController"];
            shareViewController.hidesOkayButton = YES;
            [self.navigationController pushViewController:shareViewController animated:YES];
        }
            break;
            
        case kXZCareTableViewStudyItemTypeReviewConsent:
            break;
            
        default:
            break;
    }
*/    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - TaskViewController Delegate methods

- (void)taskViewController:(ORKTaskViewController *)taskViewController didFinishWithReason:(ORKTaskViewControllerFinishReason)reason error:(nullable NSError *)__unused error
{
    if (reason == ORKTaskViewControllerFinishReasonCompleted)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if (reason == ORKTaskViewControllerFinishReasonDiscarded)
    {
        [taskViewController dismissViewControllerAnimated:YES completion:nil];
    }
    else if (reason == ORKTaskViewControllerFinishReasonFailed)
    {
        [taskViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Public methods
- (NSArray *)studyDetailsFromJSONFile:(NSString *)jsonFileName
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:jsonFileName ofType:@"json"];
    NSString *JSONString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    
    NSError *parseError;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:[JSONString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&parseError];
    
    NSMutableArray *items = [NSMutableArray new];
    
    if (!parseError)
    {
        self.diseaseName = jsonDictionary[@"disease_name"];
        self.diseaseNameLabel.text = self.diseaseName;
        
        NSArray *questions = jsonDictionary[@"questions"];
        
        NSMutableArray *rowItems = [NSMutableArray new];
        
        for (NSDictionary *questionDict in questions)
        {
            XZCareTableViewStudyDetailsItem *studyDetails = [XZCareTableViewStudyDetailsItem new];
            studyDetails.caption = questionDict[@"title"];
            studyDetails.detailText = questionDict[@"details"];
            studyDetails.iconImage = [[UIImage imageNamed:questionDict[@"icon_image"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            studyDetails.tintColor = [UIColor tertiaryColorForString:questionDict[@"tint_color"]];
            
            XZCareTableViewRow *row = [XZCareTableViewRow new];
            row.item = studyDetails;
            row.itemType = kXZCareTableViewStudyItemTypeStudyDetails;
            [rowItems addObject:row];
        }
        
        XZCareTableViewSection *section = [XZCareTableViewSection new];
        section.rows = [NSArray arrayWithArray:rowItems];
        [items addObject:section];
    }
    
    return [NSArray arrayWithArray:items];
}


- (XZCareTableViewStudyDetailsItem *)itemForIndexPath:(NSIndexPath *)indexPath
{
    XZCareTableViewSection *sectionItem = self.items[indexPath.section];
    XZCareTableViewRow *rowItem = sectionItem.rows[indexPath.row];
    
    XZCareTableViewStudyDetailsItem *studyDetailsItem = (XZCareTableViewStudyDetailsItem *)rowItem.item;
    
    return studyDetailsItem;
}

- (XZCareTableViewStudyItemType)itemTypeForIndexPath:(NSIndexPath *)indexPath
{
    XZCareTableViewSection *sectionItem = self.items[indexPath.section];
    XZCareTableViewRow *rowItem = sectionItem.rows[indexPath.row];
    
    XZCareTableViewStudyItemType studyItemType = rowItem.itemType;
    
    return studyItemType;
}

- (void) signInTapped: (id) __unused sender
{
/*???
    [((XZCareCoreAppDelegate *)[UIApplication sharedApplication].delegate) instantiateOnboardingForType:kXZCareOnboardingTaskTypeSignIn];
    
    UIViewController *viewController = [[self onboarding] nextScene];
    [self.navigationController pushViewController:viewController animated:YES];
???*/
}

- (void) signUpTapped: (id) __unused sender
{
/*???
    [((XZCareCoreAppDelegate *)[UIApplication sharedApplication].delegate) instantiateOnboardingForType:kXZCareOnboardingTaskTypeSignUp];
    
    UIViewController *viewController = [[self onboarding] nextScene];
    [self.navigationController pushViewController:viewController animated:YES];
???*/ 
}


@end
