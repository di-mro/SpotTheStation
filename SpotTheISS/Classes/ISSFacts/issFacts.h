//
//  issFacts.h
//  SpotTheISS
//
//  Created by Mary Rose Oh on 4/18/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface issFacts : NSObject

@property (strong, nonatomic) NSMutableArray *issFactsArray;

-(void) initFacts;
-(void) displayFact;

@end
