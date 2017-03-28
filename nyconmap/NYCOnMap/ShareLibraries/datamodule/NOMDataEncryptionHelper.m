//
//  NOMDataEncryptionHelper.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2015-01-10.
//  Copyright (c) 2015 Zhaohui Xing. All rights reserved.
//

#import "NOMDataEncryptionHelper.h"

#ifdef _USING_ENCODE_
#undef _USING_ENCODE_
#endif

@implementation NOMDataEncryptionHelper

static NSString* g_ESignTag = @"^|^";
static NSString* g_SignVersionTag = @"";

+(void)InitializeEncryption
{
    g_ESignTag = [NSString stringWithFormat:@"%c%c%c", 0xb0, 0xb6, 0xac];
    
    g_SignVersionTag = [NSString stringWithFormat:@"%@%@", [NOMDataEncryptionHelper GetEncryptingTag], [NOMDataEncryptionHelper GetVersionTag]];
    
#ifdef DEBUG
    NSLog(@"g_ESignTag:%@\n", g_ESignTag);
    NSLog(@"g_SignVersionTag:%@\n", g_SignVersionTag);
#endif
}

+(NSString*)GetVersion01Tag
{
    NSString* szVersion = @"01";
    return szVersion;
}

+(BOOL)IsVersion01:(NSString*)version
{
    NSString* szVersion = [NOMDataEncryptionHelper GetVersion01Tag];
    
    BOOL bRet = [szVersion isEqualToString:version];
    
    return bRet;
}


+(NSString*)GetVersionTag
{
    NSString* szVersion = [NOMDataEncryptionHelper GetVersion01Tag];
    return szVersion;
}

+(NSString*)GetEncryptingTag
{
    return g_ESignTag;
}

+(NSString*)GetEncryptingAndVersionTag
{
    return g_SignVersionTag;
}

+(NSString*)HandleVersion01EncodingData:(NSString*)pData
{
    NSString* szEncodeData = @"";
    
    if(pData == nil || pData.length == 0)
        return szEncodeData;
    
    
    
    NSUInteger length = [pData length];
    
    unichar dataBuffer[length];
    unichar encodeBuffer[length];
    
    [pData getCharacters:dataBuffer range:NSMakeRange(0, length)];
    
    for(int i = (int)length-1; 0 <= i; --i)
    {
        encodeBuffer[((int)length-1) - i] = (unichar)(~((unsigned int)dataBuffer[i])+1);
    }
    
    szEncodeData = [NSString stringWithCharacters:encodeBuffer length:length];
    
    return szEncodeData;
}

+(NSString*)HandleCurrentVersionEncodingData:(NSString*)pData
{
    NSString* szEncodeData = [NOMDataEncryptionHelper HandleVersion01EncodingData:pData];
    return szEncodeData;
}

+(NSString*)EncodingData:(NSString*)pData
{
    NSString* szRet = nil;
    
    NSString* szTag = [NOMDataEncryptionHelper GetEncryptingAndVersionTag];
    
#ifdef _USING_ENCODE_
    NSString* szEncodeData = [NOMDataEncryptionHelper HandleCurrentVersionEncodingData:pData];
    
    szRet = [NSString stringWithFormat:@"%@%@", szTag, szEncodeData];
#else
    szRet = [NSString stringWithFormat:@"%@%@", szTag, pData];
#endif
    return szRet;
}

+(NSString*)HandleVersion01DecodingData:(NSString*)pData
{
    NSString* szDecodeData = @"";
    
    if(pData == nil || pData.length == 0)
        return szDecodeData;
    
    
    
    NSUInteger length = [pData length];
    
    unichar dataBuffer[length];
    unichar decodeBuffer[length];
    
    [pData getCharacters:dataBuffer range:NSMakeRange(0, length)];
    
    for(int i = (int)length-1; 0 <= i; --i)
    {
        decodeBuffer[((int)length-1) - i] = (unichar)(~((unsigned int)dataBuffer[i]-1));
    }
 
    szDecodeData = [NSString stringWithCharacters:decodeBuffer length:length];
    
    return szDecodeData;
}

