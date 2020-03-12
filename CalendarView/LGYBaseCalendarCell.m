//
//  LGYBaseCalendarCell.m
//  LGYCalendarView
//
//  Created by LGY on 2020/3/4.
//  Copyright © 2020 LGY. All rights reserved.
//

#import "LGYBaseCalendarCell.h"

@implementation LGYBaseCalendarCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self dateLabel];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.dateLabel.frame = self.contentView.bounds;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        UILabel *dateLabel = [[UILabel alloc] init];
        dateLabel.font = [UIFont systemFontOfSize:16];
        dateLabel.textAlignment = NSTextAlignmentCenter;
        dateLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:dateLabel];
        _dateLabel = dateLabel;
    }
    return _dateLabel;
}
@end
