//
//  ZZFileManager.m
//  ZZQRCode
//
//  Created by POPLAR on 2017/8/1.
//  Copyright © 2017年 user. All rights reserved.
//

#import "ZZFileManager.h"

@implementation ZZFileManager

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success) {
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

+ (NSString *)creatDocumentFile:(NSString *)fileName
{
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSError *error;
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSString *path_document = [documentDirectory stringByAppendingPathComponent:fileName];
    if (![manager fileExistsAtPath:path_document])
    {
        [manager createDirectoryAtPath:path_document withIntermediateDirectories:YES attributes:nil error:&error];
        [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:path_document]];
    }
    return path_document;
}

+ (BOOL)removeItem:(NSString *)itemPath {
    NSError *error;
    NSFileManager *manager = [NSFileManager defaultManager];
    return [manager removeItemAtPath:itemPath error:&error];
}



@end
