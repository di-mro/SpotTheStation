//
//  MyAnnotation.m
//  SpotTheISS
//
//  Created by Mary Rose Oh on 4/18/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation

@synthesize coordinate;

- (NSString *)subtitle
{
	return nil;
}

- (NSString *)title
{
	return nil;
}


-(id)initWithCoordinate:(CLLocationCoordinate2D) c
{
	coordinate = c;
	return self;
}

@end
