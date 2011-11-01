//
//  YelpDataHandler.h
//  SDKSample
//
//  Created by Admin on 8/5/11.
//  Copyright 2011 MobilePublic All rights reserved.
////  Released to Public Domain

#import <UIKit/UIKit.h>
#import "OAuthConsumer.h"
#import "JSON.h"

@protocol YelpDataHandlerDelegate
-(void)yelpDataHandlerDidFinish:(NSArray *)results;
@end

@interface YelpDataHandler : UIViewController {
    id <YelpDataHandlerDelegate> delegate;
    NSMutableData *responseData;
    NSString *theName;
    NSString *theAddress;
    NSMutableArray *yelpDataArray;

}
@property (nonatomic, retain) id <YelpDataHandlerDelegate> delegate;
@property (nonatomic, retain) NSString *theName;
@property (nonatomic, retain) NSString *theAddress;
@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain) NSMutableArray *yelpDataArray;

- (void)setAddress:(NSString*)address setName:(NSString*)name;

-(void)makeYelpRequets;

@end
