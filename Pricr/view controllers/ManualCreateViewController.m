//
//  ManualCreateViewController.m
//  Pricr
//
//  Created by Santy Mendoza on 7/13/21.
//

#import "ManualCreateViewController.h"
#import <Parse/Parse.h>
#import "ItemCollectionViewCell.h"
#import "Item.h"
#import "HomeCollectionViewController.h"
#import "LocationsViewController.h"
#import "Listing.h"

@interface ManualCreateViewController () <UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LocationsViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UITextField *itemName;
@property (weak, nonatomic) IBOutlet UITextField *itemPrice;
@property (weak, nonatomic) IBOutlet UITextField *itemLocation;
@property (weak, nonatomic) IBOutlet UITextView *itemDescription;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (strong, nonatomic) UIImage *selectedImage;


@end

@implementation ManualCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)locationsViewController:(LocationsViewController *)controller didPickLocationWithLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude venue:(NSDictionary *)venue{
    [self.navigationController popViewControllerAnimated:YES];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude.floatValue, longitude.floatValue);
    //NSLog(@"%@",venue);
    self.venue = venue;
    self.itemLocation.text = self.venue[@"name"];
    [self dismissViewControllerAnimated:YES completion:nil];


    
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

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];

    // Do something with the images (based on your use case)
    self.selectedImage = [self resizeImage:originalImage withSize:CGSizeMake(200.0, 200.0)];
    self.itemImage.image  = originalImage;
    
    [self.imageButton setTitle:@"" forState:UIControlStateNormal];

    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (void)textFieldDidBeginEditing:(UITextView *)textField {
    self.itemDescription.text = @"";
}


- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)postButtonPressed:(id)sender {
    NSMutableArray *arrOfPrices = [NSMutableArray new];
    Listing *newListing = [Listing new];
    newListing.price = self.itemPrice.text;
    newListing.venue = self.venue;
    newListing.name = self.itemName.text;
    newListing.image= [self getPFFileFromImage:self.selectedImage];
    newListing.author = PFUser.currentUser;
    [arrOfPrices addObject:newListing];
    
    [Item postUserItem:self.selectedImage withDescription:self.itemDescription.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"successfully uploaded an item!");
            [self dismissViewControllerAnimated:YES completion:nil];
        } else{
            NSLog(@"did not post image!");
        }
    } withName:self.itemName.text withPrices:arrOfPrices];


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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"tagSegue"]) {
            LocationsViewController *vc = segue.destinationViewController;
            vc.delegate = self;
        }
}



@end
