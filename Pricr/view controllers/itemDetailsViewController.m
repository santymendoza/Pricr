//
//  itemDetailsViewController.m
//  Pricr
//
//  Created by Santy Mendoza on 7/15/21.
//

#import "itemDetailsViewController.h"
#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "ItemCollectionViewCell.h"
#import "Item.h"

@interface itemDetailsViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *itemImage;
@property (weak, nonatomic) IBOutlet UILabel *itemName;
@property (weak, nonatomic) IBOutlet UILabel *itemDescription;
@property (weak, nonatomic) IBOutlet UILabel *itemPrice;

@end

@implementation itemDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.itemName.text = self.item[@"name"];
    self.itemDescription.text = self.item[@"description"];
    self.itemImage.file = self.item[@"image"];
    self.itemPrice.text = self.item.prices[0];
    [self.itemImage loadInBackground];
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
