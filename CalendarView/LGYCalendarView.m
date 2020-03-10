//
//  LGYCalendarView.m
//  LGYCalendarView
//
//  Created by LGY on 2020/3/4.
//  Copyright © 2020 LGY. All rights reserved.
//

#import "LGYCalendarView.h"
#import "LGYCalendarWeekdayView.h"
#import "LGYMonthModel.h"


@interface LGYCalendarView ()<UICollectionViewDelegate,UICollectionViewDataSource,LGYCalendarWeekdayViewDataSource>
/// weekView
@property (nonatomic, strong)LGYCalendarWeekdayView *weekView;
/// collectionView
@property (nonatomic, strong) UICollectionView *collectionView;
/// 布局属性
@property (nonatomic, weak) LGYCalendarFlowLayout *flowLayout;
/// 月份模型
@property (nonatomic, strong) LGYMonthModel *monthModel;
/// monthInsert
@property (nonatomic) UIEdgeInsets monthInsert;
/// 是否正在执行scope animating动画
@property (nonatomic, assign) BOOL scopeAnimating;
@end

@implementation LGYCalendarView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _weekViewHeight = 30;
        _monthModel = [[LGYMonthModel alloc] init];
        [self setupSubviews];
    }
    return self;
}

- (void)registeCalendarCellClass:(Class)calendarCellClass {
    if ([calendarCellClass isSubclassOfClass:[LGYBaseCalendarCell class]]) {
        NSString *identifier = [NSString stringWithFormat:@"k%@ID",NSStringFromClass(calendarCellClass)];
        [self.collectionView registerClass:calendarCellClass forCellWithReuseIdentifier:identifier];
    }else {
        NSLog(@"calendarClass should be subclass of LGYBaseCalendarCell");
    }
}

- (LGYBaseCalendarCell *)dequeueReusableCalendarCellClass:(Class)calendarCellClass atIndex:(NSInteger)index {
    if (index < self.monthModel.dayModels.count) {
        NSString *identifier = [NSString stringWithFormat:@"k%@ID",NSStringFromClass(calendarCellClass)];
        return [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    }else {
        NSAssert(NO, @"index对应的cell不存在 out of range");
        return nil;
    }
}

- (CGFloat)estimateCalendarViewHeight {
    return [self estimateCalendarViewHeightWithScopeType:_scopeType];
}

- (CGFloat)estimateCalendarViewHeightWithScopeType:(LGYCalendarViewScopeType)scopeType {
    if (scopeType == LGYCalendarViewScopeWeek) {
        return  self.weekViewHeight +
                self.monthInsert.top +
                self.monthInsert.bottom +
                self.dateHeight;
    }else {
        NSInteger dateRows = self.monthModel.dateRows;
        return  self.weekViewHeight +
                self.monthInsert.top +
                self.monthInsert.bottom +
                self.dateHeight * dateRows +
                self.dateRowSpacing * (dateRows - 1);
    }
}

- (BOOL)nextMonth {
    NSDate *nextMonth = [self.calendar lgy_firstDateOfNextMonthReferedMonth:self.displayMonth];
    if (_maxDate) {
        NSDateComponents *nextComponents = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:nextMonth];
        NSDateComponents *maxComponents = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:_maxDate];
        if(nextComponents.year < maxComponents.year ||
           (nextComponents.year == maxComponents.year && nextComponents.month <= maxComponents.month)) {
            self.displayMonth = nextMonth;
        }else {
            NSLog(@"超出现实上限日期%@",[self.calendar lgy_yearMonthDescributionOfDate:_maxDate]);
            return NO;
        }
    }else {
        self.displayMonth = nextMonth;
    }
    return YES;
}

