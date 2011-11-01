//
//  YelpViewController.m
//  SDKSample
//
//  Created by Admin on 8/5/11.
//  Copyright 2011 MobilePublic All rights reserved.
////  Released to Public Domain


#import "YelpViewController.h"

@implementation YelpViewController
@synthesize noContent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
-(void)setPlaceName:(NSString *)pName setURL:(NSString *)url setImageURL:(NSString *)imageURL setPhone:(NSString *)phone setRating:(NSString *)rating setRatingImage:(NSString *)ratingImage setNumberReviews:(NSString *)reviews setBizId:(NSString *)bizId {
    placeName = [pName copy];
    numReviews = [reviews copy];
    ratingNum= [rating copy];
    
    urlString = [url copy];
    urlImage = [imageURL copy];
    phoneNum = [phone copy];
    ratingImageUrl = [ratingImage copy];
    businessId = [bizId copy];
    
}

-(void)makeYelpView {
    
    NSLog(@"Yelp name = %@", placeName);
    NSLog(@"Yelp URL = %@", urlString);
    NSLog(@"Image URL = %@", urlImage);
    NSLog(@"Yelp Phone = %@", phoneNum);
    NSLog(@"Yelp Rating = %@", ratingNum);
    NSLog(@"Yelp RatingImage = %@", ratingImageUrl);
    NSLog(@"Yelp Number of reviews = %@", numReviews);
    
    yelpNameLabel =[[UILabel alloc] initWithFrame:CGRectMake(88, 5, 210, 40)];
    yelpNameLabel.textColor = [UIColor whiteColor];
    yelpNameLabel.text = placeName;
    yelpNameLabel.backgroundColor = [UIColor clearColor];
    [yelpNameLabel setFont:[UIFont fontWithName:@"Arial-bold" size:13]];
    yelpNameLabel.numberOfLines=2;
    yelpNameLabel.adjustsFontSizeToFitWidth = YES;
    //[self.view addSubview:yelpNameLabel];
    
    phoneLabel =[[UILabel alloc] initWithFrame:CGRectMake(88, 10, 60, 20)];
    phoneLabel.textColor = [UIColor whiteColor];
    phoneLabel.backgroundColor = [UIColor clearColor];
    [phoneLabel setFont:[UIFont fontWithName:@"Arial-bold" size:15]];
    phoneLabel.text = @"Phone:";
    [self.view addSubview:phoneLabel];
    
    phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneButton.backgroundColor = [UIColor clearColor];
    [phoneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    phoneButton.frame = CGRectMake(138, 11, 120, 20);
    [phoneButton setTitle:phoneNum forState:UIControlStateNormal];
    phoneButton.titleLabel.font = [UIFont fontWithName:@"Arial-bold" size:14];
    [phoneButton addTarget:self action:@selector(phonePressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:phoneButton];

    ratingLabel =[[UILabel alloc] initWithFrame:CGRectMake(88, 71, 130, 20)];
    ratingLabel.textColor = [UIColor whiteColor];
    ratingLabel.text = ratingNum;
    ratingLabel.backgroundColor = [UIColor clearColor];
    [ratingLabel setFont:[UIFont fontWithName:@"Arial-bold" size:15]];
    [self.view addSubview:ratingLabel];
    
    reviewsLabel =[[UILabel alloc] initWithFrame:CGRectMake(88, 40, 120, 20)];
    reviewsLabel.textColor = [UIColor whiteColor];
    reviewsLabel.text = numReviews;
    reviewsLabel.backgroundColor = [UIColor clearColor];
    [reviewsLabel setFont:[UIFont fontWithName:@"Arial-bold" size:15]];
    [self.view addSubview:reviewsLabel];
    
    ratingsImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:ratingImageUrl]]];
    ratingImageView = [[UIImageView alloc] initWithImage:ratingsImage];   
    ratingImageView.backgroundColor = [UIColor clearColor];
    ratingImageView.frame = CGRectMake(23, 75, 60, 12);
    [self.view addSubview:ratingImageView];
    
    NSLog(@"URL Image String = %@", urlImage);
    if(urlImage == nil)
    {
        placeImage = [UIImage imageNamed:@"noImage.png"];
        placeImageView = [[UIImageView alloc] initWithImage:placeImage];   
        placeImageView.backgroundColor = [UIColor blackColor];
        placeImageView.frame = CGRectMake(23, 12, 60, 60);
        [self.view addSubview:placeImageView];
    }
    else{
        placeImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlImage]]];
        placeImageView = [[UIImageView alloc] initWithImage:placeImage];   
        placeImageView.backgroundColor = [UIColor blackColor];
        placeImageView.frame = CGRectMake(23, 12, 60, 60);
        [self.view addSubview:placeImageView];
    }
    
    NSLog(@"yelp view created");
    
}

- (void)makeLoadingView {
    [self.view addSubview:noContent];
}

- (BOOL)isYelpInstalled { 
    return [[UIApplication sharedApplication] 
                                  canOpenURL:[NSURL URLWithString:@"yelp:"]]; 
}

-(IBAction)yelpPressed {
    NSLog(@"yelp press");
    NSString *message = [[NSString alloc] initWithFormat:@"Do you want to view %@ in Yelp?", placeName];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"View in Yelp" 
                                                    message:message 
                                                   delegate:self 
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    alert.delegate = self;
    alert.tag = 0;
    [alert show]; 
    [alert release]; 

}

-(void)phonePressed {
    NSString *message = [[NSString alloc] initWithFormat:@"Call %@?", phoneNum];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Call" 
                                                    message:message 
                                                   delegate:self 
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    alert.delegate = self;
    alert.tag = 2;
    [alert show]; 
    [alert release]; 
    
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 0)
    {
        if (buttonIndex == 0)
        {
            NSLog(@"index is 0");
        }
        else if (buttonIndex == 1){
            NSString *yelpURL = [[NSString alloc] initWithFormat:@"yelp:///biz/%@", businessId];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:yelpURL]];
            NSLog(@"GOTO YELP");
        }
    }
    if (actionSheet.tag == 2)
    {
        if (buttonIndex == 0)
        {
            NSLog(@"index is 0");
        }
        else if (buttonIndex == 1)
        {
            NSString *phoneCall = [[NSString alloc] initWithFormat:@"tel://%@", phoneNum];
            [[UIApplication sharedApplication] 
             openURL:[NSURL URLWithString:phoneCall]];
            NSLog(@"Call number");
        }

    }

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
	//[phoneNum release];
    //[placeName release];
    //[urlString release];

    [super dealloc];
}
@end
