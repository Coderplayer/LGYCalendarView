//
//  LGYCalendarWeekdayView.m
//  LGYCalendarView
//
//  Created by LGY on 2020/3/4.
//  Copyright © 2020 LGY. All rights reserved.
//

#import "LGYCalendarWeekdayView.h"
@interface LGYCalendarWeekdayView ()
/// weekdayLabels
@property (nonatomic, strong) NSPointerArray *labelPointers;
@end

@implementation LGYCalendarWeekdayView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _weekdayFont = [UIFont systemFontOfSize:14];
        _weekdayColor = [UIColor blackColor];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    _labelPointers = [NSPointerArray weakObjectsPointerArray];
    _weekdayTitles = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    for (NSInteger i = 0; i < 7; i ++) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        [_labelPointers addPointer:(__bridge void *)label];
    }
    
    [self configureAppearance];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = self.bounds.size;
    CGFloat contentWidth = size.width - self.contentInserts.left - self.contentInserts.right;
    CGFloat labelWidth = contentWidth / self.labelPointers.count;
    CGFloat labelHeight = size.height - self.contentInserts.top - self.contentInserts.bottom;
    for (NSInteger i = 0; i < self.labelPointers.count; i ++) {
        UILabel *label = [self.labelPointers pointerAtIndex:i];
        label.frame = CGRectMake(self.contentInserts.left + i * labelWidth, self.contentInserts.top, labelWidth, labelHeight);
    }
}

- (NSArray<UILabel *> *)weekdayLabels {
    return _labelPointers.allObjects;
}

- (void)setWeekdayFont:(UIFont *)weekdayFont {
    _weekdayFont = weekdayFont;
    [self configureAppearance];
}

- (void)setWeekdayColor:(UIColor *)weekdayColor {
    _weekdayColor = weekdayColor;
    [self configureAppearance];
}

- (void)setWeekdayTitles:(NSArray *)weekdayTitles {
    if (weekdayTitles.count != self.labelPointers.count) {
        NSLog(@"一周七天，当前提供的weekdayTitles数目不等于7");
        return;
    }
    _weekdayTitles = weekdayTitles;
    [self configureAppearance];
}

- (void)setContentInserts:(UIEdgeInsets)contentInserts {
    _contentInserts = contentInserts;
    [self setNeedsLayout];
}

- (void)setCalendar:(NSCalendar *)calendar {
    _calendar = calendar;
    [self configureAppearance];
}

- (void)configureAppearance {
    NSInteger firstWeekday = self.calendar.firstWeekday;
    for (NSInteger i = 0; i < self.labelPointers.count; i ++) {
        UILabel *label = [self.labelPointers pointerAtIndex:i];
        label.font = _weekdayFont;
        label.textColor = _weekdayColor;
        NSInteger weekdayIndex = (i + 7 + firstWeekday - 2) % 7;
        label.text = [_weekdayTitles objectAtIndex:weekdayIndex];
    }
}

- (NSString *)weekdayTitleOfColumn:(NSInteger)column {
    if (column < self.labelPointers.count && column >= 0) {
        NSInteger firstWeekday = self.calendar.firstWeekday;
        NSInteger weekdayIndex = (column + 7 + firstWeekday - 2) % 7;
        return [_weekdayTitles objectAtIndex:weekdayIndex];
    }else {
        return @"";
    }
}
@end
