//
//  TwitterTweetLocationParser.m
//  newsonmap
//
//  Created by Zhaohui Xing on 1/30/2014.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "TwitterTweetLocationParser.h"
#import "NOMSocialTweetHelper.h"
#import "StringFactory.h"


#define TP_PREP_OF             [StringFactory GetString_TP_PREP_OF]
#define TP_PREP_ON             [StringFactory GetString_TP_PREP_ON]
#define TP_PREP_AT             [StringFactory GetString_TP_PREP_AT]
#define TP_PREP_FROM           [StringFactory GetString_TP_PREP_FROM]
#define TP_PREP_TO             [StringFactory GetString_TP_PREP_TO]
#define TP_PREP_IN             [StringFactory GetString_TP_PREP_IN]
#define TP_PREP_AND            [StringFactory GetString_TP_PREP_AND]
#define TP_PREP_BETWEEN        [StringFactory GetString_TP_PREP_BETWEEN]

#define TP_PUNCT_AMP           @"&"
#define TP_PUNCT_COMMA         @","
#define TP_PUNCT_COLON         @":"
#define TP_PUNCT_SEMICOLON     @";"
#define TP_PUNCT_DASH          @"-"
#define TP_PUNCT_SLASH         @"/"
#define TP_PUNCT_NUM           @"#"
#define TP_PUNCT_PERIOD        @"!"

#define TP_DIRWORD_NB          [StringFactory GetString_TP_DIRWORD_NB]
#define TP_DIRWORD_EB          [StringFactory GetString_TP_DIRWORD_EB]
#define TP_DIRWORD_SB          [StringFactory GetString_TP_DIRWORD_SB]
#define TP_DIRWORD_WB          [StringFactory GetString_TP_DIRWORD_WB]
#define TP_DIRWORD_NBABR       @"nb"
#define TP_DIRWORD_EBABR       @"eb"
#define TP_DIRWORD_SBABR       @"sb"
#define TP_DIRWORD_WBABR       @"wb"

#define TP_DIRWORD_APPROACHING      [StringFactory GetString_TP_DIRWORD_APPROACHING]

#define TP_STATE_NONE            0
#define TP_STATE_ADDWORD         1

@interface TwitterTweetLocationParser ()
{
    NSString*       m_TweetText;
    NSMutableArray* m_StreetList;
    int             m_ParseState;
    NSString*       m_ParseWord;
}

@end

@implementation TwitterTweetLocationParser

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        m_TweetText = nil;
        m_StreetList = [[NSMutableArray alloc] init];
        m_ParseState = TP_STATE_NONE;
        m_ParseWord = @"";
    }
    
    return self;
}


+(BOOL)IsBeginSign:(NSString*)szWord withTag:(NSString*)tag
{
    BOOL bRet = NO;
    
    if(szWord == nil || szWord.length <= 0)
        return bRet;
    
    NSString* szTestString = [szWord lowercaseString];
    
    if([szTestString isEqualToString:TP_DIRWORD_WBABR] == YES)
    {
        return YES;
    }
    if([szTestString isEqualToString:TP_DIRWORD_SBABR] == YES)
    {
        return YES;
    }
    if([szTestString isEqualToString:TP_DIRWORD_EBABR] == YES)
    {
        return YES;
    }
    if([szTestString isEqualToString:TP_DIRWORD_NBABR] == YES)
    {
        return YES;
    }
    if([szTestString isEqualToString:TP_DIRWORD_WB] == YES)
    {
        return YES;
    }
    if([szTestString isEqualToString:TP_DIRWORD_SB] == YES)
    {
        return YES;
    }
    if([szTestString isEqualToString:TP_DIRWORD_EB] == YES)
    {
        return YES;
    }
    if([szTestString isEqualToString:TP_DIRWORD_NB] == YES)
    {
        return YES;
    }
    if([szTestString isEqualToString:TP_PREP_OF] == YES)
    {
        return YES;
    }
    if([szTestString isEqualToString:TP_PREP_ON] == YES)
    {
        return YES;
    }
    if([szTestString isEqualToString:TP_PREP_AT] == YES)
    {
        return YES;
    }
    if([szTestString isEqualToString:TP_PREP_FROM] == YES)
    {
        return YES;
    }
    if([szTestString isEqualToString:TP_PREP_TO] == YES)
    {
        return YES;
    }
    if([szTestString isEqualToString:TP_PREP_IN] == YES)
    {
        return YES;
    }
    if([szTestString isEqualToString:TP_PUNCT_AMP] == YES)
    {
        return YES;
    }
    if([szTestString isEqualToString:TP_PUNCT_COMMA] == YES)
    {
        return YES;
    }
    if([szTestString isEqualToString:TP_PUNCT_COLON] == YES)
    {
        return YES;
    }
    if([szTestString isEqualToString:TP_PUNCT_DASH] == YES)
    {
        return YES;
    }
    if([szTestString isEqualToString:TP_PUNCT_SLASH] == YES)
    {
        return YES;
    }
    if([szTestString isEqualToString:TP_DIRWORD_APPROACHING] == YES)
    {
        return YES;
    }
    if([szTestString isEqualToString:TP_PREP_AND] == YES)
    {
        return YES;
    }
    if([szTestString isEqualToString:TP_PREP_BETWEEN] == YES)
    {
        return YES;
    }
    
    return bRet;
}

