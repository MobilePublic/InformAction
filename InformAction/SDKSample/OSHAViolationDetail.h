//
//  OSHAViolationDetail.h
//  SDKSample
//
//  Created by Admin on 8/5/11.
//  Copyright 2011 MobilePublic All rights reserved.
////  Released to Public Domain


#import <UIKit/UIKit.h>
#import "OSHAInspection.h"

@interface OSHAViolationDetail : UIViewController{
    OSHAInspection *inspectionDetail;
    UILabel *name;
    UILabel *address;
    UILabel *naics_code;
    UILabel *inspection_type;
    UILabel *open_date;
    UILabel *total_penalty;
    UILabel *violation_indicator;
    UILabel *serious_violation;
    UILabel *total_violations;
    UILabel *load_date;

}

@property (nonatomic, retain) OSHAInspection *inspectionDetail;
@property (nonatomic, retain) IBOutlet UILabel *name;
@property (nonatomic, retain) IBOutlet UILabel *address;
@property (nonatomic, retain) IBOutlet UILabel *naics_code;
@property (nonatomic, retain) IBOutlet UILabel *inspection_type;
@property (nonatomic, retain) IBOutlet UILabel *open_date;
@property (nonatomic, retain) IBOutlet UILabel *total_penalty;
@property (nonatomic, retain) IBOutlet UILabel *violation_indicator;
@property (nonatomic, retain) IBOutlet UILabel *serious_violation;
@property (nonatomic, retain) IBOutlet UILabel *total_violations;
@property (nonatomic, retain) IBOutlet UILabel *load_date;
@end
