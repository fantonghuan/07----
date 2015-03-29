//
//  AppDelegate.m
//  爱限免-框架
//
//  Created by cyan on 15-3-10.
//  Copyright (c) 2015年 cyan. All rights reserved.
//

#import "AppDelegate.h"
#import "ZKTabBarViewController.h"
#import "ZKAppListViewController.h"

//分享
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"

#import "TencentOpenAPI/QQApiInterface.h"
#import "TencentOpenAPI/TencentOAuth.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    /*
        
        //    UITabBarController *tabBarController = [[UITabBarController alloc] init];
        //
        //    ZKLimitViewController *limit = [[ZKLimitViewController alloc] init];
        //    UINavigationController *navLimit = [[UINavigationController alloc] initWithRootViewController:limit];
        //    navLimit.title = @"限免";
        //
        //    ZKFreeViewController *free = [[ZKFreeViewController alloc] init];
        //    UINavigationController *navFree = [[UINavigationController alloc] initWithRootViewController:free];
        //    navFree.title = @"免费";
        //
        //    ZKSaleViewController *sale = [[ZKSaleViewController alloc] init];
        //    UINavigationController *navSale = [[UINavigationController alloc] initWithRootViewController:sale];
        //    navSale.title = @"免费";
        //
        //    ZKTopicViewController *topic = [[ZKTopicViewController alloc] init];
        //    UINavigationController *navTopic = [[UINavigationController alloc] initWithRootViewController:topic];
        //
        //    ZKHotViewController *hot = [[ZKHotViewController alloc] init];
        //    UINavigationController *navHot = [[UINavigationController alloc] initWithRootViewController:hot];
        //
        //    self.window.rootViewController = tabBarController;
        //
        //    //将五个导航控制器添加成标签栏控制器的元素
        //    tabBarController.viewControllers = @[navLimit, navSale, navFree, navHot, navTopic];
        //
    */
    
    //消息提醒(比如QQ上发来的联系人信息数)
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:3];


    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self getTabbarController];
    return YES;
}

- (void)setUM {
    
    //设置友盟分享的APPKey
    [UMSocialData setAppKey:@"507fcab25270157b37000010"];
    //设置微信的appId
    [UMSocialWechatHandler setWXAppId:@"wxd9a39c7122aa6516" url:nil];
    //设置QQ的
    [UMSocialConfig setQQAppId:@"100424468" url:nil importClasses:@[[QQApiInterface class], [TencentOAuth class]]];
    
}

- (void)getTabbarController {
    ZKTabBarViewController *tabBarController = [[ZKTabBarViewController alloc] init];
    
    ZKAppListViewController *limit = (ZKAppListViewController *) [tabBarController controllerWithString:@"ZKLimitViewController" title:@"限免" andImage:@"tabbar_limitfree"];
    limit.urlString = LIMIT_URL;//网络接口
    
    //消息提醒
//    limit
    
    ZKAppListViewController *sale = (ZKAppListViewController *) [tabBarController controllerWithString:@"ZKSaleViewController" title:@"降价" andImage:@"tabbar_reduceprice"];
    
    sale.urlString = SALE_URL;
    
    ZKAppListViewController *free = (ZKAppListViewController *) [tabBarController controllerWithString:@"ZKFreeViewController" title:@"免费" andImage:@"tabbar_appfree"];
    
    free.urlString = FREE_URL;
    
    ZKAppListViewController *hot = (ZKAppListViewController *) [tabBarController controllerWithString:@"ZKHotViewController" title:@"热点" andImage:@"tabbar_rank"];
    
    hot.urlString = HOT_URL;
    
    [tabBarController controllerWithString:@"ZKTopicViewController" title:@"专题" andImage:@"tabbar_subject"];
    
    self.window.rootViewController = tabBarController;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
