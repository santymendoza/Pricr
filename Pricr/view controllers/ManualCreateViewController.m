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

@interface ManualCreateViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UITextField *itemName;
@property (weak, nonatomic) IBOutlet UITextField *itemPrice;
@property (weak, nonatomic) IBOutlet UITextField *itemLocation;
@property (weak, nonatomic) IBOutlet UITextView *itemDescription;
@property (strong, nonatomic) UIImage *selectedImage;


@end

@implementation ManualCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    UITapGestureRecognizer *singleTap =
//      [[UITapGestureRecognizer alloc] initWithTarget:self
//                                              action:@selector(imageTapped:)];
//    [self.itemImage addGestureRecognizer:singleTap];
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

//- (void)imageTapped:(UITapGestureRecognizer *)recognizer
//{
//    // Do any additional setup after loading the view.
//    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
//    imagePickerVC.delegate = self;
//    imagePickerVC.allowsEditing = YES;
//    // The Xcode simulator does not support taking pictures, so let's first check that the camera is indeed supported on the device before trying to present it.
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
//    }
//    else {
//        NSLog(@"Camera 🚫 available so we will use photo library instead");
//        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    }
//
//    [self presentViewController:imagePickerVC animated:YES completion:nil];
//}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    // Do something with the images (based on your use case)
    self.selectedImage = [self resizeImage:originalImage withSize:CGSizeMake(200.0, 200.0)];
    self.itemImage.image  = originalImage;
    
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




- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)postButtonPressed:(id)sender {
    [Item postUserItem:self.selectedImage withDescription:self.itemDescription.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"successfully uploaded an item!");
            [self dismissViewControllerAnimated:YES completion:nil];
        } else{
            NSLog(@"did not post image!");
        }
    }];


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
