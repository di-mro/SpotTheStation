//
//  MapViewController.h
//  SpotTheISS
//
//  Created by Mary Rose Oh on 4/15/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *map;
@property (strong, nonatomic) IBOutlet UINavigationBar *issNavigationBar;

@property (strong, nonatomic) NSMutableDictionary *location;

- (IBAction)tweetButton:(id)sender;
- (IBAction)aboutButton:(id)sender;


@end
