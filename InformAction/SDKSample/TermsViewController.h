//
//  TermsViewController.h
//  
//
//  Created by Admin on 8/5/11.
//  Copyright 2011 MobilePublic All rights reserved.
////  Released to Public Domain



#import <UIKit/UIKit.h>

@class WeatherAppDelegate;

 
@interface TermsViewController : UIViewController 
{
	WeatherAppDelegate  *delegate; 
} 

@property (nonatomic, assign) WeatherAppDelegate  *delegate; 

- (IBAction)agreed:(id)sender;

@end


@protocol TermsViewControllerDelegate

- (void)termsViewControllerDidFinish:(TermsViewController *)controller;

@end
