//
//  NOMSpotParkingGroundContentView.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-05-25.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMSpotParkingGroundContentView.h"
#import "CDropdownListBox.h"
#import "NOMAppInfo.h"
#import "NOMGUILayout.h"
#import "NOMSystemConstants.h"
#import "StringFactory.h"

#define PARKINGUI_COMBOBOX_ID_PRICEUNITTYPE     1

@interface NOMSpotParkingGroundContentView ()
{
    UILabel*                                    m_NameLabel;
    UITextField*                                m_NameEditor;
    
    UILabel*                                    m_PriceLabel;
    UITextField*                                m_PriceEditor;
    
    UILabel*                                    m_PriceUnitLabel;
    CDropdownListBox*                           m_PriceUnitType;
    
    UILabel*                                    m_AddressLabel;
    UITextField*                                m_AddressEditor;
    
    double                                      m_dPrice;
    int16_t                                     m_nPriceUnit;
    NSString*                                   m_Address;
    NSString*                                   m_Name;
}

-(void)OnSelectedListItemChange:(CDropdownListBox*)edit;
-(void)CloseDropdownList;
-(void)HideKeyboard;

@end

@implementation NOMSpotParkingGroundContentView

#define DEFAULT_PARKINGUI_WIDTH_IPHONE         300
#define DEFAULT_PARKINGUI_WIDTH_IPAD           500

+(float)GetDefaultEdge
{
    if([NOMAppInfo IsDeviceIPad])
        return 20;
    else
        return 10;
}

+(float)GetElemntWidth
{
    if([NOMAppInfo IsDeviceIPad] == YES)
        return DEFAULT_PARKINGUI_WIDTH_IPAD;
    else
        return DEFAULT_PARKINGUI_WIDTH_IPHONE;
}

+(float)GetElemntHeight
{
    return [NOMGUILayout GetDefaultTextEditorButtonHeight];
}

-(float)GetContentViewHeight
{
    float bRet = 0.0;
    
    float edge = [NOMSpotParkingGroundContentView GetDefaultEdge];
    float h = [NOMSpotParkingGroundContentView GetElemntHeight];
    
    bRet = h*9 + edge*10;
    
    return bRet;
}

#define DEFAULT_PARKINGGROUNDUI_ITEMLABEL_WIDTH_IPHONE         80
#define DEFAULT_PARKINGGROUNDUI_ITEMLABEL_WIDTH_IPAD           120
+(float)GetDefaultItemLabelWidth
{
    if([NOMAppInfo IsDeviceIPad])
    {
        return DEFAULT_PARKINGGROUNDUI_ITEMLABEL_WIDTH_IPAD;
    }
    else
    {
        return DEFAULT_PARKINGGROUNDUI_ITEMLABEL_WIDTH_IPHONE;
    }
}

-(void)Internal_CloseDropdownList
{
    if(m_PriceUnitType != nil)
    {
        [m_PriceUnitType CloseDropdownList];
    }
}

-(CDropdownListBox*)GetPriceUnitTypeControl
{
    return m_PriceUnitType;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self Internal_CloseDropdownList];
    
    if([NOMAppInfo IsDeviceIPad])
    {
        return;
    }
    
    if(self.frame.size.height < self.frame.size.width)
    {
        if(m_AddressEditor == textField)
        {
            if([self.superview respondsToSelector:@selector(ScrollViewTo:)] == YES)
            {
                SEL sel = @selector(ScrollViewTo:);
                float y = m_AddressEditor.frame.origin.y;
                NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[self.superview methodSignatureForSelector:sel]];
                [inv setSelector:sel];
                [inv setTarget:self.superview];
                [inv setArgument:&y atIndex:2]; //arguments 0 and 1 are self and _cmd respectively, automatically set by NSInvocation
                [inv invoke];
            }
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self HideKeyboard];
    if([NOMAppInfo IsDeviceIPad])
    {
        return;
    }
    if(self.frame.size.height < self.frame.size.width)
    {
        if(m_AddressEditor == textField)
        {
            if([self.superview respondsToSelector:@selector(RestoreScrollViewDefaultPosition)] == YES)
            {
                [self.superview performSelector:@selector(RestoreScrollViewDefaultPosition)];
            }
        }
    }
}

