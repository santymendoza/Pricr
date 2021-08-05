//
//  Review.m
//  Pricr
//
//  Created by Santy Mendoza on 8/5/21.
//

#import "Review.h"
#import "Item.h"

@implementation Review

@dynamic reviewer;
@dynamic review;
@dynamic numStars;
@dynamic objectId;
@dynamic date;
@dynamic item;






+ (nonnull NSString *)parseClassName {
    return @"Review";
}

+ (void) postReview: ( NSNumber * _Nullable )numStars item: (Item * _Nullable)item review: (NSString * _Nullable)review date: (NSString * _Nullable)date  withCompletion: (PFBooleanResultBlock  _Nullable)completion{
    Review *newReview= [Review new];
    newReview.review = review;
    newReview.date = date;
    newReview.item = item;
    newReview.numStars = numStars;
    newReview.reviewer =  [PFUser currentUser];

    [newReview saveInBackgroundWithBlock: completion];

}

@end
