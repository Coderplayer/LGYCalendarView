//
//  NSCalendar+LGYCate.h
//  LGYCalendarView
//
//  Created by LGY on 2020/3/5.
//  Copyright © 2020 LGY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSCalendar (LGYCate)
/// 日期对应月份的第一天
- (nullable NSDate *)lgy_firstDayOfMonth:(NSDate *)month;
/// 日期对应月份的最后一天
- (nullable NSDate *)lgy_lastDayOfMonth:(NSDate *)month;
/// 日期对应月份有几天
- (NSInteger)lgy_numberOfdaysInMonth:(NSDate *)month;
/// 当前月对应上一个月有几天
- (NSInteger)lgy_numberOfdaysInLastMonth:(NSDate *)month;
/// 日期对应的星期索引
- (NSInteger)lgy_weekIndexOfDate:(NSDate *)date;
/// 根据参照日期所在的月份推算上个月的第一天日期
- (NSDate *)lgy_firstDateOfLastMonthReferedMonth:(NSDate *)month;

/// 根据参照日期所在的月份推算下个月的第一天日期
/// @param month 可以为当月任意日期
/// @return 下个月的第一天
- (NSDate *)lgy_firstDateOfNextMonthReferedMonth:(NSDate *)month;

- (NSString *)lgy_yearMonthDescributionOfDate:(NSDate *)date;
@end

NS_ASSUME_NONNULL_END
