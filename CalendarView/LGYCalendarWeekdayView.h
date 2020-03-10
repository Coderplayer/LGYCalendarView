//
//  LGYCalendarWeekdayView.h
//  LGYCalendarView
//
//  Created by LGY on 2020/3/4.
//  Copyright © 2020 LGY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//static NSInteger const kLGYPerWeekDaysCount = 7;

@interface LGYCalendarWeekdayView : UIView
/// weekdayFont
@property (nonatomic, strong) UIFont *weekdayFont;
/// weekdayColor
@property (nonatomic, strong) UIColor *weekdayColor;
/// weekdayLabels
@property (nonatomic, strong, readonly) NSArray <UILabel *>*weekdayLabels;
/// weekdayTitles
@property (nonatomic, copy) NSArray<NSString *> *weekdayTitles;
/// contentInserts
@property (nonatomic, assign) UIEdgeInsets contentInserts;
/// 引用日历
@property (nonatomic, weak) NSCalendar *calendar;
/// 更新weekView
- (void)configureAppearance;
/// 列对应的星期
- (NSString *)weekdayTitleOfColumn:(NSInteger)column;
@end

NS_ASSUME_NONNULL_END
