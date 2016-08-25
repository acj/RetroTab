//
//  OpenCVUtilities.h
//  RetroTab
//
//  Created by Adam Jensen on 8/24/16.
//  Copyright © 2016 Adam Jensen. All rights reserved.
//

#import <Foundation/Foundation.h>
#undef check // Workaround for OpenCV 3; see http://stackoverflow.com/a/26168404/357055
#include <opencv2/opencv.hpp>

@interface OpenCVUtilities : NSObject

+ (NSArray*)computeVerticalHistogramForMat:(cv::Mat)mat;

+ (NSArray*)computeHorizontalHistogramForMat:(cv::Mat)mat;

+ (void)decorateEdgeOfMat:(cv::Mat)mat forHorizontalHistogram:(NSArray*)horizontalHistogram verticalHistogram:(NSArray*)verticalHistogram;

+ (void)decorateEdgeOfMat:(cv::Mat)mat forHorizontalRanges:(NSArray*)horizontalRanges verticalRanges:(NSArray*)verticalRanges;

+ (NSArray*)extractContiguousRangesFromHistogram:(NSArray*)histogram withTolerance:(NSUInteger)toleranceInPixels;

@end
