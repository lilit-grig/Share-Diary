//
//  UserDetailViewController.m
//  ShareDiary
//
//  Created by macbook on 11.11.16.
//  Copyright © 2016 macbook. All rights reserved.
//

#import "UserDetailViewController.h"

@interface UserDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation UserDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = self.imageView.frame.size.height / 2;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:1.00 green:0.60 blue:0.00 alpha:1.0];
    self.imageView.image = [UIImage imageNamed:self.user.imageName];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
