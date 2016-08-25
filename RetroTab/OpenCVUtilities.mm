//
//  OpenCVUtilities.m
//  RetroTab
//
//  Created by Adam Jensen on 8/24/16.
//  Copyright © 2016 Adam Jensen. All rights reserved.
//

#import "OpenCVUtilities.h"

@implementation OpenCVUtilities

+ (NSArray*)computeVerticalHistogramForMat:(cv::Mat)mat
{
    NSMutableArray* counts = [NSMutableArray arrayWithCapacity:mat.cols];
    
    for (int c = 0; c < mat.cols; c++) {
        NSInteger darkPixelCountForColumn = 0;
        
        for (int r = 0; r < mat.rows; r++) {
            if (mat.data[r*mat.cols + c] == 0) {
                darkPixelCountForColumn++;
            }
        }
        
        [counts addObject:@(darkPixelCountForColumn)];
    }
    
    return counts;
}

+ (NSArray*)computeHorizontalHistogramForMat:(cv::Mat)mat
{
    NSMutableArray* counts = [NSMutableArray arrayWithCapacity:mat.rows];
    
    for (int r = 0; r < mat.rows; r++) {
        NSInteger darkPixelCountForRow = 0;
        
        for (int c = 0; c < mat.cols; c++) {
            if (mat.data[r*mat.cols + c] == 0) {
                darkPixelCountForRow++;
            }
        }
        
        [counts addObject:@(darkPixelCountForRow)];
    }
    
    return counts;
}

+ (void)decorateEdgeOfMat:(cv::Mat)mat forHorizontalHistogram:(NSArray*)horizontalHistogram verticalHistogram:(NSArray*)verticalHistogram
{
    for (int c = 0; c < mat.cols; c++) {
        if ([verticalHistogram[c] intValue] > 0) {
            mat.data[c] = 0;
        }
    }
    
    for (int r = 0; r < mat.rows; r++) {
        if ([horizontalHistogram[r] intValue] > 0) {
            mat.data[r * mat.cols] = 0;
        }
    }
}

+ (void)decorateEdgeOfMat:(cv::Mat)mat forHorizontalRanges:(NSArray*)horizontalRanges verticalRanges:(NSArray*)verticalRanges
{
    for (NSValue* rangeValue in verticalRanges) {
        NSRange range = [rangeValue rangeValue];
        for (NSInteger i = range.location; i < (range.location + range.length); i++) {
            mat.data[i] = 0;
        }
    }
    
    for (NSValue* rangeValue in horizontalRanges) {
        NSRange range = [rangeValue rangeValue];
        for (NSInteger i = range.location; i < (range.location + range.length); i++) {
            mat.data[i * mat.cols] = 0;
        }
    }
}

+ (NSArray*)extractContiguousRangesFromHistogram:(NSArray*)histogram withTolerance:(NSUInteger)toleranceInPixels
{
    const NSInteger NONE = -1;
    NSMutableArray* const ranges = [NSMutableArray array];
    
    NSInteger startPositionForCurrentRange = NONE;
    NSInteger emptyPixelsSinceLastNonEmptyPixel = 0;
    
    for (int i = 0; i < histogram.count; i++) {
        const BOOL havePixels = [histogram[i] integerValue] > 0;
        
        if (havePixels) {
            if (startPositionForCurrentRange == NONE) {
                startPositionForCurrentRange = i;
            }
            
            emptyPixelsSinceLastNonEmptyPixel = 0;
        } else {
            if (startPositionForCurrentRange != NONE) {
                emptyPixelsSinceLastNonEmptyPixel++;
                
                if (emptyPixelsSinceLastNonEmptyPixel > toleranceInPixels) {
                    const NSRange range = NSMakeRange(startPositionForCurrentRange, (i - emptyPixelsSinceLastNonEmptyPixel) - startPositionForCurrentRange + 1);
                    [ranges addObject:[NSValue valueWithRange:range]];
                    
                    startPositionForCurrentRange = NONE;
                    emptyPixelsSinceLastNonEmptyPixel = 0;
                }
            }
        }
    }
    
    if (startPositionForCurrentRange != NONE) {
        const NSInteger length = ((histogram.count - 1) - emptyPixelsSinceLastNonEmptyPixel) - startPositionForCurrentRange + 1;
        const NSRange range = NSMakeRange(startPositionForCurrentRange, length);
        [ranges addObject:[NSValue valueWithRange:range]];
    }
    
    return ranges;
}

@end
