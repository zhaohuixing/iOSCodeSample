//
//  StdAdPostAppDelegate.m
//  LuckyCompassZH
//
//  Created by Zhaohui Xing on 11-10-15.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "StdAdPostAppDelegate.h"
#import "ApplicationConfigure.h"
#import "MainUIController.h"

#import "StringFactory.h"

@implementation StdAdPostAppDelegate

-(void)dealloc
{
    [m_Permissions release];
    if(m_Facebook != nil)
        [m_Facebook release];
    
    [super dealloc];
}

-(void)CompleteFacebookFeedMySelf
{
    MainUIController* pController = ( MainUIController*)[self MainViewController];
    if(pController)
    {
        [pController CompleteFacebookFeedMySelf];
    }
}

-(void)CompleteFacebookSuggestToFriends
{
    MainUIController* pController = ( MainUIController*)[self MainViewController];
    if(pController)
    {
        [pController CompleteFacebookSuggestToFriends];
    }
}

/**
 * Helper method to parse URL query parameters
 */
- (NSDictionary *)parseURLParams:(NSString *)query 
{
	NSArray *pairs = [query componentsSeparatedByString:@"&"];
	NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
	for (NSString *pair in pairs) 
    {
		NSArray *kv = [pair componentsSeparatedByString:@"="];
		NSString *val = [[kv objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		[params setObject:val forKey:[kv objectAtIndex:0]];
	}
    return params;
}

-(void)HandleAdRequest:(NSURL*)url
{
    id<AdRequestHandlerDelegate> urlHandler = [self GetAdRequestHandler];
    if(urlHandler != nil)
    {
        [urlHandler HandleAdRequest:url];
    }
}

- (void)apiFQLIMe 
{
    // Using the "pic" picture since this currently has a maximum width of 100 pixels
    // and since the minimum profile picture size is 180 pixels wide we should be able
    // to get a 100 pixel wide version of the profile picture
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"SELECT uid, name, pic FROM user WHERE uid=me()", @"query",
                                   nil];
    [m_Facebook requestWithMethodName:@"fql.query"
                            andParams:params
                        andHttpMethod:@"POST"
                          andDelegate:self];
}


-(void)ProcesUserPermission
{
    if(m_Facebook == nil)
        return;
    
    if (![m_Facebook isSessionValid]) 
    {
        /*NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"user_likes", 
                                @"read_stream",
                                //@"publish_checkins",
                                @"read_friendlists",
                                @"publish_stream",
                                //@"publish_checkins",
                                //@"manage_friendlists",
                                //@"user_activities",
                                //@"user_location",
                                //@"user_status",
                                //@"user_online_presence",
                                @"publish_actions",
                                //@"user_actions:pandacards",
                                //@"friends_actions:pandacards",
                                //@"user_games_activity",
                                nil];*/
        [m_Facebook authorize:m_Permissions];
        //[permissions release];   
        //[m_Facebook authorize:nil];
    }
    else
    {
        [self apiFQLIMe];
    }
}


-(void)InitializeFacebookInstance
{
    m_Facebook = [[Facebook alloc] initWithAppId:[ApplicationConfigure GetFacebookKey] 
                              urlSchemeSuffix:[ApplicationConfigure GetFBURLSchemeSuffix] 
                                andDelegate:self];    
//        m_Facebook = [[Facebook alloc] initWithAppId:[ApplicationConfigure GetFacebookKey] andDelegate:self];    

    //Enable frictionless request feature.
    [m_Facebook enableFrictionlessRequests];
    
    // Check and retrieve authorization information
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) 
    {
        m_Facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        m_Facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }

    m_Permissions = [[NSArray alloc] initWithObjects:
                            @"user_likes", 
                            @"read_stream",
                            //@"publish_checkins",
                            @"read_friendlists",
                            @"publish_stream",
                            //@"publish_checkins",
                            //@"manage_friendlists",
                            //@"user_activities",
                            //@"user_location",
                            //@"user_status",
                            //@"user_online_presence",
                            @"publish_actions",
                            //@"user_actions:pandacards",
                            //@"friends_actions:pandacards",
                            //@"user_games_activity",
                            nil];

    //[self ProcesUserPermission];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application 
{
    // Although the SDK attempts to refresh its access tokens when it makes API calls,
    // it's a good practice to refresh the access token also when the app becomes active.
    // This gives apps that seldom make api calls a higher chance of having a non expired
    // access token.
    if(m_Facebook != nil)
    {    
        [m_Facebook extendAccessTokenIfNeeded];
    /*    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) 
        {
            m_Facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
            m_Facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
        }*/
    }    
}

-(BOOL)handleOpenURL:(NSURL *)url
{
    BOOL bRet = YES;
    
    NSString* sScheme = [url scheme];
    if(m_Facebook && [sScheme rangeOfString:@"fb"].location != NSNotFound)
        bRet = [m_Facebook handleOpenURL:url];
    
    return bRet;
}


-(void)UserDidGrantPermission
{
    [self apiFQLIMe];
}

-(void)FacebookLogin
{
    [self ProcesUserPermission];
}

-(void)FacebookLogout
{
    if(m_Facebook)
        [m_Facebook logout];
    
}
/////////////////////////////////////////////////////////////////////////////
//
//FBSessionDelegate methods begin
//
/////////////////////////////////////////////////////////////////////////////
-(void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt 
{
    NSLog(@"token extended");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //m_Facebook.accessToken = accessToken;
    //m_Facebook.expirationDate = expiresAt;
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
 //   [self UserDidGrantPermission];
}

- (void)fbDidLogin 
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[m_Facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[m_Facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    [self UserDidGrantPermission];
}

-(void)fbDidNotLogin:(BOOL)cancelled 
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]) 
    {
    //[pendingApiCallsController userDidNotGrantPermission];
        //??????????????
        return;
    }    
}


