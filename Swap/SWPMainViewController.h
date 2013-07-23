//
//  SWPMainViewController.h
//  Swap
//
//  Created by Scott Chiang on 7/5/13.
//  Copyright (c) 2013 Scott Chiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SWPMainViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *trendingTable;

@property (weak, nonatomic) IBOutlet UITabBar *mainTabBar;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
