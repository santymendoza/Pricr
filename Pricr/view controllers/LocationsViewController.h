//
//  LocationsViewController.h
//  Pricr
//
//  Created by Santy Mendoza on 7/16/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LocationsViewController; // don't forget to add this line to avoid the "Expected a type..." error 😅
@protocol LocationsViewControllerDelegate

- (void)locationsViewController:(LocationsViewController *)controller didPickLocationWithLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude venue:(NSDictionary *)venue;



@end

@interface LocationsViewController : UIViewController
@property (strong,nonatomic) NSDictionary *location;
@property (weak, nonatomic) id<LocationsViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
