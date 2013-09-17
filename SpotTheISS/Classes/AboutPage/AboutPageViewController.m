//
//  AboutPageViewController.m
//  SpotTheISS
//
//  Created by Mary Rose Oh on 9/17/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "AboutPageViewController.h"
#import "MapViewController.h"


@interface AboutPageViewController ()

@end

@implementation AboutPageViewController

@synthesize aboutNavBar;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
  NSLog(@"About Page");
  
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Segue to Map Page
- (IBAction)goToMaps:(id)sender
{
  MapViewController *controller
  = (MapViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"MapViewPage"];
  
  [self.navigationController pushViewController:controller animated:NO];
}


@end
