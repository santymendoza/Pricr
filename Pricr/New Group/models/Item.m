//
//  Item.m
//  Instagram
//
//  Created by Santy Mendoza on 7/7/21.
//

#import "Item.h"
@implementation Item
    
@dynamic itemID;
@dynamic userID;
@dynamic author;
@dynamic description;
@dynamic image;
@dynamic createdAt;
@dynamic prices;
@dynamic name;



+ (nonnull NSString *)parseClassName {
    return @"Item";
}

+ (void) postUserItem: ( UIImage * _Nullable )image withDescription: ( NSString * _Nullable )description withCompletion: (PFBooleanResultBlock  _Nullable)completion withName: (NSString * _Nullable )name withPrices: (NSMutableArray * _Nullable )prices {
    
    Item *newItem = [Item new];
    newItem.image = [self getPFFileFromImage:image];
    newItem.author = [PFUser currentUser];
    newItem.name = name;
    newItem.description = description;
    newItem.prices = prices;
    [newItem saveInBackgroundWithBlock: completion];    
}

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
 
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

@end
