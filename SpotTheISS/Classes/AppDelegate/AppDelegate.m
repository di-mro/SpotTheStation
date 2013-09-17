//
//  AppDelegate.m
//  SpotTheISS
//
//  Created by Mary Rose Oh on 4/15/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  /*
  //Change font and appearance of UINavigationBar title
  if ([[UINavigationBar class] respondsToSelector:@selector(appearance)])
  {
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor whiteColor], UITextAttributeTextColor,
                                                          [UIColor blackColor], UITextAttributeTextShadowColor,
                                                          [NSValue valueWithUIOffset:UIOffsetMake(1, 0)], UITextAttributeTextShadowOffset,
                                                          [UIFont fontWithName:@"Chalkduster" size:20.0], UITextAttributeFont, nil]];
  }
   //*/
  
  [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                        [UIColor whiteColor], UITextAttributeTextColor,
                                                        [UIColor blackColor], UITextAttributeTextShadowColor,
                                                        [NSValue valueWithUIOffset:UIOffsetMake(1, 0)], UITextAttributeTextShadowOffset,
                                                        [UIFont fontWithName:@"Chalkduster" size:20.0], UITextAttributeFont, nil]];
  
  //Change font of UIBarButtonItems
  [[UIBarButtonItem appearance] setTitleTextAttributes:
   [NSDictionary dictionaryWithObjectsAndKeys:
    [UIColor whiteColor], UITextAttributeTextColor,
    [UIColor blackColor], UITextAttributeTextShadowColor,
    [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
    [UIFont fontWithName:@"American Typewriter" size:13.0], UITextAttributeFont, nil]
                                              forState:UIControlStateNormal];
  
  
  issMapInit = [MapViewController alloc];
  
  // Override point for customization after application launch.
  return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  issMapInit = [MapViewController alloc];
  
  facts = [issFacts alloc];
  [facts displayFact];
  
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
