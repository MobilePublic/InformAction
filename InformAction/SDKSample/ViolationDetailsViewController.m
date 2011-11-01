//
//  ViolationDetailsViewController.m
//  SDKSample
//
//  Created by Admin on 8/5/11.
//  Copyright 2011 MobilePublic All rights reserved.
////  Released to Public Domain


#import "ViolationDetailsViewController.h"
#import "OAuthConsumer.h"
#import "OSHAViolationDetail.h"
#import "WHDViolationDetail.h"
#import <QuartzCore/QuartzCore.h>

#define USE_CUSTOM_DRAWING 1

@implementation ViolationDetailsViewController
@synthesize OSHAInspectionDetail, yelpDataHandler, yelpViewController, addressStr, estName, yelpCell;
@synthesize name, address, responseData, loadingView, table, inspectionArray, dataSet, WHDInspectionDetail, transView; 


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
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.rowHeight = 50;
    table.backgroundColor = [UIColor clearColor];
    [[transView layer] setCornerRadius:10];
    self.title = @"iCitizen";

    [super viewDidLoad];

 
}

-(void)viewWillAppear:(BOOL)animated {

    yelpCell = [[UITableViewCell alloc] init];
   
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 240)];
    UIImageView *headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 240)];
    headerImage.image = [UIImage imageNamed:@"violation_description.png"];
    
    [headerView addSubview:headerImage];
    
    UITextView *textViewname = [[UITextView alloc] init ];
    UITextView *textViewaddress = [[UITextView alloc] init];
    UIImageView *locationType = [[UIImageView alloc] initWithFrame:CGRectMake(140, 60, 40, 40)];
    
    [textViewname setEditable:NO];
    [textViewaddress setEditable:NO];
    [textViewaddress setScrollEnabled:NO];
    
    textViewname.backgroundColor = [UIColor clearColor];
    textViewaddress.backgroundColor = [UIColor clearColor];
    
    textViewname.font = [UIFont fontWithName:@"Arial" size:12];
    textViewaddress.font = [UIFont fontWithName:@"Arial" size:12];
    
    [textViewname setTextAlignment:UITextAlignmentCenter];
    [textViewaddress setTextAlignment:UITextAlignmentCenter];
    
    if ([dataSet isEqualToString:@"OSHA"]){
        if ([OSHAInspectionDetail.establishmentType isEqualToString:@"FoodService"]){
            locationType.image = [UIImage imageNamed:@"fork_knife_black.png"];
        }
        else if ([OSHAInspectionDetail.establishmentType isEqualToString:@"Retail"]){
            locationType.image = [UIImage imageNamed:@"cart_black.png"];
        }
        else{
            locationType.image = [UIImage imageNamed:@"bed_black.png"];
            
        }
        
        textViewname.text = [[NSString alloc] initWithString:OSHAInspectionDetail.estab_name];
        textViewaddress.text = [[NSString alloc] initWithFormat:@"%@ %@ %@ %@",OSHAInspectionDetail.site_address,OSHAInspectionDetail.site_city, OSHAInspectionDetail.site_state, OSHAInspectionDetail.site_zip ];
        
    }
    else if ([dataSet isEqualToString:@"WHD"]){
        
        if ([WHDInspectionDetail.establishmentType isEqualToString:@"FoodService"]){
            locationType.image = [UIImage imageNamed:@"fork_knife_black.png"];
        }
        else if ([WHDInspectionDetail.establishmentType isEqualToString:@"Retail"]){
            locationType.image = [UIImage imageNamed:@"cart_black.png"];
        }
        else{
            locationType.image = [UIImage imageNamed:@"bed_black.png"];
            
        }
        
        
        textViewname.text = [[NSString alloc] initWithString:WHDInspectionDetail.trade_nm];
        textViewaddress.text = [[NSString alloc] initWithFormat:@"%@ %@ %@ %@",WHDInspectionDetail.street_addr_1_txt, WHDInspectionDetail.city_nm, WHDInspectionDetail.st_cd, WHDInspectionDetail.zip_cd ];
    }
    
    textViewname.frame = CGRectMake(100, 120, 120, 40);
    textViewaddress.frame = CGRectMake(80, 160, 160, 50);
    
    [headerView addSubview:locationType];
    [headerView addSubview:textViewname];
    [headerView addSubview:textViewaddress];
    
    
    self.table.tableHeaderView = headerView;
        
    [table reloadData];
    
    yelpDataHandler = [[YelpDataHandler alloc] init];
    yelpViewController = [[YelpViewController alloc] init];
    
    yelpDataHandler.delegate = self;
   
    CGPoint newCenter = (CGPoint) [self.table center];
    transView.center = newCenter;

    [self.table addSubview:transView];
    [self.loadingView startAnimating];
    [self yelpRequest];
   
}

