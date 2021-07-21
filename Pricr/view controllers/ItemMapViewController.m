//
//  ItemMapViewController.m
//  Pricr
//
//  Created by Santy Mendoza on 7/16/21.
//

#import "ItemMapViewController.h"
#import "LocationsViewController.h"
#import "PhotoAnnotation.h"
#import "UIImageView+AFNetworking.h"
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import "Item.h"
#import "Listing.h"
#import "itemDetailsViewController.h"




@interface ItemMapViewController ()<LocationsViewControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong,nonatomic) CLLocationManager *locationManager;
@property (strong,nonatomic)CLLocation *currentLocation;
@property (strong,nonatomic)NSString *currentCity;
@property (strong,nonatomic) NSArray *arrayOfItems;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;



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
    
    [self getData];
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


- (CLLocationCoordinate2D) getListing: (NSString *) theID{
    PFQuery *listingQuery = [PFQuery queryWithClassName:@"Listing"];
    [listingQuery orderByDescending:@"createdAt"];
    [listingQuery whereKey:@"objectId" equalTo:theID];
    [listingQuery includeKey:@"author"];
    [listingQuery includeKey:@"objectId"];
    listingQuery.limit = 20;

    // fetch data asynchronously
    [listingQuery findObjectsInBackgroundWithBlock:^(NSArray<Listing *> * _Nullable listings, NSError * _Nullable error) {
        if (listings) {
            self.coordinate = CLLocationCoordinate2DMake([listings[0].venue[@"location"][@"lat"] floatValue], [listings[0].venue[@"location"][@"lng"] floatValue]);
            PhotoAnnotation *point = [[PhotoAnnotation alloc] init];
            point.coordinate = self.coordinate;
            point.caption = listings[0].name;
            point.listing = listings[0];
            
            NSURL *posterURL = [NSURL URLWithString:listings[0].image.url];
            
            NSData *imageData = [NSData dataWithContentsOfURL:posterURL];
            UIImage *image = [[UIImage alloc]initWithData:imageData];
            UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
            resizeImageView.image = image;
            
            point.photo = resizeImageView;
            [self.mapView addAnnotation:point];
        }
        else {
        }
    }];
    
    return self.coordinate;
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];

    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;

    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImage;
}

- (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
 
    // check if image is not nil
    if (!image) {
        return nil;
    }
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

- (void) placeItems {
    for (id item in self.arrayOfItems) {
        Listing *newItem = item[@"prices"][0];
        [self getListing:newItem.objectId];
    }
}

- (void)locationsViewController:(LocationsViewController *)controller didPickLocationWithLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude{
    [self.navigationController popViewControllerAnimated:YES];

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
    // imageView.image = [UIImage imageNamed:@"camera-icon"]; // remove this line

    // add these two lines below
    PhotoAnnotation *photoAnnotationItem = annotation; // refer to this generic annotation as our more specific PhotoAnnotation
    imageView.image = photoAnnotationItem.photo.image; // set the image into the callout imageview

    return annotationView;
 }

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control{
    [self performSegueWithIdentifier:@"annotationSelected" sender:view.annotation];
}


- (void) getData {
    // construct PFQuery
    PFQuery *itemQuery = [PFQuery queryWithClassName:@"Item"];
    [itemQuery orderByDescending:@"createdAt"];
    [itemQuery includeKey:@"author"];
    itemQuery.limit = 20;

    // fetch data asynchronously
    [itemQuery findObjectsInBackgroundWithBlock:^(NSArray<Item *> * _Nullable items, NSError * _Nullable error) {
        if (items) {
            self.arrayOfItems = items;
            [self placeItems];
        }
        else {
            // handle error
        }
    }];
}


//#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(PhotoAnnotation *)sender {
    if ([segue.identifier isEqualToString:@"annotationSelected"]){
       // NSLog(sender);
        itemDetailsViewController *dc = segue.destinationViewController;
        dc.listing = sender.listing;
        
    }
}


@end
