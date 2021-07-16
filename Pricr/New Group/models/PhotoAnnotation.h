//
//  PhotoAnnotation.h
//  PhotoMap
//
//  Created by Santy Mendoza on 7/8/21.
//  Copyright © 2021 Codepath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoAnnotation : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (strong,nonatomic) UIImage *photo;

@end

NS_ASSUME_NONNULL_END