- (void) fbDidLogout 
{
    // Remove saved authorization information if it exists
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]) 
    {
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
    }
}

- (void)fbSessionInvalidated
{
    if(m_Facebook)
    {
        [m_Facebook extendAccessTokenIfNeeded];
    }
}

/////////////////////////////////////////////////////////////////////////////
//
//FBSessionDelegate methods end
//
/////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////
//
//FBDialogDelegate methods begin
//
/////////////////////////////////////////////////////////////////////////////
/**
 * Called when a UIServer Dialog successfully return. Using this callback
 * instead of dialogDidComplete: to properly handle successful shares/sends
 * that return ID data back.
 */
- (void)dialogCompleteWithUrl:(NSURL *)url 
{
    if (![url query]) 
    {
        NSLog(@"User canceled dialog or there was an error");
        return;
    }
    
    NSDictionary *params = [self parseURLParams:[url query]];
    switch (m_FB_currentAPICall) 
    {
        case kDialogFeedUser:
        {
            [self CompleteFacebookFeedMySelf];
            break;
        }
        case kDialogFeedFriend:
        {
            break;
        }
        case kDialogRequestsSendToMany:
        case kDialogRequestsSendToSelect:
        case kDialogRequestsSendToTarget:
        {
            // Successful requests return one or more request_ids.
            // Get any request IDs, will be in the URL in the form
            // request_ids[0]=1001316103543&request_ids[1]=10100303657380180
            /*NSMutableArray *requestIDs = [[[NSMutableArray alloc] init] autorelease];
            for (NSString *paramKey in params) 
            {
                if ([paramKey hasPrefix:@"request_ids"]) 
                {
                    [requestIDs addObject:[params objectForKey:paramKey]];
                }
            }
            if ([requestIDs count] > 0) 
            {
                [self CompleteFacebookSuggestToFriends];
            }*/
            [self CompleteFacebookSuggestToFriends];
            break;
        }
        default:
            break;
    }
}

- (void)dialogDidNotComplete:(FBDialog *)dialog 
{
    //NSLog(@"Dialog dismissed.");
}

- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError *)error 
{
    //NSLog(@"Error message: %@", [[error userInfo] objectForKey:@"error_msg"]);
    //[self showMessage:@"Oops, something went haywire."];
}


/////////////////////////////////////////////////////////////////////////////
//
//FBDialogDelegate methods end
//
/////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////
//
// Facebook Graph API call functions: begin (from Facebook SDK sample)
//
///////////////////////////////////////////////
/*
 * Graph API: Get the user's basic information, picking the name and picture fields.
 */
- (void)apiGraphMe 
{
    if(m_Facebook != nil)
    {    
        m_FB_currentAPICall = kAPIGraphMe;
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"name,picture",  @"fields",
                                   nil];
        [m_Facebook requestWithGraphPath:@"me" andParams:params andDelegate:self];
    }    
}

