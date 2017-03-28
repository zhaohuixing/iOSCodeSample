//
//  NOMAddressFinderUICore.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-06-26.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
//#import "NOMAddressMapView.h"
#import "NOMAddressFinderUICore.h"
#import "NOMAppInfo.h"
#import "NOMGUILayout.h"
#import "DrawHelper2.h"
#import "StringFactory.h"
#import "NOMGEOConfigration.h"

#import <AddressBook/ABPerson.h>

#include "NOMCountryInfo.h"


@interface NOMAddressFinderUICore ()
{
    UITextField*                m_StreetEdit;
    UILabel*                    m_StreetLabel;
    
    UITextField*                m_CityEdit;
    UILabel*                    m_CityLabel;
    
    UITextField*                m_StateEdit;
    UILabel*                    m_StateLabel;
    
    UITextField*                m_ZipCodeEdit;
    UILabel*                    m_ZipCodeLabel;
    
    
    //NOMAddressMapView*             m_MapView;
    
    UIPickerView*               m_CountryPicker;
    
    CLLocationCoordinate2D      m_SlectedCoordinate;
    
    NOMAddressFinderViewButtonPanel*        m_ButtonPanel;
}

@end

@implementation NOMAddressFinderUICore

+(float)GetViewLayoutHeight
{
    float textHeight = [NOMAddressFinderUICore GetDefaultTextHeight];
    float edge = [NOMAddressFinderUICore GetDefaultEdge];

    float fRet = (textHeight + edge)*4 + edge*3 + [NOMAddressFinderUICore GetPickerHeight];
    
    return fRet;
}

+(double)GetDefaultEdge
{
    if([NOMAppInfo IsDeviceIPad])
        return 20;
    else
        return 10;
}

+(double)GetDefaultBasicUISize
{
    if([NOMAppInfo IsDeviceIPad])
        return 80;
    else
        return 50;
}

+(double)GetDefaultTextHeight
{
    if([NOMAppInfo IsDeviceIPad])
        return 70;
    else
        return 40;
}

+(double)GetDefaultLabelHeight
{
    if([NOMAppInfo IsDeviceIPad])
        return 40;
    else
        return 20;
}

+(double)GetDefaultLabelWidth
{
    if([NOMAppInfo IsDeviceIPad])
        return 120;
    else
        return 80;
}

+(double)GetPickerHeight
{
    if([NOMAppInfo IsDeviceIPad])
        return 540;
    else
        return 180;
}

+(double)GetPickerWidth
{
    if([NOMAppInfo IsDeviceIPad])
        return 540;
    else
        return 300;
}

-(void)ShowSimpleAlert:(NSString*)msgAlert
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:msgAlert delegate:nil cancelButtonTitle:[StringFactory GetString_Close] otherButtonTitles:nil];
	[alertView show];
}

-(void)HideKeyboard
{
    [m_StreetEdit resignFirstResponder];
    [m_CityEdit resignFirstResponder];
    [m_StateEdit resignFirstResponder];
    [m_ZipCodeEdit resignFirstResponder];
}

