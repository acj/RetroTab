//
//  OpenCVUtilitiesTests.m
//  RetroTab
//
//  Created by Adam Jensen on 8/25/16.
//  Copyright © 2016 Adam Jensen. All rights reserved.
//

#import "OpenCVUtilities.h"
#import <XCTest/XCTest.h>

@interface OpenCVUtilitiesTests : XCTestCase

@end

@implementation OpenCVUtilitiesTests

// +extractContiguousRangesFromHistogram:withTolerance:

- (void)testWhenHistogramContainsSingleSweep_ThenRangeSpansEntireSpace {
    NSArray* const histogram = @[@(1), @(1), @(1), @(1)];
    
    NSArray* const ranges = [OpenCVUtilities extractContiguousRangesFromHistogram:histogram withTolerance:0];
    
    XCTAssertEqual(ranges.count, 1);
    NSRange range = [ranges[0] rangeValue];
    XCTAssertEqual(range.location, 0);
    XCTAssertEqual(range.length, 4);
}

- (void)testWhenHistogramContainsWhitePixelsBeyondToleranceAtEnd_ThenRangeCorrectlyAccountsForWhitePixels
{
    NSArray* const histogram = @[@(1), @(1), @(1), @(1), @(0), @(0)];
    
    NSArray* const ranges = [OpenCVUtilities extractContiguousRangesFromHistogram:histogram withTolerance:1];
    
    XCTAssertEqual(ranges.count, 1);
    NSRange range = [ranges[0] rangeValue];
    XCTAssertEqual(range.location, 0);
    XCTAssertEqual(range.length, 4);
}

- (void)testWhenHistogramContainsTwoDisjointSpansOfDarkPixels_ThenTwoRangesAreExtracted
{
    NSArray* const histogram = @[@(1), @(1), @(1), @(1), @(0), @(1), @(1), @(1)];
    
    NSArray* const ranges = [OpenCVUtilities extractContiguousRangesFromHistogram:histogram withTolerance:0];
    
    XCTAssertEqual(ranges.count, 2);
    NSRange firstRange = [ranges[0] rangeValue];
    NSRange secondRange = [ranges[1] rangeValue];
    XCTAssertEqual(firstRange.location, 0);
    XCTAssertEqual(firstRange.length, 4);
    XCTAssertEqual(secondRange.location, 5);
    XCTAssertEqual(secondRange.length, 3);
}

- (void)testWhenHistogramContainsWhitePixelsAtStartAndEndWithBlackPixelSpanBetween_thenCorrectSingleRangeIsReturned
{
    NSArray* const histogram = @[@(0), @(0), @(1), @(1), @(1), @(1), @(0), @(0)];
    
    NSArray* const ranges = [OpenCVUtilities extractContiguousRangesFromHistogram:histogram withTolerance:0];
    
    XCTAssertEqual(ranges.count, 1);
    NSRange range = [ranges[0] rangeValue];
    XCTAssertEqual(range.location, 2);
    XCTAssertEqual(range.length, 4);
}

- (void)testWhenHistogramContainsTwoSpansSeparatedByWhitePixels_thenToleranceIsRespected
{
    NSArray* const histogram = @[@(1), @(1), @(0), @(0), @(1), @(1), @(1), @(1)];
    
    NSArray* const ranges = [OpenCVUtilities extractContiguousRangesFromHistogram:histogram withTolerance:2];
    
    XCTAssertEqual(ranges.count, 1);
    NSRange firstRange = [ranges[0] rangeValue];
    XCTAssertEqual(firstRange.location, 0);
    XCTAssertEqual(firstRange.length, 8);
}

// +extractTextBoundingRectsForCanvasWithSize:horizontalRanges:verticalRanges:

- (void)testWhenRangesFormOneIntersectingRect_thenSingleRectIsReturned
{
    NSArray* const vRanges = @[[NSValue valueWithRange:NSMakeRange(3, 5)]];
    NSArray* const hRanges = @[[NSValue valueWithRange:NSMakeRange(10, 15)]];
    
    NSArray* const boundingRectArrays = [OpenCVUtilities extractTextBoundingRectsForCanvasWithSize:CGSizeMake(25, 25) horizontalRanges:hRanges verticalRanges:vRanges];
    
    XCTAssertEqual(boundingRectArrays.count, 1);
    NSArray* const rectArray = boundingRectArrays[0];
    XCTAssertEqual(rectArray.count, 1);
    CGRect rect = [rectArray[0] rectValue];
    XCTAssertEqual(rect.origin.x, 3);
    XCTAssertEqual(rect.origin.y, 10);
    XCTAssertEqual(CGRectGetWidth(rect), 5);
    XCTAssertEqual(CGRectGetHeight(rect), 15);
}

