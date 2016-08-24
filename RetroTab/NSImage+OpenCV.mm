//
//  NSImage+OpenCV.mm
//  RetroTab
//
//  Created by Adam Jensen on 8/24/16.
//
//  Portions adapted from:
//      http://docs.opencv.org/2.4/doc/tutorials/ios/image_manipulation/image_manipulation.html

#import "OpenCVBridge.h"
#import "NSImage+OpenCV.h"

@implementation NSImage (OpenCV)

- (cv::Mat)CVMat
{
    NSGraphicsContext* context = [NSGraphicsContext currentContext];
    CGRect imageRect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGImageRef imageRef = [self CGImageForProposedRect:&imageRect context:context hints:nil];
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    CGFloat cols = self.size.width;
    CGFloat rows = self.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), imageRef);
    CGContextRelease(contextRef);
    
    return cvMat;
}

- (cv::Mat)CVGrayscaleMat
{
    CGFloat cols = self.size.width;
    CGFloat rows = self.size.height;
    
    cv::Mat colorMat = [self CVMat];
    cv::Mat grayMat(rows, cols, CV_8UC1);
    
    cv::cvtColor(colorMat, grayMat, CV_BGR2GRAY);
    
    return grayMat;
}

@end
