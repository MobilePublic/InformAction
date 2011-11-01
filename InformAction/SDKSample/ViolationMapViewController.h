//
//  ViolationMapViewController.h
//  SDKSample
//
//  Created by Admin on 8/5/11.
//  Copyright 2011 MobilePublic All rights reserved.
////  Released to Public Domain


#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "InformActionAppDelegate.h"
#import "OSHADataHandler.h"
#import "WHDDataHandler.h"
#import "ViolationDetailsViewController.h"
#import "ViolationTableViewController.h"
#import "HelpViewController.h"


@interface ViolationMapViewController : UIViewController <MKMapViewDelegate, OSHADataHandlerDelegate, WHDDataHandlerDelegate, MKReverseGeocoderDelegate, CLLocationManagerDelegate, HelpViewControllerDelegate> {
    MKMapView *map;
    MKCoordinateSpan span;
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    BOOL initialLocation;
    MKReverseGeocoder *rg;
    NSArray *dataArray;
    NSString *oldPostalCode; 
    OSHADataHandler *oHandler;
    WHDDataHandler *wHandler;
    ViolationDetailsViewController *violationDetailsViewController;
    bool annotationsHidden;
    UIView *zoomWarning;
    UISegmentedControl *segmentedControl;
    NSString *dataSet;
    InformActionAppDelegate *appDelegate;
    ViolationTableViewController *tableViewController;
    HelpViewController *controller;
    
}
@property (nonatomic, retain) HelpViewController *controller;
@property (nonatomic, retain) ViolationTableViewController *tableViewController;
@property (nonatomic, retain) NSString *oldPostalCode; 
@property (nonatomic, retain) NSArray *dataArray;
@property (nonatomic, retain) MKReverseGeocoder *rg;
@property (nonatomic, retain) IBOutlet MKMapView *map;
@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property BOOL initialLocation;
@property (nonatomic, retain) OSHADataHandler *oHandler;
@property (nonatomic, retain) WHDDataHandler *wHandler;
@property (nonatomic, retain) ViolationDetailsViewController *violationDetailsViewController;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;

-(void)makeOSHARequestForZip:(NSInteger)zipString;
-(void)makeWHDRequestForZip:(NSInteger)zipString;
-(void)placeAnnotation:(id)annotation;
-(IBAction)segmentedControlChanged;
-(IBAction)listButtonPressed;

@end
