//
//  ViolationMapViewController.m
//  SDKSample
//
//  Created by Admin on 8/5/11.
//  Copyright 2011 MobilePublic All rights reserved.
////  Released to Public Domain


#import "ViolationMapViewController.h"
#import "MyOSHALocation.h"
#import "OSHAInspection.h"
#import "MyWHDLocation.h"

@implementation ViolationMapViewController
@synthesize map, locationManager, currentLocation, initialLocation, rg;
@synthesize violationDetailsViewController, oHandler, wHandler, dataArray, oldPostalCode, segmentedControl, tableViewController, controller;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    appDelegate = (InformActionAppDelegate *)[[UIApplication sharedApplication] delegate];
    oHandler = appDelegate.oData;
    wHandler = appDelegate.wData;
    
    oHandler.delegate = self;
    wHandler.delegate = self;
    
    dataSet = @"OSHA";
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationItem setHidesBackButton:YES animated:YES];
    self.navigationController.navigationBarHidden = NO;

    //self.view.frame = [[UIScreen mainScreen] applicationFrame];

    zoomWarning = [[UIView alloc] initWithFrame:CGRectMake(0, -30, 320, 30)];
    UILabel *warningLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    warningLabel.text = @"You're zoomed out too far!";
    warningLabel.textColor = [UIColor whiteColor];
    warningLabel.textAlignment = UITextAlignmentCenter;
    warningLabel.backgroundColor = [UIColor clearColor];
    zoomWarning.backgroundColor = [UIColor blackColor];
    zoomWarning.alpha = 0.65;
    [zoomWarning addSubview:warningLabel];
    [self.view addSubview:zoomWarning];
    
    annotationsHidden = NO;
    self.title = @"iCitizen";
    
    initialLocation = YES;
    rg.delegate = self;
    
    self.map.delegate = self;     
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.locationManager startUpdatingLocation];
    
    tableViewController = [[ViolationTableViewController alloc] initWithNibName:@"ViolationTableViewController" bundle:nil];
    
    UIBarButtonItem *tableButton = [[UIBarButtonItem alloc] initWithTitle:@"List" style:UIBarButtonItemStylePlain target:self action:@selector(listButtonPressed)];
    self.navigationItem.rightBarButtonItem = tableButton;
    
    UIImage *infoImage = [[UIImage alloc] initWithContentsOfFile:@"info_button.png"];
    UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithImage:infoImage style:UIBarButtonItemStylePlain target:self action:@selector(helpButtonPressed)];
    self.navigationItem.leftBarButtonItem = infoButton;
}

