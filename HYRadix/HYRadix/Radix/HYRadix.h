//
//  HYRadix.h
//  HYRadix
//
//  Created by ocean on 2017/11/14.
//  Copyright © 2017年 ocean. All rights reserved.
//  进制转换

#import <Foundation/Foundation.h>

@interface HYRadix : NSObject

#pragma mark - 二进制和十进制转换
/**
 二进制转十进制

 @param binaryValue 二进制
 @return 十进制
 */
+ (NSString *)hy_convertToDecimalFromBinary:(NSString *)binaryValue;

/**
 十进制转二进制

 @param decimalValue 十进制
 @return 二进制
 */
+ (NSString *)hy_convertToBinaryFromDecimal:(NSString *)decimalValue;

#pragma mark - 十六进制和十进制转换
/**
 十六进制转十进制

 @param hexadecimalValue 十六进制
 @return 十进制
 */
+ (NSString *)hy_convertToDecimalFromHexadecimal:(NSString *)hexadecimalValue;

/**
 十进制转十六进制

 @param decimalValue 十进制
 @return 十六进制
 */
+ (NSString *)hy_convertToHexadecimalFromDecimal:(NSString *)decimalValue;

#pragma mark - 二进制和十六进制转换

/**
 十六进制转二进制

 @param hexadecimalValue 十六进制
 @return 二进制
 */
+ (NSString *)hy_convertToBinaryFromHexadecimal:(NSString *)hexadecimalValue;

/**
 二进制转十六进制

 @param binaryValue 二进制
 @return 十六进制
 */
+ (NSString *)hy_convertToHexadecimalFromBinary:(NSString *)binaryValue;

@end
