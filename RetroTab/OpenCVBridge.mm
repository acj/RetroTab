//
//  OpenCVBridge.mm
//  RetroTab
//
//  Created by Adam Jensen on 8/24/16.

#import <Foundation/Foundation.h>
#include "OpenCVBridge.h"
#import "NSImage+OpenCV.h"
#include <opencv2/opencv.hpp>

@implementation OpenCVBridge

+ (void)identifyStructuredTextInImage:(NSImage*)image completion:(void(^)())completion
{
    cv::Mat sourceMat = [image CVGrayscaleMat];
    cv::Mat binaryMat = cv::Mat();
    cv::Mat cvMat(sourceMat.cols, sourceMat.rows, CV_8UC1);
    cv::threshold(sourceMat, binaryMat, 0, 255, cv::THRESH_BINARY | cv::THRESH_OTSU);
    
    NSArray* const horizontalHistogram = [[self class] computeHorizontalHistogramForMat:binaryMat];
    NSArray* const verticalHistogram = [[self class] computeVerticalHistogramForMat:binaryMat];
    
    NSLog(@"Horizontal: %@", horizontalHistogram);
    NSLog(@"Vertical: %@", verticalHistogram);
    
    [self decorateEdgeOfMat:binaryMat forHorizontalHistogram:horizontalHistogram verticalHistogram:verticalHistogram];
    
    NSImage* outputImage = [NSImage imageWithMat:binaryMat];
    [outputImage saveAsJPEGWithName:@"/tmp/image.jpg"];
}

#pragma mark - Private

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