-(void)yelpRequest {
    
    NSString *cityString;
    double longDouble;
    double latDouble;

    
    if ([dataSet isEqualToString:@"OSHA"]){
        latDouble = (double)(OSHAInspectionDetail.latitude);
        longDouble = (double)(OSHAInspectionDetail.longitude);
        cityString = [[NSString alloc] initWithString:OSHAInspectionDetail.site_city];
        addressStr = [[NSString alloc] initWithFormat:@"%@ %@ %@ %@",OSHAInspectionDetail.site_address, OSHAInspectionDetail.site_city, OSHAInspectionDetail.site_state, OSHAInspectionDetail.site_zip ];
        
        estName = [[NSString alloc] initWithString:OSHAInspectionDetail.estab_name];
        
    }
    else if ([dataSet isEqualToString:@"WHD"]){
        latDouble = (double)(WHDInspectionDetail.latitude);
        longDouble = (double)(WHDInspectionDetail.longitude);
        cityString = [[NSString alloc] initWithString:WHDInspectionDetail.city_nm];
        addressStr = [[NSString alloc] initWithFormat:@"%@ %@ %@ %@",WHDInspectionDetail.street_addr_1_txt, WHDInspectionDetail.city_nm, WHDInspectionDetail.st_cd, WHDInspectionDetail.zip_cd ];
        estName = [[NSString alloc] initWithString:WHDInspectionDetail.trade_nm];
    }
    
    cityString = [cityString lowercaseString];
    cityString = [cityString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    cityString = [cityString stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    
    NSLog(@"%@", addressStr);
    addressStr = [addressStr stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSLog(@"%@", addressStr);
    addressStr = [addressStr stringByReplacingOccurrencesOfString:@"." withString:@""];
    addressStr = [addressStr stringByReplacingOccurrencesOfString:@"'" withString:@""];
    addressStr = [addressStr stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    addressStr = [addressStr lowercaseString];
    NSLog(@"%@", addressStr);
    
    
    estName = [estName lowercaseString];
    estName = [estName stringByReplacingOccurrencesOfString:@"." withString:@""];
    estName = [estName stringByReplacingOccurrencesOfString:@"'" withString:@""];
    estName = [estName stringByReplacingOccurrencesOfString:@"&" withString:@""];
    estName = [estName stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSLog(@"%@", estName);

    [yelpDataHandler setTheName:estName];
    [yelpDataHandler setTheAddress:addressStr];
    
    [yelpDataHandler makeYelpRequets];
    
}


-(void)yelpDataHandlerDidFinish:(NSArray *)results {
    NSArray *dataArray = [[NSArray alloc] initWithArray:results];
    NSLog(@"contents of array = %@", dataArray);
    NSLog(@"array size : %i", [dataArray count]);
    
    
    int x = [dataArray count];
    
    for (int i = 0; i < x; i++) {
        NSDictionary *buz1 = [[NSDictionary alloc] initWithDictionary:(NSDictionary *)[dataArray objectAtIndex:i]];
        NSDictionary *location = (NSDictionary *) [buz1 objectForKey:@"location"];
        
        //NSDictionary *addressDict = (NSDictionary *) [location objectForKey:@"address"];
        
        NSString *estabAddress = [[NSString alloc] initWithString:addressStr];
        estabAddress = [estabAddress stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
        NSArray *yAddress = (NSArray *) [location objectForKey:@"display_address"];
        
        NSString *yelpAddress = (NSString *) [yAddress objectAtIndex:0];
        
        estabAddress = [estabAddress lowercaseString];
        yelpAddress = [yelpAddress lowercaseString];
        
        NSLog(@"yelp    address  = %@", yelpAddress);
        NSLog(@"current address = %@", estabAddress);
        
        NSString *yelpName = (NSString *) [buz1 objectForKey:@"name"];
        NSString *inspectName;
        
        if ([dataSet isEqualToString:@"OSHA"]){
            inspectName = [[NSString alloc] initWithString:OSHAInspectionDetail.estab_name];
        }
        else if ([dataSet isEqualToString:@"WHD"]){
            inspectName = [[NSString alloc] initWithString:WHDInspectionDetail.trade_nm];
        }
        
        yelpName = [yelpName lowercaseString];
        inspectName = [inspectName lowercaseString];
        
        NSRange r;
        r.location = 0;
        r.length = 4;
        NSRange t;
        t.location = 0;
        t.length = 4;
        
        if (yelpName.length > 4){
            yelpName = [yelpName substringWithRange:r];
            NSLog(@"%@", yelpName);
        }
        if (inspectName.length >4) {
            
            inspectName = [inspectName substringWithRange:t];
            NSLog(@"%@", inspectName);
        }
        
        yelpAddress = [yelpAddress substringWithRange:r];
        estabAddress = [estabAddress substringWithRange:r];
        
        if ([yelpAddress isEqualToString:estabAddress]) {
            NSLog(@"GREAT SCOTT!");
            
            NSString *yName = (NSString *) [buz1 objectForKey:@"name"];
            NSString *yURL = (NSString *) [buz1 objectForKey:@"url"];
            NSString *yImage = (NSString *) [buz1 objectForKey:@"image_url"];
            NSString *yPhone = (NSString *) [buz1 objectForKey:@"phone"];
            NSString *yRatingImage = (NSString *) [buz1 objectForKey:@"rating_img_url_large"];
            NSInteger *reviewCount = (NSInteger *) [buz1 objectForKey:@"review_count"];
            NSNumber *yRating = (NSNumber *) [buz1 objectForKey:@"rating"];
            
            NSString *rate =[[NSString alloc] initWithFormat:@"%@/5",yRating];
            NSString *rev = [[NSString alloc] initWithFormat:@"%@ Reviews",reviewCount];
            
            NSString *ID = (NSString *)[buz1 objectForKey:@"id"];
            NSLog(@"id = %@", ID);
            
            [yelpViewController setPlaceName:yName setURL:yURL setImageURL:yImage setPhone:yPhone setRating:rate setRatingImage:yRatingImage setNumberReviews:rev setBizId:ID];
            [yelpViewController makeYelpView];
            
            [self createYelpCell];
            

            break;
            
        }
        else {
            NSLog(@"Drat!");
        }
    }
    [self.loadingView stopAnimating];
    self.loadingView.hidden = YES;
    self.transView.hidden = YES;
}

-(void)createYelpCell {
    yelpCell = [[UITableViewCell alloc] initWithFrame:yelpViewController.view.frame reuseIdentifier:@"yelpCellIdentifier"];
    
    [yelpCell addSubview:yelpViewController.view];
    yelpCell.selectionStyle = UITableViewCellSelectionStyleNone;
    //yelpCell.selected = NO;
    
    [table reloadData];

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Table View Rows In Section: %i", [tableView numberOfRowsInSection:indexPath.section]);
    NSLog(@"Index Path row: %i and section: %i", indexPath.row, indexPath.section);
    
    if (indexPath.row != [tableView numberOfRowsInSection:indexPath.section]-1) {
        if ([dataSet isEqualToString:@"OSHA"]) {
            OSHAViolationDetail *violationDetail = [[OSHAViolationDetail alloc] initWithNibName:@"OSHAViolationDetail" bundle:nil];
            violationDetail.inspectionDetail = [inspectionArray objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:violationDetail animated:YES];
        }           
        else if ([dataSet isEqualToString:@"WHD"]){
            WHDViolationDetail *violationDetail = [[WHDViolationDetail alloc] initWithNibName:@"WHDViolationDetail" bundle:nil];
            violationDetail.inspectionDetail = [inspectionArray objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:violationDetail animated:YES];
        }
            // Handle tap code here
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
#if USE_CUSTOM_DRAWING
	const NSInteger TOP_LABEL_TAG = 1001;
	//const NSInteger BOTTOM_LABEL_TAG = 1002;
	UILabel *topLabel;
	//UILabel *bottomLabel;
#endif
    
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier]autorelease];
        
#if USE_CUSTOM_DRAWING
		UIImage *indicatorImage = [UIImage imageNamed:@"thing.png"];
		cell.accessoryView =
        [[[UIImageView alloc]
          initWithImage:indicatorImage]
         autorelease];
		
		topLabel =
        [[[UILabel alloc]
          initWithFrame:
          CGRectMake(30,10,280,30)]
         autorelease];
		[cell.contentView addSubview:topLabel];
        
		topLabel.tag = TOP_LABEL_TAG;
		topLabel.backgroundColor = [UIColor clearColor];
		topLabel.textColor = [UIColor colorWithRed:0.25 green:0.0 blue:0.0 alpha:1.0];
		topLabel.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
		topLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
        topLabel.font = [UIFont fontWithName:@"Arial" size:14];
        
		cell.backgroundView =
        [[[UIImageView alloc] init] autorelease];
		cell.selectedBackgroundView =
        [[[UIImageView alloc] init] autorelease];
#endif
	}
      
#if USE_CUSTOM_DRAWING
	else
	{
		topLabel = (UILabel *)[cell viewWithTag:TOP_LABEL_TAG];
		//bottomLabel = (UILabel *)[cell viewWithTag:BOTTOM_LABEL_TAG];
	}
	
    if (indexPath.row < [inspectionArray count]) {
        NSString *cellLabelString;
        
        if ([dataSet isEqualToString:@"OSHA"]){
            cellLabelString = [[NSString alloc] initWithFormat:@"%@ - %@", ((OSHAInspection *)[inspectionArray objectAtIndex:indexPath.row]).open_date, ((OSHAInspection *)[inspectionArray objectAtIndex:indexPath.row]).insp_type];
            
        }
        else{
            cellLabelString = [[NSString alloc] initWithFormat:@"%@ - %@", ((WHDInspection *)[inspectionArray objectAtIndex:indexPath.row]).findings_start_date, ((WHDInspection *)[inspectionArray objectAtIndex:indexPath.row]).findings_end_date];
        }
        
        topLabel.text = cellLabelString;
        
        UIImage *rowBackground;
        NSInteger sectionRows = [tableView numberOfRowsInSection:[indexPath section]];
        NSInteger row = [indexPath row];
        if (row == 0 && row == sectionRows - 2)
        {
            rowBackground = [UIImage imageNamed:@"violation_onlycell.png"];
        }
        else if (row == 0)
        {
            rowBackground = [UIImage imageNamed:@"violation_topcell.png"];
        }
        else if (row == sectionRows - 2)
        {
            rowBackground = [UIImage imageNamed:@"violation_bottomcell.png"];
        }
        else
        {
            rowBackground = [UIImage imageNamed:@"violation_middlecell.png"];
        }
        ((UIImageView *)cell.backgroundView).image = rowBackground;
    }
    else {
        return yelpCell;
    }

    
   
#else
#endif
	
	return cell;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

        return [self.inspectionArray count]+1;
}

- (void)viewDidUnload
{
    [super viewDidUnload];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
