//
//  Home.h
//  Per Due
//
//  Created by Giuseppe Lisanti on 08/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface DoveUsarla : UITableViewController <CLLocationManagerDelegate,UIAlertViewDelegate>  {
@private
    CLLocationCoordinate2D location;
    CLLocationManager *_locationManager;
    NSArray *_dataModel;
    // IBOutlet properties' ivars:
    UILabel *_tableHeaderLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *tableHeaderLabel;


- (IBAction)openCitySelector:(id)sender;
- (IBAction)openInfo:(id)sender;


@end
