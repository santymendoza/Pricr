//
//  Listing.h
//  Pricr
//
//  Created by Santy Mendoza on 7/16/21.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "PFObject.h"


NS_ASSUME_NONNULL_BEGIN

@interface Listing : PFObject<PFSubclassing>
@property (nonatomic,strong) NSDictionary *venue;
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) PFUser *author;
@property (nonatomic,strong) NSString *name;
@property (nonatomic, strong) PFFileObject *image;



+ (void) postListing: ( NSDictionary * _Nullable )venue image:( UIImage * _Nullable )image name: (NSString * _Nullable)name price: (NSString * _Nullable)price withCompletion: (PFBooleanResultBlock  _Nullable)completion;
@end

NS_ASSUME_NONNULL_END
