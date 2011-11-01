//
//  OSHADataHandler.m
//  SDKSample
//
//  Created by Admin on 8/5/11.
//  Copyright 2011 MobilePublic All rights reserved.
////  Released to Public Domain

#import "InformActionAppDelegate.h"
#import "OSHADataHandler.h"
#import "OSHAInspection.h"

@implementation OSHADataHandler
@synthesize dataRequest, arrayOfInspections, documentsPath, forwardGeocoder, delegate;

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
    NSInteger startNumber = 35000;
    NSInteger endNumber = 99999;
    
    
    NSInteger count = startNumber;
    NSInteger countHigh = startNumber + 4;
    
    while (count < endNumber){
        
        NSString *zipString = [[NSString alloc] initWithFormat:@"(site_zip ge '%i') and (site_zip le '%i')", count, countHigh];
    
        NSDictionary *arguments = [NSDictionary dictionaryWithObjectsAndKeys:@"activity_nr,estab_name,site_address,site_city,site_state,site_zip,naics_code,insp_type,open_date,total_current_penalty,osha_violation_indicator,serious_violations,total_violations,load_dt", @"select",zipString, @"filter",nil];
        [self getDataWithArgs:arguments];
        sleep(1);
        count += 5;
        countHigh +=5;
        NSLog(@"%i Zip code %i Zip Code ", count, countHigh);
    }
    
     /*   
    NSString *zipString = [[NSString alloc] initWithFormat:@"(site_zip eq '63005')"];
    
    NSDictionary *arguments = [NSDictionary dictionaryWithObjectsAndKeys:@"activity_nr,estab_name,site_address,site_city,site_state,site_zip,naics_code,insp_type,open_date,total_current_penalty,osha_violation_indicator,serious_violations,total_violations,load_dt", @"select",zipString, @"filter",nil];
    [self getDataWithArgs:arguments];
    //sleep(1);
    count += 1;
*/
    
}

-(void)getObjectsForArguments:(NSDictionary *)arguments table:(NSString *)table{
    if ([table isEqualToString:@"full"]) {
        
        [self getDataWithArgs:arguments];
        
    }
    else if ([table isEqualToString:@"food"]){
        
        [self getFoodServiceDataWithArgs:arguments];
        
    }
    else if ([table isEqualToString:@"hospitality"]){
        
        [self getHospitalityDataWithArgs:arguments];
        
    }
    else if ([table isEqualToString:@"retail"]){
        
        [self getRetailDataWithArgs:arguments];
        
    }
    
}


- (void)getDataWithArgs:(NSDictionary *)args{
    DOLDataContext *context = [[DOLDataContext alloc] initWithAPIKey:API_KEY Host:API_HOST SharedSecret:API_SECRET];
    dataRequest = [[DOLDataRequest alloc]initWithContext:context];
    dataRequest.delegate = self;
    
    [dataRequest callAPIMethod:@"Compliance/OSHA/full" withArguments:args];
}

- (void)getFoodServiceDataWithArgs:(NSDictionary *)args{
    DOLDataContext *context = [[DOLDataContext alloc] initWithAPIKey:API_KEY Host:API_HOST SharedSecret:API_SECRET];
    dataRequest = [[DOLDataRequest alloc]initWithContext:context];
    dataRequest.delegate = self;

    [dataRequest callAPIMethod:@"Compliance/OSHA/foodService" withArguments:args];
}

- (void)getHospitalityDataWithArgs:(NSDictionary *)args{
    DOLDataContext *context = [[DOLDataContext alloc] initWithAPIKey:API_KEY Host:API_HOST SharedSecret:API_SECRET];
    dataRequest = [[DOLDataRequest alloc]initWithContext:context];
    dataRequest.delegate = self;
    
    [dataRequest callAPIMethod:@"Compliance/OSHA/hospitality" withArguments:args];
}

- (void)getRetailDataWithArgs:(NSDictionary *)args{
    DOLDataContext *context = [[DOLDataContext alloc] initWithAPIKey:API_KEY Host:API_HOST SharedSecret:API_SECRET];
    dataRequest = [[DOLDataRequest alloc]initWithContext:context];
    dataRequest.delegate = self;
    
    [dataRequest callAPIMethod:@"Compliance/OSHA/retail" withArguments:args];
}

