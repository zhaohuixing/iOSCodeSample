// 
//  APCStudyOverviewCollectionViewController.m 
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
#import <XZCareCore/XZCareCore.h>
#import <ResearchKit/ResearchKit.h>

static NSString *kConsentEmailSubject = @"Consent Document";

@interface XZCareStudyOverviewCollectionViewController () <ORKTaskViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *gradientCollectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *joinButtonLeadingConstraint;
@property (weak, nonatomic) IBOutlet UIButton *btnAlreadyParticipated;

@end

@implementation XZCareStudyOverviewCollectionViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
#ifndef SHOW_CONSENT_PREVIEW
    self.pageControl.hidden = YES;
#endif
    
    
    self.items = [NSMutableArray new];
    
    [self setUpAppearance];
    self.items = [self prepareContent];
    [self setUpPageView];
    [self setupCollectionView];
    
    NSLog(@"view width:%f, height:%f", self.view.frame.size.width, self.view.frame.size.height);
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goBackToSignUpJoin:)
                                                 name:XZCareConsentCompletedWithDisagreeNotification
                                               object:nil];
    //???XZCareLogViewControllerAppeared();
#ifdef DSIABLE_LOGIN_UI
    self.loginButton.hidden = YES;
#endif
    
#ifdef APP_AS_SERVICECARE_TYPE
    [self.joinButton setTitle:@"Service Consent" forState:UIControlStateNormal];
#endif
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:XZCareConsentCompletedWithDisagreeNotification object:nil];
    _collectionView.delegate = nil;
}

- (void) goBackToSignUpJoin: (NSNotification *) __unused notification
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

    

    //???if ([self user].consented)
    {
        self.joinButtonLeadingConstraint.constant = CGRectGetWidth(self.view.frame)/2;
        [self.view layoutIfNeeded];
    }

    [self.collectionView layoutIfNeeded];

    NSLog(@"view width:%f, height:%f", self.view.frame.size.width, self.view.frame.size.height);
    self.view.backgroundColor = [UIColor whiteColor];

}

- (void)setUpPageView
{
    XZCareTableViewSection *sectionItem = self.items.firstObject;
    self.pageControl.numberOfPages = sectionItem.rows.count;
}

- (void)setupCollectionView
{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.researchInstituteImageView setImage:[UIImage imageNamed:@"logo_disease_researchInstitute"]];
}

- (void)setUpAppearance
{
    self.diseaseNameLabel.font = [UIFont appMediumFontWithSize:19];
    self.diseaseNameLabel.textColor = [UIColor blackColor];
    self.diseaseNameLabel.adjustsFontSizeToFitWidth = YES;
    self.diseaseNameLabel.minimumScaleFactor = 0.5;
    
    self.dateRangeLabel.font = [UIFont appLightFontWithSize:16];
    self.dateRangeLabel.textColor = [UIColor appSecondaryColor3];
    
    self.btnAlreadyParticipated.tintColor = [UIColor appPrimaryColor];
    
}

- (XZCareOnboarding *)onboarding
{
    return ((XZCareCoreAppDelegate *)[UIApplication sharedApplication].delegate).onboarding;
}

- (XZCarePatient *)user
{
    return ((XZCareCoreAppDelegate*) [UIApplication sharedApplication].delegate).dataSubstrate.currentUser;
}

 
#pragma mark - UICollectionViewDataSource methods

- (NSInteger) numberOfSectionsInCollectionView: (UICollectionView *) __unused collectionView
{
    return 1;
}