-(void)InitializeSubViews
{
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    float textHeight = [NOMAddressFinderUICore GetDefaultTextHeight];
    float edge = [NOMAddressFinderUICore GetDefaultEdge];
    float textedge = edge/2.0;
    
    float labelWidth = [NOMAddressFinderUICore GetDefaultLabelWidth];
    float labelHeight = [NOMAddressFinderUICore GetDefaultLabelHeight];
    
    float textWidth = self.frame.size.width -2.0*edge - labelWidth;
    
    float sx = edge+labelWidth;
    float sy = edge;
    
    float lsx = edge;
    float lsy = sy + (textHeight-labelHeight)/2.0;
    
    rect = CGRectMake(lsx, lsy, labelWidth, labelHeight);
    m_StreetLabel = [[UILabel alloc] initWithFrame:rect];
    m_StreetLabel.backgroundColor = [UIColor clearColor];
    [m_StreetLabel setTextColor:[UIColor whiteColor]];
    m_StreetLabel.highlightedTextColor = [UIColor grayColor];
    [m_StreetLabel setTextAlignment:NSTextAlignmentRight];
    m_StreetLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    m_StreetLabel.adjustsFontSizeToFitWidth = YES;
    m_StreetLabel.font = [UIFont systemFontOfSize:labelHeight*0.8];
    NSString* strLabel = [NSString stringWithFormat:@"%@:", [StringFactory GetString_Street]];
    [m_StreetLabel setText:strLabel];
    [self addSubview:m_StreetLabel];
    
    
    rect = CGRectMake(sx, sy, textWidth, textHeight);
    m_StreetEdit = [[UITextField alloc] initWithFrame:rect];
    m_StreetEdit.borderStyle = UITextBorderStyleRoundedRect;
    m_StreetEdit.textColor = [UIColor blackColor];
    m_StreetEdit.font = [UIFont systemFontOfSize:textHeight*0.7];
    m_StreetEdit.placeholder = @"<enter text>";
    m_StreetEdit.backgroundColor = [UIColor whiteColor];
    m_StreetEdit.autocorrectionType = UITextAutocorrectionTypeNo;
    
    m_StreetEdit.keyboardType = UIKeyboardTypeDefault;
    m_StreetEdit.keyboardAppearance = UIKeyboardAppearanceAlert;
    m_StreetEdit.returnKeyType = UIReturnKeyDone | UIReturnKeyGo;
    m_StreetEdit.clearButtonMode = UITextFieldViewModeWhileEditing;	// Clear 'x' button to the right
    m_StreetEdit.delegate = self;
    [self addSubview:m_StreetEdit];
    
    sy += textHeight + textedge;
    lsy = sy + (textHeight-labelHeight)/2.0;
    
    rect = CGRectMake(lsx, lsy, labelWidth, labelHeight);
    m_CityLabel = [[UILabel alloc] initWithFrame:rect];
    m_CityLabel.backgroundColor = [UIColor clearColor];
    [m_CityLabel setTextColor:[UIColor whiteColor]];
    m_CityLabel.highlightedTextColor = [UIColor grayColor];
    [m_CityLabel setTextAlignment:NSTextAlignmentRight];
    m_CityLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    m_CityLabel.adjustsFontSizeToFitWidth = YES;
    m_CityLabel.font = [UIFont systemFontOfSize:labelHeight*0.8];
    strLabel = [NSString stringWithFormat:@"%@:", [StringFactory GetString_City]];
    [m_CityLabel setText:strLabel];
    [self addSubview:m_CityLabel];
    
    
    rect = CGRectMake(sx, sy, textWidth, textHeight);
    m_CityEdit = [[UITextField alloc] initWithFrame:rect];
    m_CityEdit.borderStyle = UITextBorderStyleRoundedRect;
    m_CityEdit.textColor = [UIColor blackColor];
    m_CityEdit.font = [UIFont systemFontOfSize:textHeight*0.7];
    m_CityEdit.placeholder = @"<enter text>";
    m_CityEdit.backgroundColor = [UIColor whiteColor];
    m_CityEdit.autocorrectionType = UITextAutocorrectionTypeNo;
    
    m_CityEdit.keyboardType = UIKeyboardTypeDefault;
    m_CityEdit.keyboardAppearance = UIKeyboardAppearanceAlert;
    m_CityEdit.returnKeyType = UIReturnKeyDone | UIReturnKeyGo;
    m_CityEdit.clearButtonMode = UITextFieldViewModeWhileEditing;	// Clear 'x' button to the right
    m_CityEdit.delegate = self;
    [self addSubview:m_CityEdit];
    
    sy += textHeight + textedge;
    lsy = sy + (textHeight-labelHeight)/2.0;
    
    rect = CGRectMake(lsx, lsy, labelWidth, labelHeight);
    m_StateLabel = [[UILabel alloc] initWithFrame:rect];
    m_StateLabel.backgroundColor = [UIColor clearColor];
    [m_StateLabel setTextColor:[UIColor whiteColor]];
    m_StateLabel.highlightedTextColor = [UIColor grayColor];
    [m_StateLabel setTextAlignment:NSTextAlignmentRight];
    m_StateLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    m_StateLabel.adjustsFontSizeToFitWidth = YES;
    m_StateLabel.font = [UIFont systemFontOfSize:labelHeight*0.8];
    strLabel = [NSString stringWithFormat:@"%@:", [StringFactory GetString_State]];
    [m_StateLabel setText:strLabel];
    [self addSubview:m_StateLabel];
    
    
    rect = CGRectMake(sx, sy, textWidth, textHeight);
    m_StateEdit = [[UITextField alloc] initWithFrame:rect];
    m_StateEdit.borderStyle = UITextBorderStyleRoundedRect;
    m_StateEdit.textColor = [UIColor blackColor];
    m_StateEdit.font = [UIFont systemFontOfSize:textHeight*0.7];
    m_StateEdit.placeholder = @"<enter text>";
    m_StateEdit.backgroundColor = [UIColor whiteColor];
    m_StateEdit.autocorrectionType = UITextAutocorrectionTypeNo;
    
    m_StateEdit.keyboardType = UIKeyboardTypeDefault;
    m_StateEdit.keyboardAppearance = UIKeyboardAppearanceAlert;
    m_StateEdit.returnKeyType = UIReturnKeyDone | UIReturnKeyGo;
    m_StateEdit.clearButtonMode = UITextFieldViewModeWhileEditing;	// Clear 'x' button to the right
    m_StateEdit.delegate = self;
    [self addSubview:m_StateEdit];
    
    sy += textHeight + textedge;
    lsy = sy + (textHeight-labelHeight)/2.0;
    
    rect = CGRectMake(lsx, lsy, labelWidth, labelHeight);
    m_ZipCodeLabel = [[UILabel alloc] initWithFrame:rect];
    m_ZipCodeLabel.backgroundColor = [UIColor clearColor];
    [m_ZipCodeLabel setTextColor:[UIColor whiteColor]];
    m_ZipCodeLabel.highlightedTextColor = [UIColor grayColor];
    [m_ZipCodeLabel setTextAlignment:NSTextAlignmentRight];
    m_ZipCodeLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    m_ZipCodeLabel.adjustsFontSizeToFitWidth = YES;
    m_ZipCodeLabel.font = [UIFont systemFontOfSize:labelHeight*0.8];
    strLabel = [NSString stringWithFormat:@"%@:", [StringFactory GetString_ZipCode]];
    [m_ZipCodeLabel setText:strLabel];
    [self addSubview:m_ZipCodeLabel];
    
    
    rect = CGRectMake(sx, sy, textWidth, textHeight);
    m_ZipCodeEdit = [[UITextField alloc] initWithFrame:rect];
    m_ZipCodeEdit.borderStyle = UITextBorderStyleRoundedRect;
    m_ZipCodeEdit.textColor = [UIColor blackColor];
    m_ZipCodeEdit.font = [UIFont systemFontOfSize:textHeight*0.7];
    m_ZipCodeEdit.placeholder = @"<enter text>";
    m_ZipCodeEdit.backgroundColor = [UIColor whiteColor];
    m_ZipCodeEdit.autocorrectionType = UITextAutocorrectionTypeNo;
    
    m_ZipCodeEdit.keyboardType = UIKeyboardTypeDefault;
    m_ZipCodeEdit.keyboardAppearance = UIKeyboardAppearanceAlert;
    m_ZipCodeEdit.returnKeyType = UIReturnKeyDone | UIReturnKeyGo;
    m_ZipCodeEdit.clearButtonMode = UITextFieldViewModeWhileEditing;	// Clear 'x' button to the right
    m_ZipCodeEdit.delegate = self;
    [self addSubview:m_ZipCodeEdit];
    
    if([NOMAppInfo IsCityBaseAppRegionOnly] == NO)
    {
        sy += textHeight + edge;
        float pw = [NOMAddressFinderUICore GetPickerWidth];
        float ph = [NOMAddressFinderUICore GetPickerHeight];
        sx = (self.frame.size.width - pw)*0.5;
        rect = CGRectMake(sx, sy, pw, ph);
        m_CountryPicker = [[UIPickerView alloc] initWithFrame:rect];
        m_CountryPicker.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        m_CountryPicker.contentMode = UIViewContentModeScaleToFill;
        [m_CountryPicker setAlpha:1.0];
        m_CountryPicker.delegate = self;
        m_CountryPicker.dataSource = self;
        m_CountryPicker.showsSelectionIndicator = YES;
        m_CountryPicker.clearsContextBeforeDrawing = YES;
        m_CountryPicker.multipleTouchEnabled = YES;
        float r = ph/m_CountryPicker.bounds.size.height;
    
        if(r < 1.0)
        {
            CGAffineTransform t0 = CGAffineTransformMakeTranslation(0, m_CountryPicker.bounds.size.height/2);
            CGAffineTransform s0 = CGAffineTransformMakeScale(1.0, r);
            CGAffineTransform t1 = CGAffineTransformMakeTranslation (0, -m_CountryPicker.bounds.size.height/2);
            m_CountryPicker.transform = CGAffineTransformConcat(t0, CGAffineTransformConcat(s0, t1));
        }
    
        m_CountryPicker.autoresizesSubviews = YES;
        [self addSubview:m_CountryPicker];
        [self bringSubviewToFront:m_CountryPicker];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        m_StreetEdit = nil;
        m_StreetLabel = nil;
        m_CityEdit = nil;
        m_CityLabel = nil;
        m_StateEdit = nil;
        m_StateLabel = nil;
        m_ZipCodeEdit = nil;
        m_ZipCodeLabel = nil;
        m_CountryPicker = nil;
        m_ButtonPanel = nil;
        
        
        self.backgroundColor = [UIColor clearColor];
        [self InitializeSubViews];
        m_ButtonPanel = nil;
    }
    return self;
}

