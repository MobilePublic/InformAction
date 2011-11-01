//
//  SDKSampleAppDelegate.h
//  SDKSample
//
//  Created by Admin on 8/5/11.
//  Copyright 2011 MobilePublic All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WHDDataHandler.h"
#import "OSHADataHandler.h"
#import "TermsViewController.h"

@interface InformActionAppDelegate : NSObject <UIApplicationDelegate> {
    NSString *documentsPath;
    WHDDataHandler *wData;
    OSHADataHandler *oData;
    TermsViewController *termsController;
}

-(NSString *)getDocumentsPath;
@property (nonatomic, retain) WHDDataHandler *wData;
@property (nonatomic, retain) OSHADataHandler *oData;

@property (nonatomic, retain) NSString *documentsPath;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end
