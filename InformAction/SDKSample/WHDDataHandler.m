//
//  WHDDataHandler.m
//  SDKSample
//
//  Created by Admin on 8/5/11.
//  Copyright 2011 MobilePublic All rights reserved.
////  Released to Public Domain


#import "InformActionAppDelegate.h"
#import "WHDDataHandler.h"
#import "WHDInspection.h"

@implementation WHDDataHandler
@synthesize dataRequest, arrayOfInspections, documentsPath, forwardGeocoder, delegate,coordinatesDictionaryDocs;

//Set API key information
//API Key information can be recieved from http://developer.dol.gov/
//apply for your own key and scret and plug them in here
#define API_KEY @"KEY"
#define API_SECRET @"SECRET"
#define API_HOST @"http://api.dol.gov"

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }  
    
    forwardGeocoder = [[BSForwardGeocoder alloc] initWithDelegate:self];
    
    self.documentsPath = [(InformActionAppDelegate *)[[UIApplication sharedApplication] delegate] getDocumentsPath];
    
    arrayOfInspections = [[NSMutableArray alloc] init];
    populatingPlist = NO;
    return self;
}

- (void)sampleGet{
    populatingPlist = YES;
    reachedQueryLimit = NO;
    NSInteger startNumber = 97100;
    NSInteger endNumber = 99999;
    
    
    NSInteger count = startNumber;
    NSInteger countHigh = startNumber + 2;
    
    while ((count < endNumber) && !reachedQueryLimit){
        
        NSString *zipString = [[NSString alloc] initWithFormat:@"(zip_cd ge '%i') and (zip_cd le '%i')", count, countHigh];
        
        NSDictionary *arguments = [NSDictionary dictionaryWithObjectsAndKeys:@"trade_nm, street_addr_1_txt, city_nm, st_cd, zip_cd, naic_cd, naics_code_description, findings_end_date, findings_start_date, flsa_bw_atp_amt, flsa_ee_atp_cnt, flsa_violtn_cnt, flsa_cl_minor_cnt,flsa_cmp_assd_amt,flsa_cl_violtn_cnt,flsa_mw_bw_atp_amt,flsa_ot_bw_atp_amt,flsa_15a3_bw_atp_amt,flsa_cl_cmp_assd_amt,flsa_repeat_violator", @"select",zipString, @"filter",nil];
        [self getDataWithArgs:arguments];
        sleep(1);
        count += 3;
        countHigh +=3;
        NSLog(@"%i Zip code %i Zip Code ", count, countHigh);
    }
    if (reachedQueryLimit) {
        NSLog(@"REACHED QUERY LIMIT AT %i", count);
    }
    
    /*   
     NSString *zipString = [[NSString alloc] initWithFormat:@"(site_zip eq '63005')"];
     
     NSDictionary *arguments = [NSDictionary dictionaryWithObjectsAndKeys:@"activity_nr,estab_name,site_address,site_city,site_state,site_zip,naics_code,insp_type,open_date,total_current_penalty,WHD_violation_indicator,serious_violations,total_violations,load_dt", @"select",zipString, @"filter",nil];
     [self getDataWithArgs:arguments];
     //sleep(1);
     count += 1;
     */
    
}

-(void)getObjectsForArguments:(NSDictionary *)arguments table:(NSString *)table{
    if ([table isEqualToString:@"full"]) {
        [self getDataWithArgs:arguments];
    }
    else if ( [table isEqualToString:@"food"]){
        [self getFoodServiceDataWithArgs:arguments];
    }
    else if ( [table isEqualToString:@"hospitality"]){
        [self getHospitalityDataWithArgs:arguments];
    }
    else if ( [table isEqualToString:@"retail"]){
        [self getRetailDataWithArgs:arguments];
    }
    
}


- (void)getDataWithArgs:(NSDictionary *)args{
    DOLDataContext *context = [[DOLDataContext alloc] initWithAPIKey:API_KEY Host:API_HOST SharedSecret:API_SECRET];
    dataRequest = [[DOLDataRequest alloc]initWithContext:context];
    dataRequest.delegate = self;
    
    [dataRequest callAPIMethod:@"Compliance/WHD/full" withArguments:args];
}

- (void)getFoodServiceDataWithArgs:(NSDictionary *)args{
    DOLDataContext *context = [[DOLDataContext alloc] initWithAPIKey:API_KEY Host:API_HOST SharedSecret:API_SECRET];
    dataRequest = [[DOLDataRequest alloc]initWithContext:context];
    dataRequest.delegate = self;
    
    [dataRequest callAPIMethod:@"Compliance/WHD/foodService" withArguments:args];
}

