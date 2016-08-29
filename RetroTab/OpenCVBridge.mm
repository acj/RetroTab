//
//  OpenCVBridge.mm
//  RetroTab
//
//  Created by Adam Jensen on 8/24/16.

//#import <TesseractFramework/TesseractFramework.h>
#import <Foundation/Foundation.h>
#include "OpenCVBridge.h"
#include "OpenCVUtilities.h"
#import "NSImage+OpenCV.h"
#include <opencv2/opencv.hpp>
#include "SimpleTextRegionSegmenter.h"

static NSString* _pathToTesseractDataInBundle()
{
    NSString* bundlePath = [[NSBundle mainBundle] bundlePath];
    return [bundlePath stringByAppendingString:@"/Contents/Resources/tessdata/"];
}

@implementation OpenCVBridge

+ (void)identifyStructuredTextInImage:(NSImage*)image completion:(void(^)(NSArray*))completion
{
    tesseract::TessBaseAPI* const tesseractOCR = new tesseract::TessBaseAPI();
    NSString* tessDataPath = _pathToTesseractDataInBundle();
    setenv("TESSDATA_PREFIX", [tessDataPath UTF8String], 1);
    
    if (tesseractOCR->Init(NULL, "eng")) {
        NSLog(@"Error: Could not initialize tesseract");
        return;
    }
    
    cv::Mat sourceMat = [image CVGrayscaleMat];
    cv::Mat binaryMat = cv::Mat();
    
//    cv::GaussianBlur(sourceMat, sourceMat, cv::Size(1, 1), 0, 0);
    cv::threshold(sourceMat, binaryMat, 0, 255, cv::THRESH_BINARY | cv::THRESH_OTSU);
    
    NSArray* const textRegions = [SimpleTextRegionSegmenter extractTextRegionsFromMat:binaryMat];
//    NSLog(@"Found %lu regions: %@", (unsigned long)textRegions.count, textRegions);
    
    NSMutableArray* const textRows = [NSMutableArray array];
    for (NSArray* row in textRegions) {
//        NSLog(@"Saw %lu columns", (unsigned long)row.count);
        
        NSMutableArray* const columnsInRow = [NSMutableArray array];
        for (NSValue* rawRectValue in row) {
            CGRect regionRect = [rawRectValue rectValue];
            cv::Mat regionMat = binaryMat(cv::Rect(regionRect.origin.x, regionRect.origin.y, regionRect.size.width, regionRect.size.height));
     
            NSString* const outText = [OpenCVUtilities extractTextFromMat:regionMat ocr:tesseractOCR];
//            NSLog(@"Saw text: %@", outText);
            
            [columnsInRow addObject:outText];
        }
        
        [textRows addObject:columnsInRow];
    }
    
//    NSLog(@"Output: %@", textRows);
//    NSImage* outputImage = [NSImage imageWithMat:binaryMat];
//    [outputImage saveAsJPEGWithName:@"/tmp/image.jpg"];
    
    tesseractOCR->End();
    
    if (completion) {
        completion(textRows);
    }
}

@end
