//
//  LocationViewCell.m
//  Pricr
//
//  Created by Santy Mendoza on 7/16/21.
//

#import "LocationViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>


@interface LocationViewCell()

@property (strong, nonatomic) NSDictionary *location;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *categoryImage;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation LocationViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithLocation:(NSDictionary *)location {
    self.nameLabel.text = location[@"name"];
    self.addressLabel.text = [location valueForKeyPath:@"location.address"];
    
    NSArray *categories = location[@"categories"];
    if (categories && categories.count > 0) {
        NSDictionary *category = categories[0];
        NSString *urlPrefix = [category valueForKeyPath:@"icon.prefix"];
        NSString *urlSuffix = [category valueForKeyPath:@"icon.suffix"];
        NSString *urlString = [NSString stringWithFormat:@"%@bg_32%@", urlPrefix, urlSuffix];
        
        NSURL *url = [NSURL URLWithString:urlString];
        [self.categoryImage setImageWithURL:url];
    }
}


@end
