//
//  ColorUtils.m
//  
//
//  Created by MapleHero on 15/11/23.
//  Copyright © 2015年 Yingu-corp. All rights reserved.
//

#import "UIColor+custom.h"

@implementation UIColor(custom)

+(UIColor*)lightColor
{
    return [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
}

+(UIColor*)colorWithHexValue:(NSString *)hexStr
{
    NSUInteger hexValue = strtoul([hexStr UTF8String], 0, 16);
    if(hexValue == ERANGE)
    {
        return nil;
    }
    CGFloat a = ((hexValue & 0xFF000000) >> 24) / 255.0;
    CGFloat r = ((hexValue & 0x00FF0000) >> 16) / 255.0;
    CGFloat g = ((hexValue & 0x0000FF00) >> 8) / 255.0;
    CGFloat b = (hexValue & 0x000000FF) / 255.0;
    UIColor* color = [[UIColor alloc] initWithRed:r green:g blue:b alpha:a];
    return color;
}

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    NSRange range;
    range.location = 0;
    
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

@end
