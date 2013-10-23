//
//  GoogleMapViewController.m
//  SpotTheISS
//
//  Created by Mary Rose Oh on 10/17/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "GoogleMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "issFacts.h"


@interface GoogleMapViewController ()

@end

@implementation GoogleMapViewController

@synthesize issNavBar;
@synthesize mapView;

@synthesize location;

@synthesize issLocation;
@synthesize geoLocation;
@synthesize locatedAt;

@synthesize onlineFlag;
@synthesize httpResponseCode;

@synthesize socialNetworksSheet;
@synthesize screenshot;


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
  NSLog(@"WhereISS");
  
  //Initialize map, geoLocation and camera view
  geoLocation = [[NSString alloc] init];
  [self loadMap];
  
  //Display an ISS fact upon opening
  issFacts *facts = [[issFacts alloc] init];
  [facts displayFact];
  
  //Simulate ISS marker animation
  [NSTimer scheduledTimerWithTimeInterval:4.0
                                   target:self
                                 selector:@selector(loadMap)
                                 userInfo:nil
                                  repeats:YES];
  
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Load Google Maps
-(void) loadMap
{
  //Get ISS coordinates and plot on map
  [self getCoordinates];

  /* TEST ONLY
  issLocation.latitude  = 14.5995124;
  issLocation.longitude = 120.9842195;
  //*/
  
  //Set map camera / region view
  GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:issLocation.latitude
                                                          longitude:issLocation.longitude
                                                               zoom:3.0];
  
  //[mapView animateToCameraPosition:camera];
  
  mapView.camera            = camera;
  mapView.delegate          = self;
  mapView.mapType           = kGMSTypeNormal;
  mapView.myLocationEnabled = YES;
  
  [mapView clear];
  
  //Plot the ISS marker / annotation on the mapView
  GMSMarker *marker = [[GMSMarker alloc] init];
  marker.position   = CLLocationCoordinate2DMake(issLocation.latitude, issLocation.longitude);
  marker.title      = @"International Space Station";
  
  if(onlineFlag == 0)
  {
    marker.snippet = @"No connection detected. Please try again later.";
  }
  else
  {
    marker.snippet    = [self getISSGeoLocation];
  }
  
  marker.icon       = [UIImage imageNamed:@"iss_pin.png"];
  marker.flat       = YES;
  marker.map        = mapView;
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
  NSError *error                 = [[NSError alloc] init];
  
  //GET
  NSData *responseData = [NSURLConnection
                          sendSynchronousRequest:getRequest
                          returningResponse:&urlResponse
                          error:&error];
  
  if (responseData == nil)
  {
    onlineFlag = 0;
    
    /*
     //Show an alert if connection is not available
     UIAlertView *connectionAlert = [[UIAlertView alloc]
                                         initWithTitle:@"No Network Connection Detected"
                                               message:@"Please try again later."
                                              delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
     [connectionAlert show];
     //*/
    
    //Show sample default location if offline - Manila, Philippines
    issLocation.latitude  = 14.5995124;
    issLocation.longitude = 120.9842195;
  }
  else
  {
    onlineFlag = 1;
    /*
     timestamp: 1366015403,
     message: "success",
     iss_position:
     {
      latitude: 8.693589426544582,
      longitude: 92.54594185722208
     }
     //*/
    
    //JSON from open-notify.org
    location = [NSJSONSerialization
                JSONObjectWithData:responseData
                           options:kNilOptions
                             error:&error];
    NSLog(@"opennotify - location JSON Result: %@", location);
    
    //Retrieve latitude and longitude value from JSON
    NSNumber *latitude  = [[location valueForKey:@"iss_position"] valueForKey:@"latitude"];
    NSNumber *longitude = [[location valueForKey:@"iss_position"] valueForKey:@"longitude"];
    
    issLocation.latitude  = latitude.doubleValue;
    issLocation.longitude = longitude.doubleValue;
  }
}


#pragma mark - Get geographical location of ISS based on ISS latitude and longitude
-(NSString *) getISSGeoLocation
{
  //Get ISS coordinates first
  [self getCoordinates];
  
  CLGeocoder *geocoder = [[CLGeocoder alloc]init];
  CLLocation *loc      = [[CLLocation alloc] initWithLatitude:issLocation.latitude
                                                    longitude:issLocation.longitude];
  
  [geocoder reverseGeocodeLocation: loc completionHandler:
   ^(NSArray *placemarks, NSError *error)
   {
     CLPlacemark *placemark = [placemarks objectAtIndex:0];
     NSString *tempGeoLocation;
     
     //String to hold address
     locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
     NSLog(@"addressDictionary %@", placemark.addressDictionary);
     
     //If no geographic place matches a given coordinate
     if ([placemark.addressDictionary isEqual:(NULL)]
         || [placemark.addressDictionary isEqual:[NSNull null]]
         || [placemark.addressDictionary isEqual:nil]
         || [locatedAt isEqual:NULL]
         || [locatedAt isEqual:[NSNull null]]
         || [locatedAt isEqual:nil]
         || ([placemark.addressDictionary count] < 1))
     {
       tempGeoLocation = [[NSString alloc] initWithFormat:@"Hi there! I am currently over Earth"];
       locatedAt = @"Earth";
     }
     else
     {
        tempGeoLocation = [[NSString alloc] initWithFormat:@"Hi there! I am currently over %@", locatedAt];
     }
     
     //Assign location to geoLocation
     geoLocation = tempGeoLocation;
     NSLog(@"getISSGeoLocation - geoLocation: %@", geoLocation);
   }
   ];
  
  return geoLocation;
}


