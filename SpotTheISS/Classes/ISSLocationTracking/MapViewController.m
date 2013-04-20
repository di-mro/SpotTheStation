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
#import "issFacts.h"

#import <Social/Social.h>

#define METERS_PER_MILE 1609.344
#define MINIMUM_ZOOM_ARC 0.014 //approximately 1 miles (1 degree of arc ~= 69 miles)
#define ANNOTATION_REGION_PAD_FACTOR 1.15
#define MAX_DEGREES_ARC 360

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize map;
@synthesize issNavigationBar;
@synthesize location;

@synthesize issLocation;
@synthesize region;
@synthesize span;

@synthesize annotation;
@synthesize geoLocation;
@synthesize locatedAt;

@synthesize httpResponseCode;


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
  NSLog(@"Map initialized");
  
  //Display fact
  issFacts *facts = [[issFacts alloc] init];
  [facts displayFact];
  
  [self getISSGeoLocation];
  //[self getCoordinates];
  //[self plotISSCoordinates];
  
  NSThread *animationThread = [[NSThread alloc] initWithTarget:self selector:@selector(animate) object:nil];
  [animationThread start];
  
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


#pragma mark - Get coordinates (latitude, longitude) from open-notify.org
- (void) getCoordinates
{
  //Conect to open-notify
  NSString *URL = @"http://api.open-notify.org/iss-now/v1/";
  //NSString *URL = @"";
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
  
  /*
  region = MKCoordinateRegionMake(issLocation, span);
  [map setRegion:region animated:YES];
  
  //Annotate coordinate location in map
  annotation = [[MyAnnotation alloc] initWithCoordinate:issLocation];
  
  //Get geographical location of ISS
  NSLog(@"plotISSCoordinates - geoLocation: %@", geoLocation);
  annotation.title = @"ISS Location";
  annotation.subtitle = geoLocation;
  [map addAnnotation:annotation];
  */
}


#pragma mark - Plot the coordinates in Map to show current ISS position
-(void) plotISSCoordinates
{
  //Set latitude and longitude delta for the map
  span.latitudeDelta = 80.0f; //0.2f
  span.longitudeDelta = 80.0f; //0.2f
  
  region = MKCoordinateRegionMake(issLocation, span);
  [map setRegion:region animated:YES];
  
  //Annotate coordinate location in map
  annotation = [[MyAnnotation alloc] initWithCoordinate:issLocation];
  
  //Get geographical location of ISS
  NSLog(@"plotISSCoordinates - geoLocation: %@", geoLocation);
  annotation.title = @"ISS";
  annotation.subtitle = geoLocation;
  [map addAnnotation:annotation];
}


#pragma mark - Get geographical location of ISS based on ISS latitude and longitude
-(NSString *) getISSGeoLocation
{
  CLGeocoder *geocoder = [[CLGeocoder alloc]init];
  CLLocation *loc = [[CLLocation alloc] initWithLatitude:issLocation.latitude longitude:issLocation.longitude];
  geoLocation = [[NSString alloc] init];
  
  [geocoder reverseGeocodeLocation: loc completionHandler:
   ^(NSArray *placemarks, NSError *error)
   {
     CLPlacemark *placemark = [placemarks objectAtIndex:0];
     
     //String to hold address
     locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
     NSLog(@"addressDictionary %@", placemark.addressDictionary);
     //NSString *locatedAt = [placemark.addressDictionary valueForKey:@"Name"];
     //NSString *countryName = [placemark.addressDictionary valueForKey:@"Country"];
     
     NSString *tempGeoLocation = [[NSString alloc] initWithFormat:@"I am currently overhead %@", locatedAt];
     
     //Print the location to console
     geoLocation = tempGeoLocation;
     NSLog(@"getISSGeoLocation - geoLocation: %@", geoLocation);
   }
  ];
  return geoLocation;
}



-(void) animate
{
  //region.span.latitudeDelta += 0.5;
  //region.span.longitudeDelta += 0.5;
  //region = map.region;
  //NSLog(@"region.span.latitudeDelta: %f", region.span.latitudeDelta);
  
  for (;;)
  {
    //[self getISSGeoLocation];
    [self getCoordinates];
    //[self performSelector:@selector(getCoordinates) withObject:self afterDelay:3.0 ];
    [self plotISSCoordinates];
  }
}



#pragma mark - Delegate method - replace pin image with custom iss.png image
- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)theAnnotation
{
  NSLog(@"mapView - viewForAnnotation");
  [map removeAnnotation:theAnnotation];

  if ([theAnnotation isKindOfClass:[MyAnnotation class]])
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
      
      if((issLocation.latitude == 14.5995124) && (issLocation.longitude = 120.9842195))
      {
        annotationView.image = [UIImage imageNamed:@"dungeon_logo.png"];
      }
      else
      {
        annotationView.image = [UIImage imageNamed:@"iss_pin.png"];
      }
    }
    
    return annotationView;
  }
  
  return nil;
}


#pragma mark - Delegate method - Updating current map region
- (void)mapView:(MKMapView *)theMapView regionWillChangeAnimated:(BOOL)animated
{
  NSLog(@"regionWillChangeAnimated");
  
  region = map.region;
}


#pragma mark - Delegate method - Updating zoomed region in map and updating display of ISS annotation
- (void)mapView:(MKMapView *)theMapView regionDidChangeAnimated:(BOOL)animated
{
  MKCoordinateRegion newRegion = map.region;
  
  if (region.span.latitudeDelta != newRegion.span.latitudeDelta ||
        region.span.longitudeDelta != newRegion.span.longitudeDelta)
  {
    //Set map region to newRegion
    region = MKCoordinateRegionMake(issLocation, span);
    [map setRegion:newRegion animated:YES];
      
    //Annotate coordinate location in map
    annotation = [[MyAnnotation alloc] initWithCoordinate:issLocation];
      
    //Get geographical location of ISS
    annotation.title = @"ISS";
    NSLog(@"regionDidChangeAnimated - geoLocation: %@", geoLocation);
    annotation.subtitle = geoLocation;
    [map addAnnotation:annotation];
  }
}


#pragma mark - [Tweet] button implementation
- (IBAction)tweetButton:(id)sender
{
  NSLog(@"Tweet tweet");
  [self getISSGeoLocation];
  
  if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
  {
    SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    NSString *tweetMessage = [[NSString alloc] initWithFormat:@"The ISS is overhead %@. \nI'm tweeting using Spot the Station app :)", locatedAt];
    [tweetSheet setInitialText:tweetMessage]; //ISS is overhead / date time //@"Tweeting from my own app! :)"
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


#pragma mark - Connection didFailWithError
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
  NSLog(@"connection didFailWithError: %@", [error localizedDescription]);
}

#pragma mark - Connection didReceiveResponse
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
  NSHTTPURLResponse *httpResponse;
  httpResponse = (NSHTTPURLResponse *)response;
  httpResponseCode = [httpResponse statusCode];
  NSLog(@"httpResponse status code: %d", httpResponseCode);
}



@end