//UITextFieldDelegate method
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [m_ButtonPanel SetOKButtonEnable:NO];
    if([NOMAppInfo IsDeviceIPad])
        return;
    
    if(self.frame.size.width < self.frame.size.height)
        return;
    
    float textHeight = [NOMAddressFinderUICore GetDefaultTextHeight];
    float edge = [NOMAddressFinderUICore GetDefaultEdge];
    float textedge = edge/2.0;
    float offsetY = 0.0;
    if(textField == m_StateEdit)
    {
        offsetY = textHeight*2 + textedge*4;
    }
    else if(textField == m_ZipCodeEdit)
    {
        offsetY = textHeight*3 + textedge*5;
    }
    
    if(0 < offsetY)
    {
        if([self.superview respondsToSelector:@selector(ScrollViewTo:)] == YES)
        {
            SEL sel = @selector(ScrollViewTo:);
            NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[self.superview methodSignatureForSelector:sel]];
            [inv setSelector:sel];
            [inv setTarget:self.superview];
            [inv setArgument:&offsetY atIndex:2]; //arguments 0 and 1 are self and _cmd respectively, automatically set by NSInvocation
            [inv invoke];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self HideKeyboard];
    if([self.superview respondsToSelector:@selector(RestoreScrollViewDefaultPosition)] == YES)
    {
        [self.superview performSelector:@selector(RestoreScrollViewDefaultPosition)];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self HideKeyboard];
}

