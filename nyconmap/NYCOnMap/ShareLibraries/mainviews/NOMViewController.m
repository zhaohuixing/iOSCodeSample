//
//  NOMViewController.m
//  trafficjfk
//
//  Created by Zhaohui Xing on 2014-03-14.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMViewController.h"
#import "NOMMainView.h"
#import "NOMGUILayout.h"
#import "NOMDocumentController.h"
#import "NOMPreference.h"
#import "NOMAppInfo.h"
#import "NOMAppRegionHelper.h"

@interface NOMViewController ()
{
@private
    NOMDocumentController*          m_DocumentController;
    UIPopoverController*            m_PopoverController;
    BOOL                            m_bUpdateForResizeEvent;
    BOOL                            m_bInitialized;
}

-(void)UpdateSubViews;
+(void)UpdateLayout;

@end

static NOMViewController*   g_ViewController = nil;

@implementation NOMViewController


+(void)RegisterGlobalController:(NOMViewController*)controller
{
    if([NOMAppInfo IsVersion8] == YES)
    {
        g_ViewController = controller;
    }
}

+(void)UpdateLayout
{
    if([NOMAppInfo IsVersion8] == YES)
    {
        if(g_ViewController != nil)
            [g_ViewController UpdateSubViews];
    }
}

- (void)onOrientationChanged:(BOOL)bUpdateSubViewLayout
{
//    BOOL bLandscape = UIDeviceOrientationIsLandscape([self preferredInterfaceOrientationForPresentation]);
    BOOL bLandscape = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation);
    [NOMGUILayout SetOrientation:bLandscape];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window)
    {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    if(window != nil)
        rect = window.frame;
    
    
    CGFloat srcwidth = rect.size.width;
    CGFloat srcheight = rect.size.height;
    CGFloat w;
    CGFloat h;
    if(bLandscape == YES)
    {
        w = srcwidth < srcheight ? srcheight : srcwidth;
        h = srcwidth > srcheight ? srcheight : srcwidth;
    }
    else
    {
        h = srcwidth < srcheight ? srcheight : srcwidth;
        w = srcwidth > srcheight ? srcheight : srcwidth;
    }
    [NOMGUILayout SetLayoutDimension:w withHeight:h];
    //[(NOMMainView*)self.view setFrame:CGRectMake(0, 0, w, h)];
    [(NOMMainView*)self.view UpdateLayout:bUpdateSubViewLayout];
}

-(void)onOrientationWillChange
{
    BOOL bLandscape = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation);
    
    
    [NOMGUILayout SetOrientation:bLandscape];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window)
    {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    if(window != nil)
        rect = window.frame;
    
    
    CGFloat srcwidth = rect.size.width;
    CGFloat srcheight = rect.size.height;
    CGFloat w;
    CGFloat h;
    if(bLandscape == YES)
    {
        w = srcwidth < srcheight ? srcheight : srcwidth;
        h = srcwidth > srcheight ? srcheight : srcwidth;
    }
    else
    {
        h = srcwidth < srcheight ? srcheight : srcwidth;
        w = srcwidth > srcheight ? srcheight : srcwidth;
    }
    [NOMGUILayout SetLayoutDimension:w withHeight:h];
    //[(NOMMainView*)self.view setFrame:CGRectMake(0, 0, w, h)];
    [(NOMMainView*)self.view UpdateLayout:NO];
}

-(void)UpdateSubViews
{
    [self onOrientationWillChange];
}

-(void)PrepareOrientationChange:(CGSize)size
{
//    CGFloat srcwidth = rect.size.width;
//    CGFloat srcheight = rect.size.height;
    CGFloat w = size.width;
    CGFloat h = size.height;
/*    if(bLandscape == YES)
    {
        w = srcwidth < srcheight ? srcheight : srcwidth;
        h = srcwidth > srcheight ? srcheight : srcwidth;
    }
    else
    {
        h = srcwidth < srcheight ? srcheight : srcwidth;
        w = srcwidth > srcheight ? srcheight : srcwidth;
    }
*/
    [NOMGUILayout SetLayoutDimension:w withHeight:h];
    [(NOMMainView*)self.view UpdateLayout:NO];
}

- (void)_InteranlInitialize
{
    m_PopoverController = nil;
    [NOMAppInfo RegisterImageResourceSelector:self];
    [NOMPreference InitSharedPreference];
    [NOMAppRegionHelper InitializeAppRegionSystem];
    BOOL bLandscape = UIDeviceOrientationIsLandscape(self.interfaceOrientation);
    [NOMGUILayout SetOrientation:bLandscape];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window)
    {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    if(window != nil)
        rect = window.frame;
    
    CGFloat srcwidth = rect.size.width;
    CGFloat srcheight = rect.size.height;
    CGFloat w;
    CGFloat h;
    if(bLandscape == YES)
    {
        w = srcwidth < srcheight ? srcheight : srcwidth;
        h = srcwidth > srcheight ? srcheight : srcwidth;
    }
    else
    {
        h = srcwidth < srcheight ? srcheight : srcwidth;
        w = srcwidth > srcheight ? srcheight : srcwidth;
    }
    [NOMGUILayout SetLayoutDimension:w withHeight:h];
    
    //??????????????
    //m_DocumentController = [[NOMDocumentController alloc] init];
    m_DocumentController = [NOMGUILayout GetGlobalDocumentController];
    //??????????????
    
    m_bUpdateForResizeEvent = NO;
    m_bInitialized = YES;
    [NOMGUILayout SetRootViewController:self];
}

