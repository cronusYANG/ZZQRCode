

#import <UIKit/UIKit.h>

@interface UIColor (Addition)

// 使用 16 进制数字创建颜色，例如 0xFF0000 创建红色
// @return 颜色
+ (instancetype)colorWithHex:(uint32_t)hex;

// 生成随机颜色
// @return 随机颜色
+ (instancetype)randomColor;

// 使用 R / G / B 数值创建颜色
// @return 颜色
+ (instancetype)colorWithRed:(uint8_t)red green:(uint8_t)green blue:(uint8_t)blue;
@end
