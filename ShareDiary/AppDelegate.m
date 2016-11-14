//
//  AppDelegate.m
//  ShareDiary
//
//  Created by macbook on 10.11.16.
//  Copyright © 2016 macbook. All rights reserved.
//

#import "AppDelegate.h"
#import "DataManager.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "SharedImage.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              // Enable or disable features based on authorization.
                          }];
    
    /////
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if ([defaults boolForKey:@"isRegistered"]) {
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        self.window.rootViewController = viewController;
        
    } else {
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"signUpViewController"];
        self.window.rootViewController = viewController;
        
    }    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                    ];
    return handled;
}

- (CLLocationManager *)sharedManager {
    static CLLocationManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CLLocationManager alloc] init];
    });
    return manager;
}


- (void)scheduleNotificationForRegion:(CLCircularRegion *)region title:(NSString *)title imageName:(NSString *)imageName {
    UNLocationNotificationTrigger *trigger = [UNLocationNotificationTrigger triggerWithRegion:region repeats:YES];
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = title;
    content.body = @"Somebody has taken a photo here!";
    content.sound = [UNNotificationSound defaultSound];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",imageName]];
    NSURL *url = [NSURL fileURLWithPath:path];
    UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:imageName URL:url options:nil error:nil];
    content.attachments = @[attachment];

    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:region.identifier content:content trigger:trigger];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [[DataManager sharedManager] saveContext];
}

@end