/*
 * Graph API: Method to get the user's friends.
 */
- (void)apiGraphFriends 
{
    if(m_Facebook != nil)
        [m_Facebook requestWithGraphPath:@"me/friends" andDelegate:self];
}

/*
 * Graph API: Method to get the user's permissions for this app.
 */
- (void)apiGraphUserPermissions 
{
    if(m_Facebook != nil)
    {    
        m_FB_currentAPICall = kAPIGraphUserPermissions;
        [m_Facebook requestWithGraphPath:@"me/permissions" andDelegate:self];
    }    
}

/*
 * Graph API: Get the user's check-ins
 */
- (void)apiGraphUserCheckins 
{
    if(m_Facebook != nil)
    {    
        m_FB_currentAPICall = kAPIGraphUserCheckins;
        [m_Facebook  requestWithGraphPath:@"me/checkins" andDelegate:self];
    }    
}

/*
 * Graph API: Search query to get nearby location.
 */
- (void)apiGraphSearchPlace:(CLLocation *)location withDistance:(float)fDistance
{
    if(m_Facebook != nil)
    {    
        m_FB_currentAPICall = kAPIGraphSearchPlace;
        NSString *centerLocation = [[NSString alloc] initWithFormat:@"%f,%f",
                                location.coordinate.latitude,
                                location.coordinate.longitude];
        float fRadium = fDistance;
        if(fRadium <= 0.0)
            fRadium = 0.0;
        NSString *distanceLocation = [[NSString alloc] initWithFormat:@"%f", fRadium];
        
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"place",  @"type",
                                   centerLocation, @"center",
                                   distanceLocation,  @"distance",
                                   nil];
        [centerLocation release];
        [distanceLocation release];
        [m_Facebook requestWithGraphPath:@"search" andParams:params andDelegate:self];
    } 
}

/*
 * Graph API: Upload a photo. By default, when using me/photos the photo is uploaded
 * to the application album which is automatically created if it does not exist.
 */
- (void)apiGraphUserPhotosPost:(NSURL*)url 
{
    if(m_Facebook != nil && url)
    {    
        m_FB_currentAPICall = kAPIGraphUserPhotosPost;
    
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img  = [[UIImage alloc] initWithData:data];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   img, @"picture",
                                   nil];
        [img release];
    
        [m_Facebook requestWithGraphPath:@"me/photos"
                                    andParams:params
                                andHttpMethod:@"POST"
                                  andDelegate:self];
    }    
}

/*
 * Graph API: Post a video to the user's wall.
 */
- (void)apiGraphUserVideosPost:(NSURL*)url withDataFmt:(NSString*)dataType withType:(NSString*)videoFormat withTitle:(NSString*)title withDescription:(NSString*)description
{
    if(m_Facebook != nil && url)
    {    
        m_FB_currentAPICall = kAPIGraphUserVideosPost;
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   data, dataType, /*default type: video.mov */
                                   videoFormat, @"contentType",
                                   title, @"title",
                                   description, @"description",
								   nil];
        [m_Facebook requestWithGraphPath:@"me/videos"
                                    andParams:params
                                    andHttpMethod:@"POST"
                                  andDelegate:self];
    }    
}

/*
 * Graph API: App unauthorize
 */
- (void)apiGraphUserPermissionsDelete 
{
    if(m_Facebook != nil)
    {    
        m_FB_currentAPICall = kAPIGraphUserPermissionsDelete;
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil];
        [m_Facebook requestWithGraphPath:@"me/permissions"
                                        andParams:params
                                        andHttpMethod:@"DELETE"
                                    andDelegate:self];
    }    
}

/*
 * API: Legacy REST for getting the friends using the app. This is a helper method
 * being used to target app requests in follow-on examples.
 */
- (void)apiRESTGetAppUsers 
{
    if(m_Facebook != nil)
    {    
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"friends.getAppUsers", @"method",
                                   nil];
        [m_Facebook requestWithParams:params andDelegate:self];
    }    
}