-(IBAction)helpButtonPressed{
    controller = [[[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil] autorelease];
    controller.delegate = self;
    controller.modalPresentationStyle = UIModalPresentationFullScreen; 
	[self presentModalViewController:controller animated:YES];
}

-(void)helpViewControllerDidFinish:(HelpViewController *)controller {
    [self dismissModalViewControllerAnimated:YES];
}

-(void)listButtonPressed{
    tableViewController.currentZip = oldPostalCode;
    tableViewController.optionsViewController.dataset = dataSet;
    [tableViewController loadTableForZip:tableViewController.currentZip forDataset:tableViewController.optionsViewController.dataset forTable:tableViewController.optionsViewController.table];
    
    
    [self.navigationController pushViewController:tableViewController animated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    oHandler.delegate = self;
    wHandler.delegate = self;
    
}

-(IBAction)segmentedControlChanged{
    
    
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            NSLog(@"Selected OSHA");
            dataSet = @"OSHA";
            [map removeAnnotations:map.annotations];
            [self makeOSHARequestForZip:[oldPostalCode integerValue]];
            break;
        case 1:
            NSLog(@"Selected WHD");
            dataSet = @"WHD";
            [map removeAnnotations:map.annotations];
            [self makeWHDRequestForZip:[oldPostalCode integerValue]];
            break;
        default:
            break;
    }
    
    
    
    //[self mapView:map regionDidChangeAnimated:YES];
}

- (void)OSHADataHandlerDidFinishWithArray:(NSArray *)results {
    dataArray =[[NSArray alloc] initWithArray:results];
        
    for (OSHAInspection *row in dataArray) {
       
        
        bool foundMatchingAddress = NO;
        
        for (id<MKAnnotation> annotation in map.annotations){
            if ([annotation isKindOfClass:[MyOSHALocation class]]){
                
                if ([((MyOSHALocation*)annotation).inspection.site_address isEqualToString:row.site_address] && [((MyOSHALocation*)annotation).inspection.site_zip isEqualToString:row.site_zip]) {
                    
                    bool alreadyInArray = NO;
                    for (OSHAInspection *insp in ((MyOSHALocation*)annotation).inspectionArray) {
                        //NSLog(@"insp activity_number: %l",insp.activity_nr);
                        //NSLog(@"row  activity_number: %l",row.activity_nr);
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
            
            //NSLog(@"loop %f %f",i.latitude, i.longitude);
            CLLocationCoordinate2D coordinate;
            coordinate.latitude = (CLLocationDegrees)row.latitude;
            coordinate.longitude = (CLLocationDegrees)row.longitude;            
            MyOSHALocation *annotation = [[[MyOSHALocation alloc] initWithName:row.estab_name address:row.site_address coordinate:coordinate] autorelease];
            annotation.inspection = row;
            [annotation.inspectionArray addObject:row];
            
            [self performSelectorOnMainThread:@selector(placeAnnotation:) withObject:annotation waitUntilDone:NO]; //[map 
            NSLog(@"Placed annotation");
        }
        else NSLog(@"address already existed");
        
    }
NSLog(@"%i", [map.annotations count]);
}

- (void)WHDDataHandlerDidFinishWithArray:(NSArray *)results{
    dataArray =[[NSArray alloc] initWithArray:results];
    
    for (WHDInspection *row in dataArray) {
        bool foundMatchingAddress = NO;
        
        for (id<MKAnnotation> annotation in map.annotations){
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
            
            [self performSelectorOnMainThread:@selector(placeAnnotation:) withObject:annotation waitUntilDone:NO]; //[map 
            NSLog(@"Placed annotation");
        }
        else NSLog(@"address already existed");
    }
    NSLog(@"%i", [map.annotations count]);
    
}

- (void)placeAnnotation:(id)annotation{
 
    [map addAnnotation:annotation];
}
         

- (void) locationManager:(CLLocationManager *) manager didUpdateToLocation:(CLLocation *) newLocation fromLocation:(CLLocation *) oldLocation {
	self.currentLocation = newLocation;
	
	if (initialLocation) {
        NSLog(@"in initial location");
		span.latitudeDelta = .03;
		span.longitudeDelta = .03;
		
		MKCoordinateRegion region;
		region.center = currentLocation.coordinate;
		region.span = span;
		
		[map setRegion:region animated:TRUE];
		initialLocation = NO;
        annotationsHidden = NO;
        
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.75];
        
        zoomWarning.frame = CGRectMake(0, -30, 320, 30);
        [UIView commitAnimations];
        
	}
}

- (void) locationManager:(CLLocationManager *) manager didFailWithError:(NSError *) error {
	NSString *msg = [[NSString alloc] initWithString:@"Error obtaining location"];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"GPS Error"
													message:msg delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil];
	[alert show];
	[msg release];
	[alert release];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    NSLog(@"region changed");
    NSArray *annotations = [map annotations];  
    id annotation = nil; 
    
    NSLog(@"map region span latitudeDelta = :%f", map.region.span.latitudeDelta);
    
    if (!annotationsHidden) {
        if (map.region.span.latitudeDelta > .30)
        {
            annotationsHidden = YES;
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:.75];
            
            zoomWarning.frame = CGRectMake(0, 0, 320, 30);
            [UIView commitAnimations];
            
            for (int i=0; i<[annotations count]; i++){
                annotation = [annotations objectAtIndex:i];
                [[map viewForAnnotation:annotation] setHidden:YES];
            }
            
        }
        
    }
    else{
        if (map.region.span.latitudeDelta < .30){
            annotationsHidden = NO;
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:.75];
            
            zoomWarning.frame = CGRectMake(0, -30, 320, 30);
            [UIView commitAnimations];
            for (int i=0; i<[annotations count]; i++){
                annotation = [annotations objectAtIndex:i];
                [[map viewForAnnotation:annotation] setHidden:NO];
                
            }
            
        }
        for (int i=0; i<[annotations count]; i++){
            annotation = [annotations objectAtIndex:i];
            [[map viewForAnnotation:annotation] setHidden:YES];
        }
    }
    
    if (!annotationsHidden){
        CLLocation *newCoordinate = [[CLLocation alloc] initWithLatitude:mapView.centerCoordinate.latitude longitude:mapView.centerCoordinate.longitude];
        currentLocation = newCoordinate;
        rg = [[MKReverseGeocoder alloc] initWithCoordinate:currentLocation.coordinate];
        rg.delegate = self;
        [rg start];
    }
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
    NSLog(@"Current Zip: %@", placemark.postalCode);
    
    NSLog(@"old Zip: %@", oldPostalCode);
    
    if (![oldPostalCode isEqualToString:placemark.postalCode]) {
        
        if ([dataSet isEqualToString:@"OSHA"]){
            
            [self makeOSHARequestForZip:[placemark.postalCode integerValue]];
        
        }
        else{
            [self makeWHDRequestForZip:[placemark.postalCode integerValue]];
            
        }
    }
    oldPostalCode = [[NSString alloc]initWithFormat:@"%@", placemark.postalCode];
}

