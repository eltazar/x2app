//
//  Pubsebar.h
//  Per Due
//
//  Created by Giuseppe Lisanti on 08/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CJSONDeserializer.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "GoogleHQAnnotation.h"
#import "DettaglioRistoPub.h"
#import "Reachability.h"

@interface Pubsebar : UIViewController <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,MKMapViewDelegate,MKAnnotation,UIAlertViewDelegate> {
	UITableView *tableview;
	NSMutableArray *rows;
	UIViewController *detail;
	IBOutlet UISearchBar *barraRicerca;
	IBOutlet  MKMapView *map;
	NSMutableArray *risultatoRicerca;
	NSDictionary *dict;
	UIView *mappa;
	IBOutlet UISegmentedControl *tiporicerca;
	IBOutlet UITableViewCell *cellapersonalizzata;
	IBOutlet UITableViewCell *cellafinale;
	IBOutlet UISegmentedControl *tipoMappa;
	NSString *provincia;
	NSString *giorno;
	NSString *tiporic;
	float mylatitudine;
	float mylongitudine;
	int indice;
	IBOutlet UIView* footerView;
	NSURL *url;
	Reachability* internetReach;
	Reachability* wifiReach;

	
}

@property (nonatomic,retain) IBOutlet UITableView *tableview;
@property (nonatomic,retain) IBOutlet  IBOutlet  MKMapView *map;

@property (retain,nonatomic) NSArray *rows;
@property (retain,nonatomic) NSDictionary *dict;
@property (nonatomic, retain) UISearchBar * barraRicerca;
@property (nonatomic, retain) NSMutableArray *risultatoRicerca;
@property (nonatomic, retain) NSString *giorno;
@property (retain,nonatomic) IBOutlet UIView *mappa;
@property  (assign, readwrite) float mylatitudine;
@property  (assign, readwrite) float  mylongitudine;
@property (nonatomic, retain) NSString *provincia;
@property (nonatomic, retain) IBOutlet UIView *footerView;
@property (nonatomic, retain) NSURL *url;

- (void) ricerca:(NSString*)tiporic;
- (IBAction)mostratiporicerca:(id)sender;
-(void)showMap:(id)sender;
-(void)removeMap:(id)sender;
- (IBAction)mostraTipoMappa:(id)sender;
- (int)aggiorna;
- (void) spinTheSpinner;
- (void) doneSpinning;
-(int)check:(Reachability*) curReach;

@end