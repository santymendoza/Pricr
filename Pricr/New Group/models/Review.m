//
//  Review.m
//  Pricr
//
//  Created by Santy Mendoza on 8/5/21.
//

#import "Review.h"

@implementation Review

@dynamic reviewer;
@dynamic review;
@dynamic numStars;
@dynamic objectId;
@dynamic date;






+ (nonnull NSString *)parseClassName {
    return @"Review";
}

+ (void) postReview: ( NSNumber * _Nullable )numStars review: (NSString * _Nullable)review date: (NSString * _Nullable)date  withCompletion: (PFBooleanResultBlock  _Nullable)completion{
    Review *newReview= [Review new];
    newReview.review = review;
    newReview.date = date;
    newReview.numStars = numStars;
    newReview.reviewer =  [PFUser currentUser];

    [newReview saveInBackgroundWithBlock: completion];

}

@end
