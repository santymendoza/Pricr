//
//  ScannerViewController.m
//  Pricr
//
//  Created by Santy Mendoza on 7/13/21.
//

#import "ScannerViewController.h"
#import <MLKitBarcodeScanning/MLKBarcode.h>
#import <MLKitBarcodeScanning/MLKBarcodeScannerOptions.h>
#import <MLKitBarcodeScanning/MLKBarcodeScanner.h>
#import <MLKitBarcodeScanning/MLKitBarcodeScanning.h>
#import <MLKitVision/MLKVisionImage.h>
#import "ScannerResultsViewController.h"





@interface ScannerViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *scannerViewImage;
@property (strong, nonatomic) UIImage *barcodeImage;
@property (strong, nonatomic) MLKBarcodeScannerOptions *options;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak,nonatomic) NSString *UPCCode;




@end

@implementation ScannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     self.options =
      [[MLKBarcodeScannerOptions alloc]
       initWithFormats: MLKBarcodeFormatUPCA | MLKBarcodeFormatUPCE];
}

- (IBAction)imageHit:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    // The Xcode simulator does not support taking pictures, so let's first check that the camera is indeed supported on the device before trying to present it.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self.imageButton setTitle:@"" forState:UIControlStateNormal];
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

//- (IBAction)getDataButton:(id)sender {
//    NSLog(@"%@",self.UPCCode);
//    [self performSegueWithIdentifier:@"getData" sender:self.UPCCode];
//}



- (void) fetchItem: (NSString *) url2{
    NSString *urlCombined = [@"https://api.upcitemdb.com/prod/trial/lookup?upc=" stringByAppendingString:url2];
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
               NSLog(@"%@", dataDictionary);
               
//               self.movies = dataDictionary[@"results"];
//               self.filteredMovies = self.movies;
//               [self.collectionView reloadData];
               // TODO: Get the array of movies
               // TODO: Store the movies in a property to use elsewhere
               // TODO: Reload your table view data
              // [self.activityIndicator stopAnimating];
           }
      //  [self.refreshControl endRefreshing];
       }];
    [task resume];

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];

    // Do something with the images (based on your use case)
    self.barcodeImage = originalImage;
    self.scannerViewImage.image  = originalImage;
    
    
    [self scanImage];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) scanImage{
    
    //making UIimage visionImage
    MLKVisionImage *visionImage = [[MLKVisionImage alloc] initWithImage: self.scannerViewImage.image];
    visionImage.orientation = self.barcodeImage.imageOrientation;
    
    //getting instance of scanner
    MLKBarcodeScanner *barcodeScanner = [MLKBarcodeScanner barcodeScanner];
    
    [barcodeScanner processImage:visionImage
                      completion:^(NSArray<MLKBarcode *> *_Nullable barcodes,
                                   NSError *_Nullable error) {
      if (error != nil) {
          NSLog(@"Error in scanning barcode");
        return;
      }
      if (barcodes.count > 0) {
          for (MLKBarcode *barcode in barcodes) {
             NSArray *corners = barcode.cornerPoints;

             NSString *displayValue = barcode.displayValue;
             NSString *rawValue = barcode.rawValue;
             self.UPCCode = displayValue;
             NSLog(@"%@",displayValue);
             NSLog(@"%@",rawValue);
              
            [self performSegueWithIdentifier:@"getData" sender:self.UPCCode];
    
              //[self fetchItem:displayValue];
            //[self performSegueWithIdentifier:@"getData" sender:displayValue];

           }
      }
    }];

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


- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)postButtonPressed:(id)sender {

}


//#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ScannerResultsViewController *scannerResults = [segue destinationViewController];
    scannerResults.url = sender;
    
   // [self presentViewController:scannerResults animated:TRUE completion:nil];
}


@end
