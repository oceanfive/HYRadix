//
//  HYRadix.m
//  HYRadix
//
//  Created by ocean on 2017/11/14.
//  Copyright © 2017年 ocean. All rights reserved.
//

#import "HYRadix.h"
#import <math.h>

static NSUInteger HYRadixBinary = 2;
static NSUInteger HYRadixDecimal = 10;
static NSUInteger HYRadixHexadecimal = 16;

#pragma mark - NSString分类
@interface NSString (HYRadixHelp)

/**
 用于判断字符串是否为“空值”
 */
+ (BOOL)hy_isNullString:(nullable NSString *)string;

/**
 用于判断字符串是否包含子字符串sting
 */
- (BOOL)hy_containsString:(NSString *)string;

@end

@implementation NSString (HYRadixHelp)

+ (BOOL)hy_isNullString:(NSString *)string {
    if (string == nil ||
        string.length == 0 ||
        [string isEqualToString:@"NULL"] ||
        [string isEqualToString:@"Null"] ||
        [string isEqualToString:@"null"] ||
        [string isEqualToString:@"(NULL)"] ||
        [string isEqualToString:@"(Null)"] ||
        [string isEqualToString:@"(null)"] ||
        [string isEqualToString:@"<NULL>"] ||
        [string isEqualToString:@"<Null>"] ||
        [string isEqualToString:@"<null>"] ||
        [string isKindOfClass:[NSNull class]] ||
        string == NULL) {
        return YES;
    }
    return NO;
}

- (BOOL)hy_containsString:(NSString *)string {
    if ([NSString hy_isNullString:string] || [NSString hy_isNullString:self]) return NO;
    NSRange range = [self rangeOfString:string];
    return range.location == NSNotFound ? NO : YES;
}

@end


@implementation HYRadix

+ (BOOL)hy_isMatchedBinary:(NSString *)binaryValue {
    return [self _isMatchedRadix:HYRadixBinary radixValue:binaryValue];
}

+ (BOOL)hy_isMatchedDecimal:(NSString *)decimalValue {
    return [self _isMatchedRadix:HYRadixDecimal radixValue:decimalValue];
}

+ (BOOL)hy_isMatchedHexadecimal:(NSString *)hexadecimalValue {
    return [self _isMatchedRadix:HYRadixHexadecimal radixValue:hexadecimalValue];
}

/**
 匹配二进制、十进制、十六进制数值
 */
+ (BOOL)_isMatchedRadix:(NSUInteger)radix radixValue:(NSString *)radixValue {
    if ([NSString hy_isNullString:radixValue]) return NO;
    NSMutableString *regex = [NSMutableString string];
    if (radix == HYRadixBinary) {
        regex = [NSMutableString stringWithString:@"[01]*[.]?[01]*"];
    } else if (radix == HYRadixDecimal) {
        regex = [NSMutableString stringWithString:@"[0-9]*[.]?[0-9]*"];
    } else if (radix == HYRadixHexadecimal) {
        regex = [NSMutableString stringWithString:@"[0-9A-Fa-f]*[.]?[0-9A-Fa-f]*"];
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:radixValue];
    /*
     @discussion:
     二进制:
        1、只有0和1
        2、只有一位小数点.
     十进制:
        1、0-9
        2、只有一位小数点.
     十六进制:
        1、0-9、A-Z、a-z
        2、只有一位小数点.
     */
}

+ (NSString *)hy_convertToDecimalFromBinary:(NSString *)binaryValue {
    return [self _convertToDecimalFromRadix:HYRadixBinary radixValue:binaryValue];
}

+ (NSString *)hy_convertToDecimalFromHexadecimal:(NSString *)hexadecimalValue {
    return [self _convertToDecimalFromRadix:HYRadixHexadecimal radixValue:hexadecimalValue];
}

