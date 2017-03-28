//
//  CustomMapViewPinItem.m
//  newsonmap
//
//  Created by Zhaohui Xing on 2013-07-17.
//  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
//
#import "CustomMapViewPinItem.h"
#import "GUIEventLoop.h"
#import "NOMAppInfo.h"
#import "NOMGEOConfigration.h"
#import <CoreLocation/CoreLocation.h>
#import "NOMNewsMetaDataRecord.h"
#import "NOMSystemConstants.h"
#import "StringFactory.h"

#define PINITEM_SIZE_OFFSET        2

@interface CustomMapViewPinItem ()
{
    BOOL                                m_bSelected;
    
    CGGradientRef                       m_Gradient;
    CGGradientRef                       m_GrayGradient;
    CGColorSpaceRef                     m_Colorspace;
    
    UILabel*                            m_Title1;
    UILabel*                            m_Title2;
    UIImageView*                        m_ReadLabel;
    
    NSString*                           m_NewsID;
    BOOL                                m_bCanReportIt;
    BOOL                                m_bCalenderEnable;
    
    id<INOMCustomMapViewPinItemDelegate>    m_Delegate;
    
    BOOL                                m_bSelectable;
    
    //NSString*                           m_CachedCity;
    //NSString*                           m_CachedCommunity;
    NSString*                           m_CachedAddress;
    BOOL                                m_bTwitterTweet;
}
@end

@implementation CustomMapViewPinItem

+(float)GetTitleFont
{
    if([NOMAppInfo IsDeviceIPad] == YES)
    {
        return 18;
    }
    else
    {
        return 12;
    }
}

-(void)InitializeLabels
{
    float h = self.frame.size.height-2*PINITEM_SIZE_OFFSET;
    float w = self.frame.size.width-2*PINITEM_SIZE_OFFSET;
    float sx = self.frame.origin.x+PINITEM_SIZE_OFFSET;
    float sy = self.frame.origin.y+PINITEM_SIZE_OFFSET;
    
    CGRect innerRect = CGRectMake(sx, sy, w, h*0.5);
    
    m_Title1 = [[UILabel alloc] initWithFrame:innerRect];
    m_Title1.backgroundColor = [UIColor clearColor];
    [m_Title1 setTextColor:[UIColor blackColor]];
    m_Title1.highlightedTextColor = [UIColor grayColor];
    [m_Title1 setTextAlignment:NSTextAlignmentCenter];
    m_Title1.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    m_Title1.adjustsFontSizeToFitWidth = YES;
    m_Title1.font = [UIFont fontWithName:@"Georgia" size:[CustomMapViewPinItem GetTitleFont]];
    [m_Title1 setText:@""];
    [self addSubview:m_Title1];
    
    innerRect = CGRectMake(sx, sy+h*0.5, w, h*0.5);
    
    m_Title2 = [[UILabel alloc] initWithFrame:innerRect];
    m_Title2.backgroundColor = [UIColor clearColor];
    [m_Title2 setTextColor:[UIColor blackColor]];
    m_Title2.highlightedTextColor = [UIColor grayColor];
    [m_Title2 setTextAlignment:NSTextAlignmentCenter];
    m_Title2.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    m_Title2.adjustsFontSizeToFitWidth = YES;
    m_Title2.font = [UIFont fontWithName:@"Georgia" size:[CustomMapViewPinItem GetTitleFont]];
    [m_Title2 setText:@""];
    [self addSubview:m_Title2];
    
    UIImage* bookImage = [UIImage imageNamed:@"next200.png"];
    m_ReadLabel = [[UIImageView alloc] initWithImage:bookImage];
    float size = self.frame.size.height/3.0;
    innerRect = CGRectMake(self.frame.size.width - size, (self.frame.size.height - size)*0.5, size, size);
    [m_ReadLabel setFrame:innerRect];
    [self addSubview:m_ReadLabel];
    m_ReadLabel.hidden = YES;
}

