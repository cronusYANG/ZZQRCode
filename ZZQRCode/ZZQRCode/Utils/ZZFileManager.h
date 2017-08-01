//
//  ZZFileManager.h
//  ZZQRCode
//
//  Created by POPLAR on 2017/8/1.
//  Copyright © 2017年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZFileManager : NSObject
+ (NSString *)creatDocumentFile:(NSString *)fileName;
+ (BOOL)removeItem:(NSString *)itemPath;
@end