+ (NSString *)_convertToDecimalFromRadix:(NSUInteger)radix radixValue:(NSString *)radixValue {
    if (radix == HYRadixBinary) {
        if (![self hy_isMatchedBinary:radixValue]) return nil;
        if (![radixValue hy_containsString:@"."]) { //不包含小数点.，是整数
            return [self _convertToDecimalFromBinary:radixValue isFractional:NO];
        } else { //包含小数点.，是小数
            NSArray *array = [radixValue componentsSeparatedByString:@"."];
            NSString *integerValue = [self _convertToDecimalFromBinary:array[0] isFractional:NO];
            NSString *fractionalValue = [self _convertToDecimalFromBinary:array[1] isFractional:YES];
            double value = integerValue.doubleValue + fractionalValue.doubleValue;
            NSString *stringValue = [NSString stringWithFormat:@"%f", value];
            return [stringValue stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"0"]];
        }
    } else if (radix == HYRadixHexadecimal) {
        if (![self hy_isMatchedHexadecimal:radixValue]) return nil;
        if (![radixValue hy_containsString:@"."]) { //不包含小数点.，是整数
            return [self _convertToDecimalFromHexadecimal:radixValue isFractional:NO];
        } else { //包含小数点.，是小数
            NSArray *array = [radixValue componentsSeparatedByString:@"."];
            NSString *integerValue = [self _convertToDecimalFromHexadecimal:array[0] isFractional:NO];
            NSString *fractionalValue = [self _convertToDecimalFromHexadecimal:array[1] isFractional:YES];
            double value = integerValue.doubleValue + fractionalValue.doubleValue;
            NSString *stringValue = [NSString stringWithFormat:@"%f", value];
            return [stringValue stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"0"]];
        }
    }
    return nil;
}

+ (NSString *)_convertToDecimalFromBinary:(NSString *)binaryValue isFractional:(BOOL)isFractional {
    return [self _convertToDecimalFromRadix:HYRadixBinary radixValue:binaryValue isFractional:isFractional];
}

+ (NSString *)_convertToDecimalFromHexadecimal:(NSString *)hexadecimalValue isFractional:(BOOL)isFractional {
    return [self _convertToDecimalFromRadix:HYRadixHexadecimal radixValue:hexadecimalValue isFractional:isFractional];
}

/**
 其他进制（如二进制、十六进制）转十进制

 @param radix 进制
 @param radixValue 进制的值
 @param isFractional 是不是小数部分
 @return 十进制
 
 ps:
 如二进制数值10.1000
 isFractional   NO  YES
 radixValue     10  1000
 
 */
+ (NSString *)_convertToDecimalFromRadix:(NSUInteger)radix radixValue:(NSString *)radixValue isFractional:(BOOL)isFractional {
    if (isFractional) {
        double value = 0;
        for (int i = 0; i < radixValue.length; i++) {
            NSString *subString = [radixValue substringWithRange:NSMakeRange(i, 1)];
            int index = -(i + 1);
            value += [[self _getDecimalValueByRadixValue:subString] doubleValue] * pow(radix, index);
        }
        return [NSString stringWithFormat:@"%f", value];
    } else {
        long long value = 0;
        for (int i = (int)radixValue.length - 1; i >= 0; i--) {
            NSString *subString = [radixValue substringWithRange:NSMakeRange(i, 1)];
            int index = (int)radixValue.length - 1 - i;
            value += [[self _getDecimalValueByRadixValue:subString] longLongValue] * pow(radix, index);
        }
        return [NSString stringWithFormat:@"%lld", value];
    }
}

/**
 获取 十六进制/二进制 对应的 十进制 基数值
 */
+ (NSString *)_getDecimalValueByRadixValue:(NSString *)radixValue {
    NSDictionary *dict = [self _radixKeyValueMap];
    NSString *map = [dict objectForKey:radixValue];
    return [NSString hy_isNullString:map] ? @"0" : map;
}

/**
 获取 十进制 对应的 十六进制/二进制 基数值
 */
+ (NSString *)_getRadixValueByDecimalValue:(NSString *)decimalValue {
    __block NSString *radixValue;
    NSDictionary *dict = [self _radixKeyValueMap];
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *mKey = (NSString *)key;
        NSString *mValue = (NSString *)obj;
        if ([mValue isEqualToString:decimalValue]) {
            radixValue = mKey;
            *stop = YES;
        }
    }];
    return [NSString hy_isNullString:radixValue] ? @"0" : radixValue.lowercaseString;
}


