//
//  NOMDataEncryptionHelper.h
//  nyconmap
//
//  Created by Zhaohui Xing on 2015-01-10.
//  Copyright (c) 2015 Zhaohui Xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NOMDataEncryptionHelper : NSObject

+(void)InitializeEncryption;
+(NSString*)GetVersionTag;
+(NSString*)GetEncryptingTag;
+(NSString*)GetEncryptingAndVersionTag;
+(NSString*)EncodingData:(NSString*)pData;
+(NSString*)DecodingData:(NSString*)pData;
+(NSString*)ExtractEncodedDataBlock:(NSString*)pData versionResult:(BOOL *)bWrongVersion;

@end
