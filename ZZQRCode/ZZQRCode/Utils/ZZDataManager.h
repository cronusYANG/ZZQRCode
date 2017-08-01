//
//  ZZDataManager.h
//  ZZQRCode
//
//  Created by POPLAR on 2017/8/1.
//  Copyright © 2017年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZDataManager : NSObject
+ (void)saveData:(id)data withFileName:(NSString *)name;
+ (id)loadDataWithPath:(NSString *)name;
+ (BOOL)removeDataWithPath:(NSString *)name;
@end
