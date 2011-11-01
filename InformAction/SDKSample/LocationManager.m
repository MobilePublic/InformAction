//
//  LocationManager.m
//  SDKSample
//
//  Created by Admin on 8/5/11.
//  Copyright 2011 MobilePublic All rights reserved.
////  Released to Public Domain

#import "LocationManager.h"

@implementation LocationManager

@synthesize locMgr, delegate;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    self.locMgr = [[CLLocationManager alloc] init] ;
    [self.locMgr setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.locMgr setDelegate:self];
    [self.locMgr setDistanceFilter:kCLDistanceFilterNone];
    [self.locMgr startUpdatingLocation];
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	if([self.delegate conformsToProtocol:@protocol(LocationManagerDelegate)]) {  // Check if the class assigning itself as the delegate conforms to our protocol.  If not, the message will go nowhere.  Not good.
        //NSLog(@"%@", newLocation.coordinate);
		[self.delegate locationUpdate:newLocation];
	}
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	if([self.delegate conformsToProtocol:@protocol(LocationManagerDelegate)]) {  // Check if the class assigning itself as the delegate conforms to our protocol.  If not, the message will go nowhere.  Not good.
		[self.delegate locationError:error];
	}
}

- (void)dealloc {
	[self.locMgr release];
	[super dealloc];
}

@end
