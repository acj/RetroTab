//
//  SimpleTextRegionSegmenter.m
//  RetroTab
//
//  Created by Adam Jensen on 8/24/16.

#import "OpenCVUtilities.h"
#import "SimpleTextRegionSegmenter.h"

@implementation SimpleTextRegionSegmenter

+ (NSArray*)extractTextRegionsFromMat:(cv::Mat)mat
{
    NSArray* const horizontalHistogram = [OpenCVUtilities computeHorizontalHistogramForMat:mat];
    NSArray* const verticalHistogram = [OpenCVUtilities computeVerticalHistogramForMat:mat];
    NSArray* const verticalRanges = [OpenCVUtilities extractContiguousRangesFromHistogram:verticalHistogram withTolerance:5];
    NSArray* const horizontalRanges = [OpenCVUtilities extractContiguousRangesFromHistogram:horizontalHistogram withTolerance:5];
    
//    NSLog(@"Horizontal Histogram: %@", horizontalHistogram);
//    NSLog(@"Vertical Histogram: %@", verticalHistogram);
//    NSLog(@"Vertical Ranges: %@", verticalRanges);
//    NSLog(@"Horizontal Ranges: %@", horizontalRanges);
    
    return [OpenCVUtilities extractTextBoundingRectsForCanvasWithSize:CGSizeMake(mat.cols, mat.rows) horizontalRanges:horizontalRanges verticalRanges:verticalRanges];
}

@end