- (BOOL)lastMonth {
    NSDate *lastMonth = [self.calendar lgy_firstDateOfLastMonthReferedMonth:self.displayMonth];
    if (_minDate) {
        NSDateComponents *lastComponents = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:lastMonth];
        NSDateComponents *minComponents = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:_minDate];
        if(lastComponents.year > minComponents.year ||
           (lastComponents.year == minComponents.year && lastComponents.month >= minComponents.month)) {
            self.displayMonth = lastMonth;
        }else {
            NSLog(@"超出显示下限日期%@",[self.calendar lgy_yearMonthDescributionOfDate:_minDate]);
            return NO;
        }
    }else {
        self.displayMonth = lastMonth;
    }
    return YES;
}

- (void)refresh {
    [self.collectionView reloadData];
}


- (LGYDayModel *)dayModelAtIndex:(NSInteger)index {
    if (index < self.monthModel.dayModels.count) {
        return [self.monthModel.dayModels objectAtIndex:index];
    }else {
        return nil;
    }
}
#pragma mark - <LGYCalendarWeekdayViewDataSource>
- (void)calendarWeekdayView:(LGYCalendarWeekdayView *)weekView willConfigWeekdayTitleLabel:(UILabel *)weekTitleLabel forWeekdayIndex:(NSInteger)weekdayIndex {
    if ([self.dataSource respondsToSelector:@selector(calendarView:willConfigWeekdayTitleLabel:forWeekdayIndex:)]) {
        [self.dataSource calendarView:self willConfigWeekdayTitleLabel:weekTitleLabel forWeekdayIndex:weekdayIndex];
    }
}
#pragma mark - <UICollectionViewDelegate,UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.monthModel.dayModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LGYDayModel *day = [self.monthModel.dayModels objectAtIndex:indexPath.item];
    LGYBaseCalendarCell *cell;
    if ([self.dataSource respondsToSelector:@selector(calendarView:cellforDateAtIndex:withDayModel:)]) {
        cell = [self.dataSource calendarView:self cellforDateAtIndex:indexPath.item withDayModel:day];
    }else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"kLGYBaseCalendarCellID" forIndexPath:indexPath];
    }
    cell.dateLabel.text = [NSString stringWithFormat:@"%zd",day.dayNum];
    if (_onlyShowCurrentMonthDate && (day.monthType != LGYDayModelMonthTypeCurrent)) {
        cell.dateLabel.hidden = YES;
    }else {
        cell.dateLabel.hidden = NO;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LGYDayModel *day = [self.monthModel.dayModels objectAtIndex:indexPath.item];
    if (_onlyShowCurrentMonthDate && (day.monthType != LGYDayModelMonthTypeCurrent)) {
        return;
    }else {
        if ([self.delegate respondsToSelector:@selector(calendarView:didSelectDayModel:atIndex:)]) {
            NSDate *date = [self.monthModel dateAtIndex:indexPath.item];
            LGYDayModel *dayModel = [[LGYDayModel alloc] initWithDayNum:day.dayNum monthType:day.monthType];
            dayModel.date = date;
            dayModel.weekdayTitle = [self.weekView weekdayTitleOfColumn:indexPath.item % 7];
            [self.delegate calendarView:self didSelectDayModel:dayModel atIndex:indexPath.item];
        }
    }
}

#pragma mark - setter
- (NSCalendar *)calendar {
    return self.monthModel.calendar;
}

- (void)setFirstWeekday:(NSInteger)firstWeekday {
    self.calendar.firstWeekday = firstWeekday;
    [self.weekView configureAppearance];
    [self.monthModel cacluateMonthDatas];
    [self.collectionView reloadData];
}

- (NSInteger)firstWeekday {
    return self.calendar.firstWeekday;
}

- (void)setWeekViewHeight:(NSInteger)weekViewHeight {
    _weekViewHeight = weekViewHeight;
    [self setNeedsLayout];
}

- (void)setWeekdayTitles:(NSArray<NSString *> *)weekdayTitles {
    self.weekView.weekdayTitles = weekdayTitles;
}

- (NSArray<NSString *> *)weekdayTitles {
    return self.weekView.weekdayTitles;
}