-(void)UpdatePriceUnitType
{
    if(m_nPriceUnit <= NOM_PARKING_RATEUNIT_HOUR)
    {
        m_nPriceUnit = NOM_PARKING_RATEUNIT_HOUR;
    }
    [m_PriceUnitType SetLabel:[StringFactory GetString_ParkingRate:m_nPriceUnit]];
    [m_PriceUnitType SetSelectedItem:m_nPriceUnit];
}


-(void)OnSelectedListItemChange:(CDropdownListBox*)edit
{
    if(m_PriceUnitType == edit)
    {
        m_nPriceUnit = [m_PriceUnitType GetSelectedItem];
        [self UpdatePriceUnitType];
    }
}

-(void)InitializePriceUnitTypeDropdownList
{
    CDropdownListBox* pTypeText = [self GetPriceUnitTypeControl];
    if(pTypeText == nil)
        return;
    
    [pTypeText RegisterCtrlID:PARKINGUI_COMBOBOX_ID_PRICEUNITTYPE];
    float h = [NOMGUILayout GetDefaultTextEditorButtonHeight];
    CGRect rect = CGRectMake(0, 0, pTypeText.frame.size.width, h);
    CDropdownListContainer* pListBox = [[CDropdownListContainer alloc] initWithFrame:rect];
    [self addSubview:pListBox];
    [pTypeText RegisterDropdownList:pListBox];
    
    for(int16_t nItemID = NOM_PARKING_RATEUNIT_HOUR; nItemID <= NOM_PARKING_RATEUNIT_ONEDAY; ++nItemID)
    {
        CDropdownListItem* pItem = [[CDropdownListItem alloc] initWithFrame:rect];
        [pItem SetItemID:nItemID];
        [pItem SetText:[StringFactory GetString_ParkingRate:nItemID]];
        [pItem RegisterDelegate:pTypeText];
        [pListBox AddItem:pItem];
    }
    
    float sx = self.frame.origin.x + pTypeText.frame.origin.x;
    float sy = self.frame.origin.y + pTypeText.frame.origin.y;
    [pTypeText SetOriginInContainer:sx withY:sy];
    [pTypeText SetLabel:[StringFactory GetString_ParkingRate:NOM_PARKING_RATEUNIT_HOUR]];
    [pTypeText SetSelectedItem:NOM_PARKING_RATEUNIT_HOUR];
    [pTypeText UpdateLayout];
}

