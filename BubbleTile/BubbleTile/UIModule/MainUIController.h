//
//  MainUIController.h
//  ChuiNiuLite
//
//  Created by Zhaohui Xing on 11-02-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainApplicationDelegateTemplate.h"
#import "BTFileManager.h"
@class MainUIView;

@interface MainUIController : UIViewController<BTFileManageDelegate, AdRequestHandlerDelegate> 
{
	MainUIView*				m_MainView;
    BTFileManager*          m_FileManager;
}

@property (nonatomic, readwrite, retain)BTFileManager*          m_FileManager;


//BTFileManageDelegate protocol
-(void)PostFileSavingHandle;
-(void)StartGameWithoutCacheData;
-(void)StartGameWithCacheData;
-(void)StartGameFromFile:(NSURL*)fileUrl;

- (void)HandleAdRequest:(NSURL*)url;
- (void)AdViewClicked;
- (void)DismissExtendAdView;

- (BTFileManager*)GetFileManager;
- (void)SaveUnfinishedGameToCacheFile;
- (void)CleanCurrentGameData;
- (BOOL)HasGameFileData;
- (void)LoadNewGameToFile;
- (void)LoadLastGamePlayToFile;

- (void)ShareGameByEmail:(NSURL*)fileName;

//Show debug message
- (void)ShowDebugMessage:(NSString*)msg;

-(void)CompleteFacebookFeedMySelf;
-(void)CompleteFacebookSuggestToFriends;

@end