/*
- (void)apiGraphPostMessageToAllFriend:(NSString*)msg
{
    if(m_Facebook != nil)
    {    
        BOOL bDefaultLanguage = [ApplicationConfigure DefaultLanguageForSNPost];
        m_FB_currentAPICall = kDialogFeedUser;
        SBJSON *jsonWriter = [[SBJSON new] autorelease];
        
        // The action links to be shown with the post in the feed
        NSArray* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [StringFactory GetString_GameTitle:bDefaultLanguage],@"name",[ApplicationConfigure GetFacebookPostLinkURL],@"link", nil], nil];
        NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
        
        // Dialog parameters
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [StringFactory GetString_GameTitle:bDefaultLanguage], @"name",
                                       [StringFactory GetString_PostTitle:bDefaultLanguage], @"caption",
                                       msg, @"description",
                                       [ApplicationConfigure GetFacebookPostLinkURL], @"link",
                                       [ApplicationConfigure GetFacebookIconLinkURL], @"picture",
                                       actionLinksStr, @"actions",
                                       nil];
        
        [m_Facebook requestWithGraphPath:@"friends/feed"
                               andParams:params
                           andHttpMethod:@"POST"
                             andDelegate:self];
    }
    
}
*/

/*
 * Graph API: Check in a user to the location selected in the previous view.
 */
/*- (void)apiGraphUserCheckins:(NSUInteger)index {
    HackbookAppDelegate *delegate = (HackbookAppDelegate *)[[UIApplication sharedApplication] delegate];
    SBJSON *jsonWriter = [[SBJSON new] autorelease];
    
    NSDictionary *coordinates = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [[[myData objectAtIndex:index] objectForKey:@"location"] objectForKey:@"latitude"],@"latitude",
                                 [[[myData objectAtIndex:index] objectForKey:@"location"] objectForKey:@"longitude"],@"longitude",
                                 nil];
    
    NSString *coordinatesStr = [jsonWriter stringWithObject:coordinates];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [[myData objectAtIndex:index] objectForKey:@"id"], @"place",
                                   coordinatesStr, @"coordinates",
                                   @"", @"message",
                                   nil];
    [[delegate facebook] requestWithGraphPath:@"me/checkins"
                                    andParams:params
                                andHttpMethod:@"POST"
                                  andDelegate:self];
}*/


///////////////////////////////////////////////
//
// Facebook Graph API call functions: end
//
///////////////////////////////////////////////

///////////////////////////////////////////////
//
// Facebook Feed API call functions: begin (from Facebook SDK sample)
//
///////////////////////////////////////////////
-(void)PostFacebookFeedToUser:(NSString*)msgFeed
{
    if(m_Facebook != nil)
    {    
        BOOL bDefaultLanguage = [ApplicationConfigure DefaultLanguageForSNPost];
        m_FB_currentAPICall = kDialogFeedUser;
        SBJSON *jsonWriter = [[SBJSON new] autorelease];
    
        // The action links to be shown with the post in the feed
        NSArray* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      [StringFactory GetString_GameTitle:bDefaultLanguage],@"name",[ApplicationConfigure GetFacebookPostLinkURL],@"link", nil], nil];
        NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
    
        // Dialog parameters
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [StringFactory GetString_GameTitle:bDefaultLanguage], @"name",
                                   [StringFactory GetString_PostTitle:bDefaultLanguage], @"caption",
                                   msgFeed, @"description",
                                   [ApplicationConfigure GetFacebookPostLinkURL], @"link",
                                   //[ApplicationConfigure GetFacebookIconLinkURL], @"picture",
                                   actionLinksStr, @"actions",
                                   nil];
    
        [m_Facebook dialog:@"feed" andParams:params andDelegate:self];
    }
}


/*
 * Dialog: Feed for friend
 */
- (void)PostFacebookFeedToFriend:(NSString *)friendID withFeed:(NSString*)msgFeed
{
    if(m_Facebook != nil)
    {    
        BOOL bDefaultLanguage = [ApplicationConfigure DefaultLanguageForSNPost];
        m_FB_currentAPICall = kDialogFeedFriend;
        SBJSON *jsonWriter = [[SBJSON new] autorelease];
    
        NSArray* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
                                            [StringFactory GetString_GameTitle:bDefaultLanguage],@"name",[ApplicationConfigure GetFacebookPostLinkURL],@"link", nil], nil];
    
        NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
        
        // The "to" parameter targets the post to a friend
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   friendID, @"to",
                                       [StringFactory GetString_GameTitle:bDefaultLanguage], @"name",
                                       [StringFactory GetString_PostTitle:bDefaultLanguage], @"caption",
                                       msgFeed, @"description",
                                       [ApplicationConfigure GetFacebookPostLinkURL], @"link",
                                       //[ApplicationConfigure GetFacebookIconLinkURL], @"picture",
                                       actionLinksStr, @"actions",
                                       nil];
    
        [m_Facebook dialog:@"feed" andParams:params andDelegate:self];
    }    
}

