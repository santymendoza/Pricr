//
//  Post.m
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


+ (nonnull NSString *)parseClassName {
    return @"Post";
}

+ (void) postUserImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )description withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Item *newItem = [Item new];
    newItem.image = [self getPFFileFromImage:image];
    newItem.author = [PFUser currentUser];
    newItem.description = description;
    newItem.prices = [NSMutableArray new];
    
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
