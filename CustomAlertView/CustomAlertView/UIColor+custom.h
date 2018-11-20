//
//  ColorUtils.h
//  
//
//  Created by MapleHero on 15/11/23.
//  Copyright © 2015年 Yingu-corp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIColor(custom)

+(UIColor*)lightColor;

//hexStr参数为“0XFF879828”格式,若不以“0X”开头返回nil
+(UIColor*)colorWithHexValue:(NSString*)hexStr;

//带#的颜色色值
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
@end
