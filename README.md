# CustomAlertView

### 根据内容取得大小
```
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
 NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:AdaptedHeight(14)],  NSParagraphStyleAttributeName:paragraphStyle.copy};
 CGSize labelSize = [_content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-AdaptedWidth(80), CGFLOAT_MAX)  options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
 _textViewSize=CGSizeMake(labelSize.width, labelSize.height+1);
    
  //根据content内容的高度得出整个bgView的高度
  _bgViewHeight=IViewHeight+_textViewSize.height;
    
  return attributedString;
}
```

#### 调用方法
```
[CustomAlertView initAlertView:@"温馨提示" andShowViewController:self andContent:@"大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件" andSureBtnTitle:@"确定" andCancalBtnTitle:@"取消" andSureBlock:^{
        
    } andCancal:^{
        
    }];
```
![image](https://github.com/lsfA1/CustomAlertView/raw/master/CustomAlertView/img/01.png)
