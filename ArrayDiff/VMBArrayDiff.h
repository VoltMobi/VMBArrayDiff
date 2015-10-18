#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

typedef BOOL (^VMBArrayElementComparator)(id left, id right);

typedef NS_ENUM(NSInteger, VMBArrayDiffChangeType) {
    VMBArrayDiffChangeTypeInsert,
    VMBArrayDiffChangeTypeDelete
};


@interface VMBArrayDiffChange : NSObject <NSCopying>

- (instancetype)initWithChangeKind:(VMBArrayDiffChangeType)changeKind index:(NSUInteger)index;

@property (nonatomic, readonly) VMBArrayDiffChangeType changeType;
@property (nonatomic, readonly) NSUInteger index;

@end


extern NSSet<VMBArrayDiffChange *> *VMBChangesByDiffingArrays(NSArray *left, NSArray *right) __attribute__((overloadable));
extern NSSet<VMBArrayDiffChange *> *VMBChangesByDiffingArrays(NSArray *left, NSArray *right, __nullable VMBArrayElementComparator comparator) __attribute__((overloadable));

NS_ASSUME_NONNULL_END
