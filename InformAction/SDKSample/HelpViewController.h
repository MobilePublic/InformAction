//
//  HelpViewController.h
//  
//
//  Created by Admin on 8/5/11.
//  Copyright 2011 MobilePublic All rights reserved.
////  Released to Public Domain


#import <UIKit/UIKit.h>
@protocol HelpViewControllerDelegate;

@interface HelpViewController : UIViewController <UIGestureRecognizerDelegate>{
	id <HelpViewControllerDelegate> delegate;

}
@property (nonatomic, retain) id <HelpViewControllerDelegate> delegate;

-(IBAction)backButton;
@end

@protocol HelpViewControllerDelegate

- (void)helpViewControllerDidFinish:(HelpViewController *)controller;

@end