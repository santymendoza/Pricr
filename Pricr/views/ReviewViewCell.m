//
//  ReviewViewCell.m
//  Pricr
//
//  Created by Santy Mendoza on 8/5/21.
//

#import "ReviewViewCell.h"
#import "Review.h"

@interface ReviewViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet PFImageView *userImage;

@property (weak, nonatomic) IBOutlet UIButton *starOne;
@property (weak, nonatomic) IBOutlet UIButton *starTwo;
@property (weak, nonatomic) IBOutlet UIButton *starThree;
@property (weak, nonatomic) IBOutlet UIButton *starFour;
@property (weak, nonatomic) IBOutlet UIButton *starFive;


@end

@implementation ReviewViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithInfo:(Review *)review{
    self.userImage.file = review.reviewer[@"profilePic"];
    self.reviewLabel.text = review.review;
    self.dateLabel.text = review.date;
    self.nameLabel.text = review.reviewer.username;
    [self.userImage loadInBackground];
    if ([review.numStars floatValue] >= [@1 floatValue]){
        [self.starOne setSelected:TRUE];
    }
    if ([review.numStars floatValue] >= [@2 floatValue]){
        [self.starTwo setSelected:TRUE];
    }
    if ([review.numStars floatValue] >= [@3 floatValue]){
        [self.starThree setSelected:TRUE];
    }
    if ([review.numStars floatValue] >= [@4 floatValue]){
        [self.starFour setSelected:TRUE];
    }
    if ([review.numStars floatValue] >= [@5 floatValue]){
        [self.starFive setSelected:TRUE];
    }
}

@end
