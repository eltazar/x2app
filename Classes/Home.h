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
#import "Ristoranti.h"
#import "Pubsebar.h"
#import "Cinema.h"
#import "Teatri.h"
#import "Musei.h"
#import "Librerie.h"
#import "Benessere.h"
#import "Parchi.h"
#import "Viaggi.h"
#import "Altro.h"
#import "Opzioni.h"
#import "Info.h"

@interface Home : UITableViewController<CLLocationManagerDelegate,UIAlertViewDelegate>  {
	NSArray *lista;
	UILabel *giornoscelto;
	UIViewController *detail;
	NSString* citta;
	UIView *myheader;
	NSString *giorno;
	CLLocationManager *locationManager;
	float mylat;
	float mylong;
	IBOutlet UITableViewCell *cellahome;
	IBOutlet UILabel *head;
	Reachability* internetReach;
	Reachability* wifiReach;

}
@property (nonatomic,retain) IBOutlet UILabel *head;
@property (nonatomic, retain) UITableView *myTable;
@property (nonatomic, retain) NSArray *lista;
@property (nonatomic, retain) NSString *citta;

@property (nonatomic, retain) NSString *giorno;

@property (nonatomic, retain) IBOutlet UIView *myHeader;
@property(nonatomic, retain) CLLocationManager *locationManager;


- (IBAction)SelectCity:(id)sender;
- (IBAction)OpenInfo:(id)sender;
- (void) spinTheSpinner;
- (void) doneSpinning;
-(int)check:(Reachability*) curReach;

@end
