//
//  RootViewController.h
//  SDKSample
//
//  Created by Admin on 8/5/11.
//  Copyright 2011 MobilePublic All rights reserved.
////  Released to Public Domain


#import <UIKit/UIKit.h>
#import "ViolationMapViewController.h"

@interface RootViewController : UIViewController {
    NSArray *arrayOfResults;
    ViolationMapViewController *violationMapViewController;
}

@property(nonatomic, retain)NSArray *arrayOfResults;
@property(nonatomic, retain)ViolationMapViewController *violationMapViewController;

@end
