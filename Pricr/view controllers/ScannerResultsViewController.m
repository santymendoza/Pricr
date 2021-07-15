//
//  ScannerResultsViewController.m
//  Pricr
//
//  Created by Santy Mendoza on 7/14/21.
//

#import "ScannerResultsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Item.h"

@interface ScannerResultsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *itemName;
@property (weak, nonatomic) IBOutlet UITextField *itemLocaation;
@property (weak, nonatomic) IBOutlet UITextField *itemPrice;
@property (weak, nonatomic) IBOutlet UITextView *itemDescription;
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;

@end

@implementation ScannerResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",self.url);
    [self fetchItem];
    
    // Do any additional setup after loading the view.
}



- (IBAction)imageHit:(id)sender {
}

- (IBAction)cancelPressed:(id)sender {
    self.tabBarController.selectedViewController
        = [self.tabBarController.viewControllers objectAtIndex:0];
}


- (IBAction)postPressed:(id)sender {
        NSMutableArray *arrOfPrices = [NSMutableArray new];
        [arrOfPrices addObject: self.itemPrice.text];
        [Item postUserItem:self.itemImage.image withDescription:self.itemDescription.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                NSLog(@"successfully uploaded an item!");
                [self dismissViewControllerAnimated:YES completion:nil];
            } else{
                NSLog(@"did not post image!");
            }
        } withName:self.itemName.text withPrices:arrOfPrices];
    self.tabBarController.selectedViewController
        = [self.tabBarController.viewControllers objectAtIndex:0];
}


- (void) fetchItem {
    NSString *urlCombined = [@"https://api.upcitemdb.com/prod/trial/lookup?upc=" stringByAppendingString:self.url];
    NSURL *url = [NSURL URLWithString:urlCombined];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
//               UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Device not connected to internet" preferredStyle:UIAlertControllerStyleAlert];
//               UIAlertAction *okPressed = [UIAlertAction actionWithTitle:@"Ok" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                   NSLog(@"OK?");
//               }];
//               [alert addAction:okPressed];
//               [self presentViewController:alert animated:YES completion:^{
//                   // optional code for what happens after the alert controller has finished presenting
//                   [self fetchMovies];
//               }];
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

- (void) updateView: (NSDictionary *) data{
    self.itemName.text = data[@"items"][0][@"brand"];
    self.itemDescription.text = data[@"items"][0][@"description"];
    
    //NSLog(@"%@",data[@"items"][0][@"images"][0]);
    NSURL *itemURL = [NSURL URLWithString:data[@"items"][0][@"images"][0]];
    self.itemImage.image = nil;
    [self.itemImage setImageWithURL: itemURL];
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