-(void)CleanControlState
{
    m_StreetEdit.placeholder = @"<enter text>";
    [m_StreetEdit setText:@""];
    m_CityEdit.placeholder = @"<enter text>";
    [m_CityEdit setText:@""];
    m_StateEdit.placeholder = @"<enter text>";
    [m_StateEdit setText:@""];
    m_ZipCodeEdit.placeholder = @"<enter text>";
    [m_ZipCodeEdit setText:@""];
    [m_ButtonPanel SetOKButtonEnable:NO];
}


-(void)UpdateLayout
{
    [self HideKeyboard];

    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    float textHeight = [NOMAddressFinderUICore GetDefaultTextHeight];
    float edge = [NOMAddressFinderUICore GetDefaultEdge];
    float textedge = edge/2.0;
    
    float labelWidth = [NOMAddressFinderUICore GetDefaultLabelWidth];
    float labelHeight = [NOMAddressFinderUICore GetDefaultLabelHeight];
    
    float textWidth = self.frame.size.width -2.0*edge - labelWidth;
    
    float sx = edge+labelWidth;
    float sy = edge;
    
    float lsx = edge;
    float lsy = sy + (textHeight-labelHeight)/2.0;
    
    rect = CGRectMake(lsx, lsy, labelWidth, labelHeight);
    [m_StreetLabel setFrame:rect];
    
    rect = CGRectMake(sx, sy, textWidth, textHeight);
    [m_StreetEdit setFrame:rect];
    
    sy += textHeight + textedge;
    lsy = sy + (textHeight-labelHeight)/2.0;
    
    rect = CGRectMake(lsx, lsy, labelWidth, labelHeight);
    [m_CityLabel setFrame:rect];
    
    rect = CGRectMake(sx, sy, textWidth, textHeight);
    [m_CityEdit setFrame:rect];
    
    sy += textHeight + textedge;
    lsy = sy + (textHeight-labelHeight)/2.0;
    
    rect = CGRectMake(lsx, lsy, labelWidth, labelHeight);
    [m_StateLabel setFrame:rect];
    
    rect = CGRectMake(sx, sy, textWidth, textHeight);
    [m_StateEdit setFrame:rect];
    
    sy += textHeight + textedge;
    lsy = sy + (textHeight-labelHeight)/2.0;
    
    rect = CGRectMake(lsx, lsy, labelWidth, labelHeight);
    [m_ZipCodeLabel setFrame:rect];
    
    rect = CGRectMake(sx, sy, textWidth, textHeight);
    [m_ZipCodeEdit setFrame:rect];
    
    if(m_CountryPicker != nil)
    {
        sy += textHeight + edge;
        float pw = [NOMAddressFinderUICore GetPickerWidth];
        float ph = [NOMAddressFinderUICore GetPickerHeight];
        sx = (self.frame.size.width - pw)*0.5;
        rect = CGRectMake(sx, sy, pw, ph);
        [m_CountryPicker setFrame:rect];
        float r = ph/m_CountryPicker.bounds.size.height;
    
        if(r < 1.0)
        {
            CGAffineTransform t0 = CGAffineTransformMakeTranslation(0, m_CountryPicker.bounds.size.height/2);
            CGAffineTransform s0 = CGAffineTransformMakeScale(1.0, r);
            CGAffineTransform t1 = CGAffineTransformMakeTranslation (0, -m_CountryPicker.bounds.size.height/2);
            m_CountryPicker.transform = CGAffineTransformConcat(t0, CGAffineTransformConcat(s0, t1));
        }
    }
}

