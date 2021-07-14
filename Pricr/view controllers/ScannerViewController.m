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





@interface ScannerViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *scannerViewImage;
@property (strong, nonatomic) UIImage *barcodeImage;
@property (strong, nonatomic) MLKBarcodeScannerOptions *options;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;




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
             NSLog(@"%@",displayValue);
             NSLog(@"%@",rawValue);

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
