//
//  ListingTableViewCell.h
//  Pricr
//
//  Created by Santy Mendoza on 8/2/21.
//

#import <UIKit/UIKit.h>
#import "Listing.h"

NS_ASSUME_NONNULL_BEGIN

@interface ListingTableViewCell : UITableViewCell
- (void)updateWithInfo:(Listing *)lstng;
@end

NS_ASSUME_NONNULL_END
