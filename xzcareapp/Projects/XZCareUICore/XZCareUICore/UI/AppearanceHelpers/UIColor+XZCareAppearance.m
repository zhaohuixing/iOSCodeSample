// 
//  UIColor+APCAppearance.m 
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
 
#import "UIColor+XZCareAppearance.h"
#import "XZCareAppearanceInfo.h"
#import "XZCareUIConstants.h"

@implementation UIColor (XZCareAppearance)

//Appearance Methods
+ (UIColor *)appPrimaryColor
{
    return [XZCareAppearanceInfo valueForAppearanceKey:kPrimaryAppColorKey];
}

+ (UIColor *)appSecondaryColor1
{
    return [XZCareAppearanceInfo valueForAppearanceKey:kSecondaryColor1Key];
}

+ (UIColor *)appSecondaryColor2
{
    return [XZCareAppearanceInfo valueForAppearanceKey:kSecondaryColor2Key];
}

+ (UIColor *)appSecondaryColor3
{
    return [XZCareAppearanceInfo valueForAppearanceKey:kSecondaryColor3Key];
}

+ (UIColor *)appSecondaryColor4
{
    return [XZCareAppearanceInfo valueForAppearanceKey:kSecondaryColor4Key];
}

+ (UIColor *) appTertiaryColor1
{
    return [XZCareAppearanceInfo valueForAppearanceKey:kTertiaryColor1Key];
}

+ (UIColor *) appTertiaryColor2
{
    return [XZCareAppearanceInfo valueForAppearanceKey:kTertiaryColor2Key];
}

+ (UIColor *)appTertiaryGreenColor
{
    return [XZCareAppearanceInfo valueForAppearanceKey:kTertiaryGreenColorKey];
}

+ (UIColor *)appTertiaryBlueColor
{
    return [XZCareAppearanceInfo valueForAppearanceKey:kTertiaryBlueColorKey];
}

+ (UIColor *)appTertiaryRedColor
{
    return [XZCareAppearanceInfo valueForAppearanceKey:kTertiaryRedColorKey];
}

+ (UIColor *)appTertiaryYellowColor
{
    return [XZCareAppearanceInfo valueForAppearanceKey:kTertiaryYellowColorKey];
}

+ (UIColor *)appTertiaryPurpleColor
{
    return [XZCareAppearanceInfo valueForAppearanceKey:kTertiaryPurpleColorKey];
}

+(UIColor *)appTertiaryGrayColor
{
    return [XZCareAppearanceInfo valueForAppearanceKey:kTertiaryGrayColorKey];
}

+ (UIColor *)tertiaryColorForString:(NSString *)colorName
{
    UIColor *color;
    
    if ([colorName isEqualToString:@"blue"])
    {
        color = [UIColor appTertiaryBlueColor];
    }
    else if ([colorName isEqualToString:@"red"])
    {
        color = [UIColor appTertiaryRedColor];
    }
    else if ([colorName isEqualToString:@"green"])
    {
        color = [UIColor appTertiaryGreenColor];
    }
    else if ([colorName isEqualToString:@"yellow"])
    {
        color = [UIColor appTertiaryYellowColor];
    }
    else if ([colorName isEqualToString:@"purple"])
    {
        color = [UIColor appTertiaryPurpleColor];
    }
    else if ([colorName isEqualToString:@"appColor"])
    {
        color = [UIColor appPrimaryColor];
    }
    else
    {
        color = [UIColor appTertiaryGrayColor];
    }
    
    return color;
}

+ (UIColor *)appBorderLineColor
{
    return [XZCareAppearanceInfo valueForAppearanceKey:kBorderLineColor];
}

+ (UIColor *)colorForTaskId:(NSString *)taskId
{
    return [XZCareAppearanceInfo valueForAppearanceKey:taskId];
}

@end
