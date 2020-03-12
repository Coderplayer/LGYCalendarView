//
//  ViewController.m
//  LGYCalendarView
//
//  Created by LGY on 2020/3/4.
//  Copyright © 2020 LGY. All rights reserved.
//

#import "ViewController.h"
#import "LGYCalendarView.h"
#import "LGYMonthModel.h"
#import <WebKit/WebKit.h>
@interface ViewController ()<LGYCalendarViewDataSource,LGYCalendarViewDelegate,UITableViewDelegate,UITableViewDataSource>
/// calendarView
@property (nonatomic, strong) LGYCalendarView *calendarView;
/// 年月
@property (nonatomic, strong) UILabel *yearMonthL;

@property (nonatomic, assign) NSInteger selectIndex;
/// tableView
@property (nonatomic, strong) UITableView *tableView;

/// webView
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, assign) NSInteger scope;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.selectIndex = NSNotFound;
//    LGYCalendarWeekdayView *appear = [LGYCalendarWeekdayView appearance];
//    appear.weekdayFont = [UIFont systemFontOfSize:12];
//    appear.weekdayColor = [UIColor redColor];
//    LGYCalendarWeekdayView *weekView = [[LGYCalendarWeekdayView alloc] init];
//    weekView.frame = CGRectMake(0, 50, self.view.bounds.size.width, 50);
//    [self.view addSubview:weekView];
    
    CGSize size = self.view.bounds.size;
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 150, 50)];
    dateLabel.text = @"2020年3月";
    dateLabel.textColor = [UIColor blackColor];
    dateLabel.font = [UIFont boldSystemFontOfSize:25];
    [self.view addSubview:dateLabel];
    _yearMonthL = dateLabel;
    
    UIButton *previous = [[UIButton alloc] init];
    previous.tag = LGYDayModelMonthTypeLast;
    [previous addTarget:self action:@selector(changeMonth:) forControlEvents:UIControlEventTouchUpInside];
    [previous setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    previous.titleLabel.font = [UIFont systemFontOfSize:25];
    [previous setTitle:@"<" forState:UIControlStateNormal];
    previous.frame = CGRectMake(170, 50, 50, 50);
    [self.view addSubview:previous];
    
    UIButton *next = [[UIButton alloc] init];
    [next setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    next.tag = LGYDayModelMonthTypeNext;
    [next addTarget:self action:@selector(changeMonth:) forControlEvents:UIControlEventTouchUpInside];
    next.titleLabel.font = [UIFont systemFontOfSize:25];
    [next setTitle:@">" forState:UIControlStateNormal];
    next.frame = CGRectMake(230, 50, 50, 50);
    [self.view addSubview:next];
    
    
    [self.view addSubview:previous];
    
    
    
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(320, 50, 60, 50);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"今天" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor greenColor];
    [button addTarget:self action:@selector(today) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    NSString *str = @"2020-03-01";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [formatter dateFromString:str];
    
    
    LGYCalendarView *calendar = [[LGYCalendarView alloc] init];
    calendar.displayMonth = [NSDate date];
    calendar.minDate = date;
    calendar.maxDate = [formatter dateFromString:@"2021-12-01"];
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.dateHeight = 36;
    calendar.dateRowSpacing = 5;
    calendar.firstWeekday = 1;
    calendar.weekdayTitles = @[@"Mon",@"Tue",@"Wen",@"Thu",@"Fri",@"Sat",@"Sun"];
//    calendar.monthInsert = UIEdgeInsetsMake(5, 0, 5, 0);
    CGFloat height = [calendar estimateCalendarViewHeight];
    calendar.frame = CGRectMake(0, 100, self.view.bounds.size.width, height);
    [self.view addSubview:calendar];
    self.calendarView = calendar;
    
    CGFloat y = CGRectGetMaxY(calendar.frame);
    self.tableView.frame= CGRectMake(0, y, size.width, size.height - y);
    
    
//    UIButton *pickUp = [[UIButton alloc] initWithFrame:CGRectMake(0, 400, self.view.bounds.size.width, 50)];
//    pickUp.backgroundColor = [UIColor greenColor];
//    [pickUp addTarget:self action:@selector(pickup:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:pickUp];
    
    // 1583398631.6343679      BJ: 4:57     NY 3:57
    
//    NSTimeInterval stmp = [[NSDate date] timeIntervalSince1970];
    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:1583398631.6343679];
//    NSTimeZone *zone = [NSTimeZone timeZoneForSecondsFromGMT:7 * 3600];
//    formatter.timeZone = zone;
//    NSString *str = [formatter stringFromDate:date];
//    NSLog(@"---------%@",str);
    
    
//
//    NSArray *strs = @[@"2020-03-01",@"2020-03-02",@"2020-03-03",@"2020-03-04",@"2020-03-05",@"2020-03-06",@"2020-04-07"];
//    NSArray *weeks = @[@"五",@"六",@"日",@"一",@"二",@"三",@"四"];
//    LGYMonthModel *month = [[LGYMonthModel alloc] init];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.calendar = month.calendar;
//    formatter.dateFormat = @"yyyy-MM-dd";
//    for (NSString *str in strs) {
//        NSDate *date = [formatter dateFromString:str];
////        NSLog(@"%@星期%zd",str,[month.calendar lgy_weekIndexOfDate:date]);
//        NSInteger index = [month.calendar lgy_weekIndexOfDate:date];
//        NSInteger first = month.calendar.firstWeekday;
//        NSInteger i = (index + 7 - first) % 7;
////        NSLog(@"%@星期%@---index:%zd first:%zd",str,weeks[i],index,first);
//    }
    
    
//    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 44, size.width, size.height)];
//    NSURL *url = [[NSURL alloc] initWithString:@"https://class.krhanedu.cn/apph5"];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
//    [self.view addSubview:self.webView];
}

