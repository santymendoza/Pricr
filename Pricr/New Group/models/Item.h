//
//  Item.h
//  Pricr
//
//  Created by Santy Mendoza on 7/12/21.
//

#import <Parse/Parse.h>
#import "PFObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface Item : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *itemID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSMutableArray *prices;
@property (nonatomic, strong) NSMutableArray *favoriters;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSMutableArray *relatedItems;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) PFFileObject *image;


+ (void) postUserItem: ( UIImage * _Nullable )image withDescription: ( NSString * _Nullable )description withCompletion: (PFBooleanResultBlock  _Nullable)completion withName: (NSString * _Nullable )name withPrices: (NSMutableArray * _Nullable )prices withFavoriters: (NSMutableArray * _Nullable )favoriters withCategories: (NSArray * _Nullable )categories;

@end

NS_ASSUME_NONNULL_END
