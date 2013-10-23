//
//  AppDelegate.h
//  SpotTheISS
//
//  Created by Mary Rose Oh on 4/15/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

#import "MapViewController.h"
#import "issFacts.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
  MapViewController *issMapInit;
  issFacts *facts;
}

@property (strong, nonatomic) UIWindow *window;




@end

