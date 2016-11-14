//
//  User.m
//  SlideOutMenu
//
//  Created by Mac on 10/22/16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "User.h"

@implementation User

+ (instancetype)userWithNickName:(NSString *)nickName andImageName:(NSString *)imageName userImage:(NSString *)userImage {
    User *user = [[User alloc] init];
    user.nickName = nickName;
    user.imageName = imageName;
    user.userImage = userImage;
    return user;
}

@end
