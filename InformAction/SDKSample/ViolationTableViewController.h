//
//  ViolationTableViewController.h
//  SDKSample
//
//  Created by Admin on 8/5/11.
//  Copyright 2011 MobilePublic All rights reserved.
////  Released to Public Domain


#import <UIKit/UIKit.h>
#import "TableViewOptionsViewController.h"
#import "OSHADataHandler.h"
#import "OSHAInspection.h"
#import "WHDDataHandler.h"
#import "WHDInspection.h"
#import "InformActionAppDelegate.h"
#import "LocationManager.h"
#import "ViolationDetailsViewController.h"
#import "WHDViolationDetail.h"

@interface ViolationTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, TableViewOptionsDelegate, LocationManagerDelegate, MKReverseGeocoderDelegate, OSHADataHandlerDelegate, WHDDataHandlerDelegate>{
    TableViewOptionsViewController *optionsViewController;
    WHDViolationDetail *whdDetail;
    NSMutableArray *dataArray;
    UITableView *tableView;
    OSHADataHandler *oData;
    WHDDataHandler *wData;
    LocationManager *locMgr;
    ViolationDetailsViewController *detailsViewController;
    NSArray *OSHAInspectionsArray;
    NSArray *WHDInspectionsArray;
    NSString *currentZip;

}

@property (nonatomic, retain) TableViewOptionsViewController *optionsViewController;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSString *currentZip;

- (IBAction)geolocate;
- (IBAction)showTableOptions:(id)sender;
- (void)loadTableForZip:(NSString *)zip forDataset:(NSString *)dataSet forTable:(NSString *)table;

@end
