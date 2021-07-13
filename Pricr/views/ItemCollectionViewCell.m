//
//  ItemCollectionViewCell.m
//  Pricr
//
//  Created by Santy Mendoza on 7/12/21.
//

#import <UIKit/UIKit.h>
#import "ItemCollectionViewCell.h"
#import "Item.h"
#import <Parse/Parse.h>

@implementation ItemCollectionViewCell


- (void)setItem:(Item *)item {
    _item = item;
    self.itemImage.file = item[@"image"];
    self.itemName.text = item[@"name"];
   
    [self.itemImage loadInBackground];
}

@end
