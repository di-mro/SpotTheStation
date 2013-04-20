//
//  MyAnnotation.h
//  SpotTheISS
//
//  Created by Mary Rose Oh on 4/18/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MyAnnotation : MKPointAnnotation
{
  CLLocationCoordinate2D coordinate;
}

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *subtitle;


-(id)initWithCoordinate:(CLLocationCoordinate2D) c;


@end
