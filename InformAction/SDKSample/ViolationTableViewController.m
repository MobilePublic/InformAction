//
//  ViolationTableViewController.m
//  SDKSample
//
//  Created by Admin on 8/5/11.
//  Copyright 2011 MobilePublic All rights reserved.
////  Released to Public Domain


#import "ViolationTableViewController.h"
#import "MyWHDLocation.h"
#import "MyOSHALocation.h"


@implementation ViolationTableViewController

@synthesize tableView, currentZip, optionsViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    dataArray =[[NSMutableArray alloc] init];
    
    whdDetail = [[WHDViolationDetail alloc] initWithNibName:@"WHDViolationDetail" bundle:nil];
    InformActionAppDelegate *appDelegate = (InformActionAppDelegate *)[[UIApplication sharedApplication] delegate];
    detailsViewController = [[ViolationDetailsViewController alloc] initWithNibName:@"ViolationDetailsViewController" bundle:nil];
    optionsViewController = [[TableViewOptionsViewController alloc] initWithNibName:@"TableViewOptionsViewController" bundle:nil];
    wData = appDelegate.wData;
    oData = appDelegate.oData;
    
    UIBarButtonItem *geolocateButton = [[UIBarButtonItem alloc] initWithTitle:@"GEO" style:UIBarButtonItemStylePlain target:self action:@selector(geolocate)];
    self.navigationItem.rightBarButtonItem = geolocateButton;
    
    
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)geolocate{
    locMgr = [[LocationManager alloc] init];
    locMgr.delegate = self;
    [locMgr.locMgr startUpdatingLocation];
    
    // spoof of zip code for fail simulator
  //  currentZip = @"98103";
    
   // [self loadTableForZip:currentZip forDataset:optionsViewController.dataset forTable:optionsViewController.table];
    
}

- (void)loadTableForZip:(NSString *)zip forDataset:(NSString *)dataSet forTable:(NSString *)table{
    oData.delegate = self;
    wData.delegate = self;
    
    [dataArray removeAllObjects];
    
    int zipInt = [zip integerValue];
    int variance = 2;
    
    
    if ([dataSet isEqualToString:@"OSHA"]){
        NSString *zipString = [[NSString alloc] initWithFormat:@"(site_zip ge '%i') and (site_zip le '%i')", zipInt - variance, zipInt + variance];
        NSDictionary *arguments = [NSDictionary dictionaryWithObjectsAndKeys:@"activity_nr,estab_name,site_address,site_city,site_state,site_zip,naics_code,insp_type,open_date,total_current_penalty,osha_violation_indicator,serious_violations,total_violations,load_dt", @"select",zipString, @"filter",nil];
        [oData getObjectsForArguments:arguments table:table];
        
        
    }
    else{
        NSString *zipString = [[NSString alloc] initWithFormat:@"(zip_cd ge '%i') and (zip_cd le '%i')", zipInt - variance, zipInt + variance];
        
        NSDictionary *arguments = [NSDictionary dictionaryWithObjectsAndKeys:@"trade_nm, street_addr_1_txt, city_nm, st_cd, zip_cd, naic_cd, naics_code_description, findings_end_date, findings_start_date, flsa_bw_atp_amt, flsa_ee_atp_cnt, flsa_violtn_cnt, flsa_cl_minor_cnt,flsa_cmp_assd_amt,flsa_cl_violtn_cnt,flsa_mw_bw_atp_amt,flsa_ot_bw_atp_amt,flsa_15a3_bw_atp_amt,flsa_cl_cmp_assd_amt,flsa_repeat_violator", @"select",zipString, @"filter",nil];
        [wData getObjectsForArguments:arguments table:table];
        
    }

    
    
    
}

