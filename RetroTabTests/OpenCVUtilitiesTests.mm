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

@end
