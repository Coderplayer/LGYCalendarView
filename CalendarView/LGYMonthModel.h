//
//  LGYMonthModel.h
//  LGYCalendarView
//
//  Created by LGY on 2020/3/5.
//  Copyright © 2020 LGY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSCalendar+LGYCate.h"
NS_ASSUME_NONNULL_BEGIN



typedef NS_ENUM(NSUInteger, LGYDayModelMonthType) {
    /// 上个月
    LGYDayModelMonthTypeLast,
    /// 本月
    LGYDayModelMonthTypeCurrent,
    /// 下个月
    LGYDayModelMonthTypeNext
};
@interface LGYDayModel : NSObject
/// 对应天的阳历数字
@property (nonatomic, assign) NSInteger dayNum;
/// 该日期所属月份类型
@property (nonatomic, assign) LGYDayModelMonthType monthType;
/// 对应的日期
@property (nonatomic, strong) NSDate *date;
/// 对应星期几
@property (nonatomic, copy) NSString *weekdayTitle;
/// 初始化方法
- (instancetype)initWithDayNum:(NSInteger)dayNum monthType:(LGYDayModelMonthType)monthType;
@end




@interface LGYMonthModel : NSObject
/// 日历
@property (nonatomic, strong, readonly) NSCalendar *calendar;
/// 当前展示月份<该属性可以为当月任意一天>
@property (nonatomic, strong) NSDate *displayMonth;
/// 当月日期有几行
@property (nonatomic, assign, readonly) NSInteger dateRows;
/// 上个月出现在本月的天数
@property (nonatomic, assign, readonly) NSInteger lastMonthPlaceDaysCount;
/// 本月有几天
@property (nonatomic, assign, readonly) NSInteger currentMonthDaysCount;
/// 下个月出现在本月的天数
@property (nonatomic, assign, readonly) NSInteger nextMonthPlaceDaysCount;
/// 当前余份包含的日期模型<包含前一个和后一个月出现在当月的日期>
@property (nonatomic, copy) NSArray <LGYDayModel *> *dayModels;
/// 索引index对应的日期
- (NSDate *)dateAtIndex:(NSInteger)index;
/// 重新计算该月日期信息
- (void)cacluateMonthDatas;
@end

NS_ASSUME_NONNULL_END