#pragma mark - [About] button implementation
- (IBAction)shareToSocial:(id)sender
{
  //Social Network Action Sheet
  socialNetworksSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Share ISS' Location!"
                                       delegate:self
                              cancelButtonTitle:@"Cancel"
                         destructiveButtonTitle:nil
                              otherButtonTitles:
                                 @"Twitter"
                                , @"Facebook"
                                , nil];
  
  [socialNetworksSheet showInView:[[UIApplication sharedApplication] keyWindow]];
  [socialNetworksSheet setBounds :CGRectMake(0, 0, 320, 300)];
  [socialNetworksSheet setActionSheetStyle:UIActionSheetStyleDefault];
}


#pragma mark - Action Sheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
  //Cancel
  if (buttonIndex == [socialNetworksSheet cancelButtonIndex])
  {
    [socialNetworksSheet dismissWithClickedButtonIndex:0 animated:YES];
  }
  //Twitter
  else if (buttonIndex == 0)
  {
    [self tweet];
  }
  //Facebook
  else if (buttonIndex == 1)
  {
    [self facebook];
  }
}


#pragma mark - Get screenshot for Social Network posts
-(void) getScreenshot
{
  UIGraphicsBeginImageContext(CGSizeMake(320, 480));
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  [mapView.layer renderInContext:context];
  
  screenshot = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
}


#pragma mark - Twitter integration
- (void) tweet
{
  NSLog(@"Tweet tweet");
  [socialNetworksSheet dismissWithClickedButtonIndex:0 animated:YES];
  
  [self getISSGeoLocation];
  
  [self getScreenshot];
  
  if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
  {
    SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    NSString *tweetMessage = [[NSString alloc] initWithFormat:
                              @"The ISS is currently over %@\n"
                              @"I'm tweeting using WhereISS app."
                              , locatedAt];
    
    [tweetSheet setInitialText:tweetMessage];
    [tweetSheet addImage:screenshot];
    [self presentViewController:tweetSheet animated:YES completion:nil];
  }
  else
  {
    UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                        message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account configured in Settings."
                                       delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
  }
}


#pragma mark - Facebook integration
- (void) facebook
{
  NSLog(@"Facebook");
  [socialNetworksSheet dismissWithClickedButtonIndex:0 animated:YES];
  
  [self getISSGeoLocation];
  
  [self getScreenshot];
  
  if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
  {
    SLComposeViewController *fbSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    NSString *fbMessage = [[NSString alloc] initWithFormat:
                           @"The ISS is currently over %@\n"
                           @"Posted using WhereISS app.\n"
                           , locatedAt];
    
    NSURL *urlString = [NSURL URLWithString:@"http://www.dungeoninnovations.com/"];
    
    [fbSheet setInitialText:fbMessage];
    [fbSheet addImage:screenshot];
    [fbSheet addURL:urlString];
    [self presentViewController:fbSheet animated:YES completion:nil];
  }
  else
  {
    UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Cannot Post To Facebook"
                                        message:@"Make sure your device has an internet connection and you have at least one Facebook account configured in Settings."
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
  NSString *source6 = @"http://science.nationalgeographic.com/science/space/space-exploration/international-space-station-article/";
  
  
  NSString *aboutString = [[NSString alloc] initWithFormat:
                           @"Fact Sources: "
                           @"%@\n\n "
                           @"%@\n\n "
                           @"%@\n\n "
                           @"%@\n\n "
                           @"%@\n\n "
                           @"%@\n\n "
                           @"This app is part of the NASA International Space Apps Challenge 2013.\n\n"
                           @"Powered by Dungeon Innovations.\n"
                           @"www.dungeoninnovations.com\n\n"
                           , source1
                           , source2
                           , source3
                           , source4
                           , source5
                           , source6];
  
  
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
  httpResponse     = (NSHTTPURLResponse *)response;
  httpResponseCode = [httpResponse statusCode];
  NSLog(@"httpResponse status code: %d", httpResponseCode);
  
  if(httpResponseCode == 200)
  {
    NSLog(@"Data retrieved.");
  }
  else
  {
    //Show an alert if connection is not available
    UIAlertView *connectionAlert = [[UIAlertView alloc]
                                        initWithTitle:@"Warning"
                                              message:@"No network connection detected."
                                             delegate:nil
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
    [connectionAlert show];
  }
}


@end
