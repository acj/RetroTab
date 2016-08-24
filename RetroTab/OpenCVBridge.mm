//
//  OpenCVBridge.mm
//  RetroTab
//
//  Created by Adam Jensen on 8/24/16.

#import <Foundation/Foundation.h>
#include "OpenCVBridge.h"
#include "OpenCVUtilities.h"
#import "NSImage+OpenCV.h"
#include <opencv2/opencv.hpp>

@implementation OpenCVBridge

+ (void)identifyStructuredTextInImage:(NSImage*)image completion:(void(^)())completion
{
    cv::Mat sourceMat = [image CVGrayscaleMat];
    cv::Mat binaryMat = cv::Mat();
    cv::Mat cvMat(sourceMat.cols, sourceMat.rows, CV_8UC1);
    cv::threshold(sourceMat, binaryMat, 0, 255, cv::THRESH_BINARY | cv::THRESH_OTSU);
    
    NSArray* const horizontalHistogram = [OpenCVUtilities computeHorizontalHistogramForMat:binaryMat];
    NSArray* const verticalHistogram = [OpenCVUtilities computeVerticalHistogramForMat:binaryMat];
    
    NSLog(@"Horizontal: %@", horizontalHistogram);
    NSLog(@"Vertical: %@", verticalHistogram);
    
    [OpenCVUtilities decorateEdgeOfMat:binaryMat forHorizontalHistogram:horizontalHistogram verticalHistogram:verticalHistogram];
    
    NSImage* outputImage = [NSImage imageWithMat:binaryMat];
    [outputImage saveAsJPEGWithName:@"/tmp/image.jpg"];
}

@end
