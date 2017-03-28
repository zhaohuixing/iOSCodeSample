// 
//  APCScheduleExpressionToken.m 
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
 
#import "XZBaseScheduleExpressionToken.h"


@implementation XZBaseScheduleExpressionToken

- (id) init
{
	self = [super init];

	if (self)
	{
		_integerValue = kXZCareScheduleExpressionTokenIntegerValueNotSet;
		_stringValue = nil;
		_countOfScannedCharacters = 0;
		_type = XZCareScheduleExpressionTokenTypeNotYetParsed;
		_didEncounterError = NO;
		_errorMessage = nil;
	}

	return self;
}

// Stuff that worked.
- (BOOL) isWord
{
    return self.type == XZCareScheduleExpressionTokenTypeWord;
}

- (BOOL) isNumber
{
    return self.type == XZCareScheduleExpressionTokenTypeNumber;
}

- (BOOL) isWildcard
{
    return self.type == XZCareScheduleExpressionTokenTypeWildcard;
}

- (BOOL) isListSeparator
{
    return self.type == XZCareScheduleExpressionTokenTypeListSeparator;
}

- (BOOL) isStepSeparator
{
    return self.type == XZCareScheduleExpressionTokenTypeStepSeparator;
}

- (BOOL) isFieldSeparator
{
    return self.type == XZCareScheduleExpressionTokenTypeFieldSeparator;
}

- (BOOL) isRangeSeparator
{
    return self.type == XZCareScheduleExpressionTokenTypeRangeSeparator;
}

- (BOOL) isPositionSeparator
{
    return self.type == XZCareScheduleExpressionTokenTypePositionSeparator;
}

// Stuff that failed.
- (BOOL) isNotYetParsed
{
    return self.type == XZCareScheduleExpressionTokenTypeNotYetParsed;
}

- (BOOL) isUnrecognized
{
    return self.type == XZCareScheduleExpressionTokenTypeUnrecognized;
}

- (BOOL) isScanningError
{
    return self.type == XZCareScheduleExpressionTokenTypeScanningError;
}

- (NSString *) description
{
	return [NSString stringWithFormat: @"Token { string: [%@], integer: %d, isNumber: %@, isError: %@ }",
			self.stringValue,
			(int) self.integerValue,
			self.isNumber ? @"YES" : @"NO",
			self.didEncounterError ? @"YES" : @"NO"
			];
}

- (NSString *)debugDescription
{
	return self.description;
}

@end
