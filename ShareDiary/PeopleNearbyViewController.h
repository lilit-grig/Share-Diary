//
//  PeopleNearbyViewController.h
//  SlideOutMenu
//
//  Created by Mac on 10/22/16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PeopleNearbyViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIBarButtonItem *barButton;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

@end
