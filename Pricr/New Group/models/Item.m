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
@dynamic favoriters;
@dynamic createdAt;
@dynamic prices;
@dynamic name;
@dynamic categories;
@dynamic relatedItems;



+ (nonnull NSString *)parseClassName {
    return @"Item";
}

+ (void) postUserItem: ( UIImage * _Nullable )image withDescription: ( NSString * _Nullable )description withCompletion: (PFBooleanResultBlock  _Nullable)completion withName: (NSString * _Nullable )name withPrices: (NSMutableArray * _Nullable )prices withFavoriters: (NSMutableArray * _Nullable )favoriters withCategories:(NSArray * _Nullable)categories {
    
    Item *newItem = [Item new];
    newItem.image = [self getPFFileFromImage:image];
    newItem.author = [PFUser currentUser];
    newItem.name = name;
    newItem.favoriters = favoriters;
    newItem.description = description;
    newItem.prices = prices;
    newItem.categories = categories;
    newItem.relatedItems = [self setRelatedItems:newItem];
    [self setItemAsSimilar:newItem];
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

+ (NSInteger) numberOfSimilarCategories: (NSArray *)array1 array2:(NSArray *)array2{
    NSMutableSet* set1 = [NSMutableSet setWithArray:array1];
    NSSet* set2 = [NSMutableSet setWithArray:array2];
    [set1 intersectSet:set2]; //this will give you only the obejcts that are in both sets

    NSArray* result = [set1 allObjects];
    return result.count;
}

+ (NSMutableArray *) setRelatedItems: (Item *) postedItem{
    NSUInteger sizeOfArray = 10;
    NSMutableArray *relatedItems = [NSMutableArray array];
    for (NSUInteger i = 0; i < sizeOfArray; i++) {
        [relatedItems addObject:[NSMutableArray new]];
    }    PFQuery *itemQuery = [PFQuery queryWithClassName:@"Item"];
    [itemQuery orderByDescending:@"createdAt"];
    [itemQuery includeKey:@"prices"];
    [itemQuery includeKey:@"favoriters"];
    [itemQuery includeKey:@"objectId"];
    [itemQuery includeKey:@"categories"];
    itemQuery.limit = 20;
    // fetch data asynchronously
    [itemQuery findObjectsInBackgroundWithBlock:^(NSArray<Item *> * _Nullable items, NSError * _Nullable error) {
        if (items) {
            for (id item in items) {
                NSInteger numOfCats = [self numberOfSimilarCategories:postedItem.categories array2:item[@"categories"]];
                [relatedItems[numOfCats] addObject:item];
            }
        }
        else {
        }
    }];
    return relatedItems;
}

+ (void) setItemAsSimilar: (Item *) postedItem{
    PFQuery *itemQuery = [PFQuery queryWithClassName:@"Item"];
    [itemQuery orderByDescending:@"createdAt"];
    [itemQuery includeKey:@"prices"];
    [itemQuery includeKey:@"favoriters"];
    [itemQuery includeKey:@"objectId"];
    [itemQuery includeKey:@"categories"];
    itemQuery.limit = 20;
    // fetch data asynchronously
    [itemQuery findObjectsInBackgroundWithBlock:^(NSArray<Item *> * _Nullable items, NSError * _Nullable error) {
        if (items) {
            for (Item *item in items) {
                NSInteger numOfCats = [self numberOfSimilarCategories:postedItem.categories array2:item.categories];
                NSMutableArray *test = item.relatedItems[numOfCats];
                [test addObject:postedItem];
                item.relatedItems[numOfCats] = test;
                [item saveInBackground];
            }
        }
        else {
        }
    }];
}


@end
