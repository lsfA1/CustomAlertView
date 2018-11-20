//
//  AttStrView.h
//  CustomAlertView
//
//  Created by 李少锋 on 2018/11/20.
//  Copyright © 2018年 李少锋. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AttStrView;

NS_ASSUME_NONNULL_BEGIN

@protocol AttStrViewDelegate <NSObject>
//下面俩个代理二选一
@optional
- (void)ClickStrAtIndex:(NSUInteger)index;
- (void)ClickStrAtIndex:(NSUInteger)index attStrView:(AttStrView *)attStrView;
@end

@interface AttStrView : UIView

@property(nonatomic, weak) id<AttStrViewDelegate> delegate;
- (instancetype)initWithAttStr:(NSMutableAttributedString *)attributeStr;

@end

NS_ASSUME_NONNULL_END
