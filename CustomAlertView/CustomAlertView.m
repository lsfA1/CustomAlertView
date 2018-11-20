//
//  CustomAlertView.m
//  CustomAlertView
//
//  Created by 李少锋 on 2018/11/20.
//  Copyright © 2018年 李少锋. All rights reserved.
//

#import "CustomAlertView.h"
#import <Masonry.h>
#import "UIColor+custom.h"
#import "AttStrView.h"
#import "Macros.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define IViewHeight AdaptedHeight(170) //白色背景除去中间文本内容的高度

@interface CustomAlertView ()<AttStrViewDelegate>

@property (nonatomic, strong)UIView *BGView;//背景view
@property (nonatomic, strong)UILabel *titleLabel;//标题
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,strong)UILabel *line;
@property(nonatomic,strong)UILabel *BGViewLine;
@property(nonatomic,copy)NSString *sureTitle;
@property(nonatomic,copy)NSString *cancalTitle;
@property(nonatomic,strong)UIView * contentView;//内容view

@property(nonatomic,strong)AttStrView * attStrView;//内容
@property(nonatomic,assign)CGSize textViewSize;//内容的高度
@property(nonatomic,assign)CGFloat bgViewHeight;//背景View的高度

@end

@implementation CustomAlertView

+ (instancetype)initAlertView:(NSString *)title andShowViewController:(UIViewController *)controller andContent:(NSString *)contentText andSureBtnTitle:(NSString *)sureBtnTitle andCancalBtnTitle:(NSString *)cancalBtnTitle andSureBlock:(CustomAlertViewSureBlock)sureBlock andCancal:(CustomAlertViewCancalBlock)cancalBlock{
    CustomAlertView *customAlertView;
    if(!customAlertView){
        customAlertView=[[CustomAlertView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    customAlertView.backgroundColor=[UIColor redColor];
    customAlertView.title=title;
    customAlertView.content=contentText;
    customAlertView.sureTitle=sureBtnTitle;
    customAlertView.cancalTitle=cancalBtnTitle;
    
    //UIViewController *viewController = controller;
    if(!controller){
        UIViewController *viewController=[UIApplication sharedApplication].keyWindow.rootViewController;
        [viewController.view addSubview:customAlertView];
    }
    else{
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        [window addSubview:customAlertView];
    }
    
    customAlertView.sureBlock=sureBlock;
    customAlertView.cancalBlock=cancalBlock;
    //动态计算文本显示高度
    [customAlertView getTextHeight];
    //初始化UI
    [customAlertView constructUI];
    return customAlertView;
}

//根据content文本字体多少得出文本高度
-(NSMutableAttributedString *)getTextHeight{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:AdaptedHeight(10)];
    [paragraphStyle setParagraphSpacing:AdaptedHeight(15)];
    paragraphStyle.alignment=NSTextAlignmentLeft;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_content length])];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexValue:COLOR_FF383838] range:NSMakeRange(0, _content.length)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:AdaptedHeight(14)] range:NSMakeRange(0, _content.length)];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:AdaptedHeight(14)], NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize labelSize = [_content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-AdaptedWidth(80), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    _textViewSize=CGSizeMake(labelSize.width, labelSize.height+1);
    
    //根据content内容的高度得出整个bgView的高度
    _bgViewHeight=IViewHeight+_textViewSize.height;
    
    return attributedString;
}