+ (NSString *)hy_convertToBinaryFromDecimal:(NSString *)decimalValue {
    return [self _convertToRadix:HYRadixBinary fromDecimal:decimalValue];
}

+ (NSString *)hy_convertToHexadecimalFromDecimal:(NSString *)decimalValue {
    return [self _convertToRadix:HYRadixHexadecimal fromDecimal:decimalValue];
}

+ (NSString *)_convertToRadix:(NSUInteger)radix fromDecimal:(NSString *)decimalValue {
    if (radix == HYRadixBinary) {
        if (![self hy_isMatchedDecimal:decimalValue]) return nil;
        if (![decimalValue hy_containsString:@"."]) { //不包含小数点.，是整数
            return [self _convertToBinaryFromDecimal:decimalValue isFractional:NO];
        } else { //包含小数点.，是小数
            NSArray *array = [decimalValue componentsSeparatedByString:@"."];
            NSString *integerValue = [self _convertToBinaryFromDecimal:array[0] isFractional:NO];
            NSString *fractionalValue = [self _convertToBinaryFromDecimal:array[1] isFractional:YES];
            NSMutableString *stringValue = [NSMutableString string];
            [stringValue appendString:integerValue];
            if (fractionalValue.length > 0) {
                [stringValue appendString:@"."];
                [stringValue appendString:fractionalValue];
            }
            return [stringValue stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"0"]];
        }
    } else if (radix == HYRadixHexadecimal) {
        if (![self hy_isMatchedDecimal:decimalValue]) return nil;
        if (![decimalValue hy_containsString:@"."]) { //不包含小数点.，是整数
            return [self _convertToHexadecimalFromDecimal:decimalValue isFractional:NO];
        } else { //包含小数点.，是小数
            NSArray *array = [decimalValue componentsSeparatedByString:@"."];
            NSString *integerValue = [self _convertToHexadecimalFromDecimal:array[0] isFractional:NO];
            NSString *fractionalValue = [self _convertToHexadecimalFromDecimal:array[1] isFractional:YES];
            NSMutableString *stringValue = [NSMutableString string];
            [stringValue appendString:integerValue];
            if (fractionalValue.length > 0) {
                [stringValue appendString:@"."];
                [stringValue appendString:fractionalValue];
            }
            return [stringValue stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"0"]];
        }
    }
    return nil;
}

+ (NSString *)_convertToBinaryFromDecimal:(NSString *)decimalRadixValue isFractional:(BOOL)isFractional {
   return [self _convertToRadix:HYRadixBinary fromDecimal:decimalRadixValue isFractional:isFractional];
}

+ (NSString *)_convertToHexadecimalFromDecimal:(NSString *)decimalRadixValue isFractional:(BOOL)isFractional {
   return [self _convertToRadix:HYRadixHexadecimal fromDecimal:decimalRadixValue isFractional:isFractional];
}

/**
 十进制转其他进制（二进制、十六进制）

 @param radix 目标进制，如二进制、十六进制
 @param decimalValue 十进制数值
 @param isFractional 是不是小数部分
 @return 对应的进制值
 
 ps:
 如十进制数值10.1000
 isFractional   NO  YES
 decimalValue   10  1000

 */
+ (NSString *)_convertToRadix:(NSUInteger)radix fromDecimal:(NSString *)decimalValue isFractional:(BOOL)isFractional {
    if (isFractional) {
        NSMutableString *binary = [NSMutableString string];
        NSMutableString *newDecimal = [NSMutableString stringWithString:decimalValue];
        [newDecimal insertString:@"0." atIndex:0];
        double decimal = [newDecimal doubleValue];
        int i = 0;
        while (true) {
            double value = decimal * radix;
            long long integerValue = [self _getIntegerValueByDecimal:[NSString stringWithFormat:@"%f", value]];
            double fractionalValue = [self _getFractionalValueByDecimal:[NSString stringWithFormat:@"%f", value]];
            decimal = fractionalValue;
            [binary appendString:[self _getRadixValueByDecimalValue:[NSString stringWithFormat:@"%lld", integerValue]]];
            i++;
            if (fractionalValue == 0 || i > 32) break;
        }
        return binary;
    } else {
        NSMutableString *binary = [NSMutableString string];
        long long decimal = decimalValue.longLongValue;
        while (true) {
            long remainder = decimal % radix;
            decimal = decimal / radix;
            [binary insertString:[self _getRadixValueByDecimalValue:[NSString stringWithFormat:@"%ld", remainder]] atIndex:0];
            if (decimal == 0) break;
        }
        return binary;
    }
    /*
     @discussion
     1、正数部分：除基反向取余；对于整数部分，用被除数反复除以2，除第一次外，每次除以2均取前一次商的整数部分作被除数并依次记下每次的余数。另外，所得到的商的最后一位余数是所求二进制数的最高位
     2、小数部分：乘基取整法；对于小数部分，采用连续乘以基数2，并依次取出的整数部分，直至结果的小数部分为0为止。故该法称“乘基取整法”。
     */
}

