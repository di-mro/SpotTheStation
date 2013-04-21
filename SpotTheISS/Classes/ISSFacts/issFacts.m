//
//  issFacts.m
//  SpotTheISS
//
//  Created by Mary Rose Oh on 4/18/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "issFacts.h"

@implementation issFacts

@synthesize issFactsArray;


#pragma mark - Initialize ISS facts
-(void) initFacts
{
  //Initialize ISS Facts
  NSString *fact1 = @"The International Space Station marked its 10th anniversary of continuous human occupation on November 2, 2010.";
  
  NSString *fact2 = @"Since Expedition 1, which launched October 31, 2000, and docked November 2, the space station has been visited by 204 individuals.";
  
  NSString *fact3 = @"At the time of the anniversary, the station’s odometer read more than 1.5 billion statute miles (the equivalent of eight round trips to the Sun), over the course of 57,361 orbits around the Earth.";
  
  NSString *fact4 = @"The space station, including its large solar arrays, spans the area of a U.S. football field, including the end zones, and weighs 861,804 pounds, not including visiting vehicles.";
  
  NSString *fact5 = @"The complex now has more livable room than a conventional five-bedroom house, and has two bathrooms, a gymnasium and a 360-degree bay window.";
  
  NSString *fact6 = @"The mass of the International Space Station is equivalent to 924,739 pounds (419,455 kilograms).";
  
  NSString *fact7 = @"The ISS solar array surface area could cover the U.S. Senate Chamber three times over.";
  
  NSString *fact8 = @"ISS is larger than a five-bedroom house.";
  
  NSString *fact9 = @"ISS has an internal pressurized volume of 32,333 cubic feet, or equal that of a Boeing 747.";
  
  NSString *fact10 = @"The solar array wingspan (240 feet) is longer than that of a Boeing 777 200/300 model, which is 212 feet.";
  
  NSString *fact11 = @"Fifty-two computers control the systems on the ISS.";
  
  NSString *fact12 = @"More than 115 space flights were conducted on five different types of launch vehicles over the course of the station’s construction.";
  
  NSString *fact13 = @"More than 100 telephone-booth-sized rack facilities can be in the ISS for operating the spacecraft systems and research experiments.";
  
  NSString *fact14 = @"The ISS is almost four times as large as the Russian space station Mir and about five times as large as the U.S. Skylab.";
  
  NSString *fact15 = @"The ISS weighs almost one million pounds (approximately 925,000 pounds). That’s the equivalent of more than 320 automobiles.";
  
  NSString *fact16 = @"The ISS measures 357 feet end-to-end. That’s equivalent to the length of a football field including the end zones (well, almost – a football field is 360 feet).";
  
  NSString *fact17 = @"3.3 million lines of software code on the ground support 1.8 million lines of flight software code.";
  
  NSString *fact18 = @"Eight miles of wire connects the electrical power system.";
  
  NSString *fact19 = @"In the International Space Station’s U.S. segment alone, 1.5 million lines of flight software code run on 44 computers communicating via 100 data networks transferring 400,000 signals (e.g. pressure or temperature measurements, valve positions, etc.).";
  
  NSString *fact20 = @"The ISS manages 20 times as many signals as the space shuttle.";
  
  NSString *fact21 = @"Main U.S. control computers have 1.5 gigabytes of total main hard drive storage in the U.S. segment compared to modern PCs, which have ~500 gigabyte hard drives.";
  
  NSString *fact22 = @"The entire 55-foot robot arm assembly is capable of lifting 220,000 pounds, which is the weight of a space shuttle orbiter.";
  
  NSString *fact23 = @"The 75 to 90 kilowatts of power for the ISS is supplied by an acre of solar panels.";
  
  NSString *fact24 = @"The ISS programme is a joint project among five participating space agencies: NASA, the Russian Federal Space Agency, JAXA, ESA, and CSA. The ownership and use of the space station is established by intergovernmental treaties and agreements.";
  
  NSString *fact25 = @"The ISS is maintained at an orbital altitude of between 330 km (205 mi) and 435 km (270 mi).";
  
  NSString *fact26 = @"The ISS travels at an average speed of 27,724 kilometres (17,227 mi) per hour and completes 15.7 orbits per day.";
  
  NSString *fact27 = @"The station has been visited by nearly 200 individuals from more than a dozen countries, including seven space tourists who bought rides on Russian rockets through the private firm Space Adventures.";
  
  NSString *fact28 = @"American astronaut Peggy Whitson holds the record for most spaceflight time logged by a woman. In two long-duration stays on the ISS, Whitson racked up 376 days in space.";
  
  NSString *fact29 = @"Spaceflight is hard on the body. Studies have shown that astronauts returning from long stays on the ISS have lost significant amounts of bone mass and bone strength, as much as a few percent a month, as a result of living in microgravity.";
  
  NSString *fact30 = @"Sergei Krikalev, member of Expedition 1 and Commander of Expedition 11 has spent more time in space than anyone else, a total of 803 days and 9 hours and 39 minutes.";
  
  NSString *fact31 = @"Presently, seven research racks are aboard the station with an additional five being built or already at the Kennedy Space Center in preparation for flight.";
  
  NSString *fact32 = @"The ISS effort involves more than 100,000 people in space agencies and at 500 contractor facilities in 37 U.S. states and in 16 countries. That's almost half of the entire population of North Dakota.";
  
  NSString *fact33 = @"Building the ISS in space is like trying to change a spark plug or hang a shelf, wearing roller skates and two pairs of ski gloves with all your tools, screws and materials tethered to your body so they don't drop.";
  
  NSString *fact34 = @"The Space Station circles the Earth every 90 minutes, and looks down on 85 percent of the populated areas.";
  
  NSString *fact35 = @"The human body tends to lose muscle and bone mass rapidly in space. To fight this loss, at least two hours of strenuous exercise is built into every astronaut's daily schedule on the Space Station.";
  
  
  //Initialize array of ISS Facts
  issFactsArray = [[NSMutableArray alloc]
                   initWithObjects: fact1
                                , fact2
                                , fact3
                                , fact4
                                , fact5
                                , fact6
                                , fact7
                                , fact8
                                , fact9
                                , fact10
                                , fact11
                                , fact12
                                , fact13
                                , fact14
                                , fact15
                                , fact16
                                , fact17
                                , fact18
                                , fact19
                                , fact20
                                , fact21
                                , fact22
                                , fact23
                                , fact24
                                , fact25
                                , fact26
                                , fact27
                                , fact28
                                , fact29
                                , fact30
                                , fact31
                                , fact32
                                , fact33
                                , fact34
                                , fact35
                                , nil];
}


#pragma mark - Method to display a random fact upon opening the app
-(void) displayFact
{
  [self initFacts];
  
  uint32_t randomIndex = arc4random_uniform([issFactsArray count]);
  
  NSString *randomFact = [issFactsArray objectAtIndex:randomIndex];
  NSLog(@"randomFact: %@", randomFact);
  
  UIAlertView *factAlert = [[UIAlertView alloc]
                            initWithTitle:@"ISS Fact"
                            message:randomFact
                            delegate:self
                            cancelButtonTitle:@"OK"
                            otherButtonTitles:nil];
  
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(230, 10, 60, 40)]; //(220, 10, 40, 40)
  
  NSString *path = [[NSString alloc] initWithString:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"iss_cartoon.png"]];
  UIImage *bkgImg = [[UIImage alloc] initWithContentsOfFile:path];
  [imageView setImage:bkgImg];
  
  [factAlert addSubview:imageView];
  [factAlert show];
}


@end
