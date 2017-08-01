//
//  ZZOptionsView.h
//  ZZQRCode
//
//  Created by POPLAR on 2017/8/1.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol imgButtonDelegete <NSObject>

@optional

- (void)imgButtonBeTouched:(id)sender;

@end

@protocol lightButtonDelegete <NSObject>

@optional

- (void)lightButtonBeTouched:(UIButton *)sender;

@end

@protocol createButtonDelegete <NSObject>

@optional

- (void)createButtonBeTouched:(id)sender;

@end

@protocol fileButtonDelegete <NSObject>

@optional

- (void)fileButtonBeTouched:(id)sender;

@end


@interface ZZOptionsView : UIView
+(instancetype)optionsView;
@property (nonatomic, weak) id <imgButtonDelegete> imgDelegate;
@property (nonatomic, weak) id <lightButtonDelegete> lightDelegate;
@property (nonatomic, weak) id <createButtonDelegete> createDelegate;
@property (nonatomic, weak) id <fileButtonDelegete> fileDelegate;
@end
