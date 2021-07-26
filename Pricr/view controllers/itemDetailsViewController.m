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
#import "Listing.h"

@interface itemDetailsViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *itemImage;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *itemName;
@property (weak, nonatomic) IBOutlet UILabel *itemDescription;
@property (weak, nonatomic) IBOutlet UILabel *itemPrice;

@end

@implementation itemDetailsViewController
- (IBAction)favorited:(id)sender {
    [self likeItem: _item];
}

- (void) likeItem:(Item *)item {
    if (![self isFavorited:self.item.favoriters]){

        if (item.favoriters == nil) {
            item.favoriters = [NSMutableArray new];
            [item[@"favoriters"] addObject:PFUser.currentUser];
        }
        else if (![item.favoriters containsObject:PFUser.currentUser]){
            NSMutableArray *tst = item.favoriters;
            item.favoriters = [NSMutableArray new];
            item.favoriters = tst;
            [item[@"favoriters"] addObject:PFUser.currentUser];
        }
        [self.favoriteButton setSelected:TRUE];
    }
    else{
        NSUInteger *index = 0;
        for (PFUser *favoriter in item[@"favoriters"]){
            if ([favoriter.objectId isEqual: PFUser.currentUser.objectId]){
                NSMutableArray *test = item.favoriters;
                item.favoriters = [NSMutableArray new];
                item.favoriters = test;
                [item[@"favoriters"] removeObjectAtIndex: index];
            }
            index++;
        }
        [self.favoriteButton setSelected:FALSE];
    }
    [item saveInBackground];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    if(![self.item isEqual: nil]){
        [self getItem];
    }
    [self makeDetails];
}
- (BOOL) isFavorited: (NSMutableArray *) favoriters {
    
    for (PFUser *favoriter in favoriters){
        if ([favoriter.objectId isEqual: PFUser.currentUser.objectId]){
            return TRUE;
        }
    }
    return FALSE;
}

- (void) makeDetails{
    self.itemName.text = self.item[@"name"];
    self.itemDescription.text = self.item[@"description"];
    self.itemImage.file = self.item[@"image"];
    if ([self isFavorited:self.item.favoriters]){
        [self.favoriteButton setSelected:TRUE];
    }
    Listing *new = self.item[@"prices"][0];
    self.itemPrice.text = new.price;
    [self.itemImage loadInBackground];
}
- (void) getItem{
    PFQuery *itemQuery = [PFQuery queryWithClassName:@"Item"];
    [itemQuery orderByDescending:@"createdAt"];
    [itemQuery includeKey:@"prices"];
    [itemQuery includeKey:@"favoriters"];
    [itemQuery includeKey:@"objectId"];
    itemQuery.limit = 20;
    // fetch data asynchronously
    [itemQuery findObjectsInBackgroundWithBlock:^(NSArray<Item *> * _Nullable items, NSError * _Nullable error) {
        if (items) {
            for (id item in items) {
                for (id listing in item[@"prices"]){
                    
                    if ([listing[@"name"] isEqual: self.listing[@"name"]]){
                        self.item = item;
                        [self makeDetails];
                    }
                }
            }
        }
        else {
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
