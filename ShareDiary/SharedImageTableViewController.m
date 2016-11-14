//
//  SharedImageTableViewController.m
//  LifeDiary
//
//  Created by Lilit Grigoryan on 11/5/16.
//  Copyright © 2016 GevorGNanyaN. All rights reserved.
//

#import "SharedImageTableViewController.h"
#import "SWRevealViewController.h"
#import "SharedImage.h"
#import "AppDelegate.h"
#import "SharedImageTableViewCell.h"
#import "SharedImageDetailViewController.h"
#import "DataManager.h"

@interface SharedImageTableViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;
@property (nonatomic) NSArray *data;
@property (nonatomic) NSInteger selectedIndex;


@end

@implementation SharedImageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[(AppDelegate *)[[UIApplication sharedApplication] delegate] sharedManager] requestWhenInUseAuthorization];
    [[(AppDelegate *)[[UIApplication sharedApplication] delegate] sharedManager] startUpdatingLocation];
    [self.tableView setHidden:NO];
    self.tableView.backgroundColor = [UIColor clearColor];
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
    [self reload];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    [self reload];
}

- (void)reload {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SharedImage"];
    self.data = [[self managedObjectContext] executeFetchRequest:request error:nil];
    [self.tableView reloadData];
}

- (NSManagedObjectContext *)managedObjectContext {
    return [DataManager sharedManager].persistentContainer.viewContext;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SharedImage *sharedImage = self.data[indexPath.row];
    SharedImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sharedImageCell" forIndexPath:indexPath];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", sharedImage.imageName]];
    cell.imageTitle.text = sharedImage.title;
    cell.sharedImageView.clipsToBounds = YES;
    cell.sharedImageView.layer.cornerRadius = cell.sharedImageView.frame.size.height / 2;
    cell.sharedImageView.image = [UIImage imageWithContentsOfFile:path];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedIndex = indexPath.row;
    [self performSegueWithIdentifier:@"showImage" sender:nil];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObjectContext *context = [self managedObjectContext];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [context deleteObject:[self.data objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
    }
    NSMutableArray *array = [self.data mutableCopy];
    [array removeObjectAtIndex:indexPath.row];
    self.data = [array copy];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showImage"]) {
        SharedImageDetailViewController *vc = segue.destinationViewController;
        SharedImage *sharedImage = self.data[self.selectedIndex];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", sharedImage.imageName]];
        vc.image = [UIImage imageWithContentsOfFile:path];
    }
}

@end
