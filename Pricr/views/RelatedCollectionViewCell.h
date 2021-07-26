//
//  RelatedCollectionViewCell.h
//  Pricr
//
//  Created by Santy Mendoza on 7/26/21.
//

#import <UIKit/UIKit.h>
#import "Item.h"
#import <Parse/Parse.h>
@import Parse;


NS_ASSUME_NONNULL_BEGIN

@interface RelatedCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PFImageView *itemImage;
@property (weak, nonatomic) IBOutlet UILabel *itemName;
@property (strong, nonatomic) Item *item;

@end

NS_ASSUME_NONNULL_END
