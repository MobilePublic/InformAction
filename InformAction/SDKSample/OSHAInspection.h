//
//  OSHAInspection.h
//  SDKSample
//
//  Created by Admin on 8/5/11.
//  Copyright 2011 MobilePublic All rights reserved.
////  Released to Public Domain


#import <Foundation/Foundation.h>

@interface OSHAInspection : NSObject {
    long activity_nr;
    NSString *estab_name;
    NSString *site_address;
    NSString *site_city;
    NSString *site_state;
    NSString *site_zip;
    NSString *naics_code;
    NSString *insp_type;
    NSString *open_date;
    NSDecimalNumber *total_current_penalty;
    bool osha_violation_indicator;    
    NSInteger *serious_violations;
    NSInteger *total_violations;
    NSString *load_dt;
    
    NSString *establishmentType;

    float latitude;
    float longitude;
    
}

@property long activity_nr;
@property (nonatomic, retain) NSString *estab_name;
@property (nonatomic, retain) NSString *site_address;
@property (nonatomic, retain) NSString *site_city;
@property (nonatomic, retain) NSString *site_state;
@property (nonatomic, retain) NSString *site_zip;
@property (nonatomic, retain) NSString *naics_code;
@property (nonatomic, retain) NSString *insp_type;
@property (nonatomic, retain) NSString *open_date;
@property (nonatomic, retain) NSDecimalNumber *total_current_penalty;
@property bool osha_violation_indicator;
@property NSInteger *serious_violations;
@property NSInteger *total_violations;
@property (nonatomic, retain) NSString *load_dt;
@property (nonatomic, retain) NSString *establishmentType;
@property float latitude;
@property float longitude;

@end