-(void)AddressValidationSuccessed
{
    if([self.superview respondsToSelector:@selector(AddressValidationSuccessed)] == YES)
    {
        [self.superview performSelector:@selector(AddressValidationSuccessed)];
    }
}

-(void)ValidateAddress
{
    //NSString* textAddress;
    int nRow = (int)[NOMAppInfo GetAppDefaultCountryIndex];
    if(m_CountryPicker != nil)
    {
        nRow = (int)[m_CountryPicker selectedRowInComponent: 0];
    }
    NSString* szCountry = [NOMGEOConfigration GetCountry:nRow];
    NSString* szCountryKey = [NOMGEOConfigration GetCountryKey:nRow];
    NSString* szStreet = m_StreetEdit.text;
    NSString* szCity = m_CityEdit.text;
    NSString* szState = m_StateEdit.text;
    NSString* szZipCode = m_ZipCodeEdit.text;
    if(szStreet == nil || [szStreet length] <= 0)
    {
        [m_ButtonPanel SetOKButtonEnable:NO];
        [self ShowSimpleAlert:[StringFactory GetString_InvalidStreet]];
        return;
    }
    if(szCity == nil || [szCity length] <= 0)
    {
        [m_ButtonPanel SetOKButtonEnable:NO];
        [self ShowSimpleAlert:[StringFactory GetString_InvalidCity]];
        return;
    }
    if(szZipCode == nil || [szZipCode length] <= 0)
    {
        [m_ButtonPanel SetOKButtonEnable:NO];
        [self ShowSimpleAlert:[StringFactory GetString_InvalidZipCode]];
        return;
    }
    
    
    NSDictionary *locationDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        szCity, kABPersonAddressCityKey,
                                        szState, kABPersonAddressStateKey,
                                        szCountry, kABPersonAddressCountryKey,
                                        szCountryKey, kABPersonAddressCountryCodeKey,
                                        szStreet, kABPersonAddressStreetKey,
                                        szZipCode, kABPersonAddressZIPKey,
                                        nil];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressDictionary:locationDictionary completionHandler:^(NSArray *placemarks, NSError *error)
    {
        if(0 < [placemarks count] && error == nil)
        {
            [m_ButtonPanel SetOKButtonEnable:YES];
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            CLLocation *location = placemark.location;
            
            //???????????????
            if([NOMAppInfo IsCityBaseAppRegionOnly] == YES)
            {
                double longStart = [NOMAppInfo GetAppLongitudeStart];
                double longEnd = [NOMAppInfo GetAppLongitudeEnd];
                double latStart = [NOMAppInfo GetAppLatitudeStart];
                double latEnd = [NOMAppInfo GetAppLatitudeEnd];
                
                if(longStart <= location.coordinate.longitude && location.coordinate.longitude <= longEnd &&
                   latStart <= location.coordinate.latitude && location.coordinate.latitude <= latEnd)
                {
                    m_SlectedCoordinate.longitude = location.coordinate.longitude;
                    m_SlectedCoordinate.latitude = location.coordinate.latitude;
                    
                    [self AddressValidationSuccessed];
                }
                else
                {
                    [self ShowSimpleAlert:[StringFactory GetString_PostLocationOutAppRegion]];
                    return;
                }
            }
            else
            {
                m_SlectedCoordinate.longitude = location.coordinate.longitude;
                m_SlectedCoordinate.latitude = location.coordinate.latitude;
            
                [self AddressValidationSuccessed];
            }
        }
        else
        {
            [m_ButtonPanel SetOKButtonEnable:NO];
            if(error != nil)
            {
                NSLog(@"error:%@", [error description]);
                [self ShowSimpleAlert:[error localizedDescription]];
            }
        }
    }];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if([NOMAppInfo IsCityBaseAppRegionOnly] == YES)
    {
        return 1;
    }
    else
    {
        return NOM_COUNTRY_NUMBER ;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSString* str = @"";

    if([NOMAppInfo IsCityBaseAppRegionOnly] == YES)
    {
        int nIndex = [NOMAppInfo GetAppRegionCountryIndex];

        str = [NOMGEOConfigration GetCountry:nIndex];
    }
    else
    {
        int nIndex = (int)row;
    
        str = [NOMGEOConfigration GetCountry:nIndex];
    }
	return str;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self HideKeyboard];
    [m_ButtonPanel SetOKButtonEnable:NO];
}

