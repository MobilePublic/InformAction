//
//  WHDInspection.h
//  SDKSample
//
//  Created by Admin on 8/5/11.
//  Copyright 2011 MobilePublic All rights reserved.
////  Released to Public Domain


#import <Foundation/Foundation.h>

@interface WHDInspection : NSObject{
    NSString *trade_nm;
    NSString *street_addr_1_txt;
    NSString *city_nm;
    NSString *st_cd;
    NSString *zip_cd;
    NSString *naic_cd;
    NSString *naics_code_description;
    NSString *findings_start_date;
    NSString *findings_end_date;
    int flsa_violtn_cnt;
    NSString *flsa_repeat_violator;
    NSDecimalNumber *flsa_bw_atp_amt;
    int flsa_ee_atp_cnt;
    NSDecimalNumber *flsa_mw_bw_atp_amt;
    NSDecimalNumber *flsa_ot_bw_atp_amt;
    NSDecimalNumber *flsa_15a3_bw_atp_amt;
    NSDecimalNumber *flsa_cmp_assd_amt;
    int flsa_cl_violtn_cnt;
    int flsa_cl_minor_cnt;
    NSDecimalNumber *flsa_cl_cmp_assd_amt;
    
    NSString *establishmentType;
    float latitude;
    float longitude;
}

@property (nonatomic, retain) NSString *trade_nm;
@property (nonatomic, retain) NSString *street_addr_1_txt;
@property (nonatomic, retain) NSString *city_nm;
@property (nonatomic, retain) NSString *st_cd;
@property (nonatomic, retain) NSString *zip_cd;
@property (nonatomic, retain) NSString *naic_cd;
@property (nonatomic, retain) NSString *naics_code_description;
@property (nonatomic, retain) NSString *findings_start_date;
@property (nonatomic, retain) NSString *findings_end_date;
@property int flsa_violtn_cnt;
@property (nonatomic, retain) NSString *flsa_repeat_violator;
@property (nonatomic, retain) NSDecimalNumber *flsa_bw_atp_amt;
@property int flsa_ee_atp_cnt;
@property (nonatomic, retain) NSDecimalNumber *flsa_mw_bw_atp_amt;
@property (nonatomic, retain) NSDecimalNumber *flsa_ot_bw_atp_amt;
@property (nonatomic, retain) NSDecimalNumber *flsa_15a3_bw_atp_amt;
@property (nonatomic, retain) NSDecimalNumber *flsa_cmp_assd_amt;
@property int flsa_cl_violtn_cnt;
@property int flsa_cl_minor_cnt;
@property (nonatomic, retain) NSDecimalNumber *flsa_cl_cmp_assd_amt;

@property (nonatomic, retain) NSString *establishmentType;
@property float latitude;
@property float longitude;



@end
