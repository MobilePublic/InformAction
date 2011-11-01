//
//  YelpViewController.h
//  SDKSample
//
//  Created by Admin on 8/5/11.
//  Copyright 2011 MobilePublic All rights reserved.
////  Released to Public Domain


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface YelpViewController : UIViewController  {
    
    UILabel *yelpNameLabel;
    UILabel *ratingLabel;
    UIImage *ratingsImage;
    UIImageView *ratingImageView;
    UIImage *placeImage;
    UIImageView *placeImageView;
    UILabel *reviewsLabel;
    UILabel *phoneLabel;
    UIButton *phoneButton;
    UIButton *urlButton;
    
    //passed invalues
    NSString *urlString;
    NSString *urlImage;
    NSString *ratingImageUrl;
    NSString *phoneNum;
    NSString *placeName;
    NSString *ratingNum;
    NSString *numReviews;
    NSString *businessId;
    UIView *noContent;
}
@property (nonatomic, retain) IBOutlet UIView *noContent;
-(void)makeYelpView;
-(void)makeLoadingView;
-(IBAction)yelpPressed;
-(void)phonePressed;

- (void)setPlaceName:(NSString*)pName setURL:(NSString*)url setImageURL:(NSString*)imageURL setPhone:(NSString*)phone setRating:(NSString*)rating setRatingImage:(NSString*)ratingImage setNumberReviews:(NSString*)reviews setBizId:(NSString*)bizId;

@end
