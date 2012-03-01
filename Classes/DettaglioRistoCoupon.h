//
//  DettaglioRistoCoupon.h
//  PerDueCItyCard
//
//  Created by Giuseppe Lisanti on 12/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJSONDeserializer.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "GoogleHQAnnotation.h"
#import <MessageUI/MessageUI.h>
#import "Commenti.h"
#import "PerDueCItyCardAppDelegate.h"
#import "Reachability.h"

@interface DettaglioRistoCoupon : UIViewController <UITableViewDelegate,UITableViewDataSource,MKMapViewDelegate,MKAnnotation, CLLocationManagerDelegate,MFMailComposeViewControllerDelegate,UIWebViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate> {
	NSArray *rows;
	UITableView *tableview;
	NSInteger identificativo;
	NSDictionary *dict;
	IBOutlet UIViewController *mappa;
	IBOutlet UISegmentedControl *tipoMappa;
	IBOutlet  MKMapView *map;
	IBOutlet UITableViewCell *provacella;
	IBOutlet UITableViewCell *cellaindirizzo;
	IBOutlet UITableViewCell *CellaDettaglio1;
	IBOutlet UIViewController *sito;
	
	IBOutlet UIWebView *webView;
	UIViewController *detail;
	Reachability* internetReach;
	Reachability* wifiReach;
}

@property (retain,nonatomic) NSArray *rows;
@property (retain,nonatomic) UITableView *tableview;
@property (nonatomic, readwrite) NSInteger identificativo; 
@property (retain,nonatomic) NSDictionary *dict;
@property (retain,nonatomic) IBOutlet UIViewController *mappa;
@property (nonatomic, retain) UIViewController *sito;
@property (nonatomic, retain) UIViewController *condizioni;
@property (nonatomic, retain) IBOutlet UITextView *cond;

@property (nonatomic, retain) UIWebView *webView;

- (IBAction)mostraTipoMappa:(id)sender;
- (void) spinTheSpinner;
- (void) doneSpinning;
-(int)check:(Reachability*) curReach;

@end
