//
//  ViolationDetailsViewController.h
//  SDKSample
//
//  Created by Admin on 8/5/11.
//  Copyright 2011 MobilePublic All rights reserved.
////  Released to Public Domain


#import <UIKit/UIKit.h>
#import "OSHAInspection.h"
#import "WHDInspection.h"
//#import <GHUnit/GHUnit.h>
//#import <GHUnit/GHAsyncTestCase.h>
#import "JSON.h"
#import "YelpViewController.h"
#import "YelpDataHandler.h"

@interface ViolationDetailsViewController : UIViewController <YelpDataHandlerDelegate, UITableViewDelegate, UITableViewDataSource>{
    OSHAInspection *OSHAInspectionDetail;
    WHDInspection *WHDInspectionDetail;
    NSMutableArray *inspectionArray;
    UITableView *table;
    YelpViewController *yelpViewController;
    UILabel *name;
    UILabel *address;
    NSMutableData *responseData;
    UIActivityIndicatorView *loadingView;
    YelpDataHandler *yelpDataHandler;
    NSString *dataSet;
    NSString *addressStr;
    NSString *estName;
    UITableViewCell *yelpCell;
    UIView *transView;
    
}
@property (nonatomic, retain) IBOutlet UIView *transView;
@property (nonatomic, retain) UITableViewCell *yelpCell; 
@property (nonatomic, retain) NSString *addressStr;
@property (nonatomic, retain) NSString *estName;
@property (nonatomic, retain) YelpDataHandler *yelpDataHandler;
@property (nonatomic, retain) YelpViewController *yelpViewController;
@property (nonatomic, retain) NSMutableArray *inspectionArray;
@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingView;
@property (nonatomic, retain) OSHAInspection *OSHAInspectionDetail;
@property (nonatomic, retain) WHDInspection *WHDInspectionDetail;
@property (nonatomic, retain) IBOutlet UILabel *name;
@property (nonatomic, retain) IBOutlet UILabel *address;
@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain) NSString *dataSet;

-(void)yelpRequest;
-(void)createYelpCell;
@end
