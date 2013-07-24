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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableView delegates

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
