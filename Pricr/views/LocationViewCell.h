//
//  LocationViewCell.h
//  Pricr
//
//  Created by Santy Mendoza on 7/16/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocationViewCell : UITableViewCell
- (void)updateWithLocation:(NSDictionary *)location;
@end

NS_ASSUME_NONNULL_END
