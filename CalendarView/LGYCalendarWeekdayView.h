//
//  LGYCalendarWeekdayView.h
//  LGYCalendarView
//
//  Created by LGY on 2020/3/4.
//  Copyright © 2020 LGY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class LGYCalendarWeekdayView;
@protocol LGYCalendarWeekdayViewDataSource <NSObject>
- (void)calendarWeekdayView:(LGYCalendarWeekdayView *)weekView willConfigWeekdayTitleLabel:(UILabel *)weekTitleLabel forWeekdayIndex:(NSInteger)weekdayIndex;
@end

@interface LGYCalendarWeekdayView : UIView
/// 数据源
@property (nonatomic, weak) id<LGYCalendarWeekdayViewDataSource> dataSource;

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
