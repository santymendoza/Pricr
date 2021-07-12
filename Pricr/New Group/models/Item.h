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
@property (nonatomic, strong) NSArray *prices;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) PFFileObject *image;


//+ (void) postUserImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
