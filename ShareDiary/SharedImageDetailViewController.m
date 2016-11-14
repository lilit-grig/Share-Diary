//
//  SharedImageDetailViewController.m
//  LifeDiary
//
//  Created by Lilit Grigoryan on 11/7/16.
//  Copyright © 2016 GevorGNanyaN. All rights reserved.
//

#import "SharedImageDetailViewController.h"

@interface SharedImageDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation SharedImageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = self.imageView.frame.size.height / 2;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:1.00 green:0.60 blue:0.00 alpha:1.0];
    self.imageView.image = self.image;
}

@end
