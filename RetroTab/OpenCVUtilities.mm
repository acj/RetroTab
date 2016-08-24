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

@end
