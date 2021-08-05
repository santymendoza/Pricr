//
//  Review.h
//  Pricr
//
//  Created by Santy Mendoza on 8/5/21.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "PFObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface Review : PFObject<PFSubclassing>

@property (nonatomic,strong) NSNumber *numStars;
@property (nonatomic,strong) NSString *review;
@property (nonatomic,strong) PFUser *reviewer;
@property (nonatomic,strong) NSString *date;
@property (nonatomic,strong) NSString *objectId;


+ (void) postReview: ( NSNumber * _Nullable )numStars review: (NSString * _Nullable)review date: (NSString * _Nullable)date  withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
