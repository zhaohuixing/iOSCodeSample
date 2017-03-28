// 
//  APCLog.m 
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
 
#import "XZBaseLog.h"
#import "XZBaseUtilities.h"
#import "NSError+XZBaseCore.h"


static NSDateFormatter *dateFormatter = nil;
static NSString * const kErrorIndentationString = @"    ";


/**
 Apple says they use these formatting codes:
 http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
 */
static NSString *LOG_DATE_FORMAT = @"yyyy-MM-dd HH:mm:ss.SSS ZZZZ";


// ---------------------------------------------------------
#pragma mark - "Tags" - introductory strings in print statements
// ---------------------------------------------------------

/*
 "Tags" that appear at the left edge of the debugging
 statements we print with this logging facility.
 */

static NSString * const XZCareLogTagError   = @"XZCare_ERROR  ";
static NSString * const XZCareLogTagDebug   = @"XZCare_DEBUG  ";
static NSString * const XZCareLogTagEvent   = @"XZCare_EVENT  ";
static NSString * const XZCareLogTagData    = @"XZCare_DATA   ";
static NSString * const XZCareLogTagView    = @"XZCare_VIEW   ";
static NSString * const XZCareLogTagArchive = @"XZCare_ARCHIVE";
static NSString * const XZCareLogTagUpload  = @"XZCare_UPLOAD ";



@implementation XZBaseLog



// ---------------------------------------------------------
#pragma mark - Setup
// ---------------------------------------------------------

+ (void) initialize
{
	if (dateFormatter == nil)
	{
		dateFormatter = [NSDateFormatter new];
		dateFormatter.dateFormat = LOG_DATE_FORMAT;
	}
}

// ---------------------------------------------------------
#pragma mark - New Logging Methods.  No, really.
// ---------------------------------------------------------

+ (void) methodInfo: (NSString *) apcLogMethodInfo
	   errorMessage: (NSString *) formatString, ...
{
	if (formatString == nil)
	{
		formatString = @"(no message)";
	}

	NSString *formattedMessage = NSStringFromVariadicArgumentsAndFormat(formatString);

	[self logInternal_tag: XZCareLogTagError
				   method: apcLogMethodInfo
				  message: formattedMessage];
}

+ (void) methodInfo: (NSString *) apcLogMethodData
			  error: (NSError *) error
{
	if (error != nil)
	{
        NSString *description = error.friendlyFormattedString;

		[self logInternal_tag: XZCareLogTagError
					   method: apcLogMethodData
					  message: description];
	}
}

+ (void) methodInfo: (NSString *) apcLogMethodData
		  exception: (NSException *) exception
{
	if (exception != nil)
	{
		NSString *printout = [NSString stringWithFormat: @"EXCEPTION: [%@]. Stack trace:\n%@", exception, exception.callStackSymbols];

		[self logInternal_tag: XZCareLogTagError
					   method: apcLogMethodData
					  message: printout];
	}
}

+ (void) methodInfo: (NSString *) apcLogMethodData
			  debug: (NSString *) formatString, ...
{
	if (formatString == nil)
	{
		formatString = @"(no message)";
	}

	NSString *formattedMessage = NSStringFromVariadicArgumentsAndFormat(formatString);

	[self logInternal_tag: XZCareLogTagDebug
				   method: apcLogMethodData
				  message: formattedMessage];
}

+ (void)       methodInfo: (NSString *) apcLogMethodInfo
    filenameBeingArchived: (NSString *) filenameOrPath
{
    NSString *message = [NSString stringWithFormat: @"Adding file to .zip archive for uploading: [%@]", filenameOrPath];

    [self logInternal_tag: XZCareLogTagArchive
                   method: apcLogMethodInfo
                  message: message];
}

+ (void)       methodInfo: (NSString *) apcLogMethodInfo
    filenameBeingUploaded: (NSString *) filenameOrPath
{
    NSString *message = [NSString stringWithFormat: @"Uploading file to Sage: [%@]", filenameOrPath];

    [self logInternal_tag: XZCareLogTagUpload
                   method: apcLogMethodInfo
                  message: message];
}

+ (void) methodInfo: (NSString *) apcLogMethodData
			  event: (NSString *) formatString, ...
{
	if (formatString == nil)
	{
		formatString = @"(no message)";
	}

	NSString *formattedMessage = NSStringFromVariadicArgumentsAndFormat(formatString);

	[self logInternal_tag: XZCareLogTagEvent
				   method: apcLogMethodData
				  message: formattedMessage];
}

+ (void) methodInfo: (NSString *) apcLogMethodData
		  eventName: (NSString *) eventName
			   data: (NSDictionary *) eventDictionary
{
	NSString *message = [NSString stringWithFormat: @"%@: %@", eventName, eventDictionary];

	[self logInternal_tag: XZCareLogTagData
				   method: apcLogMethodData
				  message: message];
}

+ (void)        methodInfo: (NSString *) apcLogMethodData
	viewControllerAppeared: (NSObject *) viewController
{
	NSString *message = [NSString stringWithFormat: @"%@ appeared.", NSStringFromClass (viewController.class)];

	[self logInternal_tag: XZCareLogTagView
				   method: apcLogMethodData
				  message: message];
}



// ---------------------------------------------------------
#pragma mark - The centralized, internal logging method
// ---------------------------------------------------------

+ (void) logInternal_tag: (NSString *) tag
				  method: (NSString *) methodInfo
				 message: (NSString *) message
{
	/*
	 Objective-C disables all NSLog() statements in
	 a "release" build, so this is safe to leave as-is.
	 */
	NSLog (@"%@ %@ => %@", tag, methodInfo, message);
}

@end









