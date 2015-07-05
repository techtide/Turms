//
//  main.h
//  HappyDay
//
//  Created by Arman Bhalla on 8/24/14.
//  Copyright (c) 2014 virtualcheddar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ParseExampleAppDelegate : UIResponder <UIApplicationDelegate>

@property PFUser *applicationUser;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) NSString* stringToDisplay;

@end