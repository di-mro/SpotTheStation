//
//  GoogleMapViewController.h
//  SpotTheISS
//
//  Created by Mary Rose Oh on 10/17/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Social/Social.h>

#import <GoogleMaps/GoogleMaps.h>


@interface GoogleMapViewController : UIViewController<GMSMapViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UINavigationBar *issNavBar;
@property (strong, nonatomic) IBOutlet GMSMapView *mapView;

@property (strong, nonatomic) NSMutableDictionary *location;

@property CLLocationCoordinate2D issLocation;
@property (strong, nonatomic) NSString *locatedAt;
@property (strong, nonatomic) NSString *geoLocation;

@property int httpResponseCode;
@property int onlineFlag;

@property (strong, nonatomic) UIActionSheet *socialNetworksSheet;
@property (strong, nonatomic) UIImage *screenshot;


- (IBAction)shareToSocial:(id)sender;
- (IBAction)aboutButton:(id)sender;


@end
