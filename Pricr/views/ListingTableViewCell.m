//
//  ListingTableViewCell.m
//  Pricr
//
//  Created by Santy Mendoza on 8/2/21.
//
#import <Parse/Parse.h>
#import "ListingTableViewCell.h"

@interface ListingTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet PFImageView *listingImage;

@end

@implementation ListingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithInfo:(Listing *)lstng{
    self.listingImage.file = lstng.image;
    self.priceLabel.text = lstng.price;
    self.locationLabel.text = lstng.venue[@"name"];
    [self.listingImage loadInBackground];

}

@end