-(NSInteger) collectionView: (UICollectionView *) __unused collectionView
	 numberOfItemsInSection: (NSInteger) __unused section
{
    XZCareTableViewSection *sectionItem = self.items.firstObject;
    return sectionItem.rows.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    
    XZCareTableViewStudyDetailsItem *studyDetails = [self itemForIndexPath:indexPath];

    if (indexPath.row == 0)
    {
        XZCareStudyLandingCollectionViewCell *landingCell = (XZCareStudyLandingCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kXZCareStudyLandingCollectionViewCellIdentifier forIndexPath:indexPath];
        landingCell.delegate = self;
        landingCell.titleLabel.text = studyDetails.caption;
        landingCell.subTitleLabel.text = studyDetails.detailText;
        landingCell.readConsentButton.hidden = YES;
        
        if ([MFMailComposeViewController canSendMail])
        {
            [landingCell.emailConsentButton setTitleColor:[UIColor appPrimaryColor] forState:UIControlStateNormal];
            [landingCell.emailConsentButton setUserInteractionEnabled:YES];
        }
        else
        {
            [landingCell.emailConsentButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [landingCell.emailConsentButton setUserInteractionEnabled:NO];
        }
#ifdef DSIABLE_SHOWCONSENTDOCUMENT_UI
        landingCell.emailConsentButton.hidden = YES;
#endif
        
        if (studyDetails.showsConsent)
        {
            landingCell.readConsentButton.hidden = NO;
        }
        
        cell = landingCell;
        
    }
    else if (studyDetails.videoName.length > 0)
    {
        XZCareStudyVideoCollectionViewCell *videoCell = (XZCareStudyVideoCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kXZCareStudyVideoCollectionViewCellIdentifier forIndexPath:indexPath];
        videoCell.delegate = self;
        videoCell.titleLabel.text = studyDetails.caption;
        videoCell.videoMessageLabel.text = studyDetails.detailText;
        cell = videoCell;
        
    }
    else
    {
        XZCareStudyOverviewCollectionViewCell *webViewCell = (XZCareStudyOverviewCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kXZCareStudyOverviewCollectionViewCellIdentifier forIndexPath:indexPath];
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource: studyDetails.detailText ofType:@"html" inDirectory:@"HTMLContent"];
        NSURL *targetURL = [NSURL URLWithString:filePath];
        NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
        [webViewCell.webView loadRequest:request];
        
        cell = webViewCell;
    }
    return cell;
}

- (CGSize) collectionView: (UICollectionView *) __unused collectionView
				   layout: (UICollectionViewLayout*) __unused collectionViewLayout
   sizeForItemAtIndexPath: (NSIndexPath *) __unused indexPath
{
//#ifdef DSIABLE_SHOWCONSENTDOCUMENT_UI
//    return CGSizeMake(self.collectionView.bounds.size.width*2, self.collectionView.bounds.size.height);
//#else
    return self.collectionView.bounds.size;
//#endif
}

#pragma mark - UIScrollViewDelegate methods

- (void) scrollViewDidEndDecelerating: (UIScrollView *) __unused scrollView
{
    CGFloat pageWidth = self.collectionView.frame.size.width;
    self.pageControl.currentPage = (self.collectionView.contentOffset.x + pageWidth / 2) / pageWidth;
}

#pragma mark - TaskViewController Delegate methods

