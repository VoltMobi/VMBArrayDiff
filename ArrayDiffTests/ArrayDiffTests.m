@import ArrayDiff;
@import XCTest;


@interface ArrayDiffTests : XCTestCase

@end

@implementation ArrayDiffTests

- (void)testDiff {
    NSArray *left = @[
        @"feedbackType",
        @"name",
        @"phoneNumber",
        @"email",
        @"selectedImage",
        @"comment",
    ];

    NSArray *right = @[
        @"wat",
        @"feedbackType",
        @"restaurant",
        @"name",
        @"phoneNumber",
        @"email",
        @"comment",
    ];

    NSSet *expectedDiff = [NSSet setWithArray:@[
        [[VMBArrayDiffChange alloc] initWithChangeKind:VMBArrayDiffChangeTypeInsert index:0],
        [[VMBArrayDiffChange alloc] initWithChangeKind:VMBArrayDiffChangeTypeDelete index:4],
        [[VMBArrayDiffChange alloc] initWithChangeKind:VMBArrayDiffChangeTypeInsert index:2],
    ]];

    NSSet *diff = VMBChangesByDiffingArrays(left, right);

    XCTAssertEqualObjects(diff, expectedDiff);
}

@end