+(NSString*)HandleCurrentVersionDecodingData:(NSString*)pData
{
    NSString* szDecodeData = [NOMDataEncryptionHelper HandleVersion01DecodingData:pData];
    return szDecodeData;
}

+(BOOL)HasEncryptingAndVersionString:(NSString*)pData
{
    NSString* szSignTag = [NOMDataEncryptionHelper GetEncryptingTag];
    NSRange rangeSignTag = [pData rangeOfString:szSignTag];
    
    if(rangeSignTag.length == 0)
        return NO;
    
    szSignTag = [NOMDataEncryptionHelper GetEncryptingAndVersionTag];
    rangeSignTag = [pData rangeOfString:szSignTag];
    
    if(rangeSignTag.length == 0)
        return NO;
    
    return YES;
}

+(NSString*)ExtractEncryptingAndVersionString:(NSString*)pData signStart:(int*)nStartIndex signLength:(int*)nLength
{
    NSString* szRet = nil;
    *nStartIndex = 0;
    *nLength = 0;
    
    if(pData == nil || pData.length == 0)
        return szRet;
    
    NSString* szSignTag = [NOMDataEncryptionHelper GetEncryptingTag];
    NSRange rangeSignTag = [pData rangeOfString:szSignTag];
    
    if(rangeSignTag.length == 0)
        return szRet;
    
    rangeSignTag.length = rangeSignTag.length + 2;
    szRet = [pData substringWithRange:rangeSignTag];

    *nStartIndex = (int)rangeSignTag.location;
    *nLength = (int)rangeSignTag.length;
    
#ifdef DEBUG
    NSLog(@"ExtractEncryptingAndVersionString:%@\n", szRet);
#endif
    
    return szRet;
}

+(NSString*)ExtractEncodedDataBlock:(NSString*)pData versionResult:(BOOL *)bWrongVersion
{
    NSString* szRet = nil;
    *bWrongVersion = NO;
    int nStartIndex, nLength;
    
    NSString* szCurEVTag = [NOMDataEncryptionHelper GetEncryptingAndVersionTag];
    NSString* szEvTag = [NOMDataEncryptionHelper ExtractEncryptingAndVersionString:pData signStart:&nStartIndex signLength:&nLength];
    if(szEvTag == nil || szEvTag.length == 0)
        return szRet;
    
    if([szCurEVTag isEqualToString:szEvTag] == NO)
    {
        *bWrongVersion = YES;
        return szRet;
    }
    
    szRet = [pData substringFromIndex:(nStartIndex + nLength)];
    
#ifdef DEBUG
    NSLog(@"ExtractEncodedDataBlock:%@\n", szRet);
#endif
    
    return szRet;
}

+(NSString*)DecodingData:(NSString*)pData
{
    NSString* szRet = nil;
    
    BOOL bWrongVersion = NO;
    NSString* szEncodeString = [NOMDataEncryptionHelper ExtractEncodedDataBlock:pData versionResult:&bWrongVersion];
    if(szEncodeString == nil || szEncodeString.length == 0)
    {
#ifdef DEBUG
        if(bWrongVersion == YES)
            NSLog(@"ParseNewsDataFromRawString: wrong encryption version.\n");
        else
            NSLog(@"ParseNewsDataFromRawString: invalid data block.\n");
#endif
        
        if([NOMDataEncryptionHelper HasEncryptingAndVersionString:pData] == NO)
            return pData;
        
        return szEncodeString;
    }
    
#ifdef _USING_ENCODE_
    szRet = [NOMDataEncryptionHelper HandleCurrentVersionDecodingData:szEncodeString];
#else
    return szEncodeString;
#endif
    
    return szRet;
}


@end
