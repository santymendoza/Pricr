//
//  ListingTableViewCell.m
//  Pricr
//
//  Created by Santy Mendoza on 8/2/21.
//

#import "ListingTableViewCell.h"

@interface ListingTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *listingImage;

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
    self.priceLabel.text = lstng.price;
    self.locationLabel.text = lstng.venue[@"name"];
}

@end
