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
  map.zoomEnabled = FALSE;
  [self.view addSubview:map];
  NSLog(@"Map initialized");
  
  //Display an ISS fact upon opening
  issFacts *facts = [[issFacts alloc] init];
  [facts displayFact];
  
  [self getISSGeoLocation];
  [self getCoordinates];
  [self plotISSCoordinates];
  
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
  //Conect to open-notify.org to get JSON coordinates
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
    
    //Show sample default location if offline - Manila, Philippines
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
    NSLog(@"opennotify - location JSON Result: %@", location);
    
    //Retrieve latitude and longitude value from JSON
    NSNumber *latitude = [[location valueForKey:@"iss_position"] valueForKey:@"latitude"];
    NSNumber *longitude = [[location valueForKey:@"iss_position"] valueForKey:@"longitude"];
    
    issLocation.latitude  = latitude.doubleValue;
    issLocation.longitude = longitude.doubleValue;
  }
}


#pragma mark - Plot the coordinates in Map to show current ISS position
-(void) plotISSCoordinates
{
  //Set latitude and longitude delta for the map
  span.latitudeDelta = 100.0f; //0.2f
  span.longitudeDelta = 100.0f; //0.2f
  
  region = MKCoordinateRegionMake(issLocation, span);
  [map setRegion:region animated:YES];
  //[map setNeedsDisplay];
  
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
     NSString *tempGeoLocation;
     
     //String to hold address
     locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
     NSLog(@"addressDictionary %@", placemark.addressDictionary);
     
     //If no geographic place matches a given coordinate
     if (placemark.addressDictionary == NULL)
     {
       tempGeoLocation = [[NSString alloc] initWithFormat:@"Hi there! I am currently over Earth"];
       locatedAt = @"Earth";
     }
     else
     {
       /*
       //Greetings
       //Manila, Philippines
       if((issLocation.latitude == 14.5995124) && (issLocation.longitude = 120.9842195))
       {
         tempGeoLocation = [[NSString alloc] initWithFormat:@"Mabuhay! I am currently over the %@", locatedAt];
       }
       //USA
       else if ((issLocation.latitude == 40.4230) && (issLocation.longitude = 98.7372))
       {
         tempGeoLocation = [[NSString alloc] initWithFormat:@"Howdy! I am currently over the %@", locatedAt];
       }
       //Tokyo, Japan
       else if ((issLocation.latitude == 35.6833) && (issLocation.longitude = 139.7667))
       {
         tempGeoLocation = [[NSString alloc] initWithFormat:@"こんにちは! I am currently over the %@", locatedAt];
       }
       //Paris, France
       else if ((issLocation.latitude == 48.8742) && (issLocation.longitude = 2.3470))
       {
         tempGeoLocation = [[NSString alloc] initWithFormat:@"Bonjour! I am currently over the %@", locatedAt];
       }
       //Paris, France
       else if ((issLocation.latitude == 48.8742) && (issLocation.longitude = 2.3470))
       {
         tempGeoLocation = [[NSString alloc] initWithFormat:@"Bonjour! I am currently over the %@", locatedAt];
       }
       //Madrid, Spain
       else if ((issLocation.latitude == 40.4000) && (issLocation.longitude = 3.6833))
       {
         tempGeoLocation = [[NSString alloc] initWithFormat:@"Bonjour! I am currently over the %@", locatedAt];
       }
       //Mumbai, India
       else if ((issLocation.latitude == 18.9647) && (issLocation.longitude = 72.8258))
       {
         tempGeoLocation = [[NSString alloc] initWithFormat:@"Bonjour! I am currently over the %@", locatedAt];
       }
       else
       {
         tempGeoLocation = [[NSString alloc] initWithFormat:@"Hi there! I am currently over the %@", locatedAt];
       }
       */
       
       tempGeoLocation = [[NSString alloc] initWithFormat:@"Hi there! I am currently over %@", locatedAt];
     }
     
     //Assign location to geoLocation
     geoLocation = tempGeoLocation;
     NSLog(@"getISSGeoLocation - geoLocation: %@", geoLocation);
   }
  ];
  return geoLocation;
}


#pragma mark - Simulating the ISS movement in the map
-(void) animate
{
  //Continuous loop to get the coordinates and plot them in the map
  for (;;)
  {
    [self getISSGeoLocation];
    [self getCoordinates];
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
        annotation.title = @"We Love The ISS";
        annotation.subtitle = @"It looks like two Dungeon logos from afar :)";
      }
      else
      {
        //Set annotation image to ISS image
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
    NSString *tweetMessage = [[NSString alloc] initWithFormat:@"The ISS is currently over the %@. \nI'm tweeting using Spot the Station app :)", locatedAt];
    [tweetSheet setInitialText:tweetMessage];
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
  //Listing of sources for the facts
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