- (void)setDateHeight:(CGFloat)dateHeight {
    _dateHeight = dateHeight;
    [self setNeedsLayout];
}

- (void)setDateRowSpacing:(CGFloat)dateRowSpacing {
    _dateRowSpacing = dateRowSpacing;
    _flowLayout.minimumLineSpacing = dateRowSpacing;
    self.monthInsert = UIEdgeInsetsMake(dateRowSpacing, 0, dateRowSpacing, 0);
    [self.collectionView reloadData];
}

- (void)setMonthInsert:(UIEdgeInsets)monthInsert {
    _monthInsert = monthInsert;
    _flowLayout.sectionInset = monthInsert;
    _weekView.contentInserts = UIEdgeInsetsMake(0, monthInsert.left, 0, monthInsert.right);
}

- (void)setOnlyShowCurrentMonthDate:(BOOL)onlyShowCurrentMonthDate {
    _onlyShowCurrentMonthDate = onlyShowCurrentMonthDate;
    [self.collectionView reloadData];
}

- (void)setDisplayMonth:(NSDate *)displayMonth {
    self.monthModel.displayMonth = displayMonth;
    [self.collectionView reloadData];
    [self.collectionView setContentOffset:CGPointZero animated:NO];
}

- (NSDate *)displayMonth {
    return self.monthModel.displayMonth;
}

- (void)setScopeType:(LGYCalendarViewScopeType)scopeType {
    if (_scopeType != scopeType) {
        _scopeType = scopeType;
        self.flowLayout.scopeType = scopeType;
        [self.collectionView reloadData];
    }
}

- (void)setScopeType:(LGYCalendarViewScopeType)scopeType toIndex:(NSInteger)index {
    self.scopeType = scopeType;
    if (self.scopeType == LGYCalendarViewScopeWeek) {
        if (index >= self.monthModel.dayModels.count || index < 0) {
            index = 0;
        }
        NSInteger row = index / 7;
        [self.collectionView setContentOffset:CGPointMake(self.collectionView.bounds.size.width * row, 0)];
    }
}

- (NSInteger)lastMonthPlaceDaysCount {
    return self.monthModel.lastMonthPlaceDaysCount;
}

- (NSInteger)currentMonthDaysCount {
    return self.monthModel.currentMonthDaysCount;
}

- (NSInteger)nextMonthPlaceDaysCount {
    return self.monthModel.nextMonthPlaceDaysCount;
}

#pragma mark - setupsubvews
- (void)setupSubviews {
    self.weekView.calendar = self.calendar;
    [self collectionView];
    [self registeCalendarCellClass:[LGYBaseCalendarCell class]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.bounds.size;
    self.weekView.frame = CGRectMake(0, 0, size.width, _weekViewHeight);
    CGFloat contentWidth = size.width - self.monthInsert.left - self.monthInsert.right - 1;
    CGFloat dateWidth = contentWidth / 7;
    
    self.flowLayout.itemSize = CGSizeMake(dateWidth, self.dateHeight);
    CGFloat calendarHeight = [self estimateCalendarViewHeightWithScopeType:LGYCalendarViewScopeMonth] - self.weekViewHeight;;
    self.collectionView.frame = CGRectMake(0, _weekViewHeight, size.width, calendarHeight);
}

- (LGYCalendarWeekdayView *)weekView {
    if (!_weekView) {
        LGYCalendarWeekdayView *weekView = [[LGYCalendarWeekdayView alloc] init];
        weekView.dataSource = self;
        [self addSubview:weekView];
        _weekView = weekView;
    }
    return _weekView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        LGYCalendarFlowLayout *flowLayout = [[LGYCalendarFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 0; // 列间距
        flowLayout.minimumLineSpacing = 0; //行间距
        _flowLayout = flowLayout;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.pagingEnabled = YES;
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [self addSubview:collectionView];
        _collectionView = collectionView;
    }
    return _collectionView;
}
@end


