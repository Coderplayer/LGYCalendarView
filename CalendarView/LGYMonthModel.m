//
//  LGYMonthModel.m
//  LGYCalendarView
//
//  Created by LGY on 2020/3/5.
//  Copyright © 2020 LGY. All rights reserved.
//

#import "LGYMonthModel.h"
@implementation LGYDayModel
- (instancetype)initWithDayNum:(NSInteger)dayNum monthType:(LGYDayModelMonthType)monthType {
    if (self = [super init]) {
        self.dayNum = dayNum;
        self.monthType = monthType;
    }
    return self;
}
@end


@interface LGYMonthModel ()
/// 日历
@property (nonatomic, strong) NSCalendar *calendar;
/// 当月日期有几行
@property (nonatomic, assign) NSInteger dateRows;
/// 数据源第一个对应的日期
@property (nonatomic, strong) NSDate *firstDateOfDayModels;

/// 上个月出现在本月的天数
@property (nonatomic, assign) NSInteger lastMonthsPlaceDayCount;
/// 本月有几天
@property (nonatomic, assign) NSInteger currentMonthsDayCount;
/// 下个月出现在本月的天数
@property (nonatomic, assign) NSInteger nextMonthsPlaceDayCount;
@end

@implementation LGYMonthModel
- (instancetype)init {
    if (self = [super init]) {
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        _calendar.locale = [NSLocale currentLocale];
        _calendar.timeZone = [NSTimeZone defaultTimeZone];
        _calendar.firstWeekday = 1;
    }
    return self;
}

- (void)setDisplayMonth:(NSDate *)displayMonth {
    _displayMonth = displayMonth;
    [self cacluateMonthDatas];
}

/// 计算月份相关数据
- (void)cacluateMonthDatas {

    NSInteger currentMonthDaysCount = [self.calendar lgy_numberOfdaysInMonth:_displayMonth];
    _currentMonthDaysCount = currentMonthDaysCount;
    
    NSDate *firstDateOfMonth = [self.calendar lgy_firstDayOfMonth:_displayMonth];
    NSInteger firstDayWeekIndex = [self.calendar lgy_weekIndexOfDate:firstDateOfMonth];
    NSInteger lastMonthPlaceCount = (firstDayWeekIndex + 7 - self.calendar.firstWeekday) % 7;
    _lastMonthPlaceDaysCount = lastMonthPlaceCount;
    
    _firstDateOfDayModels = firstDateOfMonth;
    
    NSMutableArray *dayModels = [[NSMutableArray alloc] init];
    if (lastMonthPlaceCount) {
        _firstDateOfDayModels = [self.calendar dateByAddingUnit:NSCalendarUnitDay value:-lastMonthPlaceCount toDate:firstDateOfMonth options:0];
        NSInteger lastMonthDayCount = [self.calendar lgy_numberOfdaysInLastMonth:_displayMonth];
        for (NSInteger i = lastMonthPlaceCount - 1; i >= 0; i --) {
            LGYDayModel *day = [[LGYDayModel alloc] initWithDayNum:lastMonthDayCount - i monthType:LGYDayModelMonthTypeLast];
            [dayModels addObject:day];
        }
    }
    
    for (NSInteger i = 1; i <= currentMonthDaysCount; i ++) {
        LGYDayModel *day = [[LGYDayModel alloc] initWithDayNum:i monthType:LGYDayModelMonthTypeCurrent];
        [dayModels addObject:day];
    }
    
    
    _nextMonthPlaceDaysCount = 0;
    if (dayModels.count % 7) {
        NSInteger nextMonthPlaceCount = 7 - (dayModels.count % 7);
        _nextMonthPlaceDaysCount = nextMonthPlaceCount;
        if (nextMonthPlaceCount) {
            for (NSInteger i = 1; i <= nextMonthPlaceCount; i ++) {
                LGYDayModel *day = [[LGYDayModel alloc] initWithDayNum:i monthType:LGYDayModelMonthTypeNext];
                [dayModels addObject:day];
            }
        }
    }

    self.dayModels = [dayModels copy];
    self.dateRows = dayModels.count / 7;
}

- (NSDate *)dateAtIndex:(NSInteger)index {
    if (index < self.dayModels.count) {
        return [self.calendar dateByAddingUnit:NSCalendarUnitDay value:index toDate:_firstDateOfDayModels options:0];
    }else {
        return nil;
    }
}

@end
