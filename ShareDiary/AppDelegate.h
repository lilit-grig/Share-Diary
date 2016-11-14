//
//  AppDelegate.h
//  ShareDiary
//
//  Created by macbook on 10.11.16.
//  Copyright © 2016 macbook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)scheduleNotificationForRegion:(CLCircularRegion *)region title:(NSString *)title imageName:(NSString *)imageName;

- (CLLocationManager *)sharedManager;

@end

