//
//  BubbleTileAppDelegate.h
//  BubbleTile
//
//  Created by Zhaohui Xing on 11-05-05.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StdAdPostAppDelegate.h"

@interface BubbleTileAppDelegate : StdAdPostAppDelegate
{
    UIViewController*       viewController;
    BOOL                    m_bUpdateOrientation;   
    BOOL                    m_bLoadOpenFileURL;
}
@property (nonatomic, retain) IBOutlet UIWindow *window;

- (UIViewController *)MainViewController;
- (id<AdRequestHandlerDelegate>)GetAdRequestHandler;
- (Facebook*)GetFacebookInstance;

@end