- (id)init
{
    self = [super init];
    
    if(self != nil)
    {
        m_bInitialized = NO;
        [self _InteranlInitialize];
    }
    
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle
{
    if(self != nil)
    {
        m_bInitialized = NO;
        [self _InteranlInitialize];
    }
    return self;
}

-(void)ApplicationBecomeActive
{
    if(m_DocumentController != nil)
    {
        [m_DocumentController ApplicationBecomeActive];
    }
}

-(void)ApplicationBecomeInActive
{
    if(m_DocumentController != nil)
    {
        [m_DocumentController ApplicationBecomeInActive];
    }
}

- (void)viewDidLoad
{
    if(m_bInitialized == NO)
        [self _InteranlInitialize];
    
    m_bUpdateForResizeEvent = NO;
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    CGRect rect = [[UIScreen mainScreen] bounds];
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window)
    {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    if(window != nil)
        rect = window.frame;

    self.view = [[NOMMainView alloc] initWithFrame:rect];
    
    [(NOMMainView*)self.view SetDocumentController:m_DocumentController];
    m_bUpdateForResizeEvent = NO;
    [self onOrientationChanged:NO];
    [m_DocumentController SetCloudInitializationPause:YES];
     
    BOOL bAccepted = [NOMAppInfo GetTermOfUse];
    if(bAccepted == NO)
    {
        [(NOMMainView*)self.view MakeAppLocationOnMap];
        [(NOMMainView*)self.view OpenTermOfUseView:bAccepted];
    }
    else
    {
        [(NOMMainView*)self.view MakeAppLocationOnMap];
        [m_DocumentController SetCloudInitializationPause:NO];
        //if([m_DocumentController IsCloudServiceInitialized] == NO)
        //{
        //    [m_DocumentController InitializeCloudService];
        //}
    }
}

- (void)viewDidUnload
{
    NSLog(@"viewDidUnload is called");
}
- (void)didReceiveMemoryWarning
{
    //[super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"didReceiveMemoryWarning is called");
    [m_DocumentController HandleLowMemoryState];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    [self onOrientationChanged:NO];
     m_bUpdateForResizeEvent = YES;
}

- (void)viewDidLayoutSubviews
{
    if(m_bUpdateForResizeEvent == NO)
    {
        [self onOrientationChanged:YES];
        m_bUpdateForResizeEvent = YES;
    }
}

- (void)orientationChanged:(NSNotification *)notification
{
    [self onOrientationChanged:NO];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(id <UIContentContainer>)container
{
    return;
}


-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
 //   [self PrepareOrientationChange:size];
/*    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
    {
        BOOL bLandscape = (size.height < size.width);
        [NOMGUILayout SetOrientation:bLandscape];
        
        [NOMGUILayout SetLayoutDimension:size.width withHeight:size.height];
        [(NOMMainView*)self.view UpdateLayout:NO];
    }
    completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
    {
    }];
*/
    
    if([NOMAppInfo IsVersion8] == YES)
    {
        [super viewWillTransitionToSize: size withTransitionCoordinator: coordinator];
        [self onOrientationWillChange];
    }
}

-(void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
//    [self onOrientationChanged:NO];
//    [self onOrientationWillChange];
/*    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         //UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];      // do whatever
         [self onOrientationWillChange];
     }
    completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         //[self onOrientationChanged:NO];
     }];
    
*/
    if([NOMAppInfo IsVersion8] == YES)
    {
        [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
        [self onOrientationWillChange];
    }
}

//-(void)preferredContentSizeDidChangeForChildContentContainer:(id<UIContentContainer>)container
//{
//    [self onOrientationChanged:NO];
//}

//- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
//{
  //  BOOL bLandscape = UIDeviceOrientationIsLandscape(self.interfaceOrientation);
//}

-(void)InitializeMobilePushEndPointARN
{
    [m_DocumentController InitializeMobilePushEndPointARN];
}

- (BOOL)HandleRemoteNotificationData:(NSDictionary *)userInfo
{
    BOOL bRet = NO;
    
    if(m_DocumentController != nil)
        bRet = [m_DocumentController HandleRemoteNotificationData:userInfo];
    
    return bRet;
}

//
//Apple Watch opening event
//
-(void)HandleAppleWatchOpenRequest:(NSMutableDictionary*)appData
{
    if(m_DocumentController != nil)
        [m_DocumentController HandleAppleWatchOpenRequest:appData];
}

-(void)SelectPicture
{
    if([NOMAppInfo IsDeviceIPhone])
    {
        UIImagePickerController* photoPicker = [[UIImagePickerController alloc] init];
        [photoPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [photoPicker setDelegate:self];
        [self presentViewController:photoPicker animated:YES completion:nil];
    }
    else
    {
        UIImagePickerController* photoPicker = [[UIImagePickerController alloc] init];
        [photoPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [photoPicker setDelegate:self];
        
        UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:photoPicker];
        popoverController.delegate = self;
        m_PopoverController = popoverController;
        [popoverController presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2.0, 0, -1,-1) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

-(void)TakePicture;
{
    
}

//
//UIImagePickerControllerDelegate methods
//
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if([NOMAppInfo IsDeviceIPhone])
    {
        [self dismissViewControllerAnimated:YES completion: ^(void)
        {
            return;
        }];
    }
    else
    {
        if(m_PopoverController)
        {
            [m_PopoverController dismissPopoverAnimated:YES];
            m_PopoverController = nil;
        }
        else
        {
            // Dismiss the modal view controller if we weren't presented from a popover.
            [self dismissViewControllerAnimated:YES completion: ^(void)
             {
                 return;
             }];
        }
    }
    
    id<IImageReceiverDelegate> currentImageReceiver = [NOMAppInfo GetCurrentImageResourceReceiver];
    if(currentImageReceiver != nil)
    {
        [currentImageReceiver ReceiveImage:image];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion: ^(void)
     {
         return;
     }];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    m_PopoverController = nil;
}



@end
