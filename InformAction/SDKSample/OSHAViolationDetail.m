//
//  OSHAViolationDetail.m
//  SDKSample
//
//  Created by Admin on 8/5/11.
//  Copyright 2011 MobilePublic All rights reserved.
////  Released to Public Domain


#import "OSHAViolationDetail.h"

@implementation OSHAViolationDetail
@synthesize inspectionDetail, name, naics_code, address, serious_violation, total_penalty, total_violations, open_date, load_date, inspection_type, violation_indicator;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    //path to naic code plist
    NSString *path = [[NSBundle mainBundle] pathForResource:@"NAICS" ofType:@"plist"];        
    NSDictionary *coordinatesDictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    //place name
    name.text = [NSString stringWithFormat:@"%@", inspectionDetail.estab_name];
    
    //address string
    NSString *addressStr = [[NSString alloc] initWithFormat:@"%@\n %@, %@ %@",inspectionDetail.site_address, inspectionDetail.site_city, inspectionDetail.site_state, inspectionDetail.site_zip];
    //NSLog(@"addressStr: %@", addressStr);
    address.text = addressStr;

    //niac code string
    NSString *naicString = [[NSString alloc] initWithFormat:@"%@",[coordinatesDictionary objectForKey:inspectionDetail.naics_code]];
    naics_code.text = naicString;
    
    //date complaint was filed
    NSString *openDateString = [[NSString alloc] initWithFormat:@"%@", inspectionDetail.open_date];
    open_date.text = openDateString;
    
    //date inspection happened
    NSString *loadDateString = [[NSString alloc] initWithFormat:@"%@", inspectionDetail.load_dt];
    load_date.text = loadDateString;

    //violation yes no
    NSLog(@"OSHA VIOLATION INDICATOR = %d", inspectionDetail.osha_violation_indicator);
    if (inspectionDetail.osha_violation_indicator == 1){
        violation_indicator.text = [NSString stringWithFormat:@"Yes"];
    }
    else if (inspectionDetail.osha_violation_indicator == 0){
        violation_indicator.text = [NSString stringWithFormat:@"No"];
    }
    
    //number of serious violations
    NSString *seriousString = [NSString stringWithFormat:@"%@", inspectionDetail.serious_violations];
    NSLog(@"serious violations    %@", seriousString);
    if ([seriousString isEqualToString:@"<null>"]) {
        serious_violation.text = [NSString stringWithFormat:@"0"];
        //NSLog(@"sv null");

    }
    else {
        serious_violation.text = seriousString;
        //NSLog(@"sv not null");

    }
    
    NSString *totalViolationsStr = [NSString stringWithFormat:@"%@", inspectionDetail.total_violations];
    if ([totalViolationsStr isEqualToString:@"<null>"]) {
        total_violations.text = [NSString stringWithFormat:@"0"];
        //NSLog(@"tv null");
    }
    else {
        total_violations.text = totalViolationsStr;
        //NSLog(@"tv not null");
    }
    
    //total current penalty 
    NSString *penaltyStr = [[NSString alloc] initWithFormat:@"%@", inspectionDetail.total_current_penalty];
    NSDecimalNumber *totalPenalty = [NSDecimalNumber decimalNumberWithString:penaltyStr];
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    //NSLog(@"%@", [currencyFormatter stringFromNumber:totalPenalty]);
    if ([penaltyStr isEqualToString:@"<null>"]) {
        total_penalty.text = [NSString stringWithFormat:@"0"];
    }
    else {
        total_penalty.text = [NSString stringWithFormat:@"%@", [currencyFormatter stringFromNumber:totalPenalty]];
    }
    self.title = inspectionDetail.insp_type;
    
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