- (void)OSHADataHandlerDidFinishWithArray:(NSArray *)results{
    OSHAInspectionsArray = [[NSArray alloc] initWithArray:results];
    NSLog(@"finished with array");
    
    //dataArray =[[NSArray alloc] initWithArray:results];
    
    for (OSHAInspection *row in OSHAInspectionsArray) {
        
        
        bool foundMatchingAddress = NO;
        
        for (id<MKAnnotation> annotation in dataArray){
            if ([annotation isKindOfClass:[MyOSHALocation class]]){
                
                if ([((MyOSHALocation*)annotation).inspection.site_address isEqualToString:row.site_address] && [((MyOSHALocation*)annotation).inspection.site_zip isEqualToString:row.site_zip]) {
                    
                    bool alreadyInArray = NO;
                    for (OSHAInspection *insp in ((MyOSHALocation*)annotation).inspectionArray) {
                        if (insp.activity_nr == row.activity_nr){
                            alreadyInArray = YES;
                        }
                    }
                    
                    if (!alreadyInArray) {
                        [((MyOSHALocation*)annotation).inspectionArray addObject:row];
                    }
                    foundMatchingAddress = YES;
                    
                }
            }
            
        }
        
        if (!foundMatchingAddress){
            
            CLLocationCoordinate2D coordinate;
            coordinate.latitude = (CLLocationDegrees)row.latitude;
            coordinate.longitude = (CLLocationDegrees)row.longitude;            
            MyOSHALocation *annotation = [[[MyOSHALocation alloc] initWithName:row.estab_name address:row.site_address coordinate:coordinate] autorelease];
            annotation.inspection = row;
            [annotation.inspectionArray addObject:row];
            
            [dataArray addObject:annotation];
            NSLog(@"Placed annotation");
        }
        else NSLog(@"address already existed");
        
        
    }
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIImageView *headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    headerImage.image = [UIImage imageNamed:@"pole_topper.png"];
    
    [headerView addSubview:headerImage];
    
    
    tableView.tableHeaderView = headerView;
    

    int footerHeight = 420 - 44 - 40 - ([dataArray count] * 44);
    
    if (footerHeight > 0){
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320,footerHeight)];
        UIImageView *footerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, footerHeight)];
        footerImage.image = [UIImage imageNamed:@"violation_polecell.png"];
        
        [footerView addSubview:footerImage];
        
        tableView.tableFooterView = footerView;
    }
    else{
        tableView.tableFooterView= nil;
    }
    [tableView reloadData];
    

    
}

- (void)WHDDataHandlerDidFinishWithArray:(NSArray *)results{
    WHDInspectionsArray = [[NSArray alloc] initWithArray:results];
    
    //dataArray =[[NSArray alloc] initWithArray:results];
    
    for (WHDInspection *row in WHDInspectionsArray) {
        
        
        bool foundMatchingAddress = NO;
        
        for (id<MKAnnotation> annotation in dataArray){
            if ([annotation isKindOfClass:[MyWHDLocation class]]){
                
                if ([((MyWHDLocation*)annotation).inspection.street_addr_1_txt isEqualToString:row.street_addr_1_txt] && [((MyWHDLocation*)annotation).inspection.zip_cd isEqualToString:row.zip_cd]) {
                    
                    bool alreadyInArray = NO;
                    for (WHDInspection *insp in ((MyWHDLocation*)annotation).inspectionArray) {
                        if ([insp.street_addr_1_txt isEqualToString:row.street_addr_1_txt]){
                            alreadyInArray = YES;
                        }
                    }
                    
                    if (!alreadyInArray) {
                        [((MyWHDLocation*)annotation).inspectionArray addObject:row];
                    }
                    foundMatchingAddress = YES;
                    
                }
            }
            
        }
        
        if (!foundMatchingAddress){
            
            //NSLog(@"loop %f %f",i.latitude, i.longitude);
            CLLocationCoordinate2D coordinate;
            coordinate.latitude = (CLLocationDegrees)row.latitude;
            coordinate.longitude = (CLLocationDegrees)row.longitude;            
            MyWHDLocation *annotation = [[[MyWHDLocation alloc] initWithName:row.trade_nm address:row.street_addr_1_txt coordinate:coordinate] autorelease];
            annotation.inspection = row;
            [annotation.inspectionArray addObject:row];
            
            [dataArray addObject:annotation]; //[map 
        }
        else NSLog(@"address already existed");
        
        
    }

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIImageView *headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    headerImage.image = [UIImage imageNamed:@"pole_topper.png"];
    
    [headerView addSubview:headerImage];
    
    
    tableView.tableHeaderView = headerView;
    
    
    
    
    int footerHeight = 420 - 44 - 40 -([dataArray count] * 44);
    
    if (footerHeight > 0){
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320,footerHeight)];
        UIImageView *footerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, footerHeight)];
        footerImage.image = [UIImage imageNamed:@"violation_polecell.png"];
        
        [footerView addSubview:footerImage];
        
        tableView.tableFooterView = footerView;
    }
    else{
        tableView.tableFooterView= nil;
    }
    
    
    [tableView reloadData];
    
    

    
}


