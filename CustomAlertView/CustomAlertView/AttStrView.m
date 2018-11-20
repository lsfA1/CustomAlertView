//
//  AttStrView.m
//  CustomAlertView
//
//  Created by 李少锋 on 2018/11/20.
//  Copyright © 2018年 李少锋. All rights reserved.
//

#import "AttStrView.h"
#import<CoreText/CoreText.h>
#import "UIColor+custom.h"

@interface AttStrView ()
{
    CTFrameRef _frame;
}

@property(nonatomic, strong)NSMutableAttributedString *attributeStr;

@end

@implementation AttStrView

- (instancetype)initWithAttStr:(NSMutableAttributedString *)attributeStr{
    if (self = [super init]) {
        self.attributeStr = attributeStr;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // 屏幕坐标系转换为系统坐标系
    CGContextRef context = UIGraphicsGetCurrentContext();           // 获取图形上下文
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // 生成文字区域frame
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributeStr);
    // 绘制区域
    CGMutablePathRef path = CGPathCreateMutable();
    
    // 绘制尺寸
    CGPathAddRect(path, NULL, self.bounds);
    
    // 富文本长度
    NSInteger length = self.attributeStr.length;
    
    // 根据绘制区域及富文本，设置frame，该frame只是富文本的frame
    _frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, length), path, NULL);
    // 根据frame绘制文字
    CTFrameDraw(_frame, context);
    
    // CFRelease(_frame);
    CFRelease(path);
    CFRelease(frameSetter);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint location = [self systemPointFromScreenPoint:[touch locationInView:self]];
    [self ClickStrAtPoint:location];
    [super touchesBegan:touches withEvent:event];
}

- (void)ClickStrAtPoint:(CGPoint)location
{
    NSArray * lines = (NSArray *)CTFrameGetLines(_frame);
    CFRange ranges[lines.count];
    CGPoint origins[lines.count];
    CTFrameGetLineOrigins(_frame, CFRangeMake(0, 0), origins);
    
    for (int i = 0; i < lines.count; i ++) {
        CTLineRef line = (__bridge CTLineRef)lines[i];
        CFRange range = CTLineGetStringRange(line);
        ranges[i] = range;
    }
    
    for (int i = 0; i < self.attributeStr.length; i ++) {
        long maxLoc;
        int lineNum;
        for (int j = 0; j < lines.count; j ++) {
            CFRange range = ranges[j];
            maxLoc = range.location + range.length - 1;
            if (i <= maxLoc) {
                lineNum = j;
                break;
            }
        }
        CTLineRef line = (__bridge CTLineRef)lines[lineNum];
        CGPoint origin = origins[lineNum];
        CGRect CTRunFrame = [self frameForCTRunWithIndex:i CTLine:line origin:origin];
        if ([self isFrame:CTRunFrame containsPoint:location]) {
            // 点击到了文字
            if ([self.delegate respondsToSelector:@selector(ClickStrAtIndex:)]) {
                [self.delegate ClickStrAtIndex:i];
                return;
            }
            else if ([self.delegate respondsToSelector:@selector(ClickStrAtIndex:attStrView:)])
            {
                [self.delegate ClickStrAtIndex:i attStrView:self];
                return;
            }
            return;
        }
    }
}

- (BOOL)isIndex:(NSInteger)index inRange:(NSRange)range
{
    if ((index <= range.location + range.length - 1) && (index >= range.location)) {
        return YES;
    }
    return NO;
}

- (CGPoint)systemPointFromScreenPoint:(CGPoint)origin
{
    return CGPointMake(origin.x, self.bounds.size.height - origin.y);
}

- (BOOL)isFrame:(CGRect)frame containsPoint:(CGPoint)point
{
    return CGRectContainsPoint(frame, point);
}

- (CGRect)frameForCTRunWithIndex:(NSInteger)index CTLine:(CTLineRef)line origin:(CGPoint)origin
{
    CGFloat offsetX = CTLineGetOffsetForStringIndex(line, index, NULL);
    CGFloat offsexX2 = CTLineGetOffsetForStringIndex(line, index + 1, NULL);
    offsetX += origin.x;
    offsexX2 += origin.x;
    CGFloat offsetY = origin.y;
    CGFloat lineAscent;
    CGFloat lineDescent;
    NSArray * runs = (__bridge NSArray *)CTLineGetGlyphRuns(line);
    CTRunRef runCurrent;
    for (int k = 0; k < runs.count; k ++) {
        CTRunRef run = (__bridge CTRunRef)runs[k];
        CFRange range = CTRunGetStringRange(run);
        NSRange rangeOC = NSMakeRange(range.location, range.length);
        if ([self isIndex:index inRange:rangeOC]) {
            runCurrent = run;
            break;
        }
    }
    CTRunGetTypographicBounds(runCurrent, CFRangeMake(0, 0), &lineAscent, &lineDescent, NULL);
    CGFloat height = lineAscent + lineDescent;
    return CGRectMake(offsetX, offsetY, offsexX2 - offsetX, height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
