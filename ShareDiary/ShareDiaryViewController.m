//
//  ShareDiaryViewController.m
//  LifeDiary
//
//  Created by User on 10/22/16.
//  Copyright © 2016 GevorGNanyaN. All rights reserved.
//

#import "ShareDiaryViewController.h"
#import "AppDelegate.h"
#import "Reachability.h"
#import "DataManager.h"
#import "SharedImage.h"

#import <CoreData/CoreData.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <CoreLocation/CoreLocation.h>

@interface ShareDiaryViewController () <CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *imageTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UINavigationBar *saveAndImage;

@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) UIImagePickerController *imagePicker;
@property (nonatomic) double currentLatitude;
@property (nonatomic) double currentLongitude;
@property (nonatomic) double imageLatitude;
@property (nonatomic) double imageLongitude;
@property (nonatomic) UIImage *imageToShare;

@end

@implementation ShareDiaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self internetConnection];
    [self touchViewDismiss];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:1.00 green:0.60 blue:0.00 alpha:1.0];
    [self.saveAndImage setBackgroundImage:[UIImage new]
                            forBarMetrics:UIBarMetricsDefault];
    [self.saveAndImage setShadowImage:[UIImage new]];
    self.saveAndImage.translucent = YES;
    self.locationManager = [(AppDelegate *)[[UIApplication sharedApplication] delegate] sharedManager];
    [self.locationManager setDelegate:self];
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = self.imageView.frame.size.height / 2;
}

#pragma mark - Core Data

- (NSManagedObjectContext *)managedObjectContext {
    return [DataManager sharedManager].persistentContainer.viewContext;
}

#pragma mark - Internet Connection

- (void)internetConnection {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Please check your internet connection" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - Dismissing keyboard

- (void)touchViewDismiss {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    [self.imageTitle resignFirstResponder];
}

#pragma mark - Creating circular region

- (CLCircularRegion *)createRegionWithLatitude:(double)latitude andLongitude:(double)longitude {
    CLLocationCoordinate2D regionCenter = CLLocationCoordinate2DMake(latitude, longitude);
    return [[CLCircularRegion alloc] initWithCenter:regionCenter radius:100 identifier:[NSString stringWithFormat:@"%.12f, %.12f", latitude, longitude]];
}

#pragma mark - UIActivityController presentation

- (IBAction)shareActivity:(id)sender {
    UIImage *image = self.imageView.image;
    if (!image) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Please take a photo" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[image] applicationActivities:nil];
        activityController.popoverPresentationController.sourceView = self.view;
        activityController.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypePostToVimeo, UIActivityTypePostToWeibo];
        [self presentViewController:activityController animated:YES completion:nil];
    }
}

#pragma mark - Saving data

- (IBAction)saveButton:(UIBarButtonItem *)sender {
    if(!self.imageView.image) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning!" message:@"Please add image to share" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        NSManagedObjectContext *context = [self managedObjectContext];
        SharedImage *sharedImage = [NSEntityDescription insertNewObjectForEntityForName:@"SharedImage" inManagedObjectContext:context];
        sharedImage.imageName = [NSString stringWithFormat:@"%lu,%.12f,%.12f", (long)([[NSDate date] timeIntervalSince1970]*100.0), self.imageLatitude, self.imageLongitude];
        sharedImage.latitude = self.imageLatitude;
        sharedImage.longitude = self.imageLongitude;
        if (![self.imageTitle.text isEqualToString:@""]) {
            sharedImage.title = self.imageTitle.text;
        }
        [context save:nil];
        
        //writing image to file
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", sharedImage.imageName]];
        NSData *data = UIImageJPEGRepresentation(self.imageView.image, 1);
        [data writeToFile:path atomically:YES];
        
        
//         Creating notification region and scheduling notification(commented since there is an issue with notifications)
        
      //  CLCircularRegion *notificationRegion = [self createRegionWithLatitude:sharedImage.latitude andLongitude:sharedImage.longitude];
        //[(AppDelegate *)[[UIApplication sharedApplication] delegate] scheduleNotificationForRegion:notificationRegion title:self.imageTitle.text imageName:sharedImage.imageName];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Congratulations!!!" message:@"Your photo has been successfully shared" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - CLLocationManager delegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *newLocation = [locations lastObject];
    self.currentLatitude = newLocation.coordinate.latitude;
    self.currentLongitude = newLocation.coordinate.longitude;
}

#pragma mark - Camera Presentation

- (IBAction)addImage:(UIBarButtonItem *)sender {
    static UIImagePickerController *cameraUI;
    if (!cameraUI) {
        cameraUI = [[UIImagePickerController alloc] init];
    }
    self.imagePicker = cameraUI;
    self.imagePicker.allowsEditing = YES;
    self.imagePicker.delegate = self;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    } else {
        NSLog(@"Camera is not available");
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    self.imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

#pragma mark - ImagePickerController delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *imageToSave;
        if ([picker allowsEditing]) {
            imageToSave = [info objectForKey:UIImagePickerControllerEditedImage];
            
        } else {
            imageToSave = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            UIImageWriteToSavedPhotosAlbum(imageToSave,
                                           nil,
                                           nil,
                                           NULL);
            
        }
        self.imageLatitude = self.currentLatitude;
        self.imageLongitude = self.currentLongitude;
        self.imageView.image = imageToSave;
    }
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Overriding dealloc

- (void)dealloc {
    [self.locationManager setDelegate:nil];
}

@end