- (void)today {
    self.calendarView.displayMonth = [NSDate date];
    NSInteger todayNum = [self.calendarView.calendar component:NSCalendarUnitDay fromDate:self.calendarView.displayMonth];
    self.selectIndex = self.calendarView.lastMonthPlaceDaysCount + todayNum - 1;
    [self.calendarView refresh];
    
    NSString *yearMonth = [self.calendarView.calendar lgy_yearMonthDescributionOfDate:self.calendarView.displayMonth];
    _yearMonthL.text = yearMonth;
    
}

- (LGYBaseCalendarCell *)calendarView:(LGYCalendarView *)calendarView cellforDateAtIndex:(NSInteger)index {
    LGYBaseCalendarCell *cell = [calendarView dequeueReusableCalendarCellClass:[LGYBaseCalendarCell class] atIndex:index];
    LGYDayModel *dayModel = [calendarView dayModelAtIndex:index];
    UIColor *textColor = (dayModel.monthType == LGYDayModelMonthTypeCurrent) ? [UIColor blackColor] : [UIColor lightGrayColor];
    if (index == self.selectIndex) {
        textColor = [UIColor redColor];
    }
    cell.dateLabel.textColor = textColor;
    cell.dateLabel.font = [UIFont systemFontOfSize:18];
    return cell;
}

- (void)calendarView:(LGYCalendarView *)calendarView willConfigWeekdayTitleLabel:(UILabel *)weekTitleLabel forWeekdayIndex:(NSInteger)weekdayIndex {
    weekTitleLabel.font = [UIFont systemFontOfSize:16];
    NSLog(@"-----%zd",weekdayIndex);
    if (weekdayIndex == 1 || weekdayIndex == 7) {
        weekTitleLabel.textColor = [UIColor lightGrayColor];
    }else {
        weekTitleLabel.textColor = [UIColor blackColor];
    }
    
}

