//
//  Macros.h
//  CustomAlertView
//
//  Created by 李少锋 on 2018/11/20.
//  Copyright © 2018年 李少锋. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width
#define Iphone6sPlus_Height                    667.0//iphone6 的屏幕高度
#define Main_Screen_Height_For_Adjustify       (kDevice_Is_iPhoneX ? Iphone6sPlus_Height : Main_Screen_Height)
#define kScreenWidthRatio       (Main_Screen_Width / 375.0)
#define kScreenHeightRatio      (Main_Screen_Height_For_Adjustify / 667.0)
#define AdaptedWidth(x)         ceilf((x) * kScreenWidthRatio)
#define AdaptedHeight(x)        ceilf((x) * kScreenHeightRatio)

#define COLOR_FF383838    @"0xff383838"

#define COLOR_F1F1F1    @"0xfff1f1f1"

#define COLOR_FFFC0B36    @"0xfffc0b36"

#endif /* Macros_h */
