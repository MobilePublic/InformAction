//
//  HelpViewController.m
// 
//
//  Created by Admin on 8/5/11.
//  Copyright 2011 MobilePublic All rights reserved.
////  Released to Public Domain

#import "HelpViewController.h"

@implementation HelpViewController
@synthesize delegate;

-(IBAction)backButton {
	[self.delegate helpViewControllerDidFinish:self];
    NSLog(@"hit");
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
