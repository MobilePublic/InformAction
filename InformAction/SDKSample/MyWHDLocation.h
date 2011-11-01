//
//  MyLocation.h
//  
//
//  Created by Admin on 8/5/11.
//  Copyright 2011 MobilePublic All rights reserved.
////  Released to Public Domain


#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "WHDInspection.h"

@interface MyWHDLocation : NSObject <MKAnnotation> {

    NSString *_name;
    NSString *_address;
    CLLocationCoordinate2D _coordinate;
    WHDInspection *inspection;
    NSMutableArray *inspectionArray;
    
}
@property (nonatomic, retain) NSString *dataSet;
@property (nonatomic, retain) NSMutableArray *inspectionArray;
@property (nonatomic, retain) WHDInspection *inspection;
@property (copy) NSString *name;
@property (copy) NSString *address;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;

@end