- (void)locationUpdate:(CLLocation *)location {
	NSLog(@"Current location found");
    
    NSLog(@"%@", location);
    [locMgr.locMgr stopUpdatingLocation];
    MKReverseGeocoder *rg = [[MKReverseGeocoder alloc] initWithCoordinate:location.coordinate];
    rg.delegate = self;
    [rg start];
    
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
    
    MKPlacemark *myPlacemark = placemark;
    NSLog(@"%@", myPlacemark.postalCode);
    currentZip = myPlacemark.postalCode;
    [self loadTableForZip:currentZip forDataset:optionsViewController.dataset forTable:optionsViewController.table];
    
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error{
    NSLog(@"reverse geocode failed with error: %@", error);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Couldn't use your current location.  Make sure location services are enabled" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
    
}


- (void)locationError:(NSError *)error {
    NSLog(@"error with location");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Couldn't use your current location.  Make sure location services are enabled" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)viewWillAppear:(BOOL)animated{
    
    
    self.title = @"iCitizen";

    
    /*
    UITextField *zipTextField = [[UITextField alloc] initWithFrame:CGRectMake(200, 5, 110, 30)];
    [zipTextField setBorderStyle:UITextBorderStyleRoundedRect];
    
    
    
    [self.navigationController.navigationBar addSubview:zipTextField]; */
//    self.navigationItem.titleView = zipTextField;
    
    //[self.view addSubview:zipTextField];
   // [self.navigationController.navigationBar addSubview:zipTextField];

    
}

- (IBAction)showTableOptions:(id)sender{
    
    [optionsViewController setModalTransitionStyle:UIModalTransitionStylePartialCurl];
    optionsViewController.delegate = self;
    [self presentModalViewController:optionsViewController animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)optionsDidFinish:(id)optionsController{
    
    [optionsViewController dismissModalViewControllerAnimated:YES];
    [self loadTableForZip:currentZip forDataset:optionsViewController.dataset forTable:optionsViewController.table];
    
}

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    self.title = @"iCitizen";
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.rowHeight = 50;
    tableView.backgroundColor = [UIColor clearColor];
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

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if ([optionsViewController.dataset isEqualToString:@"OSHA"]){
        detailsViewController.OSHAInspectionDetail = ((MyOSHALocation *)[dataArray objectAtIndex:indexPath.row]).inspection;
        detailsViewController.dataSet = @"OSHA";
        detailsViewController.inspectionArray = ((MyOSHALocation *)[dataArray objectAtIndex:indexPath.row]).inspectionArray;
        
        [self.navigationController pushViewController:detailsViewController animated:YES];
    }
    else if ([optionsViewController.dataset isEqualToString:@"WHD"]){
        detailsViewController.WHDInspectionDetail = ((MyWHDLocation *)[dataArray objectAtIndex:indexPath.row]).inspection;
        detailsViewController.dataSet = @"WHD";
        detailsViewController.inspectionArray = ((MyWHDLocation *)[dataArray objectAtIndex:indexPath.row]).inspectionArray;
        
        [self.navigationController pushViewController:detailsViewController animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UILabel *topLabel;
    
    const NSInteger TOP_LABEL_TAG = 1001;
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ( cell == nil ) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
        //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        UIImage *indicatorImage = [UIImage imageNamed:@"indicator.png"];
        cell.accessoryView =
        [[[UIImageView alloc]
          initWithImage:indicatorImage]
         autorelease];
        
        topLabel =
        [[[UILabel alloc]
          initWithFrame:
          CGRectMake(45,10,230,30)]
         autorelease];
        [cell.contentView addSubview:topLabel];
        
        
        topLabel.tag = TOP_LABEL_TAG;
        topLabel.backgroundColor = [UIColor clearColor];
        topLabel.textColor = [UIColor whiteColor];
        topLabel.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
        topLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
        topLabel.font = [UIFont boldSystemFontOfSize:15];
        

        cell.backgroundView =
        [[[UIImageView alloc] init] autorelease];
        cell.selectedBackgroundView =
        [[[UIImageView alloc] init] autorelease];

        
        
    } else {
        // "cell 1" was present in the cache, so log that we're reusing it
        //NSLog(@"reusing cell '%@' (%p) for row %d...", cell.reuseIdentifier, cell, indexPath.row);
        topLabel = (UILabel *)[cell viewWithTag:TOP_LABEL_TAG];
        
    }
    
    
    
   // cell.imageView.frame = CGRectMake(-25, -25, 35, 35);
    //cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    NSString *cellLabelString;

    UIImage *cellImage;
    
    if ([optionsViewController.dataset isEqualToString:@"OSHA"]){
    
        cellLabelString = [NSString stringWithFormat:@"%@",((MyOSHALocation *)[dataArray objectAtIndex:indexPath.row]).inspection.estab_name];
        
        if ([((MyOSHALocation *)[dataArray objectAtIndex:indexPath.row]).inspection.establishmentType isEqualToString:@"FoodService"]){
            cell.imageView.image = [UIImage imageNamed:@"fork_knife_white.png"];
        }
        else if ([((MyOSHALocation *)[dataArray objectAtIndex:indexPath.row]).inspection.establishmentType isEqualToString:@"Retail"]){
            cell.imageView.image = [UIImage imageNamed:@"cart_white.png"];
        }
        else{
            cell.imageView.image = [UIImage imageNamed:@"bed_white.png"];
            
        }

        
    }
    else {
        cellLabelString = [NSString stringWithFormat:@"%@",((MyWHDLocation *)[dataArray objectAtIndex:indexPath.row]).inspection.trade_nm];
        
        if ([((MyWHDLocation *)[dataArray objectAtIndex:indexPath.row]).inspection.establishmentType isEqualToString:@"FoodService"]){
            cell.imageView.image = [UIImage imageNamed:@"fork_knife_white.png"];
        }
        else if ([((MyWHDLocation *)[dataArray objectAtIndex:indexPath.row]).inspection.establishmentType isEqualToString:@"Retail"]){
            cell.imageView.image = [UIImage imageNamed:@"cart_white.png"];
        }
        else{
            cell.imageView.image = [UIImage imageNamed:@"bed_white.png"];
            
        }
        
        
    }
    
    //cell.imageView.image = cellImage;
    
    topLabel.text = cellLabelString;
    
    
    
    UIImage *rowBackground;// = [[UIImage alloc] init ];
	//UIImage *selectionBackground;
	//NSInteger sectionRows = [tableView numberOfRowsInSection:[indexPath section]];
	//NSInteger row = [indexPath row];
	/*
    
    if (row == 0 && row == sectionRows - 1)
	{
		rowBackground = [UIImage imageNamed:@"list_page_topcell.png"];
		//selectionBackground = [UIImage imageNamed:@"topAndBottomRowSelected.png"];
	}
	else if (row == 0)
	{
		rowBackground = [UIImage imageNamed:@"list_page_topcell.png"];
		//selectionBackground = [UIImage imageNamed:@"topRowSelected.png"];
	}
	else if (row == sectionRows - 1)
	{
		rowBackground = [UIImage imageNamed:@"list_page_bottomcell.png"];
		//selectionBackground = [UIImage imageNamed:@"bottomRowSelected.png"];
	}
	else
	{
		rowBackground = [UIImage imageNamed:@"list_page_bottomcell.png"];
		//selectionBackground = [UIImage imageNamed:@"middleRowSelected.png"];
	}
    */
    
    
    rowBackground = [UIImage imageNamed:@"list_page_bottomcell.png"];
	((UIImageView *)cell.backgroundView).image = rowBackground;
    
    
   // cell.textLabel.frame = CGRectMake(45, 0, 275, 40);
    
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [dataArray count];
    
    
}


@end
