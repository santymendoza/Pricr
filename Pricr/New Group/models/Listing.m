//
//  Listing.m
//  Pricr
//
//  Created by Santy Mendoza on 7/16/21.
//

#import "Listing.h"

@implementation Listing

@dynamic author;
@dynamic price;
@dynamic venue;
@dynamic name;
@dynamic image;
@dynamic objectId;


+ (nonnull NSString *)parseClassName {
    return @"Listing";
}

+ (void) postListing: ( NSDictionary * _Nullable )venue price: (NSString * _Nullable)price withCompletion: (PFBooleanResultBlock  _Nullable)completion{
    Listing *newListing = [Listing new];
    newListing.venue = venue;
    newListing.price = price;
    newListing.author =  [PFUser currentUser];

    [newListing saveInBackgroundWithBlock: completion];

}

@end