- (NSArray *)createObjectsFromArray:(NSArray *)array{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    if (populatingPlist){
        OSHAInspection *i = [OSHAInspection alloc];
        NSLog(@"populating List bro");
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *plistName = @"coordinates.plist";
        NSString *path = [documentsDirectory stringByAppendingPathComponent:plistName];
        
        NSMutableDictionary *coordinatesDictionary = [[[NSMutableDictionary alloc] initWithContentsOfFile:plistName] autorelease];
        
      //  [coordinatesDictionary writeToFile:[documentsDirectory stringByAppendingPathComponent:plistName] atomically:YES];    
        //[choresDictionary writeToFile:path atomically:YES];
        /*
        
        NSMutableDictionary *dictionary = [[[NSMutableDictionary alloc] init] autorelease];
        for (NSString *drugStr in listContents) {
            NSString *substring = [drugStr substringToIndex:1];
            NSMutableArray *valueArray = (NSMutableArray*)[dictionary objectForKey:substring];
            if(valueArray==nil){
                NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:5];
                [newArray addObject:drugStr];
                [dictionary setObject:newArray forKey:substring];
            }else{
                [valueArray addObject:drugStr];
            }
            
        }
        */
        
        NSLog(@"COUNT RETURNED : %i", [array count]);
        
        for (NSDictionary *result in array){
            i.activity_nr = (NSString *)[result objectForKey:@"activity_nr"];
            //i.estab_name = (NSString *)[result objectForKey:@"estab_name"];
            i.site_address = (NSString *)[result objectForKey:@"site_address"];
            i.site_city= (NSString *)[result objectForKey:@"site_city"];
            i.site_state = (NSString *)[result objectForKey:@"site_state"];
            i.site_zip = (NSString *)[result objectForKey:@"site_zip"];

            
            
            NSMutableArray *testArray = [[NSMutableArray alloc] init];

            testArray = [coordinatesDictionary objectForKey:[NSString stringWithFormat:@"%@ %@ %@ %@",i.site_address, i.site_city, i.site_state, i.site_zip]];
            if (testArray == nil){
                sleep(1);
                NSString *response = [self getLocationForInspection:i];
                NSArray *chunks = [response componentsSeparatedByString:@","];
                if ([chunks count] == 2){
                    NSString *lat = [chunks objectAtIndex:0];
                    NSString *lon = [chunks objectAtIndex:1];
                    i.latitude = [lat floatValue];
                    i.longitude = [lon floatValue];
                    
                }
                NSLog(@"%f,%f", i.latitude, i.longitude);
                NSLog(@"value didn't exist. adding");
                [coordinatesDictionary setValue:response forKey:[NSString stringWithFormat:@"%@ %@ %@ %@",i.site_address, i.site_city, i.site_state, i.site_zip]];
                [coordinatesDictionary writeToFile:path atomically:YES];
            }
            else{
                if ([testArray isEqualToString:@"0.0,0.0"]){
                    
                    NSLog(@"HIT A 0 0 ");
                    
                }
                
                
                NSLog(@"value already existed in plist.  %@", testArray);
            }
            
        }

        return  nil;
    }
    else{
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *plistName = @"coordinates.plist";
        //NSString *path = [documentsDirectory stringByAppendingPathComponent:plistName];
        
        NSString *myFile = [documentsDirectory stringByAppendingPathComponent:plistName];
        
        NSMutableDictionary *coordinatesDictionaryDocs = [[[NSMutableDictionary alloc] initWithContentsOfFile:myFile] autorelease];
        
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"coordinates" ofType:@"plist"];        
        NSMutableDictionary *coordinatesDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        
        
        NSString *oshapath = [[NSBundle mainBundle] pathForResource:@"OSHAInspectionCodes" ofType:@"plist"];
        NSDictionary *violationCodes = [[NSDictionary alloc] initWithContentsOfFile:oshapath];
        
        NSMutableArray *inspectionArray = [[NSMutableArray alloc] init ];
        
        
        NSLog(@"COUNT RETURNED : %i", [array count]);
        
        for (NSDictionary *result in array){
            OSHAInspection *i = [OSHAInspection alloc];
            i.activity_nr = [[result objectForKey:@"activity_nr"] longValue];
            i.estab_name = (NSString *)[result objectForKey:@"estab_name"];
            i.site_address = (NSString *)[result objectForKey:@"site_address"];
            i.site_city= (NSString *)[result objectForKey:@"site_city"];
            i.site_state = (NSString *)[result objectForKey:@"site_state"];
            i.site_zip = (NSString *)[result objectForKey:@"site_zip"];
            i.naics_code = (NSString *)[result objectForKey:@"naics_code"];
            
            
            NSString *naicsCodeCompareRest = [i.naics_code substringToIndex:3];
            //NSLog(@"naicscodecompare : %@", naicsCodeCompareRest);
            
            NSString *naicsCodeCompareRetail = [i.naics_code substringToIndex:1];
            
            if ([naicsCodeCompareRest isEqualToString:@"722"]){
                i.establishmentType = @"FoodService";
            }
            else if ([naicsCodeCompareRetail isEqualToString:@"4"]){
                i.establishmentType = @"Retail";
            }
            else{
                i.establishmentType = @"Hospitality";
            }
            
            NSLog(@"Estab type: %@",i.establishmentType);
            
            
            
            i.insp_type = [violationCodes objectForKey:(NSString *)[result objectForKey:@"insp_type"]];
            
            //i.insp_type = (NSString *)[result objectForKey:@"insp_type"];
            
            
            
            NSString *dateStr = (NSString *)[result objectForKey:@"open_date"];
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
            
            
            i.open_date = [dateFormatter stringFromDate:open_date];
            i.total_current_penalty = (NSDecimalNumber *)[result objectForKey:@"total_current_penalty"];
            i.osha_violation_indicator = (bool)[result objectForKey:@"osha_violation_indicator"];
            i.serious_violations = (NSInteger *)[result objectForKey:@"serious_violations"];
            i.total_violations = (NSInteger *)[result objectForKey:@"total_violations"];
    
            //NSLog(@"Result : %@", i.osha_violation_indicator?@"YES":@"NO");
            
          
            if ([[result objectForKey:@"osha_violation_indicator"] intValue] == 1) {
                i.osha_violation_indicator = YES;
                NSLog(@"osha_violation_indicator = %@",i.osha_violation_indicator?@"YES":@"NO");
            }
            else{
                i.osha_violation_indicator = NO;
                NSLog(@"osha_violation_indicator = %@",i.osha_violation_indicator?@"YES":@"NO");

            }
            dateStr = (NSString *)[result objectForKey:@"load_dt"];
            open_date = [[NSDate alloc] initWithTimeIntervalSince1970:(NSTimeInterval)[[dateStr substringWithRange:dateRange] doubleValue]];
            
            i.load_dt = [dateFormatter stringFromDate:open_date];
            
            NSMutableArray *testArray = [[NSMutableArray alloc] init];
            testArray = [coordinatesDictionary objectForKey:[NSString stringWithFormat:@"%@ %@ %@ %@",i.site_address, i.site_city, i.site_state, i.site_zip]];
            
            if (testArray == nil){
                testArray = [coordinatesDictionaryDocs objectForKey:[NSString stringWithFormat:@"%@ %@ %@ %@",i.site_address, i.site_city, i.site_state, i.site_zip]];
                
                if (testArray == nil){
                    NSString *response = [self getLocationForInspection:i];
                    NSLog(@"%@",response);
                    
                    NSLog(@" MAKE GEOCODE REQUEST ");
                    
                    NSArray *chunks = [response componentsSeparatedByString:@","];
                    if ([chunks count] == 2){
                        NSString *lat = [chunks objectAtIndex:0];
                        NSString *lon = [chunks objectAtIndex:1];
                        i.latitude = [lat floatValue];
                        i.longitude = [lon floatValue];
                    }
                    
                    NSLog(@"%f,%f Added", i.latitude, i.longitude);
                    [coordinatesDictionaryDocs setValue:response forKey:[NSString stringWithFormat:@"%@ %@ %@ %@",i.site_address, i.site_city, i.site_state, i.site_zip]];
                    [coordinatesDictionaryDocs writeToFile:path atomically:YES];

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
                
                i.latitude = [[chunks objectAtIndex:0] floatValue];
                i.longitude = [[chunks objectAtIndex:1] floatValue];

            }
            
            [inspectionArray addObject:i];
            [i release];
        }
        
        [delegate OSHADataHandlerDidFinishWithArray:inspectionArray];
        //return inspectionArray;
    
    }
    [pool drain];
    return  nil;

    
}

