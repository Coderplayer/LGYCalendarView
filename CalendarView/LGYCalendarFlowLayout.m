//
//  LGYCalendarFlowLayout.m
//  LGYCalendarView
//
//  Created by LGY on 2020/3/6.
//  Copyright © 2020 LGY. All rights reserved.
//

#import "LGYCalendarFlowLayout.h"

@interface LGYCalendarFlowLayout ()
@property (assign, nonatomic) CGSize contentSize;
/// 布局属性
@property (nonatomic, strong) NSMutableArray *allAttributes;
@end

@implementation LGYCalendarFlowLayout
- (void)prepareLayout {
    self.allAttributes = [NSMutableArray array];
    //获取section的数量
    NSUInteger section = [self.collectionView numberOfSections];

    CGSize collectionSize = self.collectionView.bounds.size;
    for (int sec = 0; sec < section; sec++) {
        //获取每个section的cell个数
        NSUInteger count = [self.collectionView numberOfItemsInSection:sec];
        NSInteger rows = count / 7;
        CGFloat height = self.sectionInset.top + self.sectionInset.bottom; //基准高度
        if (self.scopeType == LGYCalendarViewScopeMonth) {
            height += self.itemSize.height * rows + self.minimumLineSpacing * (rows - 1);
            self.contentSize = CGSizeMake(collectionSize.width, height);
        }else {
            height += self.itemSize.height;
            self.contentSize = CGSizeMake(collectionSize.width * rows, height);
        }
        for (NSUInteger item = 0; item<count; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:sec];
            //重新排列
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            [self.allAttributes addObject:attributes];
        }
    }
    
}
- (CGSize)collectionViewContentSize {
    return self.contentSize;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = (indexPath.item) / 7;
    NSInteger column = indexPath.item % 7;
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    if (self.scopeType == LGYCalendarViewScopeMonth) {
        CGFloat x = self.sectionInset.left + self.itemSize.width * column;
        CGFloat y = self.sectionInset.top + (self.itemSize.height + self.minimumLineSpacing) * row;
        attr.frame = CGRectMake(x, y, self.itemSize.width, self.itemSize.height);
    }else {
        CGFloat x = self.sectionInset.left + self.itemSize.width * column + row * self.collectionView.bounds.size.width;
        CGFloat y = self.sectionInset.top;
        attr.frame = CGRectMake(x, y, self.itemSize.width, self.itemSize.height);
    }
    
    return attr;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.allAttributes;
}

@end
