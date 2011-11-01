//
//  WHDViolationDetail.h
//  SDKSample
//
//  Created by Admin on 8/5/11.
//  Copyright 2011 MobilePublic All rights reserved.
////  Released to Public Domain


#import <UIKit/UIKit.h>
#import "WHDInspection.h"

@interface WHDViolationDetail : UIViewController{
    WHDInspection *inspectionDetail;
    UIScrollView *scrollView;
    
    UILabel *trade_nm;
    UITextView *streetAddress;
    UILabel *naic_cd;
    UILabel *naics_code_description;
    UILabel *findings_dates;
    UILabel *flsa_violtn_cnt;
    UILabel *flsa_repeat_violator;
    UILabel *flsa_bw_atp_amt;
    UILabel *flsa_ee_atp_cnt;
    UILabel *flsa_mw_bw_atp_amt;
    UILabel *flsa_ot_bw_atp_amt;
    UILabel *flsa_15a3_bw_atp_amt;
    UILabel *flsa_cmp_assd_amt;
    UILabel *flsa_cl_violtn_cnt;
    UILabel *flsa_cl_minor_cnt;
    UILabel *flsa_cl_cmp_assd_amt;
    
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) WHDInspection *inspectionDetail;
@property (nonatomic, retain) IBOutlet UILabel *trade_nm;
@property (nonatomic, retain) IBOutlet UITextView *streetAddress;
@property (nonatomic, retain) IBOutlet UILabel *naic_cd;
@property (nonatomic, retain) IBOutlet UILabel *naics_code_description;
@property (nonatomic, retain) IBOutlet UILabel *findings_dates;
@property (nonatomic, retain) IBOutlet UILabel *flsa_violtn_cnt;
@property (nonatomic, retain) IBOutlet UILabel *flsa_repeat_violator;
@property (nonatomic, retain) IBOutlet UILabel *flsa_bw_atp_amt;
@property (nonatomic, retain) IBOutlet UILabel *flsa_ee_atp_cnt;
@property (nonatomic, retain) IBOutlet UILabel *flsa_mw_bw_atp_amt;
@property (nonatomic, retain) IBOutlet UILabel *flsa_ot_bw_atp_amt;
@property (nonatomic, retain) IBOutlet UILabel *flsa_15a3_bw_atp_amt;
@property (nonatomic, retain) IBOutlet UILabel *flsa_cmp_assd_amt;
@property (nonatomic, retain) IBOutlet UILabel *flsa_cl_violtn_cnt;
@property (nonatomic, retain) IBOutlet UILabel *flsa_cl_minor_cnt;
@property (nonatomic, retain) IBOutlet UILabel *flsa_cl_cmp_assd_amt;



@end