-(void)makeWHDRequestForZip:(NSInteger)zipString{
    
    int variance = 10;
    int max = zipString + variance;
    int min = zipString - variance;
    
    NSString *zip = [[NSString alloc]initWithFormat:@"(zip_cd gt '%i') and (zip_cd lt '%i')", min, max];
    NSDictionary *arguments = [NSDictionary dictionaryWithObjectsAndKeys:@"trade_nm, street_addr_1_txt, city_nm, st_cd, zip_cd, naic_cd, naics_code_description, findings_end_date, findings_start_date, flsa_bw_atp_amt, flsa_ee_atp_cnt, flsa_violtn_cnt, flsa_cl_minor_cnt,flsa_cmp_assd_amt,flsa_cl_violtn_cnt,flsa_mw_bw_atp_amt,flsa_ot_bw_atp_amt,flsa_15a3_bw_atp_amt,flsa_cl_cmp_assd_amt,flsa_repeat_violator", @"select",zip, @"filter",nil];
    [wHandler getObjectsForArguments:arguments table:@"full"];
    
}

-(void)makeOSHARequestForZip:(NSInteger)zipString{
    
    int variance = 10;
    int max = zipString + variance;
    int min = zipString - variance;
    
    NSString *zip = [[NSString alloc]initWithFormat:@"(site_zip gt '%i') and (site_zip lt '%i')", min, max];
    NSDictionary *arguments = [NSDictionary dictionaryWithObjectsAndKeys:@"activity_nr,estab_name,site_address,site_city,site_state,site_zip,naics_code,insp_type,open_date,total_current_penalty,osha_violation_indicator,serious_violations,total_violations,load_dt", @"select",zip, @"filter",nil];
    [oHandler getObjectsForArguments:arguments table:@"full"];
    
    
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {    
    NSLog(@"Geocoder Fail");
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    static NSString *identifier = @"MyLocation";   
    if ([annotation isKindOfClass:[MyOSHALocation class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            
            if ([((MyOSHALocation *)annotation).inspection.establishmentType isEqualToString:@"FoodService"]){
                annotationView.image = [UIImage imageNamed:@"fork_knife_black.png"];
            }
            else if ([((MyOSHALocation *)annotation).inspection.establishmentType isEqualToString:@"Retail"]){
                annotationView.image = [UIImage imageNamed:@"cart_black.png"];
            }
            else{
                annotationView.image = [UIImage imageNamed:@"bed_black.png"];
                
            }
            
            
            annotationView.canShowCallout = YES;
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

        } 
        else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        
        return annotationView;
    }
    
    if ([annotation isKindOfClass:[MyWHDLocation class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            
            if ([((MyWHDLocation *)annotation).inspection.establishmentType isEqualToString:@"FoodService"]){
                annotationView.image = [UIImage imageNamed:@"fork_knife_black.png"];
            }
            else if ([((MyWHDLocation *)annotation).inspection.establishmentType isEqualToString:@"Retail"]){
                annotationView.image = [UIImage imageNamed:@"cart_black.png"];
            }
            else{
                annotationView.image = [UIImage imageNamed:@"bed_black.png"];
                
            }
            
            annotationView.canShowCallout = YES;
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            
        } 
        else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        
        return annotationView;
    }
    
    return nil;        
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	NSLog(@"link to new page goes here");
    
    if ([dataSet isEqualToString:@"OSHA"]){
        MyOSHALocation *location = (MyOSHALocation *)view.annotation;
        violationDetailsViewController = [[ViolationDetailsViewController alloc] initWithNibName:@"ViolationDetailsViewController" bundle:nil];
        violationDetailsViewController.dataSet = @"OSHA";
        violationDetailsViewController.inspectionArray = location.inspectionArray;
        violationDetailsViewController.OSHAInspectionDetail = location.inspection;
        
        [self.navigationController pushViewController:violationDetailsViewController animated:YES];
    }
    else{
        MyWHDLocation *location = (MyWHDLocation *)view.annotation;
        violationDetailsViewController = [[ViolationDetailsViewController alloc] initWithNibName:@"ViolationDetailsViewController" bundle:nil];
        violationDetailsViewController.dataSet = @"WHD";
        violationDetailsViewController.inspectionArray = location.inspectionArray;
        violationDetailsViewController.WHDInspectionDetail = location.inspection;
    
        [self.navigationController pushViewController:violationDetailsViewController animated:YES];
        
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
