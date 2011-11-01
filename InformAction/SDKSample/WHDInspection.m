//
//  WHDInspection.m
//  SDKSample
//
//  Created by Admin on 8/5/11.
//  Copyright 2011 MobilePublic All rights reserved.
////  Released to Public Domain


#import "WHDInspection.h"

@implementation WHDInspection

@synthesize trade_nm, street_addr_1_txt, city_nm, st_cd, zip_cd, naic_cd, naics_code_description, findings_end_date, findings_start_date, flsa_bw_atp_amt, flsa_ee_atp_cnt, flsa_violtn_cnt, flsa_cl_minor_cnt,flsa_cmp_assd_amt,flsa_cl_violtn_cnt,flsa_mw_bw_atp_amt,flsa_ot_bw_atp_amt,flsa_15a3_bw_atp_amt,flsa_cl_cmp_assd_amt,flsa_repeat_violator,establishmentType, latitude,longitude;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end