+(BOOL)IsCancelSign:(NSString*)szWord withTag:(NSString*)tag
{
    BOOL bRet = NO;
    
    if(szWord == nil || szWord.length <= 0)
        return bRet;
    
    NSString* szTestString = [szWord lowercaseString];
    
    if([szTestString isEqualToString:TP_DIRWORD_WBABR] == YES)
    {
        return YES;
    }
    if([szTestString isEqualToString:TP_DIRWORD_SBABR] == YES)
    {
        return YES;
    }
    if([szTestString isEqualToString:TP_DIRWORD_EBABR] == YES)
    {
        return YES;
    }
    if([szTestString isEqualToString:TP_DIRWORD_NBABR] == YES)
    {
        return YES;
    }
    if([szTestString isEqualToString:TP_DIRWORD_WB] == YES)
    {
        return YES;
    }
    if([szTestString isEqualToString:TP_DIRWORD_SB] == YES)
    {
        return YES;
    }
    if([szTestString isEqualToString:TP_DIRWORD_EB] == YES)
    {
        return YES;
    }
    if([szTestString isEqualToString:TP_DIRWORD_NB] == YES)
    {
        return YES;
    }
    if([szTestString isEqualToString:TP_PREP_OF] == YES)
    {
        return YES;
    }
    return bRet;
}

+(BOOL)IsEndSign:(NSString*)szWord withTag:(NSString*)tag
{
    BOOL bRet = NO;
    
    if(szWord == nil || szWord.length <= 0)
        return bRet;
    
    NSString* szTestString = [szWord lowercaseString];
    
    if([szTestString isEqualToString:TP_PREP_AT] == YES)
    {
        return YES;
    }
    if([szTestString isEqualToString:TP_PREP_FROM] == YES)
    {
        return YES;
    }
    if([szTestString isEqualToString:TP_PREP_TO] == YES)
    {
        return YES;
    }
    if([szTestString isEqualToString:TP_PREP_IN] == YES)
    {
        return YES;
    }
    if([szTestString isEqualToString:TP_PUNCT_AMP] == YES)
    {
        return YES;
    }
    if([szTestString isEqualToString:TP_PUNCT_COMMA] == YES)
    {
        return YES;
    }
    if([szTestString isEqualToString:TP_PUNCT_COLON] == YES)
    {
        return YES;
    }
    if([szTestString isEqualToString:TP_PUNCT_SEMICOLON] == YES)
    {
        return YES;
    }
    if([szTestString isEqualToString:TP_PUNCT_PERIOD] == YES)
    {
        return YES;
    }
    if([szTestString isEqualToString:TP_PUNCT_SLASH] == YES)
    {
        return YES;
    }
    if([szTestString isEqualToString:TP_DIRWORD_APPROACHING] == YES)
    {
        return YES;
    }
    if([szTestString isEqualToString:TP_PREP_AND] == YES)
    {
        return YES;
    }
    if([szTestString isEqualToString:TP_PREP_BETWEEN] == YES)
    {
        return YES;
    }
    if([szTestString isEqualToString:TP_PREP_BETWEEN] == YES)
    {
        return YES;
    }
    return bRet;
}

