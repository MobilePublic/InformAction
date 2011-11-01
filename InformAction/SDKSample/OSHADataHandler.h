//
//  OSHADataHandler.h
//  SDKSample
//
//  Created by Admin on 8/5/11.
//  Copyright 2011 MobilePublic All rights reserved.
////  Released to Public Domain


#import <Foundation/Foundation.h>
#import "DOLDataRequest.h"
#import <MapKit/MapKit.h>
#import "OSHAInspection.h"
#import "BSForwardGeocoder.h"

@protocol OSHADataHandlerDelegate
-(void)OSHADataHandlerDidFinishWithArray:(NSArray *)results;
@end

@interface OSHADataHandler : NSObject <DOLDataRequestDelegate, BSForwardGeocoderDelegate>{
    id <OSHADataHandlerDelegate> delegate;
    DOLDataRequest *dataRequest;
    NSMutableArray *arrayOfInspections;
    NSString *documentsPath;
    BSForwardGeocoder *forwardGeocoder;
    bool populatingPlist;
}

@property(nonatomic, retain) id <OSHADataHandlerDelegate> delegate;
@property(nonatomic, retain)DOLDataRequest *dataRequest;
@property(nonatomic, retain)NSMutableArray *arrayOfInspections;
@property(nonatomic, retain)NSString *documentsPath;
@property(nonatomic, retain)BSForwardGeocoder *forwardGeocoder;

-(void)getDataWithArgs:(NSDictionary *)args;
-(void)getHospitalityDataWithArgs:(NSDictionary *)args;
-(void)getRetailDataWithArgs:(NSDictionary *)args;
-(void)getFoodServiceDataWithArgs:(NSDictionary *)args;
-(void)sampleGet;
-(NSArray *)createObjectsFromArray:(NSArray *)array;
-(NSString *)getLocationForInspection:(OSHAInspection *)i;
-(void)getObjectsForArguments:(NSDictionary *)arguments table:(NSString *)table;

@end
