//
//  ZZDataManager.m
//  ZZQRCode
//
//  Created by POPLAR on 2017/8/1.
//  Copyright © 2017年 user. All rights reserved.
//

#import "ZZDataManager.h"
#import "ZZFileManager.h"

@implementation ZZDataManager

+ (void)saveData:(id)data withFileName:(NSString *)name
{
    NSString *path = [ZZFileManager creatDocumentFile:@"dataFile"];
    NSString *filename = [[NSString alloc]initWithFormat:@"%@.dat",name];
    NSString *filePath = [path stringByAppendingPathComponent:filename];
    [NSKeyedArchiver archiveRootObject:data toFile:filePath];
}

+ (id)loadDataWithPath:(NSString *)name
{
    NSString *path = [ZZFileManager creatDocumentFile:@"dataFile"];
    NSString *filename = [[NSString alloc]initWithFormat:@"%@.dat",name];
    NSString *filePath = [path stringByAppendingPathComponent:filename];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

+ (BOOL)removeDataWithPath:(NSString *)name {
    NSString *path = [ZZFileManager creatDocumentFile:@"dataFile"];
    NSString *filename = [[NSString alloc]initWithFormat:@"%@.dat",name];
    NSString *filePath = [path stringByAppendingPathComponent:filename];
    return [ZZFileManager removeItem:filePath];
}
@end