+ (NSString *)hy_convertToBinaryFromHexadecimal:(NSString *)hexadecimalValue {
    NSString *value = [self hy_convertToDecimalFromHexadecimal:hexadecimalValue];
    return [self hy_convertToBinaryFromDecimal:value];
}

+ (NSString *)hy_convertToHexadecimalFromBinary:(NSString *)binaryValue {
    NSString *value = [self hy_convertToDecimalFromBinary:binaryValue];
    return [self hy_convertToHexadecimalFromDecimal:value];
}

/**
 获取十进制数值的整数数值
 */
+ (long long)_getIntegerValueByDecimal:(NSString *)decimal {
    if ([NSString hy_isNullString:decimal]) return NSNotFound;
    if ([decimal hy_containsString:@"."]) { //包含小数点，为小数
        NSRange range = [decimal rangeOfString:@"."];
        NSString *integer = [decimal substringToIndex:range.location];
        return integer.longLongValue;
    } else { //不包含小数点，为正数
        return decimal.longLongValue;
    }
}

/**
 获取十进制数值的小数数值
 */
+ (double)_getFractionalValueByDecimal:(NSString *)decimal {
    if ([NSString hy_isNullString:decimal]) return NSNotFound;
    if ([decimal hy_containsString:@"."]) { //包含小数点，为小数
        NSRange range = [decimal rangeOfString:@"."];
        NSMutableString *fractional = [NSMutableString string];
        [fractional appendString:[decimal substringFromIndex:range.location]];
        [fractional insertString:@"0" atIndex:0];
        return fractional.doubleValue;
    } else { //不包含小数点，为正数
        return 0.0;
    }
}

/**
 十六/十/二进制 数值映射
 */
+ (NSDictionary *)_radixKeyValueMap {
    static NSMutableDictionary *radixDict;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        radixDict = [NSMutableDictionary dictionary];
        [radixDict setObject:@"0" forKey:@"0"];
        [radixDict setObject:@"1" forKey:@"1"];
        [radixDict setObject:@"2" forKey:@"2"];
        [radixDict setObject:@"3" forKey:@"3"];
        [radixDict setObject:@"4" forKey:@"4"];
        [radixDict setObject:@"5" forKey:@"5"];
        [radixDict setObject:@"6" forKey:@"6"];
        [radixDict setObject:@"7" forKey:@"7"];
        [radixDict setObject:@"8" forKey:@"8"];
        [radixDict setObject:@"9" forKey:@"9"];
        [radixDict setObject:@"10" forKey:@"A"];
        [radixDict setObject:@"11" forKey:@"B"];
        [radixDict setObject:@"12" forKey:@"C"];
        [radixDict setObject:@"13" forKey:@"D"];
        [radixDict setObject:@"14" forKey:@"E"];
        [radixDict setObject:@"15" forKey:@"F"];
        [radixDict setObject:@"10" forKey:@"a"];
        [radixDict setObject:@"11" forKey:@"b"];
        [radixDict setObject:@"12" forKey:@"c"];
        [radixDict setObject:@"13" forKey:@"d"];
        [radixDict setObject:@"14" forKey:@"e"];
        [radixDict setObject:@"15" forKey:@"f"];
    });
    return radixDict;
}

@end

