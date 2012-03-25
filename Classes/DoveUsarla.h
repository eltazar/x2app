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
	CLLocationManager *locationManager;	
	Reachability* internetReach;
	Reachability* wifiReach;

}


@property (nonatomic, retain) NSArray *dataModel;

@property (nonatomic, retain) IBOutlet UILabel *tableHeaderLabel;



// TODO: non rispettano naming convention, correggere!
- (IBAction)openCitySelector:(id)sender;
- (IBAction)openInfo:(id)sender;
- (void)spinTheSpinner;
- (void)doneSpinning;

@end
