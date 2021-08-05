//
//  ReviewViewCell.h
//  Pricr
//
//  Created by Santy Mendoza on 8/5/21.
//

#import <UIKit/UIKit.h>
#import "Review.h"

NS_ASSUME_NONNULL_BEGIN

@import Parse;

@interface ReviewViewCell : UITableViewCell
- (void)updateWithInfo:(Review *)review;

@end

NS_ASSUME_NONNULL_END