- (void)calendarView:(LGYCalendarView *)calendarView didSelectDayModel:(nonnull LGYDayModel *)dayModel atIndex:(NSInteger)index {
    if (dayModel.monthType == LGYDayModelMonthTypeCurrent) {
        self.selectIndex = index;
        [calendarView refresh];
    }else {
        BOOL canShow = [self chageMonthWithType:dayModel.monthType];
        if (canShow) {
            self.selectIndex = dayModel.dayNum + self.calendarView.lastMonthPlaceDaysCount - 1;
            [self.calendarView refresh];
        }
    }
    NSLog(@"%@",dayModel.weekdayTitle);
}


- (BOOL)chageMonthWithType:(LGYDayModelMonthType)monthType {
    if (monthType != LGYDayModelMonthTypeCurrent) {
        BOOL canShow = NO;
        if (monthType == LGYDayModelMonthTypeNext) {
            canShow = [self.calendarView nextMonth];
        }else {
            canShow = [self.calendarView lastMonth];
        }
        
        if (!canShow) {
            return canShow;
        }
        
        if (self.calendarView.scopeType == LGYCalendarViewScopeMonth) {
            CGFloat height = [self.calendarView estimateCalendarViewHeight];
            CGRect rect = self.calendarView.frame;
            rect.size.height = height;
            CGSize size = self.view.bounds.size;
            CGFloat maxY = CGRectGetMaxY(rect);
            [UIView animateWithDuration:0.25 animations:^{
                self.calendarView.frame = rect;
                self.tableView.frame = CGRectMake(0, maxY, size.width, size.height - maxY);
            }];
            
            [UIView animateWithDuration:0.25 animations:^{
               self.calendarView.frame = CGRectMake(0, 100, self.view.bounds.size.width, height);
            }];
        }
        NSString *yearMonth = [self.calendarView.calendar lgy_yearMonthDescributionOfDate:self.calendarView.displayMonth];
        _yearMonthL.text = yearMonth;
    }
    return YES;
}

- (void)changeMonth:(UIButton *)btn {
    self.selectIndex = NSNotFound;
    [self chageMonthWithType:btn.tag];
}


#pragma mark - <UITableViewDelegate,UITableViewDataSource>>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"section-%zd row-%zd",indexPath.section,indexPath.row];
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    LGYCalendarViewScopeType type = offset > 0 ? LGYCalendarViewScopeWeek : LGYCalendarViewScopeMonth;
    if (_scope != type) {
        _scope = type;
        
        [self.calendarView setScopeType:type toIndex:self.selectIndex];
        CGRect rect = self.calendarView.frame;
        rect.size.height = [self.calendarView estimateCalendarViewHeight];
        CGFloat maxY = CGRectGetMaxY(rect);
        CGSize size = self.view.bounds.size;
        
        [UIView animateWithDuration:0.25 animations:^{
            self.calendarView.frame = rect;
            self.tableView.frame = CGRectMake(0, maxY, size.width, size.height - maxY);
        }];
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] init];
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
        tableView.rowHeight = 40;
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}

@end



//- (void)pickup:(UIButton *)btn {
//    btn.selected = !btn.selected;
//
//    CGRect rect = self.calendarView.frame;
//    CGFloat scopeH = [self.calendarView estimateCalendarViewHeightWithScopeType:LGYCalendarViewScopeWeek];
//    CGFloat openH = [self.calendarView estimateCalendarViewHeightWithScopeType:LGYCalendarViewScopeMonth];
//    rect.size.height = btn.selected ? scopeH : openH;
//    CGFloat maxY = CGRectGetMaxY(rect);
//    CGSize size = self.view.bounds.size;
//    LGYCalendarViewScopeType scopeType = btn.selected ? LGYCalendarViewScopeWeek : LGYCalendarViewScopeMonth;
////    if (scopeType == LGYCalendarViewScopeMonth) {
////        self.calendarView.scopeType = btn.selected;
////    }
//    [UIView animateWithDuration:0.25 animations:^{
//        self.calendarView.frame = rect;
//        self.tableView.frame = CGRectMake(0, maxY, size.width, size.height - maxY);
//    } completion:^(BOOL finished) {
////        if (scopeType == LGYCalendarViewScopeWeek) {
//            self.calendarView.scopeType = btn.selected;
////        }
//    }];
//}
