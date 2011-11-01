//
//  WHDDataHandler.h
//  SDKSample
//
//  Created by Admin on 8/5/11.
//  Copyright 2011 MobilePublic All rights reserved.
////  Released to Public Domain


#import <Foundation/Foundation.h>
#import "DOLDataRequest.h"
#import <MapKit/MapKit.h>
#import "WHDInspection.h"
#import "BSForwardGeocoder.h"

@protocol WHDDataHandlerDelegate
-(void)WHDDataHandlerDidFinishWithArray:(NSArray *)results;
@end

@interface WHDDataHandler : NSObject <DOLDataRequestDelegate, BSForwardGeocoderDelegate>{
    id <WHDDataHandlerDelegate> delegate;
    DOLDataRequest *dataRequest;
    NSMutableArray *arrayOfInspections;
    NSString *documentsPath;
    BSForwardGeocoder *forwardGeocoder;
    bool populatingPlist;
    bool reachedQueryLimit;
    NSMutableDictionary *coordinatesDictionaryDocs;

}

@property(nonatomic, retain) id <WHDDataHandlerDelegate> delegate;
@property(nonatomic, retain) DOLDataRequest *dataRequest;
@property(nonatomic, retain) NSMutableArray *arrayOfInspections;
@property(nonatomic, retain) NSString *documentsPath;
@property(nonatomic, retain) BSForwardGeocoder *forwardGeocoder;
@property(nonatomic, retain) NSMutableDictionary *coordinatesDictionaryDocs;

-(void)getDataWithArgs:(NSDictionary *)args;
-(void)getHospitalityDataWithArgs:(NSDictionary *)args;
-(void)getRetailDataWithArgs:(NSDictionary *)args;
-(void)getFoodServiceDataWithArgs:(NSDictionary *)args;
-(void)sampleGet;
-(NSArray *)createObjectsFromArray:(NSArray *)array;
-(NSString *)getLocationForInspection:(WHDInspection *)i;
-(void)getObjectsForArguments:(NSDictionary *)arguments table:(NSString *)table;

@end
