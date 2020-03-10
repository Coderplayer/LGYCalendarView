//
//  NSCalendar+LGYCate.m
//  LGYCalendarView
//
//  Created by LGY on 2020/3/5.
//  Copyright © 2020 LGY. All rights reserved.
//

#import "NSCalendar+LGYCate.h"

@implementation NSCalendar (LGYCate)
- (NSDate *)lgy_firstDayOfMonth:(NSDate *)month {
    if (!month) return nil;
    NSDateComponents *components = [self components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:month];
    components.day = 1;
    return [self dateFromComponents:components];
}

- (NSDate *)lgy_lastDayOfMonth:(NSDate *)month {
    if (!month) return nil;
    NSDateComponents *components = [self components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:month];
    components.month++;
    components.day = 0;
    return [self dateFromComponents:components];
}

- (NSInteger)lgy_numberOfdaysInMonth:(NSDate *)month {
    if (!month) return 0;
    NSRange days = [self rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:month];
    return days.length;
}

- (NSInteger)lgy_numberOfdaysInLastMonth:(NSDate *)month {
    if (!month) return 0;
    NSDateComponents *components = [self components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:month];
    components.month--;
    components.day = 1;
    NSDate *lastDateOfLastMonth = [self dateFromComponents:components];
    NSRange days = [self rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:lastDateOfLastMonth];
    return days.length;
}

- (NSInteger)lgy_weekIndexOfDate:(NSDate *)date {
    if (!date) { return NSNotFound;}
    
    NSDateComponents *components = [self components:NSCalendarUnitWeekday fromDate:date];
    return components.weekday;
}


- (NSDate *)lgy_firstDateOfLastMonthReferedMonth:(NSDate *)month {
    if (!month) return nil;
    NSDateComponents *components = [self components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:month];
    components.month--;
    components.day = 1;
    return [self dateFromComponents:components];
}

- (NSDate *)lgy_firstDateOfNextMonthReferedMonth:(NSDate *)month {
    if (!month) return 0;
    NSDateComponents *components = [self components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:month];
    components.month++;
    components.day = 1;
    return [self dateFromComponents:components];
}

- (NSString *)lgy_yearMonthDescributionOfDate:(NSDate *)date {
    if (!date) {
        return @"";
    }
    NSDateComponents *components = [self components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
    NSString *desc = [NSString stringWithFormat:@"%zd年%zd月",components.year,components.month];
    return desc;
}
@end