-(void)InitializeUIElements
{
    float w = [NOMSpotParkingGroundContentView GetElemntWidth];
    float xedge = (self.frame.size.width - w)*0.5;
    float yedge = [NOMSpotParkingGroundContentView GetDefaultEdge];
    
    
    float sx = xedge;
    float sy = yedge;
    float textHeight = [NOMGUILayout GetDefaultTextEditorButtonHeight];
    
    CGRect rect;// = CGRectMake(sx, sy, w, textHeight);
   
    w = [NOMSpotParkingGroundContentView GetDefaultItemLabelWidth];
    rect = CGRectMake(sx, sy, w, textHeight);
   
    m_NameLabel = [[UILabel alloc] initWithFrame:rect];
    m_NameLabel.backgroundColor = [UIColor clearColor];
    [m_NameLabel setTextColor:[UIColor blackColor]];
    m_NameLabel.highlightedTextColor = [UIColor grayColor];
    [m_NameLabel setTextAlignment:NSTextAlignmentRight];
    m_NameLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    m_NameLabel.adjustsFontSizeToFitWidth = YES;
    m_NameLabel.font = [UIFont systemFontOfSize:textHeight*0.4];
    [m_NameLabel setText:[StringFactory GetString_Name]];
    [self addSubview:m_NameLabel];
    
    sx += w + yedge;
    w = self.frame.size.width - sx - xedge;
    rect = CGRectMake(sx, sy, w, textHeight);
    m_NameEditor = [[UITextField alloc] initWithFrame:rect];
    m_NameEditor.borderStyle = UITextBorderStyleRoundedRect;
    m_NameEditor.textColor = [UIColor blackColor];
    m_NameEditor.font = [UIFont systemFontOfSize:textHeight*0.6];
    m_NameEditor.placeholder = @"<Name>";
    m_NameEditor.backgroundColor = [UIColor whiteColor];
    m_NameEditor.autocorrectionType = UITextAutocorrectionTypeNo;
    
    m_NameEditor.keyboardType = UIKeyboardTypeEmailAddress;
    m_NameEditor.keyboardAppearance = UIKeyboardAppearanceAlert;
    m_NameEditor.returnKeyType = UIReturnKeyDone | UIReturnKeyGo;
    m_NameEditor.clearButtonMode = UITextFieldViewModeWhileEditing;	// Clear 'x' button to the right
    m_NameEditor.delegate = self;
    [self addSubview:m_NameEditor];
    
    sx = xedge;
    sy += textHeight + yedge;
    w = [NOMSpotParkingGroundContentView GetDefaultItemLabelWidth];
    rect = CGRectMake(sx, sy, w, textHeight);
    m_PriceLabel = [[UILabel alloc] initWithFrame:rect];
    m_PriceLabel.backgroundColor = [UIColor clearColor];
    [m_PriceLabel setTextColor:[UIColor blackColor]];
    m_PriceLabel.highlightedTextColor = [UIColor grayColor];
    [m_PriceLabel setTextAlignment:NSTextAlignmentRight];
    m_PriceLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    m_PriceLabel.adjustsFontSizeToFitWidth = YES;
    m_PriceLabel.font = [UIFont systemFontOfSize:textHeight*0.4];
    NSString* szPriceLabel = [NSString stringWithFormat:@"%@ (%@)", [StringFactory GetString_Price], [StringFactory GetString_DollarSign]];
    [m_PriceLabel setText:szPriceLabel];
    [self addSubview:m_PriceLabel];
    
    sx += w + yedge;
    w = self.frame.size.width - sx - xedge;
    rect = CGRectMake(sx, sy, w, textHeight);
    m_PriceEditor = [[UITextField alloc] initWithFrame:rect];
    m_PriceEditor.borderStyle = UITextBorderStyleRoundedRect;
    m_PriceEditor.textColor = [UIColor blackColor];
    m_PriceEditor.font = [UIFont systemFontOfSize:textHeight*0.6];
    m_PriceEditor.placeholder = @"<Price>";
    m_PriceEditor.backgroundColor = [UIColor whiteColor];
    m_PriceEditor.autocorrectionType = UITextAutocorrectionTypeNo;
    
    m_PriceEditor.keyboardType = UIKeyboardTypeDecimalPad;
    m_PriceEditor.keyboardAppearance = UIKeyboardAppearanceDefault;
    m_PriceEditor.returnKeyType = UIReturnKeyDone | UIReturnKeyGo;
    m_PriceEditor.clearButtonMode = UITextFieldViewModeWhileEditing;	// Clear 'x' button to the right
    m_PriceEditor.delegate = self;
    [self addSubview:m_PriceEditor];
    
    
    sx = xedge;
    sy += textHeight + yedge;
    w = [NOMSpotParkingGroundContentView GetDefaultItemLabelWidth];
    rect = CGRectMake(sx, sy, w, textHeight);
    m_PriceUnitLabel = [[UILabel alloc] initWithFrame:rect];
    m_PriceUnitLabel.backgroundColor = [UIColor clearColor];
    [m_PriceUnitLabel setTextColor:[UIColor blackColor]];
    m_PriceUnitLabel.highlightedTextColor = [UIColor grayColor];
    [m_PriceUnitLabel setTextAlignment:NSTextAlignmentRight];
    m_PriceUnitLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    m_PriceUnitLabel.adjustsFontSizeToFitWidth = YES;
    m_PriceUnitLabel.font = [UIFont systemFontOfSize:textHeight*0.4];
    [m_PriceUnitLabel setText:[StringFactory GetString_Unit]];
    [self addSubview:m_PriceUnitLabel];
    
    sx += w + yedge;
    w = self.frame.size.width - sx - xedge;
    rect = CGRectMake(sx, sy, w, textHeight);
    m_PriceUnitType = [[CDropdownListBox alloc] initWithFrame:rect];
    [self addSubview:m_PriceUnitType];
    
    
    sx = xedge;
    sy += textHeight + yedge;
    w = [NOMSpotParkingGroundContentView GetDefaultItemLabelWidth];
    rect = CGRectMake(sx, sy, w, textHeight);
    m_AddressLabel = [[UILabel alloc] initWithFrame:rect];
    m_AddressLabel.backgroundColor = [UIColor clearColor];
    [m_AddressLabel setTextColor:[UIColor blackColor]];
    m_AddressLabel.highlightedTextColor = [UIColor grayColor];
    [m_AddressLabel setTextAlignment:NSTextAlignmentRight];
    m_AddressLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    m_AddressLabel.adjustsFontSizeToFitWidth = YES;
    m_AddressLabel.font = [UIFont systemFontOfSize:textHeight*0.4];
    [m_AddressLabel setText:[StringFactory GetString_Address]];
    [self addSubview:m_AddressLabel];
    
    sx += w + yedge;
    w = self.frame.size.width - sx - xedge;
    rect = CGRectMake(sx, sy, w, textHeight);
    m_AddressEditor = [[UITextField alloc] initWithFrame:rect];
    m_AddressEditor.borderStyle = UITextBorderStyleRoundedRect;
    m_AddressEditor.textColor = [UIColor blackColor];
    m_AddressEditor.font = [UIFont systemFontOfSize:textHeight*0.6];
    m_AddressEditor.placeholder = @"<Address>";
    m_AddressEditor.backgroundColor = [UIColor whiteColor];
    m_AddressEditor.autocorrectionType = UITextAutocorrectionTypeNo;
    
    m_AddressEditor.keyboardType = UIKeyboardTypeEmailAddress;
    m_AddressEditor.keyboardAppearance = UIKeyboardAppearanceAlert;
    m_AddressEditor.returnKeyType = UIReturnKeyDone | UIReturnKeyGo;
    m_AddressEditor.clearButtonMode = UITextFieldViewModeWhileEditing;	// Clear 'x' button to the right
    m_AddressEditor.delegate = self;
    [self addSubview:m_AddressEditor];
}


