//
//  AppDelegate.m
//  ZZQRCode
//
//  Created by POPLAR on 2017/6/6.
//  Copyright © 2017年 user. All rights reserved.
//

#import "AppDelegate.h"
#import "ZZScanningViewController.h"
#import "ZZCreateViewController.h"
#import "ZZCacheViewController.h"

#define TYPE_3DTOUCH_LOOK @"3dtouch.look"
#define TYPE_3DTOUCH_CREATE @"3dtouch.create"
#define TYPE_3DTOUCH_RECORD @"3dtouch.record"

@interface AppDelegate ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [NSThread sleepForTimeInterval:1.5];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    ZZScanningViewController *vc = [[ZZScanningViewController alloc] init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    
    [self creatUIApplicationShortcutItems];

    // Override point for customization after application launch.
    return YES;
}

- (void)creatUIApplicationShortcutItems {
    
    UIMutableApplicationShortcutItem *lookItem = [self creatUIApplicationShortcutItem:@"img" actionType:nil itemType:TYPE_3DTOUCH_LOOK title:@"识别"];
    
    UIMutableApplicationShortcutItem *createItem = [self creatUIApplicationShortcutItem:@"QRcode" actionType:nil itemType:TYPE_3DTOUCH_CREATE title:@"生成"];
    
    UIMutableApplicationShortcutItem *recordItem = [self creatUIApplicationShortcutItem:@"file" actionType:nil itemType:TYPE_3DTOUCH_RECORD title:@"历史记录"];
    
    NSMutableArray *items;
    if (lookItem && createItem && recordItem) {
        items = @[lookItem,createItem,recordItem].mutableCopy;
    }

    if (items.count > 0) {
        [UIApplication sharedApplication].shortcutItems = items;
    }
}


-(UIMutableApplicationShortcutItem *)creatUIApplicationShortcutItem:(NSString*)iconName actionType:(NSString*)actionType itemType:(nullable NSString*)itemType title:(NSString*)title {
    
    UIApplicationShortcutIcon *icon = [UIApplicationShortcutIcon iconWithTemplateImageName:iconName];
    
    NSDictionary *userInfo = [NSDictionary dictionary];
    if (actionType) {
        userInfo = @{@"action_type":actionType};
    } else {
        userInfo = nil;
    }
    
    UIMutableApplicationShortcutItem *item = [[UIMutableApplicationShortcutItem alloc] initWithType:itemType localizedTitle:title localizedSubtitle:@"" icon:icon userInfo:userInfo];
    
    return item;
}

-(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler{
    
    if (shortcutItem) {
        if ([shortcutItem.type isEqualToString:TYPE_3DTOUCH_LOOK]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"openThePicker" object:nil];
        }else if ([shortcutItem.type isEqualToString:TYPE_3DTOUCH_CREATE]){
            ZZCreateViewController *vc = [[ZZCreateViewController alloc] init];
            [[self getCurrentViewController].navigationController pushViewController:vc animated:YES];
        }else if ([shortcutItem.type isEqualToString:TYPE_3DTOUCH_RECORD]){
            ZZCacheViewController *vc = [[ZZCacheViewController alloc] init];
            [[self getCurrentViewController].navigationController pushViewController:vc animated:YES];
        }

    }
    
    if (completionHandler) {
        completionHandler(YES);
    }

    
}

- (UIViewController *) getCurrentViewController {
    UIApplication *application = [UIApplication sharedApplication];
    AppDelegate *myAppDelegate = (AppDelegate *)[application delegate];
    UIViewController *viewController;
    if ([myAppDelegate.window.rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)myAppDelegate.window.rootViewController;
        viewController = nav.visibleViewController;
    }
    return viewController;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
