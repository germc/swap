//
//  SWPMapAnnotation.m
//  Swap
//
//  Created by Scott Chiang on 7/23/13.
//  Copyright (c) 2013 Scott Chiang. All rights reserved.
//

#import "SWPMapAnnotation.h"

@implementation SWPMapAnnotation

-(id)initWithCoordinates:(CLLocationCoordinate2D)coordinate title:(NSString *)title subTitle:(NSString *)subTitle
{
    self = [super init];
    
    if (self) {
        _coordinate = coordinate;
        _title = title;
        _subTitle = subTitle;
    }
    return self;
}

@end