-(void)InitializeControls
{
    [self InitializeUIElements];
    [self InitializePriceUnitTypeDropdownList];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self InitializeControls];
        
        m_Address = nil;
        m_Name = nil;
        m_nPriceUnit = 0;
        m_dPrice = 0.0;
        
    }
    return self;
}

-(void)CloseDropdownList
{
    [self HideKeyboard];
    [self Internal_CloseDropdownList];
}

-(void)HideKeyboard
{
    if(m_NameEditor != nil)
        [m_NameEditor resignFirstResponder];
    if(m_AddressEditor != nil)
        [m_AddressEditor resignFirstResponder];
    if(m_PriceEditor != nil)
        [m_PriceEditor resignFirstResponder];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self CloseDropdownList];
    [super touchesEnded:touches withEvent:event];
}

-(void)UpdateLayout
{
    [self CloseDropdownList];
    
    float w = [NOMSpotParkingGroundContentView GetElemntWidth];
    float xedge = (self.frame.size.width - w)*0.5;
    float yedge = [NOMSpotParkingGroundContentView GetDefaultEdge];
    
    
    float sx = xedge;
    float sy = yedge;
    float textHeight = [NOMGUILayout GetDefaultTextEditorButtonHeight];
    
    CGRect rect;// = CGRectMake(sx, sy, w, textHeight);
    
    w = [NOMSpotParkingGroundContentView GetDefaultItemLabelWidth];
    rect = CGRectMake(sx, sy, w, textHeight);
    
    [m_NameLabel setFrame:rect];
    
    sx += w + yedge;
    w = self.frame.size.width - sx - xedge;
    rect = CGRectMake(sx, sy, w, textHeight);
    [m_NameEditor setFrame:rect];
    
    sx = xedge;
    sy += textHeight + yedge;
    w = [NOMSpotParkingGroundContentView GetDefaultItemLabelWidth];
    rect = CGRectMake(sx, sy, w, textHeight);
    [m_PriceLabel setFrame:rect];
    
    sx += w + yedge;
    w = self.frame.size.width - sx - xedge;
    rect = CGRectMake(sx, sy, w, textHeight);
    [m_PriceEditor setFrame:rect];
    
    sx = xedge;
    sy += textHeight + yedge;
    w = [NOMSpotParkingGroundContentView GetDefaultItemLabelWidth];
    rect = CGRectMake(sx, sy, w, textHeight);
    [m_PriceUnitLabel setFrame:rect];
    
    sx += w + yedge;
    w = self.frame.size.width - sx - xedge;
    rect = CGRectMake(sx, sy, w, textHeight);
    [m_PriceUnitType setFrame:rect];
    float offsetx = m_PriceUnitType.frame.origin.x;
    float offsety = m_PriceUnitType.frame.origin.y;
    [m_PriceUnitType SetOriginInContainer:offsetx withY:offsety];
    [m_PriceUnitType UpdateLayout];
    
    
    sx = xedge;
    sy += textHeight + yedge;
    w = [NOMSpotParkingGroundContentView GetDefaultItemLabelWidth];
    rect = CGRectMake(sx, sy, w, textHeight);
    [m_AddressLabel setFrame:rect];
    
    sx += w + yedge;
    w = self.frame.size.width - sx - xedge;
    rect = CGRectMake(sx, sy, w, textHeight);
    [m_AddressEditor setFrame:rect];
}


