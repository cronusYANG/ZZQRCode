//
//  ZZOptionsView.h
//  ZZQRCode
//
//  Created by POPLAR on 2017/8/1.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol optionsButtonClickDelegete <NSObject>

@optional

- (void)imgButtonBeTouched:(id)sender;
- (void)lightButtonBeTouched:(UIButton *)sender;
- (void)createButtonBeTouched:(id)sender;
- (void)fileButtonBeTouched:(id)sender;

@end

@protocol lightButtonDelegete <NSObject>

@optional



@end

@protocol createButtonDelegete <NSObject>

@optional



@end

@protocol fileButtonDelegete <NSObject>

@optional



@end


@interface ZZOptionsView : UIView
+(instancetype)optionsView;
@property (nonatomic, weak) id <optionsButtonClickDelegete> delegete;

@end
