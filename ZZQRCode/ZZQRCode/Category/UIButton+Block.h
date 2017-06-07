//
//  UIButton+Block.h
//  ButtonBlock
//
//  Created by luciuslu on 13-11-25.
//
//

#import <UIKit/UIKit.h>

typedef void(^ButtonBlock)(UIButton* btn);

@interface UIButton (Block)

- (void)addAction:(ButtonBlock)block;
- (void)addAction:(ButtonBlock)block forControlEvents:(UIControlEvents)controlEvents;

@end