-(void)Reset
{
    m_Address = nil;
    m_Name = nil;
    m_dPrice = 0.0;
    m_nPriceUnit = NOM_PARKING_RATEUNIT_HOUR;
    
    [m_NameEditor setText:@""];
    [m_PriceEditor setText:@""];
    [m_AddressEditor setText:@""];
    
    m_nPriceUnit = NOM_PARKING_RATEUNIT_HOUR;
    
    [m_PriceUnitType SetLabel:[StringFactory GetString_ParkingRate:m_nPriceUnit]];
    [m_PriceUnitType SetSelectedItem:m_nPriceUnit];
}

-(void)SetAddress:(NSString*)address
{
    if(m_Address != nil && 0 < m_Address.length)
    {
        m_Address = nil;
    }
    if(address != nil && 0 < address.length)
    {
        m_Address = [address copy];
        [m_AddressEditor setText:m_Address];
    }
    else
    {
        [m_AddressEditor setText:@""];
    }
}

-(void)SetName:(NSString*)name
{
    if(m_Name != nil && 0 < m_Name.length)
    {
        m_Name = nil;
    }
    if(name != nil && 0 < name.length)
    {
        m_Name = [name copy];
        [m_NameEditor setText:m_Name];
    }
    else
    {
        [m_NameEditor setText:@""];
    }
}

-(void)SetRate:(double)dPrice
{
    m_dPrice = dPrice;
    if(m_dPrice <= 0.0)
    {
        [m_PriceEditor setText:@""];
    }
    else
    {
        [m_PriceEditor setText:[NSString stringWithFormat:@"%f", m_dPrice]];
    }
}

-(void)SetRateUnit:(int16_t)nUnit
{
    m_nPriceUnit = nUnit;
    [self UpdatePriceUnitType];
}

-(NSString*)GetAddress
{
    m_Address = m_AddressEditor.text;
    return m_Address;
}

-(NSString*)GetName
{
    m_Name = m_NameEditor.text;
    return m_Name;
}

-(double)GetRate
{
    if(m_PriceEditor.text == nil || m_PriceEditor.text.length <= 0)
    {
        m_dPrice = 0.0;
    }
    else
    {
        m_dPrice = [m_PriceEditor.text doubleValue];
    }
    return m_dPrice;
}

-(int16_t)GetRateUnit
{
    return m_nPriceUnit;
}


@end
