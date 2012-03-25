//
//  Home.h
//  Per Due
//
//  Created by Giuseppe Lisanti on 08/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Reachability.h"

@interface DoveUsarla : UITableViewController<CLLocationManagerDelegate,UIAlertViewDelegate>  {
	NSArray *dataModel;
	UILabel *giornoscelto;
	//UIViewController *detail;
	NSString* citta;
	//UIView *myheader;
	NSString *giorno;
	CLLocationManager *locationManager;	
	//IBOutlet UILabel *head;
	Reachability* internetReach;
	Reachability* wifiReach;

}

@property (nonatomic, retain) UITableView *myTable;
@property (nonatomic, retain) NSArray *dataModel;
@property (nonatomic, retain) NSString *citta;
@property (nonatomic, retain) NSString *giorno;

//@property (nonatomic, retain) IBOutlet UIView *tableHeader;
@property (nonatomic, retain) IBOutlet UILabel *tableHeaderLabel;



// TODO: non rispettano naming convention, correggere!
- (IBAction)openCitySelector:(id)sender;
- (IBAction)openInfo:(id)sender;
- (void)spinTheSpinner;
- (void)doneSpinning;

@end
