//
//  YelpDataHandler.m
//  SDKSample
//
//  Created by Admin on 8/5/11.
//  Copyright 2011 MobilePublic All rights reserved.
////  Released to Public Domain

#import "YelpDataHandler.h"

@implementation YelpDataHandler
@synthesize responseData, theName, theAddress, delegate, yelpDataArray;

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

- (void)setAddress:(NSString *)address setName:(NSString *)name{
    theAddress = [address copy];
    theName = [name copy];
}

-(void)makeYelpRequets  {
    
    NSLog(@"YelpDataHandler name and address = %@ %@", theName, theAddress);
    
    NSString *post = [NSString stringWithFormat:@"http://api.yelp.com/v2/search?term=%@&location=%@", theName, theAddress];
    
    NSURL *URL = [NSURL URLWithString:post];
    NSLog(@"Url = %@", URL);
    
    //Key, and Token can be recived by going to http://www.yelp.com/developers
    //replace KEY and SECRET with your own yelp consumer and token
    OAConsumer *consumer = [[[OAConsumer alloc] initWithKey:@"KEY" secret:@"SECRET"] autorelease];
    OAToken *token = [[[OAToken alloc] initWithKey:@"KEY" secret:@"SECRET"] autorelease];  
    
    id<OASignatureProviding, NSObject> provider = [[[OAHMAC_SHA1SignatureProvider alloc] init] autorelease];
    NSString *realm = nil;  
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:URL
                                                                   consumer:consumer
                                                                      token:token
                                                                      realm:realm
                                                          signatureProvider:provider];
    [request prepare];
    
    responseData = [[NSMutableData alloc] init];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [connection release];
    [request release];
    
    
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Error: %@, %@", [error localizedDescription], [error localizedFailureReason]);
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    yelpDataArray = [[NSMutableArray alloc] init];
    
    NSLog(@"Success!");
    NSString *stringFromData = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    [responseData release];
    
    SBJsonParser *parser = [[SBJsonParser new] autorelease];
    
	NSDictionary *responseDict = [parser objectWithString:stringFromData error:nil];
    NSLog(@"Main Array count = %i",[responseDict count]);
    [stringFromData release];
    NSLog(@"Parsed stuff = %@", responseDict);
    
    NSArray *businesses = (NSArray *) [responseDict objectForKey:@"businesses"];  
    NSLog(@"Business Array count = %i",[businesses count]);
    
    yelpDataArray =[NSMutableArray arrayWithArray:businesses];
    
    [delegate yelpDataHandlerDidFinish:yelpDataArray];

    
    //NSLog(@"Businesses = %@", businesses);
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
