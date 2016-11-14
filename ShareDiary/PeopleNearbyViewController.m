//
//  PeopleNearbyViewController.m
//  SlideOutMenu
//
//  Created by Mac on 10/22/16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "PeopleNearbyViewController.h"
#import "UserNearbyCell.h"
#import "SWRevealViewController.h"
#import "User.h"
#import "UserDetailViewController.h"

@interface PeopleNearbyViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSArray *userNearby;
@property (nonatomic) NSInteger selectedUserIndex;

@end

@implementation PeopleNearbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.translucent = YES;
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.barButton setTarget: self.revealViewController];
        [self.barButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    self.userNearby = @[[User userWithNickName:@"Johan_11" andImageName:@"UserShared1.jpg" userImage:@"user1.png"],
                        [User userWithNickName:@"Kenny45" andImageName:@"UserShared2.jpg" userImage:@"user4.png"],
                        [User userWithNickName:@"Donald" andImageName:@"UserShared3.jpg" userImage:@"user5.png"],
                        [User userWithNickName:@"Julia" andImageName:@"UserShared4.jpg" userImage:@"user3.png"],
                        [User userWithNickName:@"Andrea-55" andImageName:@"UserShared5.jpg" userImage:@"user6.jpg"],
                        [User userWithNickName:@"Angus0-" andImageName:@"UserShared6.jpg" userImage:@"user7.png"],
                        [User userWithNickName:@"Christy:-" andImageName:@"UserShared7.jpg" userImage:@"user2.png"],
                        [User userWithNickName:@"Sara" andImageName:@"UserShared8.jpg" userImage:@"user8.png"],
                        [User userWithNickName:@"Angus40-" andImageName:@"UserShared9.jpg" userImage:@"user9.png"],
                        [User userWithNickName:@"Will))" andImageName:@"UserShared10.jpg" userImage:@"user10.jpg"]];
}

// MARK: UITableViewDataSource and Delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.userNearby count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserNearbyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    tableView.backgroundColor = [UIColor clearColor];
    User *user = self.userNearby[indexPath.row];
    cell.labelNickName.text = user.nickName;
    cell.userImage.layer.masksToBounds = YES;
    cell.userImage.layer.cornerRadius =  cell.userImage.frame.size.height / 2;
    cell.userImage.image = [UIImage imageNamed:user.userImage];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedUserIndex = indexPath.row;
    [self performSegueWithIdentifier:@"ImageViewControllerSegue" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"ImageViewControllerSegue"]){
        UserDetailViewController *vc = [segue destinationViewController];
        vc.user = self.userNearby[self.selectedUserIndex];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