///////////////////////////////////////////////
//
// Facebook Feed API call functions: end
//
///////////////////////////////////////////////

///////////////////////////////////////////////
//
// Facebook Request API call functions: begin (from Facebook SDK sample)
//
///////////////////////////////////////////////
/*
 * Dialog: Requests - send to all.
 */
- (void)SendRequestsSendToMany:(NSString*)msg withAlert:(NSString*)notification 
{
    if(m_Facebook != nil)
    {    
        BOOL bDefaultLanguage = [ApplicationConfigure DefaultLanguageForSNPost];
        m_FB_currentAPICall = kDialogRequestsSendToMany;
        SBJSON *jsonWriter = [[SBJSON new] autorelease];

        // The action links to be shown with the post in the feed
        NSArray* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [StringFactory GetString_GameTitle:bDefaultLanguage],@"name",[ApplicationConfigure GetFacebookPostLinkURL],@"link", nil], nil];
        NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
        
        // Dialog parameters
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [StringFactory GetString_GameTitle:bDefaultLanguage], @"name",
                                       [StringFactory GetString_PostTitle:bDefaultLanguage], @"caption",
                                       msg, @"message",
                                       notification, @"notification_text",
                                       [ApplicationConfigure GetFacebookPostLinkURL], @"link",
                                       //[ApplicationConfigure GetFacebookIconLinkURL], @"picture",
                                       actionLinksStr, @"actions",
                                       nil];

        [m_Facebook dialog:@"apprequests" andParams:params andDelegate:self];
    }   
}

/*
 * Dialog: Requests - send to selected.
 */
- (void)apiDialogRequestsSendToNonUsers:(NSArray *)selectIDs withMessage:(NSString*)msg withAlert:(NSString*)notification
{
    if(m_Facebook != nil)
    {    
        BOOL bDefaultLanguage = [ApplicationConfigure DefaultLanguageForSNPost];
        m_FB_currentAPICall  = kDialogRequestsSendToSelect;
        
        NSString *selectIDsStr = [selectIDs componentsJoinedByString:@","];
    
        // The action links to be shown with the post in the feed
        SBJSON *jsonWriter = [[SBJSON new] autorelease];
        NSArray* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [StringFactory GetString_GameTitle:bDefaultLanguage],@"name",[ApplicationConfigure GetFacebookPostLinkURL],@"link", nil], nil];
        NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
        
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [StringFactory GetString_GameTitle:bDefaultLanguage], @"name",
                                       [StringFactory GetString_PostTitle:bDefaultLanguage], @"caption",
                                       msg, @"message",
                                       notification, @"notification_text",
                                       [ApplicationConfigure GetFacebookPostLinkURL], @"link",
                                       //[ApplicationConfigure GetFacebookIconLinkURL], @"picture",
                                       actionLinksStr, @"actions",
                                       selectIDsStr, @"suggestions",
                                       nil];
    
        [m_Facebook dialog:@"apprequests" andParams:params andDelegate:self];
    }   
}

- (void)apiDialogRequestsSendToFriend:(NSString *)friendID withMessage:(NSString*)msg withAlert:(NSString*)notification
{
    if(m_Facebook != nil)
    {    
        BOOL bDefaultLanguage = [ApplicationConfigure DefaultLanguageForSNPost];
        m_FB_currentAPICall  = kDialogRequestsSendToTarget;
        
        
        // The action links to be shown with the post in the feed
        SBJSON *jsonWriter = [[SBJSON new] autorelease];
        NSArray* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [StringFactory GetString_GameTitle:bDefaultLanguage],@"name",[ApplicationConfigure GetFacebookPostLinkURL],@"link", nil], nil];
        NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
        
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [StringFactory GetString_GameTitle:bDefaultLanguage], @"name",
                                       [StringFactory GetString_PostTitle:bDefaultLanguage], @"caption",
                                       msg, @"message",
                                       notification, @"notification_text",
                                       [ApplicationConfigure GetFacebookPostLinkURL], @"link",
                                       //[ApplicationConfigure GetFacebookIconLinkURL], @"picture",
                                       actionLinksStr, @"actions",
                                       friendID, @"to",
                                       nil];
        
        [m_Facebook dialog:@"apprequests" andParams:params andDelegate:self];
    }   
}

