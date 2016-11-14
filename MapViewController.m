//
//  MapViewController.m
//  ShareDiary
//
//  Created by Lilit Grigoryan on 11/11/16.
//  Copyright © 2016 macbook. All rights reserved.
//

#import "MapViewController.h"
#import "SharedImage.h"
#import "DataManager.h"
#import "SWRevealViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic) NSMutableArray *annotations;

@property (nonatomic) NSMutableArray *annotationImages;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.translucent = YES;
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.barButton setTarget:self.revealViewController];
        [self.barButton setAction:@selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    [self addAllPins];
    
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    [self.mapView setCenterCoordinate:userLocation.coordinate animated:YES];
}

#pragma mark - Creating pins

- (void)addAllPins {
    NSMutableArray *title=[NSMutableArray array];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SharedImage"];
    NSMutableArray *arrCoordinateStr = [[NSMutableArray alloc] initWithCapacity:title.count];
    NSArray *results = [[[DataManager sharedManager] context] executeFetchRequest:request error:nil];
    for (SharedImage *image in results) {
        [arrCoordinateStr addObject:[NSString stringWithFormat:@"%.12f, %.12f", image.latitude, image.longitude]];
        [title addObject:image.title];
    }
    for(int i = 0; i < title.count; i++)
    {
        [self addPinWithTitle:title[i] andCoordinate:arrCoordinateStr[i]];
    }
}

#pragma mark - Adding pins to map

- (void)addPinWithTitle:(NSString *)title andCoordinate:(NSString *)strCoordinate {
    MKPointAnnotation *mapPin = [[MKPointAnnotation alloc] init];
    // clear out any white space
    strCoordinate = [strCoordinate stringByReplacingOccurrencesOfString:@" " withString:@""];
    // convert string into actual latitude and longitude values
    NSArray *components = [strCoordinate componentsSeparatedByString:@","];
    double latitude = [components[0] doubleValue];
    double longitude = [components[1] doubleValue];
    // setup the map pin with all data and add to map view
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    mapPin.title = title;
    mapPin.coordinate = coordinate;
    [self.mapView addAnnotation:mapPin];
}

#pragma mark - Adding image to pin

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"pin";
    MKPinAnnotationView *pinView =
    (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!pinView)
    {
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                        reuseIdentifier:identifier];
        UIImage *flagImage = [UIImage imageNamed:@"pinImage"];
        annotationView.layer.masksToBounds = YES;
        annotationView.layer.cornerRadius = annotationView.frame.size.height / 2;
        // You may need to resize the image here.
        annotationView.image = flagImage;
        return annotationView;
    }
    else {
        pinView.annotation = annotation;
    }
    return pinView;
}

@end
