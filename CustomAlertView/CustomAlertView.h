//
//  CustomAlertView.h
//  CustomAlertView
//
//  Created by 李少锋 on 2018/11/20.
//  Copyright © 2018年 李少锋. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CustomAlertViewSureBlock)(void);
typedef void(^CustomAlertViewCancalBlock)(void);

@interface CustomAlertView : UIView

@property(nonatomic,strong)UIButton *cancalBtn;
@property(nonatomic,strong)UIButton *sureBtn;
@property (nonatomic, copy)CustomAlertViewSureBlock sureBlock;
@property (nonatomic, copy)CustomAlertViewCancalBlock cancalBlock;

/**
 alertView弹框调用方法（只需要一个按钮的时候，sureBtnTitle或者cancalBtnTitle传空）
 
 @param title 标题
 @param controller 显示的viewcontroller
 @param contentText 内容
 @param sureBtnTitle 确定按钮文本
 @param cancalBtnTitle 取消按钮文本
 @param sureBlock 确定block
 @param cancalBlock 取消block
 @return
 */
+ (instancetype)initAlertView:(NSString *)title andShowViewController:(UIViewController *)controller andContent:(NSString *)contentText andSureBtnTitle:(NSString *)sureBtnTitle andCancalBtnTitle:(NSString *)cancalBtnTitle andSureBlock:(CustomAlertViewSureBlock)sureBlock andCancal:(CustomAlertViewCancalBlock)cancalBlock;

@end

NS_ASSUME_NONNULL_END
