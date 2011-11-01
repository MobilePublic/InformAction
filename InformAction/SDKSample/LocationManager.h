//
//  LocationManager.h
//  SDKSample
//
//  Created by Admin on 8/5/11.
//  Copyright 2011 MobilePublic All rights reserved.
////  Released to Public Domain


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>


@protocol LocationManagerDelegate

@required
- (void)locationUpdate:(CLLocation *)location;
- (void)locationError:(NSError *)error;

@end



@interface LocationManager : NSObject <CLLocationManagerDelegate>{
    CLLocationManager *locMgr;
    id delegate;
    
    
}

@property (nonatomic, retain) CLLocationManager *locMgr;
@property (nonatomic, assign) id delegate;


@end
