//
//  MapViewController.h
//  SpotTheISS
//
//  Created by Mary Rose Oh on 4/15/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "MyAnnotation.h"

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *map;
@property (strong, nonatomic) IBOutlet UINavigationBar *issNavigationBar;

@property (strong, nonatomic) NSMutableDictionary *location;

@property CLLocationCoordinate2D issLocation;
@property MKCoordinateRegion region;
@property MKCoordinateSpan span;

@property MyAnnotation *annotation;

@property (strong, nonatomic) NSString *geoLocation;
@property (strong, nonatomic) NSString *locatedAt;

@property int httpResponseCode;

- (IBAction)tweetButton:(id)sender;
- (IBAction)aboutButton:(id)sender;


@end
