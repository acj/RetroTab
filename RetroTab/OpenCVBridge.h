//
//  OpenCVBridge.h
//  RetroTab
//
//  Created by Adam Jensen on 8/24/16.

#import <Foundation/Foundation.h>

@interface OpenCVBridge : NSObject

+ (void)identifyStructuredTextInImage:(NSImage*)image completion:(void(^)())completion;

@end