-(NSString *)getLocationForInspection:(OSHAInspection *)i{
    
    
   // NSMutableDictionary* plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:[documentsPath stringByAppendingPathComponent:@"coordinates.plist"]];
    NSString *inspectionAddress = [[NSString alloc] initWithFormat:@"%@ %@ %@", i.site_address, i.site_city, i.site_zip]; 
    NSLog(@"Address: %@", inspectionAddress);
//    NSLog(inspectionAddress);
    return  [forwardGeocoder findCoordinatesForLocation:inspectionAddress];
    [inspectionAddress release];

}

#pragma mark BSForwardGeocoder delegate methods

- (void)forwardGeocoderFoundLocation:(BSForwardGeocoder*)geocoder forInspection:(OSHAInspection *)inspection{
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
    
    
    
    [NSThread detachNewThreadSelector:@selector(createObjectsFromArray:) toTarget:self withObject:resultsArray];
    
    //NSArray *inspectionArray = [[NSArray alloc] initWithArray:[self createObjectsFromArray:resultsArray]];
    
    //[delegate OSHADataHandlerDidFinishWithArray:inspectionArray];
    
    //Refresh the tableview
    //[self.tableView reloadData];

}

-(void)dolDataRequest:(DOLDataRequest *)request didCompleteWithError:(NSString *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    
    [alert show];
    [alert release];
}

@end
