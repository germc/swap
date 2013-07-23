//
//  SWPMainViewController.m
//  Swap
//
//  Created by Scott Chiang on 7/5/13.
//  Copyright (c) 2013 Scott Chiang. All rights reserved.
//

#import "SWPMainViewController.h"
#import "SWPMapAnnotation.h"

@interface SWPMainViewController ()

@end

@implementation SWPMainViewController
{
    CLLocationManager *locationManager;
    NSMutableArray *results;
    CLLocationCoordinate2D _zoomlocation;
    MKCoordinateRegion _viewRegion;
    NSMutableArray *mapAnnotations;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    if (![PFUser currentUser]) {
//        PFLogInViewController *loginViewController = [[PFLogInViewController alloc] init];
//        [loginViewController setDelegate:self];
//        
//        PFSignUpViewController *signupViewController = [[PFSignUpViewController alloc] init];
//        [signupViewController setDelegate:self];
//        
//        [loginViewController setFacebookPermissions:[NSArray arrayWithObjects:@"friends_about_me", nil]];
//        [loginViewController setFields:PFLogInFieldsTwitter | PFLogInFieldsFacebook | PFLogInFieldsDefault | PFLogInFieldsDismissButton];
//        [loginViewController setSignUpController:signupViewController];
//        
//        [self presentViewController:loginViewController animated:YES completion:NULL];
//    }
    
    _zoomlocation.latitude = locationManager.location.coordinate.latitude;
    _zoomlocation.longitude = locationManager.location.coordinate.longitude;
    
    _viewRegion = MKCoordinateRegionMakeWithDistance(_zoomlocation, 2000, 2000);
    
    [_mapView setRegion:_viewRegion animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _trendingTable.dataSource = self;
    _trendingTable.delegate = self;
    
    self.mapView.delegate = self;
    
    self.tabBarItem.badgeValue = @"R";
    
    self.view.backgroundColor = [UIColor redColor];
    locationManager = [[CLLocationManager alloc] init];
    [locationManager startUpdatingLocation];
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/trending?ll=%f,%f&oauth_token=OE1Q3UHXI2TB1PEAL4JM0CYX33OPX12WPPI5OOX5CIYA5LN1&v=20130708", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    mapAnnotations = [[NSMutableArray alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        NSMutableDictionary *resultData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
//        NSLog(@"%@", resultData);
        
        results = [[resultData objectForKey:@"response"] objectForKey:@"venues"];
//        NSLog(@"%@", results);
        
        
        for (NSDictionary *item in results)
        {
//            NSLog(@"%@", item[@"name"]);
//            NSLog(@"%@", item[@"url"]);
//            NSLog(@"%@", item[@"location"][@"lat"]);
//            NSLog(@"%@", item[@"location"][@"lng"]);
            float lat = [item[@"location"][@"lat"] floatValue];
            float lng = [item[@"location"][@"lng"] floatValue];
            CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(lat, lng);
            
            NSString *name = item[@"name"];
            NSString *bizUrl = item[@"url"];
            
            SWPMapAnnotation *annot = [[SWPMapAnnotation alloc] initWithCoordinates:coord title:name subtitle:bizUrl];
            
            [mapAnnotations addObject:annot];
        }
        
        [self.mapView addAnnotations:mapAnnotations];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Parse login

-(BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password
{
    if (username && password && username.length != 0 && password.length != 0) {
        return YES;
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Info" message:@"Please fill out all the information" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    
    return NO;
}

-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    //after user logs in, show the main controller
    // use [self.navigationController pushViewController:controller ...]
//    [self.navigationController pushViewController:self.navigationController animated:YES];
}

- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"User canceled login");
}

#pragma mark Parse signup

- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Make sure you fill out all of the information!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    NSLog(@"hello there buddy");
    [self dismissViewControllerAnimated:YES completion:NULL]; }

- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *trendingTableIdentifier = @"TrendingTableIdentifier";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:trendingTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:trendingTableIdentifier];
    }
    //    cell.textLabel.text = [NSString stringWithFormat:@"Hello there %d", indexPath.row + 1];
    //    cell.detailTextLabel.text = @"bye bye";
    NSDictionary *tableItem = [results objectAtIndex:indexPath.row];
    //    NSLog(@"%@", tableItem);
    cell.textLabel.text = [NSString stringWithFormat:@"%@", tableItem[@"name"]];
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"disclosure button tapped");
}

//-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
//{
//    static NSString *ident = @"trendingMapAnnot";
//    if ([annotation isKindOfClass:[SWPMapAnnotation class]]) {
//        MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ident];
//        
//        if (annotationView == nil) {
//            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ident];
//            annotationView.enabled = YES;
//        } else {
//            annotationView.annotation = annotation;
//        }
//        return annotationView;
//    }
//    return nil;
//}

@end
