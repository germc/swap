//
//  SWPMapAnnotation.h
//  Swap
//
//  Created by Scott Chiang on 7/23/13.
//  Copyright (c) 2013 Scott Chiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SWPMapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *subtitle;

-(id)initWithCoordinates:(CLLocationCoordinate2D)coordinate title:(NSString *)title subtitle:(NSString *)subTitle;

@end
