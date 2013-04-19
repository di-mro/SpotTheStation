//
//  MapViewController.m
//  SpotTheISS
//
//  Created by Mary Rose Oh on 4/15/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "MapViewController.h"

#import "MyAnnotation.h"
#import "issAnnotationView.h"

#import <Social/Social.h>

#import "issFacts.h"


#define METERS_PER_MILE 1609.344

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize map;
@synthesize issNavigationBar;
@synthesize location;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  //Initialize MapView
  map = [[MKMapView alloc] initWithFrame:CGRectMake(0, 44, 320, 416)];
  map.delegate = self;
  map.mapType = MKMapTypeStandard;
  [self.view addSubview:map];
  
  //Display fact
  issFacts *facts = [[issFacts alloc] init];
  [facts displayFact];
  
  //for(;;)
  //while(true)
  //{
    [self getCoordinates];

    //[self performSelectorOnMainThread:@selector(getCoordinates) withObject:nil waitUntilDone:FALSE];
    //[self performSelector:@selector(getCoordinates) withObject:self afterDelay:3.0];
  //}
  
  //[mapView setMapType:MKMapTypeStandard];
  //[mapView setMapType:MKMapTypeHybrid];
  //[mapView setMapType:MKMapTypeSatellite];
  
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Get coordinates from open-notify.org
- (void) getCoordinates
{
  //Variable declarations
  CLLocationCoordinate2D issLocation;
  MKCoordinateRegion region;
  MKCoordinateSpan span;
  
  //Set latitude and longitude delta for the map
  span.latitudeDelta = 100.0f; //0.2f
  span.longitudeDelta = 100.0f; //0.2f
  
  //Conect to open-notify
  NSString *URL = @"http://api.open-notify.org/iss-now/v1/";
  NSMutableURLRequest *getRequest = [NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:URL]];
  
  [getRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  [getRequest setHTTPMethod:@"GET"];
  NSLog(@"%@", getRequest);
  
  NSURLConnection *connection = [[NSURLConnection alloc]
                                 initWithRequest:getRequest
                                 delegate:self];
  [connection start];
  
  NSHTTPURLResponse *urlResponse = [[NSHTTPURLResponse alloc] init];
  NSError *error = [[NSError alloc] init];
  
  //GET
  NSData *responseData = [NSURLConnection
                          sendSynchronousRequest:getRequest
                          returningResponse:&urlResponse
                          error:&error];
  //-end connect to open-notify
  
  if (responseData == nil)
  {
    //Show an alert if connection is not available
    UIAlertView *connectionAlert = [[UIAlertView alloc]
                                    initWithTitle:@"Warning"
                                    message:@"No network connection detected."
                                    delegate:nil
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
    [connectionAlert show];
    
    //Show sample default location if offline - Manila
    issLocation.latitude  = 14.5995124;
    issLocation.longitude = 120.9842195;
    //issLocation.latitude  = 39.281516;
    //issLocation.longitude = -76.580806;
  }
  else
  {
    /*
     timestamp: 1366015403,
     message: "success",
     iss_position: 
     {
      latitude: 8.693589426544582,
      longitude: 92.54594185722208
     }
     */
    
    //JSON from open-notify.org
    location = [NSJSONSerialization
                JSONObjectWithData:responseData
                options:kNilOptions
                error:&error];
    NSLog(@"location JSON Result: %@", location);
    
    //Retrieve latitude and longitude value from JSON
    NSNumber *latitude = [[location valueForKey:@"iss_position"] valueForKey:@"latitude"];
    NSNumber *longitude = [[location valueForKey:@"iss_position"] valueForKey:@"longitude"];
    
    issLocation.latitude  = latitude.doubleValue;
    issLocation.longitude = longitude.doubleValue;
  }
  
  region = MKCoordinateRegionMake(issLocation, span);
  [map setRegion:region animated:YES];
  
  //Annotate coordinate location in map
  MyAnnotation *annotation = [[MyAnnotation alloc] initWithCoordinate:issLocation];
  [map addAnnotation:annotation];
  
}


#pragma mark - Delegate method - replace pin image with custom iss.png image
- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
  NSLog(@"mapView - viewForAnnotation");
  [map removeAnnotation:annotation];

  if ([annotation isKindOfClass:[MyAnnotation class]])
  {
    NSString *annotationIdentifier = @"issAnnotationIdentifier";
    issAnnotationView *annotationView = (issAnnotationView *)[map dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
    
    if(annotationView)
    {
      annotationView.annotation = annotation;
      
    }
    else
    {
      annotationView = [[issAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
      annotationView.image = [UIImage imageNamed:@"iss_pin.png"];
    }
    
    return annotationView;
  }
  
  return nil;
}


#pragma mark - [Tweet] button implementation
- (IBAction)tweetButton:(id)sender
{
  NSLog(@"Tweet tweet");
  
  if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
  {
    SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweetSheet setInitialText:@"Tweeting from my own app! :)"]; //ISS is overhead / date time
    [self presentViewController:tweetSheet animated:YES completion:nil];
  }
  else
  {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Sorry"
                              message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
  }
}


#pragma mark - [About] button implementation
- (IBAction)aboutButton:(id)sender
{
  NSString *source1 = @"http://www.nasa.gov/mission_pages/station/main/onthestation/facts_and_figures.html";
  NSString *source2 = @"http://www.bbc.co.uk/science/space/solarsystem/space_missions/international_space_station";
  NSString *source3 = @"http://blogs.scientificamerican.com/observations/2010/11/03/10-facts-about-the-international-space-station-and-life-in-orbit/";
  NSString *source4 = @"http://www.boeing.com/boeing/defense-space/space/spacestation/overview/facts.page";
  NSString *source5 = @"http://www.pbs.org/spacestation/station/issfactsheet.htm";
  
  
  NSString *aboutString = [[NSString alloc] initWithFormat:@"This app is part of the NASA International Space Apps Challenge 2013. \n\nPowered by the Dungeon Innovations team. \n\n\nFact Sources: %@\n\n %@\n\n %@\n\n %@\n\n %@\n\n", source1, source2, source3, source4, source5 ];
  
  
  UIAlertView *aboutAlertView = [[UIAlertView alloc]
                                 initWithTitle:@"About"
                                 message:aboutString
                                 delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
  [aboutAlertView show];
}


@end
