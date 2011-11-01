//
//  OSHAInspection.m
//  SDKSample
//
//  Created by Admin on 8/5/11.
//  Copyright 2011 MobilePublic All rights reserved.
////  Released to Public Domain


#import "OSHAInspection.h"

@implementation OSHAInspection

@synthesize activity_nr, estab_name, site_address, site_city,site_state,site_zip,naics_code,insp_type,open_date,total_violations,total_current_penalty,osha_violation_indicator,serious_violations,load_dt, establishmentType, latitude, longitude;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end
