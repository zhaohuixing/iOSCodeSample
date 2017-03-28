// 
//  APCLearnMasterViewController.m 
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

static CGFloat kSectionHeaderHeight = 40.f;
static NSString *kreturnControlOfTaskDelegate = @"returnControlOfTaskDelegate";

@interface XZCareLearnMasterViewController () <ORKTaskViewControllerDelegate>

@property (strong, nonatomic) ORKTaskViewController *consentVC;
@property (weak, nonatomic) IBOutlet UIImageView *diseaseBanner;
@property (weak, nonatomic) IBOutlet UILabel *diseaseName;

@end

@implementation XZCareLearnMasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnControlOfTaskDelegate:) name:kreturnControlOfTaskDelegate object:nil];
    
    self.items = [NSMutableArray new];
    self.diseaseBanner.image = [UIImage imageNamed:@"logo_disease_researchInstitute"];
    self.diseaseName.text = [XZBaseUtilities appName];
    self.items = [self prepareContent];
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setUpNavigationBarAppearance];
}

-(void)setUpNavigationBarAppearance
{
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    XZCareLogViewControllerAppeared();
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kreturnControlOfTaskDelegate object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)prepareContent
{
    return [self studyDetailsFromJSONFile:@"Learn"];
}


#pragma mark - UITableViewDataSource methods

- (NSInteger) numberOfSectionsInTableView: (UITableView *) __unused tableView
{
    return 1;
}

- (NSInteger) tableView: (UITableView *) __unused tableView
  numberOfRowsInSection: (NSInteger) section
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
    cell.imageView.tintColor = [UIColor appPrimaryColor];
    
    return cell;
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XZCareTableViewStudyDetailsItem *item = [self itemForIndexPath:indexPath];
    XZCareTableViewLearnItemType itemType = [self itemTypeForIndexPath:indexPath];
    
    switch (itemType)
    {
        case kXZCareTableViewLearnItemTypeStudyDetails:
        {
            XZCareLearnStudyDetailsViewController *detailViewController = [[UIStoryboard storyboardWithName:@"XZCareLearn" bundle:[NSBundle XZCareCoreBundle]] instantiateViewControllerWithIdentifier:@"XZCareLearnStudyDetailsViewController"];
            detailViewController.showConsentRow = YES;
            [self.navigationController pushViewController:detailViewController animated:YES];
        }
            break;
        case kXZCareTableViewLearnItemTypeReviewConsent:
            break;
            
        case kXZCareTableViewLearnItemTypeOtherDetails:
        {
            XZCareStudyDetailsViewController *detailViewController = [[UIStoryboard storyboardWithName:@"XZCareOnboarding" bundle:[NSBundle XZCareCoreBundle]] instantiateViewControllerWithIdentifier:@"XZCareStudyDetailsViewController"];
            detailViewController.studyDetails = item;
            [self.navigationController pushViewController:detailViewController animated:YES];
        }
            break;
        case kXZCareTableViewLearnItemTypeShare:
        {
            XZCareShareViewController *shareViewController = [[UIStoryboard storyboardWithName:@"XZCareOnboarding" bundle:[NSBundle XZCareCoreBundle]] instantiateViewControllerWithIdentifier:@"XZCareShareViewController"];
            shareViewController.hidesOkayButton = YES;
            [self.navigationController pushViewController:shareViewController animated:YES];
        }
            break;
            
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)        tableView: (UITableView *) __unused tableView
    heightForHeaderInSection: (NSInteger) section
{
    CGFloat height;
    
    if (section == 0)
    {
        height = 0;
    }
    else
    {
        height = kSectionHeaderHeight;
    }
    
    return height;
}

#pragma mark - TaskViewController Delegate methods

//If the TaskViewController has claimed the task delegate, we will be returned control here
-(void) returnControlOfTaskDelegate: (id) __unused sender
{
    self.consentVC.delegate = self;
}

- (void)taskViewController:(ORKTaskViewController *) __unused taskViewController didFinishWithReason:(ORKTaskViewControllerFinishReason) __unused reason error:(nullable NSError *) __unused error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Public methods

- (NSArray *)studyDetailsFromJSONFile:(NSString *)jsonFileName
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:jsonFileName ofType:@"json"];
    NSString *JSONString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    
    NSError *parseError;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:[JSONString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&parseError];
    
    NSMutableArray *learnItems = [NSMutableArray new];
    
    if (!parseError)
    {
        NSArray *items = jsonDictionary[@"items"];
        for (NSDictionary *sectionDict in items)
        {
            XZCareTableViewSection *section = [XZCareTableViewSection new];
            section.sectionTitle = sectionDict[@"section_title"];
            NSArray *rowItemsFromDict = sectionDict[@"row_items"];
            NSMutableArray *rowItems = [NSMutableArray new];
            
            for (NSDictionary *rowItemDict in rowItemsFromDict)
            {
                XZCareTableViewRow *rowItem = [XZCareTableViewRow new];
                XZCareTableViewStudyDetailsItem *studyDetails = [XZCareTableViewStudyDetailsItem new];
                studyDetails.caption = rowItemDict[@"title"];
                studyDetails.detailText = rowItemDict[@"details"];
                studyDetails.iconImage = [[UIImage imageNamed:rowItemDict[@"icon_image"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                
                rowItem.item = studyDetails;
                
                if ([studyDetails.detailText isEqualToString:@"study_details"])
                {
                    rowItem.itemType = kXZCareTableViewLearnItemTypeStudyDetails;
                }
                else if ([studyDetails.detailText isEqualToString:@"share"])
                {
                    rowItem.itemType = kXZCareTableViewLearnItemTypeShare;
                }
                else
                {
                    rowItem.itemType = kXZCareTableViewLearnItemTypeOtherDetails;
                }
                [rowItems addObject:rowItem];
            }
            section.rows = [NSArray arrayWithArray:rowItems];
            [learnItems addObject:section];
        }
    }
    
    return [NSArray arrayWithArray:learnItems];
}

- (XZCareTableViewStudyDetailsItem *)itemForIndexPath:(NSIndexPath *)indexPath
{
    XZCareTableViewSection *sectionItem = self.items[indexPath.section];
    XZCareTableViewRow *rowItem = sectionItem.rows[indexPath.row];
    
    XZCareTableViewStudyDetailsItem *studyDetailsItem = (XZCareTableViewStudyDetailsItem *)rowItem.item;
    
    return studyDetailsItem;
}

- (XZCareTableViewLearnItemType)itemTypeForIndexPath:(NSIndexPath *)indexPath
{
    XZCareTableViewSection *sectionItem = self.items[indexPath.section];
    XZCareTableViewRow *rowItem = sectionItem.rows[indexPath.row];
    
    XZCareTableViewLearnItemType learnItemType = rowItem.itemType;
    return learnItemType;
}

@end
