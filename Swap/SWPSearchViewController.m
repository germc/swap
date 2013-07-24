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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchField.delegate = self;
    
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager startUpdatingLocation];
    
    [self searchForPOI];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:recognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)searchForPOI
{
    NSString *urlString;
    if (self.searchField.text.length > 0) {
        urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%f,%f&query=%@&oauth_token=OE1Q3UHXI2TB1PEAL4JM0CYX33OPX12WPPI5OOX5CIYA5LN1&v=20130708", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude, [self.searchField.text stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    } else {
        urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/trending?ll=%f,%f&oauth_token=OE1Q3UHXI2TB1PEAL4JM0CYX33OPX12WPPI5OOX5CIYA5LN1&v=20130708", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        NSMutableDictionary *resultData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        results = [[resultData objectForKey:@"response"] objectForKey:@"venues"];
        [self.searchTableView reloadData];
        
        // add activity indicators
        
    }];
}

#pragma mark UITableView delegates

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [results count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *resultTableID = @"resultTableCell";
    
    UITableViewCell *cell = [self.searchTableView dequeueReusableCellWithIdentifier:resultTableID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resultTableID];
    }
    NSDictionary *item = [results objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", item[@"name"]];
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    
    return cell;
}

#pragma mark UITextField delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self dismissKeyboard];
    if (self.searchField.text.length > 0) {
        [self searchForPOI];
    }
//    [self.searchTableView reloadData];
    return YES;
}

-(void)dismissKeyboard
{
    [self.searchField resignFirstResponder];
}

@end
