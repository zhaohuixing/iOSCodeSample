    //
//  MainUIController.m
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-02-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "MainUIView.h"
#import "MainUIController.h"
#import "ApplicationConfigure.h"


@implementation MainUIController

@synthesize m_FileManager;

- (id)init
{
	self = [super init];
	if(self)
	{
        m_FileManager = [[[BTFileManager alloc] init] retain];
        m_FileManager.m_Delegate = self;
	}
	
	return self;
}	

- (BTFileManager*)GetFileManager
{
    return m_FileManager;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)orientation
{
	[m_MainView OnOrientationChange];
	[m_MainView UpdateSubViewsOrientation];
}

- (void)CleanCurrentGameData
{
    if(m_FileManager)
        [m_FileManager Reset];
    [BTFileManager DeleteCacheFile];
}

- (BOOL)HasGameFileData
{
    BOOL bRet = NO;
    if(m_FileManager)
        bRet = [m_FileManager IsFileValid];
    if(bRet)
        bRet = ![m_FileManager CurrentDocumentIsCacheFile];
    
    return bRet;
}

- (void)LoadNewGameToFile
{
    
}

- (void)LoadLastGamePlayToFile
{
    
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    // Return YES for supported orientations.
    return YES;
}


- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
    [m_FileManager release];
    [super dealloc];
}

- (void)HandleAdRequest:(NSURL*)url
{
}

- (void)AdViewClicked
{
    
}

- (void)DismissExtendAdView
{
    
}

//BTFileManageDelegate protocol
-(void)PostFileSavingHandle
{
    
}

-(void)StartGameWithoutCacheData
{
    
}

-(void)StartGameWithCacheData
{
    
}

- (void)SaveUnfinishedGameToCacheFile
{
    
}

-(void)StartGameFromFile:(NSURL*)fileUrl
{
    
}

- (void)ShareGameByEmail:(NSURL*)fileName
{
    
}

//Show debug message
- (void)ShowDebugMessage:(NSString*)msg
{
    
}

-(void)CompleteFacebookFeedMySelf
{
    
}

-(void)CompleteFacebookSuggestToFriends
{
    
}
@end