-(void)SetTwitterLogo
{
    [m_ReadLabel setImage:[UIImage imageNamed:@"twitterlogo.png"]];
    m_bTwitterTweet = YES;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        size_t num_locations = 2;
        CGFloat locations[3] = {0.0, 1.0};
        CGFloat colors[12] =
        {
            0.5, 0.5, 1.0, 1.0,
            0.0, 0.0, 0.6, 1.0,
        };
        m_Colorspace = CGColorSpaceCreateDeviceRGB();
        m_Gradient = CGGradientCreateWithColorComponents (m_Colorspace, colors, locations, num_locations);
        
        CGFloat colors1[12] =
        {
            1.0, 1.0, 1.0, 1.0,
            0.8, 0.8, 0.8, 1.0,
        };
        m_GrayGradient = CGGradientCreateWithColorComponents (m_Colorspace, colors1, locations, num_locations);
        
        [self InitializeLabels];
        m_NewsID = nil;
        m_Delegate = nil;
        m_bSelectable = YES;
        m_bCanReportIt = NO;
        //m_CachedCity = nil;
        //m_CachedCommunity = nil;
        m_CachedAddress = nil;
        m_bCalenderEnable = NO;
        m_bTwitterTweet = NO;
    }
    return self;
}

-(void)dealloc
{
    CGColorSpaceRelease(m_Colorspace);
    CGGradientRelease(m_Gradient);
    CGGradientRelease(m_GrayGradient);
}

-(void)DrawBlueBackground:(CGContextRef)context inRect:(CGRect)rect
{
    CGRect rt = CGRectMake(rect.origin.x+PINITEM_SIZE_OFFSET, rect.origin.y+PINITEM_SIZE_OFFSET, rect.size.width-2*PINITEM_SIZE_OFFSET, rect.size.height-2*PINITEM_SIZE_OFFSET);
    
    CGContextSaveGState(context);
    
    CGContextAddRect(context, rt);
    CGContextClip(context);
    CGPoint pt1, pt2;
    pt1.x = rt.origin.x;
    pt1.y = rt.origin.y;
    pt2.x = rt.origin.x;
    pt2.y = pt1.y+rt.size.height;
    CGContextDrawLinearGradient (context, m_Gradient, pt1, pt2, 0);
    
    CGContextRestoreGState(context);
}

-(void)DrawWhiteBackground:(CGContextRef)context inRect:(CGRect)rect
{
    CGRect rt = CGRectMake(rect.origin.x+PINITEM_SIZE_OFFSET, rect.origin.y+PINITEM_SIZE_OFFSET, rect.size.width-2*PINITEM_SIZE_OFFSET, rect.size.height-2*PINITEM_SIZE_OFFSET);
    
    CGContextSaveGState(context);
    
    CGContextAddRect(context, rt);
    CGContextClip(context);
    CGFloat clr[] = {1, 1, 1, 1};
    CGContextSetFillColor(context, clr);
    CGContextFillPath(context);
    CGContextFillRect(context, rt);
    
    CGContextRestoreGState(context);
}

-(void)DrawGreyBackground:(CGContextRef)context inRect:(CGRect)rect
{
    CGRect rt = CGRectMake(rect.origin.x+PINITEM_SIZE_OFFSET, rect.origin.y+PINITEM_SIZE_OFFSET, rect.size.width-2*PINITEM_SIZE_OFFSET, rect.size.height-2*PINITEM_SIZE_OFFSET);
    
    CGContextSaveGState(context);
    
    CGContextAddRect(context, rt);
    CGContextClip(context);
    CGPoint pt1, pt2;
    pt1.x = rt.origin.x;
    pt1.y = rt.origin.y;
    pt2.x = rt.origin.x;
    pt2.y = pt1.y+rt.size.height;
    CGContextDrawLinearGradient (context, m_GrayGradient, pt1, pt2, 0);
    
    CGContextRestoreGState(context);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    if(!m_bSelectable)
    {
        [self DrawGreyBackground:context inRect:rect];
    }
    else
    {
        if(m_bSelected == YES)
            [self DrawBlueBackground:context inRect:rect];
        else
            [self DrawWhiteBackground:context inRect:rect];
    }
}

-(void)AttachDelegate:(id<INOMCustomMapViewPinItemDelegate>)delegate
{
    m_Delegate = delegate;
}

-(void)UpdateForSelectionChange
{
    if(!m_bSelectable)
        return;
    
    if(m_Title1 != nil)
    {
        if(m_bSelected == YES)
            [m_Title1 setTextColor:[UIColor whiteColor]];
        else
            [m_Title1 setTextColor:[UIColor blackColor]];
    }
    if(m_Title2 != nil)
    {
        if(m_bSelected == YES)
            [m_Title2 setTextColor:[UIColor whiteColor]];
        else
            [m_Title2 setTextColor:[UIColor blackColor]];
    }
    [self setNeedsDisplay];
}

