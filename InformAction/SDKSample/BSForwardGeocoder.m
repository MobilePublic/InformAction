//
//  Created by Björn Sållarp on 2010-03-13.
//  NO Copyright 2010 MightyLittle Industries. NO rights reserved.
// 
//  Use this code any way you like. If you do like it, please
//  link to my blog and/or write a friendly comment. Thank you!
//
//  Read my blog @ http://blog.sallarp.com
//

#import "BSForwardGeocoder.h"
#import "NSString+URLEncode.h"

@implementation BSForwardGeocoder
@synthesize searchQuery, status, results, delegate, useHTTP, currentInspection;

- (id)initWithDelegate:(id<BSForwardGeocoderDelegate>)aDelegate
{
	if ((self == [super init])) {
		delegate = aDelegate;
	}
	return self;
}

- (void)findLocation:(NSString *)searchString inspection:(OSHAInspection *)inspection
{
	self.currentInspection = inspection;
	self.searchQuery = searchString;
//	[self performSelectorInBackground:@selector(startGeocoding) withObject:nil];
    [self performSelectorOnMainThread:@selector(startGeocoding) withObject:nil waitUntilDone:YES];
}

- (void)geocodingSucceded{
    if ([delegate respondsToSelector:@selector(forwardGeocoderFoundLocation:forInspection:)]) {
        if (currentInspection != nil) {
            [delegate forwardGeocoderFoundLocation:self forInspection:currentInspection];
        }
        
        
    }
}

- (void)geocodingFailed:(NSString*)errorMessage
{
    if ([delegate respondsToSelector:@selector(forwardGeocoderError::)]) {
        [delegate forwardGeocoderError:self errorMessage:errorMessage];
    }
}

- (NSString *)findCoordinatesForLocation:(NSString *)searchString{
  	
    
    NSError *parseError = nil;
    NSString* mapsUrl = [[NSString alloc] initWithFormat:@"%@://maps.google.com/maps/api/geocode/xml?address=%@&sensor=false", 
                         useHTTP ? @"http" : @"https", [searchString URLEncodedString]];
    
    // Create the url object for our request. It's important to escape the 
    // search string to support spaces and international characters
    NSURL *url = [[NSURL alloc] initWithString:mapsUrl];
    
    // Run the KML parser
    BSGoogleV3KmlParser *parser = [[BSGoogleV3KmlParser alloc] init];
    [parser parseXMLFileAtURL:url parseError:&parseError ignoreAddressComponents:NO];
    [url release];
    [mapsUrl release];
    
    status = parser.statusCode;
    NSString *resultString;
    // If the query was successfull we store the array with results
    //NSLog(@"parser status code: %@",parser.statusCode);
    if (parser.statusCode == G_GEO_SUCCESS) {
        //self.results = parser.results;
        BSKmlResult *result = [parser.results objectAtIndex:0];
        
        resultString = [[NSString alloc] initWithFormat:@"%f,%f",result.latitude, result.longitude];
        //NSLog(@"success");

        
    }
    else {
        resultString = @"FAIL";
    }
    
    if (status == G_GEO_TOO_MANY_QUERIES){
        return @"TOO MANY QUERIES";
	} 
    else if (status != G_GEO_SUCCESS) {
        return [parseError localizedDescription];
	}
    else return resultString;
	   

    [parser release];
    
}


- (void)startGeocoding
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	int version = 3;
	
	NSError *parseError = nil;
	
	if (version == 2) {
		// Create the url to Googles geocoding API, we want the response to be in XML
		NSString* mapsUrl = [[NSString alloc] initWithFormat:@"%@://maps.google.com/maps/geo?q=%@&gl=se&output=xml&oe=utf8&sensor=false", 
							 useHTTP ? @"http" : @"https", [searchQuery URLEncodedString]];
		
		// Create the url object for our request. It's important to escape the 
		// search string to support spaces and international characters
		NSURL *url = [[NSURL alloc] initWithString:mapsUrl];
		
		// Run the KML parser
		BSGoogleV2KmlParser *parser = [[BSGoogleV2KmlParser alloc] init];
		[parser parseXMLFileAtURL:url parseError:&parseError];
		[url release];
		[mapsUrl release];
		
		status = parser.statusCode;
		
		// If the query was successfull we store the array with results
		if(parser.statusCode == G_GEO_SUCCESS) {
			self.results = parser.placemarks;
		}
		
		[parser release];
		
	}
	else if (version == 3) {
		// Create the url to Googles geocoding API, we want the response to be in XML
		NSString* mapsUrl = [[NSString alloc] initWithFormat:@"%@://maps.google.com/maps/api/geocode/xml?address=%@&sensor=false", 
							 useHTTP ? @"http" : @"https", [searchQuery URLEncodedString]];
		
		// Create the url object for our request. It's important to escape the 
		// search string to support spaces and international characters
		NSURL *url = [[NSURL alloc] initWithString:mapsUrl];
		
		// Run the KML parser
		BSGoogleV3KmlParser *parser = [[BSGoogleV3KmlParser alloc] init];
		[parser parseXMLFileAtURL:url parseError:&parseError ignoreAddressComponents:NO];
		[url release];
		[mapsUrl release];
		
		status = parser.statusCode;
		
		// If the query was successfull we store the array with results
		if (parser.statusCode == G_GEO_SUCCESS) {
			self.results = parser.results;
		}
		
		[parser release];
	}
	
	
	
	if (parseError != nil) {
        [self performSelectorOnMainThread:@selector(geocodingFailed:) withObject:[parseError localizedDescription] waitUntilDone:NO];
	}
	else {
        [self performSelectorOnMainThread:@selector(geocodingSucceded) withObject:nil waitUntilDone:NO];
	}
	
	[pool release];
}

-(void)dealloc
{
    [results release];
	[searchQuery release];
	[googleAPiKey release];
	
	[super dealloc];
}


@end