- (void)taskViewController:(ORKTaskViewController *)taskViewController didFinishWithReason:(ORKTaskViewControllerFinishReason)reason error:(nullable NSError *)__unused error
{
    if (reason == ORKTaskViewControllerFinishReasonCompleted)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
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
        
        NSString *fromDate = jsonDictionary[@"from_date"];
        if (fromDate.length > 0)
        {
            self.dateRangeLabel.text = [fromDate stringByAppendingFormat:@" - %@", jsonDictionary[@"to_date"]];
        }
        else
        {
            self.dateRangeLabel.hidden = YES;
        }
        
        NSArray *questions = jsonDictionary[@"questions"];
        
        NSMutableArray *rowItems = [NSMutableArray new];
        
        for (NSDictionary *questionDict in questions)
        {
            XZCareTableViewStudyDetailsItem *studyDetails = [XZCareTableViewStudyDetailsItem new];
            studyDetails.caption = questionDict[@"title"];
            studyDetails.detailText = questionDict[@"details"];
            studyDetails.iconImage = [[UIImage imageNamed:questionDict[@"icon_image"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            studyDetails.tintColor = [UIColor tertiaryColorForString:questionDict[@"tint_color"]];
            studyDetails.videoName = questionDict[@"video_name"];
            studyDetails.showsConsent = ((NSString *)questionDict[@"show_consent"]).length > 0;
            
#ifdef DSIABLE_SHOWCONSENTDOCUMENT_UI
            studyDetails.showsConsent = NO;
#endif
            
            
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
    [((XZCareCoreAppDelegate *)[UIApplication sharedApplication].delegate) instantiateOnboardingForType:kXZCareOnboardingTaskTypeSignIn];
    
    UIViewController *viewController = [[self onboarding] nextScene];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void) signUpTapped: (id) __unused sender
{
    [((XZCareCoreAppDelegate *)[UIApplication sharedApplication].delegate) instantiateOnboardingForType:kXZCareOnboardingTaskTypeSignUp];
    
    UIViewController *viewController = [[self onboarding] nextScene];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)pageClicked:(UIPageControl *)sender
{
    NSInteger page = sender.currentPage;
    CGRect frame = self.collectionView.frame;
    CGFloat offset = frame.size.width * page;
    [self.collectionView setContentOffset:CGPointMake(offset, 0) animated:YES];
}

#pragma mark - APCStudyVideoCollectionViewCellDelegate methods

- (void)studyVideoCollectionViewCellWatchVideo:(XZCareStudyVideoCollectionViewCell *)cell
{
    XZCareTableViewStudyDetailsItem *studyDetails = (XZCareTableViewStudyDetailsItem *)[self itemForIndexPath:[self.collectionView indexPathForCell:cell]];
    NSURL *fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:studyDetails.videoName ofType:@"mp4"]];
    XZCareIntroVideoViewController *introVideoViewController = [[XZCareIntroVideoViewController alloc] initWithContentURL:fileURL];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:introVideoViewController];
    navController.navigationBarHidden = YES;
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)studyVideoCollectionViewCellReadConsent:(XZCareStudyVideoCollectionViewCell *) __unused cell
{
    //XZCareWebViewController *webViewController = [[UIStoryboard storyboardWithName:@"XZCareWebView" bundle:[NSBundle XZCareCoreBundle]] instantiateViewControllerWithIdentifier:@"XZCareWebViewController"];
    XZCareConsentWebViewController *webViewController = [XZCareConsentWebViewController CreateInstance];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"consent" ofType:@"pdf"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    [webViewController.webview setDataDetectorTypes:UIDataDetectorTypeAll];
    webViewController.title = NSLocalizedString(@"Consent", @"Consent");
    
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:webViewController];
    [self.navigationController presentViewController:navController animated:YES completion:^{
        [webViewController.webview loadData:data MIMEType:@"application/pdf" textEncodingName:@"utf-8" baseURL:nil];
    }];

}

- (void)studyVideoCollectionViewCellEmailConsent:(XZCareStudyVideoCollectionViewCell *) __unused cell
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailComposeVC = [[MFMailComposeViewController alloc] init];
        mailComposeVC.mailComposeDelegate = self;
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"consent" ofType:@"pdf"];
        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
        [mailComposeVC addAttachmentData:fileData mimeType:@"application/pdf" fileName:@"Consent"];
        
        [self presentViewController:mailComposeVC animated:YES completion:NULL];
    }
}

#pragma mark - MFMailComposeViewControllerDelegate method

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            //??XZCareLogError2(error);
            break;
        default:
            break;
    }
    controller.mailComposeDelegate = nil;
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)studyLandingCollectionViewCellEmailConsent:(XZCareStudyLandingCollectionViewCell *) __unused cell
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailComposeVC = [[MFMailComposeViewController alloc] init];
        mailComposeVC.mailComposeDelegate = self;
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"consent" ofType:@"pdf"];
        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
        [mailComposeVC addAttachmentData:fileData mimeType:@"application/pdf" fileName:@"Consent"];
        [mailComposeVC setSubject:kConsentEmailSubject];
        [self presentViewController:mailComposeVC animated:YES completion:NULL];
    }
    

    
}

- (void)studyLandingCollectionViewCellReadConsent:(XZCareStudyLandingCollectionViewCell *) __unused cell
{
    //XZCareWebViewController *webViewController = [[UIStoryboard storyboardWithName:@"XZCareWebView" bundle:[NSBundle XZCareCoreBundle]] instantiateViewControllerWithIdentifier:@"XZCareWebViewController"];
    XZCareConsentWebViewController *webViewController = [XZCareConsentWebViewController CreateInstance];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"consent" ofType:@"pdf"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    [webViewController.webview setDataDetectorTypes:UIDataDetectorTypeAll];
    webViewController.title = NSLocalizedString(@"Consent", @"Consent");
    
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:webViewController];
    [self.navigationController presentViewController:navController animated:YES completion:^{
        [webViewController.webview loadData:data MIMEType:@"application/pdf" textEncodingName:@"utf-8" baseURL:nil];
    }];
}

@end
