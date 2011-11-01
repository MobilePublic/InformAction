//
//  TableViewOptionsViewController.h
//  SDKSample
//
//  Created by Admin on 8/5/11.
//  Copyright 2011 MobilePublic All rights reserved.
////  Released to Public Domain


#import <UIKit/UIKit.h>

@protocol TableViewOptionsDelegate
@required
- (void)optionsDidFinish:(id)optionsController;

@end

@interface TableViewOptionsViewController : UIViewController {
    id <TableViewOptionsDelegate> delegate;
    
    UISegmentedControl *tableSegmentedControl;
    UISegmentedControl *dataSetSegmentedControl;
    
    NSString *dataset;
    NSString *table;
    
    
}

@property (nonatomic, retain) IBOutlet UISegmentedControl *tableSegmentedControl;
@property (nonatomic, retain) IBOutlet UISegmentedControl *dataSetSegmentedControl;
@property (nonatomic, retain) id <TableViewOptionsDelegate> delegate;
@property (nonatomic, retain) NSString *dataset;
@property (nonatomic, retain) NSString *table;


- (IBAction)tableSegmentedControlChanged:(id)sender;
- (IBAction)dataSetSegmentedControlChanged:(id)sender;

@end
