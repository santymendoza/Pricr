//
//  RelatedCollectionViewCell.m
//  Pricr
//
//  Created by Santy Mendoza on 7/26/21.
//

#import "RelatedCollectionViewCell.h"
#import "Item.h"
#import <Parse/Parse.h>
#import <UIKit/UIKit.h>

@implementation RelatedCollectionViewCell

- (void)setItem:(Item *)item {
    _item = item;
    self.itemImage.file = item[@"image"];
    self.itemName.text = item[@"name"];
   
    [self.itemImage loadInBackground];
}
@end
