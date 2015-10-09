#import "VMBArrayDiff.h"


static NSArray *SolveLCS(NSArray *left, NSArray *right, VMBArrayElementComparator comparator) {
    const NSUInteger rows = left.count + 1;
    const NSUInteger cols = right.count + 1;

    NSMutableArray *solution = [NSMutableArray arrayWithCapacity:rows];
    for (NSUInteger row = 0; row < rows; row++) {
        NSMutableArray *rowArray = [NSMutableArray arrayWithCapacity:cols];
        for (NSUInteger col = 0; col < cols; col++) {
            [rowArray addObject:@0];
        }
        [solution addObject:rowArray];
    }

    for (NSUInteger row = 1; row < rows; row++) {
        for (NSUInteger col = 1; col < cols; col++) {
            NSNumber *newValue;
            if (comparator(left[row - 1], right[col - 1])) {
                newValue = @([solution[row - 1][col - 1] unsignedIntegerValue] + 1);
            } else {
                NSNumber *prevX = solution[row][col - 1];
                NSNumber *prevY = solution[row - 1][col];
                newValue = @(MAX(prevX.unsignedIntegerValue, prevY.unsignedIntegerValue));
            }

            solution[row][col] = newValue;
        }
    }

    return solution;
}

static void ChangesByDiffingArraysIter(NSArray *LCSSolution, NSArray *left, NSArray *right, NSUInteger row, NSUInteger col, NSMutableSet *acc, VMBArrayElementComparator comparator) {
    if (row > 0 && col > 0 && comparator(left[row - 1], right[col - 1])) {
        ChangesByDiffingArraysIter(LCSSolution, left, right, row - 1, col - 1, acc, comparator);
    } else if (col > 0 && (row == 0 || [LCSSolution[row][col - 1] compare:LCSSolution[row - 1][col]] != NSOrderedAscending)) {
        ChangesByDiffingArraysIter(LCSSolution, left, right, row, col - 1, acc, comparator);

        VMBArrayDiffChange *insert = [[VMBArrayDiffChange alloc] initWithChangeKind:VMBArrayDiffChangeTypeInsert
                                                                              index:col - 1];
        [acc addObject:insert];
    } else if (row > 0 && (col == 0 || [LCSSolution[row][col - 1] compare:LCSSolution[row - 1][col]] == NSOrderedAscending)) {
        ChangesByDiffingArraysIter(LCSSolution, left, right, row - 1, col, acc, comparator);

        VMBArrayDiffChange *delete = [[VMBArrayDiffChange alloc] initWithChangeKind:VMBArrayDiffChangeTypeDelete
                                                                              index:row - 1];
        [acc addObject:delete];
    }
}

#pragma mark - API

NSSet *VMBChangesByDiffingArrays(NSArray *left, NSArray *right, VMBArrayElementComparator comparator) __attribute__((overloadable)) {
    if (comparator == nil) {
        comparator = ^(id a, id b) {
            return [a isEqual:b];
        };
    }

    NSMutableSet *result = [NSMutableSet set];

    NSArray *LCSSolution = SolveLCS(left, right, comparator);

    ChangesByDiffingArraysIter(LCSSolution, left, right, left.count, right.count, result, comparator);

    return result;
}

NSSet *VMBChangesByDiffingArrays(NSArray *left, NSArray *right) __attribute__((overloadable)) {
    return VMBChangesByDiffingArrays(left, right, nil);
}


@implementation VMBArrayDiffChange

- (instancetype)initWithChangeKind:(VMBArrayDiffChangeType)changeKind index:(NSUInteger)index {
    self = [super init];

    if (self == nil) {
        return nil;
    }

    _changeType = changeKind;
    _index = index;

    return self;
}

#pragma mark - Equality & hash

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    }
    if ((other == nil) || ![[other class] isEqual:self.class]) {
        return NO;
    }

    return [self isEqualToChange:other];
}

- (BOOL)isEqualToChange:(VMBArrayDiffChange *)change
{
    if (self == change) {
        return YES;
    }
    if (change == nil) {
        return NO;
    }
    if (self.changeType != change.changeType) {
        return NO;
    }
    if (self.index != change.index) {
        return NO;
    }
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = (NSUInteger) self.changeType;
    hash = hash * 31u + self.index;
    return hash;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

@end
