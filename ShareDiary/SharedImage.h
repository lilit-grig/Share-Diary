//
//  SharedImage.h
//  ShareDiary
//
//  Created by macbook on 11.11.16.
//  Copyright © 2016 macbook. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface SharedImage : NSManagedObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic, copy) NSString *imageName;

@end
