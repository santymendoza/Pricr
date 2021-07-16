//
//  ItemMapViewController.m
//  Pricr
//
//  Created by Santy Mendoza on 7/16/21.
//

#import "ItemMapViewController.h"
#import "LocationsViewController.h"
#import "PhotoAnnotation.h"
//#import "FullImageViewController.h"
#import "UIImageView+AFNetworking.h"
#import <CoreLocation/CoreLocation.h>



@interface ItemMapViewController ()<LocationsViewControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong,nonatomic) CLLocationManager *locationManager;
@property (strong,nonatomic)CLLocation *currentLocation;
@property (strong,nonatomic)NSString *currentCity;


@end

@implementation ItemMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}


- (NSString *) getCityName{
    return self.currentCity;
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    self.currentLocation = location;
    NSLog(@"lat%f - lon%f", location.coordinate.latitude, location.coordinate.longitude);
    
    //one degree of latitude is approximately 111 kilometers (69 miles) at all times.
    MKCoordinateRegion userRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude), MKCoordinateSpanMake(0.1, 0.1));
    [self.mapView setRegion:userRegion animated:false];
    
    [self.locationManager stopUpdatingLocation];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             self.currentCity = placemark.locality;
         }
         else
         {
             NSLog(@"Geocode failed with error %@", error);
             NSLog(@"\nCurrent Location Not Detected\n");

         }
     }];
}


- (void)locationsViewController:(LocationsViewController *)controller didPickLocationWithLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude{
    [self.navigationController popViewControllerAnimated:YES];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude.floatValue, longitude.floatValue);

        PhotoAnnotation *point = [[PhotoAnnotation alloc] init];
        point.coordinate = coordinate;
        //point.photo = [self resizeImage:self.selectedImage withSize:CGSizeMake(50.0, 50.0)];
        [self.mapView addAnnotation:point];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
     MKPinAnnotationView *annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
     if (annotationView == nil) {
         annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
         annotationView.canShowCallout = true;
         annotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
         annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
     }

     UIImageView *imageView = (UIImageView*)annotationView.leftCalloutAccessoryView;
    PhotoAnnotation *photoAnnotationItem = annotation; // refer to this generic annotation as our more specific PhotoAnnotation
    imageView.image = photoAnnotationItem.photo; // set the image into the callout imageview

     return annotationView;
 }

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control{
    [self performSegueWithIdentifier:@"fullImageSegue" sender:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