///////////////////////////////////////////////
//
// Facebook Request API call functions: end
//
///////////////////////////////////////////////

///////////////////////////////////////////////
//
// Facebook FBRequestDelegate Methods: begin
//
///////////////////////////////////////////////
/**
 * Called when the Facebook API request has returned a response. This callback
 * gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response 
{
    //NSLog(@"received response");
}

/**
 * Called when a request returns and its response has been parsed into
 * an object. The resulting object may be a dictionary, an array, a string,
 * or a number, depending on the format of the API response. If you need access
 * to the raw response, use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(FBRequest *)request didLoad:(id)result 
{
    if ([result isKindOfClass:[NSArray class]] && ([result count] > 0)) 
    {
        result = [result objectAtIndex:0];
    }
    switch (m_FB_currentAPICall) 
    {
        case kAPIGraphUserPermissionsDelete:
        {
            // the app from thinking there is a valid session
            m_Facebook.accessToken = nil;
            m_Facebook.expirationDate = nil;
            
            // Notify the root view about the logout.
            [self fbDidLogout];
            break;
        }
        case kAPIFriendsForDialogFeed:
        {
            /*NSArray *resultData = [result objectForKey: @"data"];
            // Check that the user has friends
            if ([resultData count] > 0) 
            {
                // Pick a random friend to post the feed to
                int randomNumber = arc4random() % [resultData count];
                [self apiDialogFeedFriend: 
                 [[resultData objectAtIndex: randomNumber] objectForKey: @"id"]];
            } else {
                [self showMessage:@"You do not have any friends to post to."];
            }*/
            break;
        }
        case kAPIGetAppUsersFriendsNotUsing:
        {
            // Save friend results
            /*[savedAPIResult release];
            savedAPIResult = nil;
            // Many results
            if ([result isKindOfClass:[NSArray class]]) {
                savedAPIResult = [[NSMutableArray alloc] initWithArray:result copyItems:YES];
            } else if ([result isKindOfClass:[NSDecimalNumber class]]) {
                savedAPIResult = [[NSMutableArray alloc] initWithObjects:[result stringValue], nil];
            }
            
            // Set up to get friends
            currentAPICall = kAPIFriendsForDialogRequests;
            [self apiGraphFriends];*/
            break;
        }
        case kAPIGetAppUsersFriendsUsing:
        {
 /*           NSMutableArray *friendsWithApp = [[NSMutableArray alloc] initWithCapacity:1];
            // Many results
            if ([result isKindOfClass:[NSArray class]]) {
                [friendsWithApp addObjectsFromArray:result];
            } else if ([result isKindOfClass:[NSDecimalNumber class]]) {
                [friendsWithApp addObject: [result stringValue]];
            }
            
            if ([friendsWithApp count] > 0) {
                [self apiDialogRequestsSendToUsers:friendsWithApp];
            } else {
                [self showMessage:@"None of your friends are using the app."];
            }
            
            [friendsWithApp release];*/
            break;
        }
        case kAPIFriendsForDialogRequests:
        {
/*            NSArray *resultData = [result objectForKey:@"data"];
            if ([resultData count] == 0) {
                [self showMessage:@"You have no friends to select."];
            } else {
                NSMutableArray *friendsWithoutApp = [[NSMutableArray alloc] initWithCapacity:1];
                // Loop through friends and find those who do not have the app
                for (NSDictionary *friendObject in resultData) {
                    BOOL foundFriend = NO;
                    for (NSString *friendWithApp in savedAPIResult) {
                        if ([[friendObject objectForKey:@"id"] isEqualToString:friendWithApp]) {
                            foundFriend = YES;
                            break;
                        }
                    }
                    if (!foundFriend) {
                        [friendsWithoutApp addObject:[friendObject objectForKey:@"id"]];
                    }
                }
                if ([friendsWithoutApp count] > 0) {
                    [self apiDialogRequestsSendToNonUsers:friendsWithoutApp];
                } else {
                    [self showMessage:@"All your friends are using the app."];
                }
                [friendsWithoutApp release];
            }*/
            break;
        }
        case kAPIFriendsForTargetDialogRequests:
        {
            /*NSArray *resultData = [result objectForKey: @"data"];
            // got friends?
            if ([resultData count] > 0) { 
                // pick a random one to send a request to
                int randomIndex = arc4random() % [resultData count];	
                NSString* randomFriend = 
                [[resultData objectAtIndex: randomIndex] objectForKey: @"id"];
                [self apiDialogRequestsSendTarget:randomFriend];
            } else {
                [self showMessage: @"You have no friends to select."];
            }*/
            break;
        }
        case kAPIGraphMe:
        {
/*            NSString *nameID = [[NSString alloc] initWithFormat: @"%@ (%@)", 
                                [result objectForKey:@"name"], 
                                [result objectForKey:@"id"]];
            NSMutableArray *userData = [[NSMutableArray alloc] initWithObjects:
                                        [NSDictionary dictionaryWithObjectsAndKeys:
                                         [result objectForKey:@"id"], @"id",
                                         nameID, @"name",
                                         [result objectForKey:@"picture"], @"details",
                                         nil], nil];
            // Show the basic user information in a new view controller
            APIResultsViewController *controller = [[APIResultsViewController alloc]
                                                    initWithTitle:@"Your Information"
                                                    data:userData
                                                    action:@""];
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
            [userData release];
            [nameID release];*/
            break;
        }
        case kAPIGraphUserFriends:
        {
            /*NSMutableArray *friends = [[NSMutableArray alloc] initWithCapacity:1];
            NSArray *resultData = [result objectForKey:@"data"];
            if ([resultData count] > 0) {
                for (NSUInteger i=0; i<[resultData count] && i < 25; i++) {
                    [friends addObject:[resultData objectAtIndex:i]];
                }
                // Show the friend information in a new view controller
                APIResultsViewController *controller = [[APIResultsViewController alloc]
                                                        initWithTitle:@"Friends"
                                                        data:friends action:@""];
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];
            } else {
                [self showMessage:@"You have no friends."];
            }
            [friends release];*/
            break;
        }
        case kAPIGraphUserCheckins:
        {
            /*NSMutableArray *places = [[NSMutableArray alloc] initWithCapacity:1];
            NSArray *resultData = [result objectForKey:@"data"];
            for (NSUInteger i=0; i<[resultData count] && i < 5; i++) {
                NSString *placeID = [[[resultData objectAtIndex:i] objectForKey:@"place"] objectForKey:@"id"];
                NSString *placeName = [[[resultData objectAtIndex:i] objectForKey:@"place"] objectForKey:@"name"];
                NSString *checkinMessage = [[resultData objectAtIndex:i] objectForKey:@"message"] ?
                [[resultData objectAtIndex:i] objectForKey:@"message"] : @"";
                [places addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                   placeID,@"id",
                                   placeName,@"name",
                                   checkinMessage,@"details",
                                   nil]];
            }
            // Show the user's recent check-ins a new view controller
            APIResultsViewController *controller = [[APIResultsViewController alloc]
                                                    initWithTitle:@"Recent Check-ins"
                                                    data:places
                                                    action:@"recentcheckins"];
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
            [places release];*/
            break;
        }
        case kAPIGraphSearchPlace:
        {
            /*NSMutableArray *places = [[NSMutableArray alloc] initWithCapacity:1];
            NSArray *resultData = [result objectForKey:@"data"];
            for (NSUInteger i=0; i<[resultData count] && i < 5; i++) {
                [places addObject:[resultData objectAtIndex:i]];
            }
            // Show the places nearby in a new view controller
            APIResultsViewController *controller = [[APIResultsViewController alloc]
                                                    initWithTitle:@"Nearby"
                                                    data:places
                                                    action:@"places"];
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
            [places release];*/
            break;
        }
        case kAPIGraphUserPhotosPost:
        {
            //[self showMessage:@"Photo uploaded successfully."];
            break;
        }
        case kAPIGraphUserVideosPost:
        {
            //[self showMessage:@"Video uploaded successfully."];
            break;
        }
        default:
            break;
    }
}

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error 
{
    //[self hideActivityIndicator];
    //NSLog(@"Error message: %@", [[error userInfo] objectForKey:@"error_msg"]);
    //[self showMessage:@"Oops, something went haywire."];
}

///////////////////////////////////////////////
//
// Facebook FBRequestDelegate Methods: end
//
///////////////////////////////////////////////


@end
