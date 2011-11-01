//
//  MyLocation.m
//  
//
//  Created by Admin on 8/5/11.
//  Copyright 2011 MobilePublic All rights reserved.
////  Released to Public Domain


#import "MyWHDLocation.h"

@implementation MyWHDLocation
@synthesize name = _name;
@synthesize address = _address;
@synthesize coordinate = _coordinate;
@synthesize inspection, inspectionArray, dataSet;

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init])) {
        _name = [name copy];
        _address = [address copy];
        _coordinate = coordinate;
    }
    inspectionArray = [[NSMutableArray alloc] init];
    return self;
}

- (NSString *)title {
    return _name;
}

- (NSString *)subtitle {
    return _address;
}

- (void)dealloc
{
    [_name release];
    _name = nil;
    [_address release];
    _address = nil;    
    [super dealloc];
}

@end