-(void)SetSelectState:(BOOL)bSelected
{
    if(!m_bSelectable)
        return;
    
    if(bSelected == YES)
    {
        if([[self superview] respondsToSelector:@selector(UnselectedAllItems)] == YES)
        {
            [[self superview] performSelector:@selector(UnselectedAllItems)];
        }
        
        
    }
    m_bSelected = bSelected;
    [self UpdateForSelectionChange];
}

-(void)ResetSelectState
{
    m_bSelectable = YES;
    m_bSelected = NO;
    [self UpdateForSelectionChange];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!m_bSelectable)
        return;
    
    if(m_bSelected == NO)
    {
        [self SetSelectState:YES];
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!m_bSelectable)
        return;
    
    if(m_bSelected == YES)
    {
        m_bSelected = NO;
        [self UpdateForSelectionChange];
    }
}

-(void)HandleItemSelectedEvent
{
    if(m_Delegate != nil && m_NewsID != nil)
    {
        //[NOMGEOConfigration SetCachedCurrentReadingLocationData:m_CachedCity with:m_CachedCommunity];
        if(m_bTwitterTweet == NO)
        {
            if(m_bCalenderEnable == YES)
            {
                [m_Delegate OpenCalenderSupportedNews:m_NewsID with:m_bCanReportIt withAddress:m_CachedAddress];
            }
            else
            {
                [m_Delegate OpenNews:m_NewsID with:m_bCanReportIt];
            }
        }
        else
        {
            [m_Delegate OpenTwitterTweet:m_NewsID];
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!m_bSelectable)
        return;
    
	NSArray *allTouches = [touches allObjects];
	CGPoint pt = [[allTouches objectAtIndex:0] locationInView:self];
    if(pt.x < 0 || self.frame.size.width < pt.x || pt.y < 0 || self.frame.size.height < pt.y)
    {
        if(m_bSelected == YES)
        {
            m_bSelected = NO;
            [self UpdateForSelectionChange];
        }
        return;
    }
    
    if(m_bSelected == YES)
    {
        [self HandleItemSelectedEvent];
    }
}

-(void)Set:(NSString*)newsID withTitle1:(NSString*)title1 withTitle2:(NSString*)title2
{
    m_NewsID = [newsID copy];
    [m_Title1 setText:title1];
    [m_Title2 setText:title2];
}

-(BOOL)IsSelectable
{
    return m_bSelectable;
}

-(void)SetSelectable:(BOOL)bSelectable
{
    m_bSelectable = bSelectable;
    if(m_bSelectable == YES)
    {
        m_ReadLabel.hidden = NO;
        [self bringSubviewToFront:m_ReadLabel];
    }
    else
    {
        m_ReadLabel.hidden = YES;
        [self sendSubviewToBack:m_ReadLabel];
    }
        
}

-(void)SetEnableReport:(BOOL)bEnable
{
    m_bCanReportIt = bEnable;
}

/*
-(void)SetCachedLocationData:(NSString*)city with:(NSString*)community
{
    m_CachedCity = city;
    m_CachedCommunity = community;
}
*/

-(void)SetEnableCalender:(double)lat withLongitude:(double)lon
{
    m_bCalenderEnable = YES;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation* location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         NSLog(@"CustomMapViewPinItem reverseGeocodeLocation:completionHandler: Completion Handler called!");
         
         if (error)
         {
             NSLog(@"CustomMapViewPinItem Geocode failed with error: %@", error);
             m_CachedAddress = @"";
             return;
         }
         if(placemarks && placemarks.count > 0)
         {
             //do something
             m_CachedAddress = @"";
             CLPlacemark *topResult = [placemarks objectAtIndex:0];
             if(topResult != nil)
             {
                 //m_CachedAddress = [NSString stringWithFormat:@"%@", topResult.]
                 @try
                 {
                     NSString* szName = @"N/A";
                     if(topResult.name != nil && 0 < topResult.name.length)
                         szName = [NSString stringWithFormat:@"%@", topResult.name];
                     NSString* szStreet = @"N/A";
                     if(topResult.thoroughfare != nil && 0 < topResult.thoroughfare.length)
                         szStreet = [NSString stringWithFormat:@"%@", topResult.thoroughfare];
                     NSString* szCity = @"N/A";
                     if(topResult.locality != nil && 0 < topResult.locality.length)
                         szCity = [NSString stringWithFormat:@"%@", topResult.locality];

                     NSString* szState = @"N/A";
                     if(topResult.administrativeArea != nil && 0 < topResult.administrativeArea.length)
                         szState = [NSString stringWithFormat:@"%@", topResult.administrativeArea];
                     
                     NSString* szPostCode = @"N/A";
                     if(topResult.postalCode != nil && 0 < topResult.postalCode.length)
                         szPostCode = [NSString stringWithFormat:@"%@", topResult.postalCode];
                     
                     NSString* szCountry = @"N/A";
                     if(topResult.country != nil && 0 < topResult.country.length)
                         szCountry = [NSString stringWithFormat:@"%@", topResult.country];
                     
                     m_CachedAddress = [NSString stringWithFormat:@"%@, %@, %@, %@ %@, %@", szName, szStreet, szCity, szState, szPostCode, szCountry];
                 }
                 @catch (NSException* e)
                 {
                     m_CachedAddress = @"";
                 }
             }
         }
     }];
}

