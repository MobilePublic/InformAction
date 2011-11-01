//
//  TableViewOptionsViewController.m
//  SDKSample
//
//  Created by Admin on 8/5/11.
//  Copyright 2011 MobilePublic All rights reserved.
////  Released to Public Domain

#import "TableViewOptionsViewController.h"

@implementation TableViewOptionsViewController
@synthesize tableSegmentedControl, dataSetSegmentedControl, delegate, dataset, table;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.view.backgroundColor = background;
    [background release];
    
    
    dataset = [[NSString alloc] init];
    table = [[NSString alloc] init];
    
    dataset = @"OSHA";
    table = @"full";
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)tableSegmentedControlChanged:(id)sender{
    
    switch (tableSegmentedControl.selectedSegmentIndex) {
        case 0:
            NSLog(@"Selected all tables");
            table = @"full";
            break;
        case 1:
            NSLog(@"Selected retail");
            table = @"retail";
            break;
        case 2:
            NSLog(@"Selected hotel");
            table = @"hospitality";
            break;
        case 3:
            NSLog(@"Sected food");
            table = @"food";
            break;
        default:
            break;
    }
    
    [self.delegate optionsDidFinish:self];
    
}

- (IBAction)dataSetSegmentedControlChanged:(id)sender{
    switch (dataSetSegmentedControl.selectedSegmentIndex) {
        case 0:
            NSLog(@"Selected OSHA");
            dataset = @"OSHA";
            [dataSetSegmentedControl setSelectedSegmentIndex:0];
            break;
        case 1:
            NSLog(@"Selected WHD");
            dataset = @"WHD";
            [dataSetSegmentedControl setSelectedSegmentIndex:1];
            break;
            
        default:
            break;
    }
    
    [self.delegate optionsDidFinish:self];
    
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
