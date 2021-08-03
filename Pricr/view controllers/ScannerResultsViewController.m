//
//  ScannerResultsViewController.m
//  Pricr
//
//  Created by Santy Mendoza on 7/14/21.
//

#import "ScannerResultsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Item.h"
#import "Listing.h"
#import "LocationsViewController.h"

@interface ScannerResultsViewController ()  <UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LocationsViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *itemName;
@property (weak, nonatomic) IBOutlet UITextField *itemLocation;
@property (weak, nonatomic) IBOutlet UITextField *itemPrice;
@property (weak, nonatomic) IBOutlet UITextView *itemDescription;
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (strong, nonatomic) NSArray *itemCategories;
@property (strong, nonatomic) NSArray *arrayOfItems;
@property (strong, nonatomic) NSString *searchTitle;
@property (strong, nonatomic) Item *otherItem;



@end

@implementation ScannerResultsViewController

- (void)viewDidLoad {
    [self getData];
    [super viewDidLoad];
    [self fetchItem];
    
    // Do any additional setup after loading the view.
}



- (IBAction)imageHit:(id)sender {
}

- (IBAction)cancelPressed:(id)sender {
    self.tabBarController.selectedViewController
        = [self.tabBarController.viewControllers objectAtIndex:0];
}


- (void) getData {
    // construct PFQuery
    PFQuery *itemQuery = [PFQuery queryWithClassName:@"Item"];
    [itemQuery orderByDescending:@"createdAt"];
    [itemQuery includeKey:@"author"];
    [itemQuery includeKey:@"prices"];
    itemQuery.limit = 20;

    // fetch data asynchronously
    [itemQuery findObjectsInBackgroundWithBlock:^(NSArray<Item *> * _Nullable items, NSError * _Nullable error) {
        if (items) {
            
            self.arrayOfItems = items;
        }
        else {
            // handle error
        }
    }];
}

- (IBAction)postPressed:(id)sender {
    BOOL alreadyItem = FALSE;
    for (Item *item in self.arrayOfItems){
        if ([item.name isEqual:self.itemName.text]){
            alreadyItem = TRUE;
            self.otherItem = item;
        }
    }
    Listing *newListing = [Listing new];
    newListing.price = self.itemPrice.text;
    newListing.venue = self.venue;
    newListing.name = self.itemName.text;
    newListing.image= [self getPFFileFromImage:self.itemImage.image];
    newListing.author = PFUser.currentUser;
    if (alreadyItem){
        NSMutableArray *newArray = self.otherItem.prices;
        
        [newArray addObject:newListing];
        self.otherItem.prices = newArray;
        [self.otherItem saveInBackground];
        
    }
    else{
        NSMutableArray *arrOfPrices = [NSMutableArray new];
        NSMutableArray *favoriters = [NSMutableArray new];
        [arrOfPrices addObject:newListing];
        
        [Item postUserItem:self.itemImage.image withDescription:self.itemDescription.text withSearchTitle:self.searchTitle withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                NSLog(@"successfully uploaded an item!");
                [self dismissViewControllerAnimated:YES completion:nil];
            } else{
                NSLog(@"did not post image!");
            }
        } withName:self.itemName.text withPrices:arrOfPrices withFavoriters:favoriters withCategories:self.itemCategories];
    }


    [self dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];

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

- (void)locationsViewController:(LocationsViewController *)controller didPickLocationWithLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude venue:(NSDictionary *)venue{
    [self.navigationController popViewControllerAnimated:YES];
    

    
    self.venue = venue;
    self.itemLocation.text = self.venue[@"name"];
    [self dismissViewControllerAnimated:YES completion:nil];

}



- (void) fetchItem {
    NSString *urlCombined = [@"https://api.upcitemdb.com/prod/trial/lookup?upc=" stringByAppendingString:self.url];
    NSURL *url = [NSURL URLWithString:urlCombined];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               
               if ([dataDictionary[@"items"] count] == 0){
                   UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"No items found with that barcode, try again" preferredStyle:UIAlertControllerStyleAlert];
                   UIAlertAction *okPressed = [UIAlertAction actionWithTitle:@"Ok" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                       [self dismissViewControllerAnimated:YES completion:nil];
                   }];
                   [alert addAction:okPressed];
                   [self presentViewController:alert animated:YES completion:^{
                       // optional code for what happens after the alert controller has finished presenting
                   }];
               }
               else{
                   [self updateView:dataDictionary];
               }
              // [self.activityIndicator stopAnimating];
           }
      //  [self.refreshControl endRefreshing];
       }];
    [task resume];

}


- (NSArray *) makeListOfCategories: (NSString *) categories{
    return [categories componentsSeparatedByString:@" > "];
    
}

- (void) updateView: (NSDictionary *) data{
    self.itemName.text = data[@"items"][0][@"brand"];
    self.searchTitle = data[@"items"][0][@"title"];
    self.itemDescription.text = data[@"items"][0][@"description"];
    self.itemCategories = [self makeListOfCategories:data[@"items"][0][@"category"]];
    NSURL *itemURL = [NSURL URLWithString:data[@"items"][0][@"images"][0]];
    self.itemImage.image = nil;
    [self.itemImage setImageWithURL: itemURL];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"tagSegue"]) {
            LocationsViewController *vc = segue.destinationViewController;
            vc.delegate = self;
        }
}


@end
