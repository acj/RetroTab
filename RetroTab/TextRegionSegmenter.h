//
//  TextRegionSegmenter.h
//  RetroTab
//
//  Created by Adam Jensen on 8/24/16.

#import <Foundation/Foundation.h>
#undef check // Workaround for OpenCV 3; see http://stackoverflow.com/a/26168404/357055
#include <opencv2/opencv.hpp>

@protocol TextRegionSegmenter
+ (NSArray*)extractTextRegionsFromMat:(cv::Mat)mat;
@end
