//
//  WHDViolationDetail.m
//  SDKSample
//
//  Created by Admin on 8/5/11.
//  Copyright 2011 MobilePublic All rights reserved.
////  Released to Public Domain


#import "WHDViolationDetail.h"

@implementation WHDViolationDetail

@synthesize inspectionDetail;

@synthesize trade_nm, streetAddress, naic_cd, naics_code_description, findings_dates, flsa_bw_atp_amt, flsa_ee_atp_cnt, flsa_violtn_cnt, flsa_cl_minor_cnt,flsa_cmp_assd_amt,flsa_cl_violtn_cnt,flsa_mw_bw_atp_amt,flsa_ot_bw_atp_amt,flsa_15a3_bw_atp_amt,flsa_cl_cmp_assd_amt,flsa_repeat_violator, scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self.scrollView.frame = self.view.frame;
    self.scrollView.contentSize = CGSizeMake(320, 500);
    [self.view addSubview:scrollView];
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];

    //name
    trade_nm.text = inspectionDetail.trade_nm;
    
    //address
    streetAddress.text = [NSString stringWithFormat:@"%@ %@ %@ %@", inspectionDetail.street_addr_1_txt, inspectionDetail.city_nm, inspectionDetail.st_cd, inspectionDetail.zip_cd];
    
    //naic code
    naics_code_description.text = inspectionDetail.naics_code_description;
    
    //date
    findings_dates.text = [NSString stringWithFormat:@"%@ - %@", inspectionDetail.findings_start_date, inspectionDetail.findings_end_date];
    
    //flsa violation count
    flsa_violtn_cnt.text = [NSString stringWithFormat:@"%i", inspectionDetail.flsa_violtn_cnt];
    
    //repeat violator
    flsa_repeat_violator.text = inspectionDetail.flsa_repeat_violator;
    
    
    //back min wage
    //flsa_bw_atp_amt.text = [NSString stringWithFormat:@"%f", inspectionDetail.flsa_bw_atp_amt];
    NSString *backMinWageStr = [[NSString alloc] initWithFormat:@"%@", inspectionDetail.flsa_bw_atp_amt];
    NSDecimalNumber *bw_atp_amt = [NSDecimalNumber decimalNumberWithString:backMinWageStr];
    if ([backMinWageStr isEqualToString:@"(null)"]) {
        flsa_bw_atp_amt.text = [NSString stringWithFormat:@"0"];
    }
    else {
       flsa_bw_atp_amt.text = [NSString stringWithFormat:@"%@", [currencyFormatter stringFromNumber:bw_atp_amt]];
    }

    //elig employee
      flsa_ee_atp_cnt.text = [NSString stringWithFormat:@"%i", inspectionDetail.flsa_ee_atp_cnt];
    
    //idk
    NSString *mw_bw_atp_amt_str = [[NSString alloc] initWithFormat:@"%@", inspectionDetail.flsa_bw_atp_amt];
    //NSLog(@"%@", mw_bw_atp_amt_str);
    NSDecimalNumber *mw_bw_atp_amt = [NSDecimalNumber decimalNumberWithString:mw_bw_atp_amt_str];
    //NSLog(@"%@", [currencyFormatter stringFromNumber:mw_bw_atp_amt]);
    if ([mw_bw_atp_amt_str isEqualToString:@"(null)"]){
        flsa_mw_bw_atp_amt.text = [NSString stringWithFormat:@"0"];
    }
    else {
        flsa_mw_bw_atp_amt.text =[NSString stringWithFormat:@"%@", [currencyFormatter stringFromNumber:mw_bw_atp_amt]];
    }

    //overtime back wage
    NSString *ot_bw_atp_amt_str = [[NSString alloc] initWithFormat:@"%@", inspectionDetail.flsa_ot_bw_atp_amt];
    NSDecimalNumber *ot_bw_atp_amt = [NSDecimalNumber decimalNumberWithString:ot_bw_atp_amt_str];
    if ([ot_bw_atp_amt_str isEqualToString:@"(null)"]) {
        flsa_ot_bw_atp_amt.text = [NSString stringWithFormat:@"0"];
    }
    else{
        flsa_ot_bw_atp_amt.text =[NSString stringWithFormat:@"%@", [currencyFormatter stringFromNumber:ot_bw_atp_amt]];
    }
    
    //workers who meet min wage via waiters
    NSString *a3_bw_atp_amt_str = [[NSString alloc] initWithFormat:@"%@", inspectionDetail.flsa_15a3_bw_atp_amt];
    NSDecimalNumber *a3_bw_atp_amt = [NSDecimalNumber decimalNumberWithString:a3_bw_atp_amt_str];
    if ([a3_bw_atp_amt_str isEqualToString:@"(null)"]) {
        flsa_15a3_bw_atp_amt.text = [NSString stringWithFormat:@"0"];
    }
    else {
        flsa_15a3_bw_atp_amt.text = [NSString stringWithFormat:@"%@", [currencyFormatter stringFromNumber:a3_bw_atp_amt]];
    }

    //civil money penalties
    NSString *cmp_assd_amt_str = [NSString stringWithFormat:@"%@", inspectionDetail.flsa_cmp_assd_amt];
    NSDecimalNumber *cmp_assd_amt = [NSDecimalNumber decimalNumberWithString:cmp_assd_amt_str];
    if ([cmp_assd_amt_str isEqualToString:@"(null)"]) {
        flsa_cmp_assd_amt.text = [NSString stringWithFormat:@"0"];
    }
    else {
        flsa_cmp_assd_amt.text = [NSString stringWithFormat:@"%@", [currencyFormatter stringFromNumber:cmp_assd_amt]];
    }

    //child labor violations
    flsa_cl_violtn_cnt.text = [NSString stringWithFormat:@"%i", inspectionDetail.flsa_cl_violtn_cnt];
    
    //illegal employed minors
    flsa_cl_minor_cnt.text = [NSString stringWithFormat:@"%i", inspectionDetail.flsa_cl_minor_cnt];
    
    //child labor penalty
    NSString *cl_cmp_assd_amt_str = [NSString stringWithFormat:@"%@", inspectionDetail.flsa_cl_cmp_assd_amt];
    NSDecimalNumber *cl_cmp_assd_amt = [NSDecimalNumber decimalNumberWithString:cl_cmp_assd_amt_str];
    if ([cl_cmp_assd_amt_str isEqualToString:@"(null)"]) {
        flsa_cl_cmp_assd_amt.text = [NSString stringWithFormat:@"0"];
    }
    else {
        flsa_cl_cmp_assd_amt.text = [NSString stringWithFormat:@"%@", [currencyFormatter stringFromNumber:cl_cmp_assd_amt]];
    }
    
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
