//
//  ReviewViewController.h
//  Pricr
//
//  Created by Santy Mendoza on 8/4/21.
//

#import <UIKit/UIKit.h>
#import "Item.h"

NS_ASSUME_NONNULL_BEGIN
@import Parse;


@interface ReviewViewController : UIViewController
@property (strong,nonatomic) Item *item;
@end

NS_ASSUME_NONNULL_END
