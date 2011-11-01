//
//  TermsViewController.m
//  
//
//  Created by Admin on 8/5/11.
//  Copyright 2011 MobilePublic All rights reserved.
////  Released to Public Domain


#import "TermsViewController.h"


@implementation TermsViewController
@synthesize delegate;


- (IBAction)agreed:(id)sender{
     
    [delegate termsViewControllerDidFinish:self];
	
} 


- (void)dealloc 
{
	[super dealloc];
} 
@end