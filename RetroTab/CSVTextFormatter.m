//
//  CSVTextFormatter.m
//  RetroTab
//
//  Created by Adam Jensen on 8/29/16.

#import "CSVTextFormatter.h"

@implementation CSVTextFormatter

+ (id)formatText:(NSArray*)textRowArray
{
    NSMutableString* const formattedString = [NSMutableString string];
    
    for (NSArray* row in textRowArray) {
        for (NSString* columnText in row) {
            [formattedString appendFormat:@"%@,", columnText];
        }
        
        [formattedString appendString:@"\n"];
    }
    
    return formattedString;
}

@end