- (void)constructUI {
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [self addGestureRecognizer:tap];
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    
    _BGView = [[UIView alloc] init];
    _BGView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, _bgViewHeight);
    _BGView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_BGView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = self.title;
    _titleLabel.font = [UIFont boldSystemFontOfSize:AdaptedHeight(20.0)];
    _titleLabel.textColor = [UIColor colorWithHexValue:COLOR_FF383838];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleLabel sizeToFit];
    [_BGView addSubview:_titleLabel];
    
    _contentView=[[UIView alloc]init];
    _contentView.backgroundColor=[UIColor clearColor];
    [_BGView addSubview:_contentView];
    
    _attStrView=[[AttStrView alloc]initWithAttStr:[self getTextHeight]];
    _attStrView.backgroundColor=[UIColor clearColor];
    [_contentView addSubview:_attStrView];
    
    _BGViewLine=[[UILabel alloc]init];
    _BGViewLine.backgroundColor=[UIColor colorWithHexValue:COLOR_F1F1F1];
    [_BGView addSubview:_BGViewLine];
    
    _cancalBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_cancalBtn setTitle:_cancalTitle forState:UIControlStateNormal];
    _cancalBtn.titleLabel.font=[UIFont systemFontOfSize:AdaptedHeight(18)];
    [_cancalBtn addTarget:self action:@selector(cancalBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_cancalBtn setTitleColor:[UIColor colorWithHexValue:COLOR_FF383838] forState:UIControlStateNormal];
    [_BGView addSubview:_cancalBtn];
    
    _line=[[UILabel alloc]init];
    _line.backgroundColor=[UIColor colorWithHexValue:COLOR_F1F1F1];
    [_BGView addSubview:_line];
    
    _sureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_sureBtn setTitle:_sureTitle forState:UIControlStateNormal];
    _sureBtn.titleLabel.font=[UIFont systemFontOfSize:AdaptedHeight(18)];
    [_sureBtn setTitleColor:[UIColor colorWithHexValue:COLOR_FFFC0B36] forState:UIControlStateNormal];
    [_sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_BGView addSubview:_sureBtn];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.BGView.frame = CGRectMake(0, SCREEN_HEIGHT - self.bgViewHeight, SCREEN_WIDTH, self.bgViewHeight);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.BGView);
        make.top.equalTo(self.BGView).offset(AdaptedHeight(25));
    }];
    
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(AdaptedHeight(30));
        make.bottom.equalTo(self.BGView).offset(-AdaptedHeight(90));
        make.left.equalTo(self.BGView).offset(AdaptedWidth(40));
        make.right.equalTo(self.BGView).offset(-AdaptedWidth(40));
    }];
    
    [_attStrView mas_makeConstraints:^(MASConstraintMaker *make) {
        if(self.textViewSize.width>=(CGRectGetWidth(self.BGView.frame)-AdaptedWidth(80))){
            make.left.equalTo(self.BGView).offset(AdaptedWidth(40));
            make.right.equalTo(self.BGView).offset(-AdaptedWidth(40));
        }
        make.width.equalTo(@(self.textViewSize.width+1));
        make.height.equalTo(@(self.textViewSize.height));
        make.center.equalTo(self.BGView);
    }];
    
    [_BGViewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.BGView.mas_bottom).offset(-AdaptedHeight(61));
        make.left.right.equalTo(self.BGView).offset(0);
        make.height.equalTo(@(AdaptedHeight(0.5)));
    }];
    
    [_cancalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.BGView).offset(0);
        make.top.equalTo(self.BGView.mas_bottom).offset(-AdaptedHeight(60));
        make.width.equalTo(@((SCREEN_WIDTH-1)/2));
        make.height.equalTo(@(AdaptedHeight(60)));
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cancalBtn.mas_right).offset(0);
        make.bottom.equalTo(self.BGView.mas_bottom).offset(-AdaptedHeight(12));
        make.width.equalTo(@(AdaptedWidth(0.5)));
        make.height.equalTo(@(AdaptedHeight(36)));
    }];
    
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line.mas_right).offset(0);
        make.top.equalTo(self.BGView.mas_bottom).offset(-AdaptedHeight(60));
        make.right.equalTo(self.BGView).offset(0);
        make.height.equalTo(@(AdaptedHeight(60)));
    }];
    
    //只需有一个按钮的时候，隐藏一个
    if(_sureTitle==nil||_sureTitle.length==0){
        _line.hidden=YES;
        _sureBtn.hidden=YES;
        [_cancalBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.BGView).offset(0);
            make.top.equalTo(self.BGView.mas_bottom).offset(-AdaptedHeight(60));
            make.height.equalTo(@(AdaptedHeight(60)));
        }];
    }
    else if (_cancalTitle==nil||_cancalTitle.length==0){
        _line.hidden=YES;
        _cancalBtn.hidden=YES;
        [_sureBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.BGView).offset(0);
            make.top.equalTo(self.BGView.mas_bottom).offset(-AdaptedHeight(60));
            make.height.equalTo(@(AdaptedHeight(60)));
        }];
    }
}

#pragma mark -YGAttStrView delegate
-(void)ClickStrAtIndex:(NSUInteger)index
{
    [self hiddenView];
}

-(void)tapClick:(UITapGestureRecognizer *)tap{
    [self hiddenView];
}

-(void)cancalBtnClick:(id)sender{
    if(_cancalBlock){
        [self hiddenView];
        _cancalBlock();
    }
}

-(void)sureBtnClick:(id)sender{
    if(_sureBlock){
        [self hiddenView];
        _sureBlock();
    }
}

-(void)hiddenView{
    [UIView animateWithDuration:0.3 animations:^{
        self.BGView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.bgViewHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
