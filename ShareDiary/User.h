//
//  User.h
//  SlideOutMenu
//
//  Created by Mac on 10/22/16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic) NSString *nickName;
@property (nonatomic) NSString *imageName;
@property (nonatomic) NSString *userImage;

+ (instancetype)userWithNickName:(NSString *)nickName andImageName:(NSString *)imageName userImage:(NSString *)userImage;

@end