- (void)getHospitalityDataWithArgs:(NSDictionary *)args{
    DOLDataContext *context = [[DOLDataContext alloc] initWithAPIKey:API_KEY Host:API_HOST SharedSecret:API_SECRET];
    dataRequest = [[DOLDataRequest alloc]initWithContext:context];
    dataRequest.delegate = self;
    
    [dataRequest callAPIMethod:@"Compliance/WHD/hospitality" withArguments:args];
}

- (void)getRetailDataWithArgs:(NSDictionary *)args{
    DOLDataContext *context = [[DOLDataContext alloc] initWithAPIKey:API_KEY Host:API_HOST SharedSecret:API_SECRET];
    dataRequest = [[DOLDataRequest alloc]initWithContext:context];
    dataRequest.delegate = self;
    
    [dataRequest callAPIMethod:@"Compliance/WHD/retail" withArguments:args];
}

- (NSArray *)createObjectsFromArray:(NSArray *)array{
    reachedQueryLimit = NO;
    
    if (populatingPlist){
        WHDInspection *i = [WHDInspection alloc];
        NSLog(@"populating LIst bro");
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *plistName = @"coordinates_whd.plist";
        NSString *path = [documentsDirectory stringByAppendingPathComponent:plistName];
        
        NSMutableDictionary *coordinatesDictionary = [[[NSMutableDictionary alloc] initWithContentsOfFile:path] autorelease];
        
        
        
        NSLog(@"COUNT RETURNED : %i", [array count]);
        
        for (NSDictionary *result in array){
            //i.activity_nr = (NSString *)[result objectForKey:@"activity_nr"];
            //i.estab_name = (NSString *)[result objectForKey:@"estab_name"];
            i.street_addr_1_txt = (NSString *)[result objectForKey:@"street_addr_1_txt"];
            i.city_nm = (NSString *)[result objectForKey:@"city_nm"];
            i.st_cd = (NSString *)[result objectForKey:@"st_cd"];
            i.zip_cd = (NSString *)[result objectForKey:@"zip_cd"];
            
            NSMutableArray *testArray = [[NSMutableArray alloc] init];
            
            testArray = [coordinatesDictionary objectForKey:[NSString stringWithFormat:@"%@ %@ %@ %@",i.street_addr_1_txt, i.city_nm, i.st_cd, i.zip_cd]];
            if (testArray == nil){
                NSString *response = [self getLocationForInspection:i];
                sleep(1);
                NSLog(@"Response: %@", response);
                if ([response isEqualToString:@"TOO MANY QUERIES"]){
                    NSLog(@"Setting query limit reached to YES");
                    reachedQueryLimit = YES;
                }
                
                NSArray *chunks = [response componentsSeparatedByString:@","];
                if ([chunks count] == 2){
                    NSString *lat = [chunks objectAtIndex:0];
                    NSString *lon = [chunks objectAtIndex:1];
                    i.latitude = [lat floatValue];
                    i.longitude = [lon floatValue];
                    
                    
                    
                }
                NSLog(@"%f,%f", i.latitude, i.longitude);
                NSLog(@"value didn't exist. adding");
                
                if (!reachedQueryLimit){
                    [coordinatesDictionary setValue:response forKey:[NSString stringWithFormat:@"%@ %@ %@ %@",i.street_addr_1_txt, i.city_nm, i.st_cd, i.zip_cd]];
                    [coordinatesDictionary writeToFile:path atomically:YES];
                }
            }
            else{
                
                NSLog(@"value already existed in plist.  %@", testArray);
            }
            
        }
        
        return  nil;
    }
    
    else{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *plistName = @"coordinates_whd.plist";
        
        NSString *myFile = [documentsDirectory stringByAppendingPathComponent:plistName];
        
        coordinatesDictionaryDocs = [[[NSMutableDictionary alloc] initWithContentsOfFile:myFile] autorelease];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"coordinates_whd" ofType:@"plist"];
        
        NSMutableDictionary *coordinatesDictionary = [[[NSMutableDictionary alloc] initWithContentsOfFile:path] autorelease];
         
        NSMutableArray *inspectionArray = [[NSMutableArray alloc] init];
            
    
        NSLog(@"COUNT RETURNED : %i", [array count]);
        
        for (NSDictionary *result in array){
            WHDInspection *i = [WHDInspection alloc];
            i.trade_nm = (NSString *)[result objectForKey:@"trade_nm"];
            i.street_addr_1_txt = (NSString *)[result objectForKey:@"street_addr_1_txt"];
            i.city_nm = (NSString *)[result objectForKey:@"city_nm"];
            i.st_cd = (NSString *)[result objectForKey:@"st_cd"];
            i.zip_cd = (NSString *)[result objectForKey:@"zip_cd"];
            i.naic_cd = (NSString *)[result objectForKey:@"naic_cd"];
            i.naics_code_description = (NSString *)[result objectForKey:@"naics_code_description"];
            
            NSString *dateStr = (NSString *)[result objectForKey:@"findings_start_date"];
            NSRange startRange;
            NSRange endRange;
            startRange = [dateStr rangeOfString:@"("];
            endRange = [dateStr rangeOfString:@")"];
            NSRange dateRange;
            dateRange.location = startRange.location + 1;
            dateRange.length = endRange.location - startRange.location -4;
            NSDate *open_date = [[NSDate alloc] initWithTimeIntervalSince1970:(NSTimeInterval)[[dateStr substringWithRange:dateRange] doubleValue]];
            NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
            [dateFormatter setDateStyle:NSDateFormatterShortStyle];
            
            i.findings_start_date = [dateFormatter stringFromDate:open_date];
            
            dateStr = (NSString *)[result objectForKey:@"findings_end_date"];
            open_date = [[NSDate alloc] initWithTimeIntervalSince1970:(NSTimeInterval)[[dateStr substringWithRange:dateRange] doubleValue]];
            
            i.findings_end_date = [dateFormatter stringFromDate:open_date];
            i.flsa_violtn_cnt = [(NSString *)[result objectForKey:@"flsa_violtn_cnt"] intValue];
            i.flsa_repeat_violator = (NSString *)[result objectForKey:@"flsa_repeat_violator"];
            i.flsa_bw_atp_amt = (NSDecimalNumber *)[result objectForKey:@"flsa_bw_apt_amt"];
            i.flsa_ee_atp_cnt = [(NSString *)[result objectForKey:@"flsa_ee_atp_cnt"] intValue];
            i.flsa_mw_bw_atp_amt = (NSDecimalNumber *)[result objectForKey:@"flsa_mw_bw_atp_amt"];
            i.flsa_ot_bw_atp_amt = (NSDecimalNumber *)[result objectForKey:@"flsa_ot_bw_atp_amt"];
            i.flsa_15a3_bw_atp_amt = (NSDecimalNumber *)[result objectForKey:@"flsa_15a3_bw_atp_amt"];
            i.flsa_cmp_assd_amt = (NSDecimalNumber *)[result objectForKey:@"flsa_cmp_assd_amt"];
            i.flsa_cl_violtn_cnt = [(NSString *)[result objectForKey:@"flsa_cl_violtn_cnt"] intValue];
            i.flsa_cl_minor_cnt = [(NSString *)[result objectForKey:@"flsa_cl_minor_cnt"] intValue];
            i.flsa_cl_cmp_assd_amt = (NSDecimalNumber *)[result objectForKey:@"flsa_cl_cmp_assd_amt"];
            
            NSString *naicsCodeCompareRest = [i.naic_cd substringToIndex:3];
            //NSLog(@"naicscodecompare : %@", naicsCodeCompareRest);
            
            NSString *naicsCodeCompareRetail = [i.naic_cd substringToIndex:1];
            
            if ([naicsCodeCompareRest isEqualToString:@"722"]){
                i.establishmentType = @"FoodService";
            }
            else if ([naicsCodeCompareRetail isEqualToString:@"4"]){
                i.establishmentType = @"Retail";
            }
            else{
                i.establishmentType = @"Hospitality";
            }
            
            NSMutableArray *testArray = [[NSMutableArray alloc] init];
            
            testArray = [coordinatesDictionary objectForKey:[NSString stringWithFormat:@"%@ %@ %@ %@",i.street_addr_1_txt, i.city_nm, i.st_cd, i.zip_cd]];
            if (testArray == nil){
                
                testArray = [coordinatesDictionaryDocs objectForKey:[NSString stringWithFormat:@"%@ %@ %@ %@",i.street_addr_1_txt, i.city_nm, i.st_cd, i.zip_cd]];
                
                if (testArray == nil){
                    
                    NSString *response = [self getLocationForInspection:i];
                    
                    if ([response isEqualToString:@"TOO MANY QUERIES"]){
                        NSLog(@"Setting query limit reached to YES");
                        reachedQueryLimit = YES;
                        
                    }
                    
                    NSArray *chunks = [response componentsSeparatedByString:@","];
                    if ([chunks count] == 2){
                        NSString *lat = [chunks objectAtIndex:0];
                        NSString *lon = [chunks objectAtIndex:1];
                        i.latitude = [lat floatValue];
                        i.longitude = [lon floatValue];
                        
                    }
                    NSLog(@"%f,%f", i.latitude, i.longitude);
                    NSLog(@"value didn't exist. adding");
                    
                    if (!reachedQueryLimit){
                        [coordinatesDictionaryDocs setValue:response forKey:[NSString stringWithFormat:@"%@ %@ %@ %@",i.street_addr_1_txt, i.city_nm, i.st_cd, i.zip_cd]];
                        [coordinatesDictionaryDocs writeToFile:myFile atomically:YES];
                    }
                    else{
                        NSLog(@"Query limit was reached. did not add to plist");
                    }

                }
                else{
                    NSArray *chunks = [testArray componentsSeparatedByString:@","];
                    if ([chunks count] == 2){
                        NSString *lat = [chunks objectAtIndex:0];
                        NSString *lon = [chunks objectAtIndex:1];
                        i.latitude = [lat floatValue];
                        i.longitude = [lon floatValue];
                        
                    }
                }
                                
                
            }
            else{
                NSArray *chunks = [(NSString *)testArray componentsSeparatedByString:@","];
                if ([chunks count] > 1){
                    
                
                i.latitude = [[chunks objectAtIndex:0] floatValue];
                i.longitude = [[chunks objectAtIndex:1] floatValue];
                }
            }
            
            [inspectionArray addObject:i];
            [i release];
            
        }
    
        
        
    return inspectionArray;
        
    }
    
    return  nil;
}

