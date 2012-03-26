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
    // Properties' ivars:
    NSArray *dataModel;
    // IBOutlet properties' ivars:
    IBOutlet UILabel *tableHeaderLabel;
}

@property (nonatomic, retain) NSArray *dataModel;

@property (nonatomic, retain) IBOutlet UILabel *tableHeaderLabel;


- (void)spinTheSpinner;
- (void)doneSpinning;

- (IBAction)openCitySelector:(id)sender;
- (IBAction)openInfo:(id)sender;


@end
