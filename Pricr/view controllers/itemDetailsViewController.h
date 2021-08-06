//
//  itemDetailsViewController.h
//  Pricr
//
//  Created by Santy Mendoza on 7/15/21.
//

#import <UIKit/UIKit.h>
#import "Item.h"
#import "Listing.h"

NS_ASSUME_NONNULL_BEGIN

@interface itemDetailsViewController : UIViewController

@property (strong,nonatomic) Item *item;
@property (strong,nonatomic) Listing *listing;
@property (strong,nonatomic) NSString *itemID;
@property (strong,nonatomic) NSString *fromMap;




@end

NS_ASSUME_NONNULL_END