-(NSString *)getLocationForInspection:(WHDInspection *)i{
    
    
    // NSMutableDictionary* plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:[documentsPath stringByAppendingPathComponent:@"coordinates.plist"]];
    NSString *inspectionAddress = [[NSString alloc] initWithFormat:@"%@ %@ %@", i.street_addr_1_txt, i.city_nm, i.zip_cd]; 
    NSLog(@"Address: %@", inspectionAddress);
    //    NSLog(inspectionAddress);
    return  [forwardGeocoder findCoordinatesForLocation:inspectionAddress];
    [inspectionAddress release];
    
}

#pragma mark BSForwardGeocoder delegate methods

- (void)forwardGeocoderFoundLocation:(BSForwardGeocoder*)geocoder forInspection:(WHDInspection *)inspection{
    NSLog(@"%d",geocoder.status);
    if(forwardGeocoder.status == G_GEO_SUCCESS)
	{
		int searchResults = [forwardGeocoder.results count];
        
		// Add placemarks for each result
		for(int i = 0; i < searchResults; i++)
		{
			BSKmlResult *place = [forwardGeocoder.results objectAtIndex:i];
            
            inspection.latitude = place.latitude;
            inspection.longitude = place.longitude;
            
            NSLog(@"%f %f", inspection.latitude, inspection.longitude);
			// Add a placemark on the map
			/*CustomPlacemark *placemark = [[CustomPlacemark alloc] initWithRegion:place.coordinateRegion];
             placemark.title = place.address;
             [mapView addAnnotation:placemark];	*/
            
		}
        
		if([forwardGeocoder.results count] == 1)
		{
			BSKmlResult *place = [forwardGeocoder.results objectAtIndex:0];
            
            inspection.latitude = place.latitude;
            inspection.longitude = place.longitude;
            
            NSLog(@"%f %f", inspection.latitude, inspection.longitude);
            
			// Zoom into the location		
			//[mapView setRegion:place.coordinateRegion animated:TRUE];
		}
        
    }
}

- (void)forwardGeocoderError:(BSForwardGeocoder*)geocoder errorMessage:(NSString *)errorMessage{
    
    NSLog(@"Error");
}



#pragma mark DOLDataRequest delegate methods
-(void)dolDataRequest:(DOLDataRequest *)request didCompleteWithResults:(NSArray *)resultsArray {
    NSLog(@"Got results");
    
    
    
    NSArray *inspectionArray = [[NSArray alloc] initWithArray:[self createObjectsFromArray:resultsArray]];
    
    [delegate WHDDataHandlerDidFinishWithArray:inspectionArray];
    
    //Refresh the tableview
    //[self.tableView reloadData];
    
}

-(void)dolDataRequest:(DOLDataRequest *)request didCompleteWithError:(NSString *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    NSLog(@"Error with DOLDataRequest: %@",error);
//    [alert show];
    [alert release];
}

@end
