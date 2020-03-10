//
//  LGYCalendarFlowLayout.h
//  LGYCalendarView
//
//  Created by LGY on 2020/3/6.
//  Copyright © 2020 LGY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LGYCalendarViewScopeType) {
    /// 月日历
    LGYCalendarViewScopeMonth,
    /// 展示一周日历
    LGYCalendarViewScopeWeek
};



/// 日历的布局属性默认只有一组即只显示一个月的数据
/// 共有两种排布方式收起状态和展开状态
@interface LGYCalendarFlowLayout : UICollectionViewFlowLayout
@property (nonatomic, assign) LGYCalendarViewScopeType scopeType;
@end

NS_ASSUME_NONNULL_END