-(CLLocationCoordinate2D)GetSelectedCoordinate
{
    return m_SlectedCoordinate;
}

-(CLLocationDegrees)GetSelectedCoordinateLantiude
{
    return m_SlectedCoordinate.latitude;
}

-(CLLocationDegrees)GetSelectedCoordinateLongitude
{
    return m_SlectedCoordinate.longitude;
}

-(void)SetButtonPanel:(NOMAddressFinderViewButtonPanel*)panel
{
    m_ButtonPanel = panel;
}

-(NSString*)GetStreetAddress
{
    return m_StreetEdit.text;
}

-(NSString*)GetCity
{
    return m_CityEdit.text;
}

-(NSString*)GetState
{
    return m_StateEdit.text;
}

-(NSString*)GetZipCode
{
    return m_ZipCodeEdit.text;
}

-(NSString*)GetCountry
{
    int nRow = (int)[NOMAppInfo GetAppDefaultCountryIndex];
    if(m_CountryPicker != nil)
    {
        nRow = (int)[m_CountryPicker selectedRowInComponent: 0];
    }
    NSString* szCountry = [NOMGEOConfigration GetCountry:nRow];
    return szCountry;
}

-(NSString*)GetCountryKey
{
    int nRow = (int)[NOMAppInfo GetAppDefaultCountryIndex];
    if(m_CountryPicker != nil)
    {
        nRow = (int)[m_CountryPicker selectedRowInComponent: 0];
    }
    NSString* szCountry = [NOMGEOConfigration GetCountryKey:nRow];
    return szCountry;
}

@end
