//
//  LocationsViewController.m
//  Pricr
//
//  Created by Santy Mendoza on 7/16/21.
//

#import "LocationsViewController.h"
#import "LocationViewCell.h"
#import "ItemMapViewController.h"
#import "ManualCreateViewController.h"
#import <CoreLocation/CoreLocation.h>




static NSString * const clientID = @"QA1L0Z0ZNA2QVEEDHFPQWK0I5F1DE3GPLSNW4BZEBGJXUCFL";
static NSString * const clientSecret = @"W2AOE1TYC4MHK5SZYOUGX0J3LVRALMPB4CXT3ZH21ZCPUMCU";

@interface LocationsViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *results;
@property (strong,nonatomic) CLLocationManager *locationManager;
@property (strong,nonatomic)NSString *locationString;
@property (strong,nonatomic)CLLocation *currentLocation;


@end

@implementation LocationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateTable {
    [self fetchLocationsWithQuery:@"" nearLoc:self.locationString];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    self.currentLocation = location;
    NSNumber *myLat = [NSNumber numberWithDouble:location.coordinate.latitude];
    NSNumber *myLon = [NSNumber numberWithDouble:location.coordinate.longitude];
    self.locationString = [[[myLat stringValue] stringByAppendingString: @","] stringByAppendingString: [myLon stringValue]];
    NSLog(@"lat%f - lon%f", location.coordinate.latitude, location.coordinate.longitude);
    
    //one degree of latitude is approximately 111 kilometers (69 miles) at all times.
    MKCoordinateRegion userRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude), MKCoordinateSpanMake(0.1, 0.1));
    //[self.mapView setRegion:userRegion animated:false];
    
    [self.locationManager stopUpdatingLocation];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             //self.currentCity = placemark.locality;
             [self updateTable];
         }
         else
         {
             NSLog(@"Geocode failed with error %@", error);
             NSLog(@"\nCurrent Location Not Detected\n");

         }
     }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LocationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationCell" forIndexPath:indexPath];
    
    [cell updateWithLocation: self.results[indexPath.row]];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // This is the selected venue
    NSDictionary *venue = self.results[indexPath.row];
    NSNumber *lat = [venue valueForKeyPath:@"location.lat"];
    NSNumber *lng = [venue valueForKeyPath:@"location.lng"];
    NSLog(@"%@, %@", lat, lng);
    [self.delegate locationsViewController:self didPickLocationWithLatitude:lat longitude:lng venue:venue];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *newText = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
    [self fetchLocationsWithQuery:newText nearLoc:self.locationString];
    return true;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self fetchLocationsWithQuery:searchBar.text nearLoc:self.locationString];
}

- (void)fetchLocationsWithQuery:(NSString *)query nearLoc:(NSString *)latlon {
    NSString *baseURLString = @"https://api.foursquare.com/v2/venues/search?";
    NSString *queryString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&v=20141020&ll=%@&query=%@&categoryId=4bf58dd8d48988d118951735&sortByDistance=1&radius=100000", clientID, clientSecret, latlon, query];
    //NSLog(queryString);
    queryString = [queryString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:[baseURLString stringByAppendingString:queryString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"response: %@", responseDictionary);
            self.results = [responseDictionary valueForKeyPath:@"response.venues"];
            [self.tableView reloadData];
        }
    }];
    [task resume];
}


//#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//    UITableView *tappedCell = sender;
//    NSIndexPath *indexPath = [self.tableView indexPathForCell: tappedCell];
//    NSDictionary *venue = self.results[indexPath.row];
//
//    ManualCreateViewController *manualController = [segue destinationViewController];
//    manualController.venue = venue;
}

@end

