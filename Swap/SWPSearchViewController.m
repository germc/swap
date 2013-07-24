//
//  SWPSearchViewController.m
//  Swap
//
//  Created by Scott Chiang on 7/23/13.
//  Copyright (c) 2013 Scott Chiang. All rights reserved.
//

#import "SWPSearchViewController.h"

@interface SWPSearchViewController ()

@end

@implementation SWPSearchViewController
{
    NSMutableArray *results;
    CLLocationManager *locationManager;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _searchField.delegate = self;
    
    _searchTableView.delegate = self;
    _searchTableView.dataSource = self;
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager startUpdatingLocation];
    
    [self searchForPOI];
    [_searchTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)searchForPOI
{
    NSString *urlString;
    if ([self.searchField.text isEqualToString:@""]) {
        urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/trending?ll=%f,%f&oauth_token=OE1Q3UHXI2TB1PEAL4JM0CYX33OPX12WPPI5OOX5CIYA5LN1&v=20130708", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];
    } else {
        urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%f,%f&query=%@&oauth_token=OE1Q3UHXI2TB1PEAL4JM0CYX33OPX12WPPI5OOX5CIYA5LN1&v=20130708", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude, self.searchField.text];
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        NSMutableDictionary *resultData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        results = [[resultData objectForKey:@"response"] objectForKey:@"venues"];
    }];
}

#pragma mark UITableView delegates

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [results count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"daf"];
    return cell;
}

#pragma mark UITextField delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.searchField resignFirstResponder];
    if (self.searchField.text.length > 0) {
        [self searchForPOI];
        [_searchTableView reloadData];
    }
    
    return YES;
}

@end
