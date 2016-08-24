//
//  NSImage+OpenCV.h
//  RetroTab
//
//  Created by Adam Jensen on 8/24/16.

#undef check // Workaround for OpenCV 3; see http://stackoverflow.com/a/26168404/357055

#include <AppKit/AppKit.h>
#include <Foundation/Foundation.h>
#include <opencv2/opencv.hpp>

@interface NSImage (OpenCV)

- (cv::Mat)CVMat;
- (cv::Mat)CVGrayscaleMat;

@end
