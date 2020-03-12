//
//  LGYCalendarView.h
//  LGYCalendarView
//
//  Created by LGY on 2020/3/4.
//  Copyright © 2020 LGY. All rights reserved.
//

#import "LGYBaseCalendarCell.h"
#import "LGYMonthModel.h"
#import "LGYCalendarFlowLayout.h"
NS_ASSUME_NONNULL_BEGIN

@class LGYCalendarView;

@protocol LGYCalendarViewDataSource <NSObject>
@optional
- (LGYBaseCalendarCell *)calendarView:(LGYCalendarView *)calendarView cellforDateAtIndex:(NSInteger)index;
- (void)calendarView:(LGYCalendarView *)calendarView willDisplayDateCell:(LGYBaseCalendarCell *)dateCell forDateAtIndex:(NSInteger)index;

/// 配置日历的头部 即星期视图中label的相关属性字体、颜色
/// @param calendarView 日历控件
/// @param weekTitleLabel 星期视图中的一个label
/// @param weekdayIndex  该label对应星期的索引，与系统一致 周日：1，周一：2，....... 周六：7
- (void)calendarView:(LGYCalendarView *)calendarView willConfigWeekdayTitleLabel:(UILabel *)weekTitleLabel forWeekdayIndex:(NSInteger)weekdayIndex;
@end

@protocol LGYCalendarViewDelegate <NSObject>
@optional
- (void)calendarView:(LGYCalendarView *)calendarView didSelectDayModel:(LGYDayModel *)dayModel atIndex:(NSInteger)index;
@end

@interface LGYCalendarView : UIView
/// 日历模式<周/月>
@property (nonatomic, assign)  LGYCalendarViewScopeType scopeType;
/// 数据源
@property (nonatomic, weak) id <LGYCalendarViewDataSource> dataSource;
/// 数据源
@property (nonatomic, weak) id <LGYCalendarViewDelegate> delegate;
/// 每周第一天的索引
@property (nonatomic, assign) NSInteger firstWeekday;
/// 日历
@property (nonatomic, strong, readonly) NSCalendar *calendar;
/// 当前展示月份<该属性可以为当月任意一天>,设置该属性前确保属性calendar的设置已完成
@property (nonatomic, strong) NSDate *displayMonth;
/// 日历头部星期视图的高度
@property (nonatomic, assign) NSInteger weekViewHeight;
/// 星期视图对应的星期文字
@property (nonatomic, copy) NSArray<NSString *> *weekdayTitles;
/// date行与行之间间距
@property (nonatomic) CGFloat dateRowSpacing;
/// dateSize
@property (nonatomic) CGFloat  dateHeight;
/// 是否只显示当前月份日期 <默认会计算显示上个月和下个月的站位日期>
@property (nonatomic, assign) BOOL onlyShowCurrentMonthDate;
/// 日历可以展示的最小日期
@property (nonatomic, strong) NSDate *minDate;
/// 日历可以展示的最大日期
@property (nonatomic, strong) NSDate *maxDate;
/// 上个月出现在本月的天数
@property (nonatomic, assign, readonly) NSInteger lastMonthPlaceDaysCount;
/// 本月有几天
@property (nonatomic, assign, readonly) NSInteger currentMonthDaysCount;
/// 下个月出现在本月的天数
@property (nonatomic, assign, readonly) NSInteger nextMonthPlaceDaysCount;

/// 注册日历控件中日期cell
- (void)registeCalendarCellClass:(nonnull Class)calendarCellClass;
/// 根据日期模型返回期cell
- (__kindof LGYBaseCalendarCell *)dequeueReusableCalendarCellClass:(Class)calendarCellClass atIndex:(NSInteger)index;

/// 根据相日历关设置估算日历控件的高度
- (CGFloat)estimateCalendarViewHeight;

/// 展示上一个月
/// @return 是否是可以显示上月日期信息<可能超过显示日期下限>
- (BOOL)lastMonth;

/// 展示下一个月
/// @return 是否是可以显示下月日期信息<可能超过显示日期上限>
- (BOOL)nextMonth;

/// 索引index对应天模型,注意这是日历数据源中模型，你只能访问改模型中的属性
/// @param index 模型索引
/// @return 天模型
- (nullable LGYDayModel *)dayModelAtIndex:(NSInteger)index;

/// 索引对应的日期
- (nullable NSDate *)dateAtIndex:(NSInteger)index;

/// 索引对应的星期标签
- (NSString *)weekdayTitleAtIndex:(NSInteger)index;

/// 点击制定索引的的日期，这个方法会调用calendarView:didSelectDayModel:atIndex:
- (void)clickDateAtIndex:(NSInteger)index;

/// 刷新日期
- (void)refresh;

/// 设置日历显示模式并滚动日历
- (void)setScopeType:(LGYCalendarViewScopeType)scopeType toIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