+(BOOL)IsUsedKeyword:(NSString*)szWord
{
    if(szWord == nil || szWord.length <= 0)
        return NO;
    
    BOOL bRet = [NOMSocialTweetHelper IsSearchingKeyWord:szWord];
    return bRet;
}


-(void)ParseLocationFromTweet:(NSString*)tweet
{
    if(tweet == nil || tweet.length <= 0)
        return;
    m_ParseWord = @"";
    m_ParseState = TP_STATE_NONE;

    m_TweetText = tweet;

    NSLinguisticTagger *tagger = [[NSLinguisticTagger alloc]
                                initWithTagSchemes:[NSArray arrayWithObject:NSLinguisticTagSchemeLexicalClass]
                                options:NSLinguisticTaggerOmitWhitespace];
    
    [tagger setString:m_TweetText];
    [tagger enumerateTagsInRange:NSMakeRange(0, [m_TweetText length])
                          scheme:NSLinguisticTagSchemeLexicalClass
                         options:NSLinguisticTaggerOmitWhitespace
                      usingBlock:^(NSString *tag, NSRange tokenRange, NSRange sentenceRange, BOOL *stop)
     {
         NSString* word = [m_TweetText substringWithRange:tokenRange];
         if(word != nil)
         {
             if(m_ParseState == TP_STATE_NONE)
             {
                 if([TwitterTweetLocationParser IsBeginSign:word withTag:tag] == YES)
                 {
                     m_ParseState = TP_STATE_ADDWORD;
                 }
             }
             else if(m_ParseState == TP_STATE_ADDWORD)
             {
                 if([TwitterTweetLocationParser IsEndSign:word withTag:tag] == YES)
                 {
                     if(0 < m_ParseWord.length)
                     {
                         if([TwitterTweetLocationParser IsUsedKeyword:m_ParseWord] == NO)
                         {
                             [m_StreetList addObject:[NSString stringWithFormat:@"%@", m_ParseWord]];
                         }
                         m_ParseWord = @"";
                         m_ParseState = TP_STATE_NONE;
                         if([TwitterTweetLocationParser IsBeginSign:word withTag:tag] == YES)
                         {
                             m_ParseState = TP_STATE_ADDWORD;
                         }
                     }
                 }
                 else if([TwitterTweetLocationParser IsCancelSign:word withTag:tag] == YES)
                 {
                     if(0 < m_ParseWord.length)
                     {
                         m_ParseWord = @"";
                         m_ParseState = TP_STATE_NONE;
                         if([TwitterTweetLocationParser IsBeginSign:word withTag:tag] == YES)
                         {
                             m_ParseState = TP_STATE_ADDWORD;
                         }
                     }
                 }
                 else
                 {
                     if(m_ParseWord.length <= 0)
                     {
                         m_ParseWord = [NSString stringWithFormat:@"%@", word];
                     }
                     else
                     {
                         m_ParseWord = [NSString stringWithFormat:@"%@ %@",m_ParseWord, word];
                     }
                 }
             }
         }
#ifdef DEBUG
         NSLog(@"Text element: %@ (%@)\n", word, tag);
#endif
     }];
    if(0 < m_ParseWord.length)
    {
        [m_StreetList addObject:[NSString stringWithFormat:@"%@", m_ParseWord]];

    }
    
#ifdef DEBUG
    if(0 < m_StreetList.count)
    {
        for(int i = 0; i < m_StreetList.count; ++i)
        {
            NSLog(@"String %i: %@\n", i, [m_StreetList objectAtIndex:i]);
        }
    }
#endif
}

-(NSArray*)GetLocationList
{
    return m_StreetList;
}

-(void)ParseLocationFromText:(NSString*)text
{
    [self ParseLocationFromTweet:text];
}

@end