-(BOOL)IsCalenderSupported
{
    return m_bCalenderEnable;
}

//?????
-(BOOL)LoadItemData:(id)rawData
{
    if(rawData != nil && [rawData isKindOfClass:[NOMNewsMetaDataRecord class]] == YES)
    {
        NOMNewsMetaDataRecord* data = (NOMNewsMetaDataRecord*)rawData;
        if(data.m_NewsMainCategory != NOM_NEWSCATEGORY_LOCALTRAFFIC)
        {
            if([data m_bTwitterTweet] == NO)
            {
                [self Set:data.m_NewsID withTitle1:[StringFactory GetString_NewsMainTitle:data.m_NewsMainCategory] withTitle2:[StringFactory GetString_NewsTitle:data.m_NewsMainCategory subCategory:data.m_NewsSubCategory]];
            }
            else
            {
                if(NOM_TWITTER_TITLE_MAX_LENGHT < data.m_TweetText.length)
                {
                    NSRange range = NSMakeRange(0, NOM_TWITTER_TITLE_MAX_LENGHT-4);
                    NSString* text = [data.m_TweetText substringWithRange:range];
                    text = [NSString stringWithFormat:@"%@...   ", text];
                    [self Set:data.m_NewsID withTitle1:text withTitle2:data.m_NewsPosterDisplayName];
                }
                else
                {
                    [self Set:data.m_NewsID withTitle1:data.m_TweetText withTitle2:data.m_NewsPosterDisplayName];
                }
                [self SetTwitterLogo];
            }
            if(data.m_NewsMainCategory == NOM_NEWSCATEGORY_COMMUNITY && (data.m_NewsSubCategory == NOM_NEWSCATEGORY_COMMUNITY_SUBCATEGORY_COMMUNITYEVENT || data.m_NewsSubCategory == NOM_NEWSCATEGORY_COMMUNITY_SUBCATEGORY_COMMUNITYYARDSALE))
            {
                [self SetEnableCalender:data.m_NewsLatitude withLongitude:data.m_NewsLongitude];
            }
        }
        else
        {
            if([data m_bTwitterTweet] == NO)
            {
                [self Set:data.m_NewsID withTitle1:[StringFactory GetString_NewsMainTitle:data.m_NewsMainCategory] withTitle2:[StringFactory GetString_TrafficTypeTitle:data.m_NewsSubCategory withType:data.m_NewsThirdCategory]];
            }
            else
            {
                if(NOM_TWITTER_TITLE_MAX_LENGHT < data.m_TweetText.length-4)
                {
                    NSRange range = NSMakeRange(0, NOM_TWITTER_TITLE_MAX_LENGHT);
                    NSString* text = [data.m_TweetText substringWithRange:range];
                    text = [NSString stringWithFormat:@"%@...   ", text];
                    [self Set:data.m_NewsID withTitle1:text withTitle2:data.m_NewsPosterDisplayName];
                }
                else
                {
                    [self Set:data.m_NewsID withTitle1:data.m_TweetText withTitle2:data.m_NewsPosterDisplayName];
                }
                [self SetTwitterLogo];
            }
        }
        if((data.m_NewsResourceURL != nil && 0 < [data.m_NewsResourceURL length]) || [data m_bTwitterTweet] == YES || [data FromTrafficRouteSource]== YES)
        {
            [self SetSelectable:YES];
        }
        else
        {
            [self SetSelectable:NO];
        }
        //NSString* szPinCountryCode = [Pin GetCountryCode];
        //NSString* szCurrentCountryCode = [NOMGEOConfigration GetCurrentCountryCode];
        //BOOL bEnable = [NOMGEOConfigration IsSameCountryCode:szCurrentCountryCode with:szPinCountryCode];
        //[item SetEnableReport:bEnable];
        //
        //???
        //
        [self SetEnableReport:NO];
        return YES;
    }
    
    return NO;
}

@end
