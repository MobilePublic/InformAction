//
//  SDKSampleAppDelegate.m
//  SDKSample
//
//  Created by Admin on 8/5/11.
//  Copyright 2011 MobilePublic All rights reserved.
////  Released to Public Domain




#import "InformActionAppDelegate.h"
#import "HelpViewController.h"

@implementation InformActionAppDelegate

@synthesize documentsPath;

@synthesize window=_window;

@synthesize navigationController=_navigationController;

@synthesize oData, wData;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    
    oData = [[OSHADataHandler alloc] init];
    wData = [[WHDDataHandler alloc] init];

    self.documentsPath = [self getDocumentsPath];
    
    NSString *plistName = @"coordinates_whd.plist";
    NSString *myFile = [documentsPath stringByAppendingPathComponent:plistName];
    
    NSMutableDictionary *coordinatesDictionaryDocs = [[[NSMutableDictionary alloc] initWithContentsOfFile:myFile] autorelease];
    
    if ([coordinatesDictionaryDocs count] == 0){
        NSMutableDictionary *newArray = [[NSMutableDictionary alloc] init];
        [newArray writeToFile:myFile atomically:YES];
        [newArray release];
    }
    
    plistName = @"coordinates.plist";
    myFile = [documentsPath stringByAppendingPathComponent:plistName];
    
    coordinatesDictionaryDocs = [[[NSMutableDictionary alloc] initWithContentsOfFile:myFile] autorelease];
    
    if ([coordinatesDictionaryDocs count] == 0){
        NSMutableDictionary *newArray = [[NSMutableDictionary alloc] init];
        [newArray writeToFile:myFile atomically:YES];
        [newArray release];
    }

    
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    
    if (![[NSUserDefaults standardUserDefaults] 
          boolForKey:@"didShowOneTimeAlert"]) { 
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Terms of Use" 
                                                        message:@"By clicking agree, you are agreeing to the application Terms of Use" 
                                                       delegate:self 
                                              cancelButtonTitle:@"Agree"
                                              otherButtonTitles:@"Terms", nil];
        alert.delegate = self;
        [alert show]; 
        [alert release]; 
        
        HelpViewController *help = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
        help.view.frame = CGRectMake(0, 20, 320,460);
        //[self.navigationController.view addSubview:help.view];
        
        
        [[NSUserDefaults standardUserDefaults] setBool:YES 
                                                forKey:@"didShowOneTimeAlert"]; 
        [[NSUserDefaults standardUserDefaults] synchronize]; 
    } 
    
    
    
    
    return YES;
}

- (void)termsViewControllerDidFinish:(TermsViewController *)controller {
    [termsController dismissModalViewControllerAnimated:YES];
    //[termsController.view removeFromSuperview];
    [termsController release];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //NSLog(@"Button %d pressed", buttonIndex);
    if (buttonIndex == 1) {
        termsController = [[TermsViewController alloc] init];
        termsController.delegate = self;
        termsController.modalPresentationStyle = UIModalPresentationFullScreen; 
        [self.navigationController presentModalViewController:termsController animated:YES];
    }
    else if (buttonIndex == 2) {
        [[NSUserDefaults standardUserDefaults] setBool:YES 
                                                forKey:@"didShowOneTimeAlert"]; 
        [[NSUserDefaults standardUserDefaults] synchronize]; 
    }
}


- (NSString *)getDocumentsPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application
{

}

- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [super dealloc];
}

@end