- (void)testWhenRangesContaintTwoRowsAndTwoColumns_thenFourRectsAreReturned
{
    NSArray* const vRanges = @[[NSValue valueWithRange:NSMakeRange(0, 5)], [NSValue valueWithRange:NSMakeRange(10, 15)]];
    NSArray* const hRanges = @[[NSValue valueWithRange:NSMakeRange(10, 15)], [NSValue valueWithRange:NSMakeRange(30, 10)]];
    
    NSArray* const boundingRectArrays = [OpenCVUtilities extractTextBoundingRectsForCanvasWithSize:CGSizeMake(25, 45) horizontalRanges:hRanges verticalRanges:vRanges];
    
    XCTAssertEqual(boundingRectArrays.count, 2);
    NSArray* const firstColumnRectArray = boundingRectArrays[0];
    XCTAssertEqual(firstColumnRectArray.count, 2);
    NSArray* const secondColumnRectArray = boundingRectArrays[1];
    XCTAssertEqual(secondColumnRectArray.count, 2);
    
    CGRect upperLeftRect = [firstColumnRectArray[0] rectValue];
    CGRect lowerLeftRect = [firstColumnRectArray[1] rectValue];
    
    CGRect upperRightRect = [secondColumnRectArray[0] rectValue];
    CGRect lowerRightRect = [secondColumnRectArray[1] rectValue];
    
    XCTAssertEqual(upperLeftRect.origin.x, 0);
    XCTAssertEqual(upperLeftRect.origin.y, 10);
    XCTAssertEqual(CGRectGetWidth(upperLeftRect), 5);
    XCTAssertEqual(CGRectGetHeight(upperLeftRect), 15);
    
    XCTAssertEqual(lowerLeftRect.origin.x, 0);
    XCTAssertEqual(lowerLeftRect.origin.y, 30);
    XCTAssertEqual(CGRectGetWidth(lowerLeftRect), 5);
    XCTAssertEqual(CGRectGetHeight(lowerLeftRect), 10);
    
    XCTAssertEqual(upperRightRect.origin.x, 10);
    XCTAssertEqual(upperRightRect.origin.y, 10);
    XCTAssertEqual(CGRectGetWidth(upperRightRect), 15);
    XCTAssertEqual(CGRectGetHeight(upperRightRect), 15);
    
    XCTAssertEqual(lowerRightRect.origin.x, 10);
    XCTAssertEqual(lowerRightRect.origin.y, 30);
    XCTAssertEqual(CGRectGetWidth(lowerRightRect), 15);
    XCTAssertEqual(CGRectGetHeight(lowerRightRect), 10);
}

- (void)testWhenRangesAreFromSample1_thenFourColumnsWithEightRectsEachAreReturned
{
    NSArray* const vRanges = @[
        [NSValue valueWithRange:NSMakeRange(11, 43)],
        [NSValue valueWithRange:NSMakeRange(94, 44)],
        [NSValue valueWithRange:NSMakeRange(178, 44)],
        [NSValue valueWithRange:NSMakeRange(262, 44)]
    ];
    
    NSArray* const hRanges = @[
        [NSValue valueWithRange:NSMakeRange(13, 12)],
        [NSValue valueWithRange:NSMakeRange(33, 12)],
        [NSValue valueWithRange:NSMakeRange(54, 12)],
        [NSValue valueWithRange:NSMakeRange(74, 12)],
        [NSValue valueWithRange:NSMakeRange(94, 12)],
        [NSValue valueWithRange:NSMakeRange(114, 12)],
        [NSValue valueWithRange:NSMakeRange(134, 12)],
        [NSValue valueWithRange:NSMakeRange(154, 12)]
    ];
    
    NSArray* const boundingRectArrays = [OpenCVUtilities extractTextBoundingRectsForCanvasWithSize:CGSizeMake(314, 175) horizontalRanges:hRanges verticalRanges:vRanges];
    
    XCTAssertEqual(boundingRectArrays.count, 4);
    XCTAssertEqual(((NSArray*)boundingRectArrays[0]).count, 8);
    XCTAssertEqual(((NSArray*)boundingRectArrays[1]).count, 8);
    XCTAssertEqual(((NSArray*)boundingRectArrays[2]).count, 8);
    XCTAssertEqual(((NSArray*)boundingRectArrays[3]).count, 8);
    
    // TODO: Test actual rectangles
}

@end
