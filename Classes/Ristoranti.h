//
//  Ristoranti.h
//  Per Due
//
//  Created by Giuseppe Lisanti on 12/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "CJSONDeserializer.h"
#import <CoreLocation/CoreLocation.h>
#import "Home.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "GoogleHQAnnotation.h"
#import "DettaglioRistoPub.h"
#import "Reachability.h"
#import "GeoDecoder.h"

@interface Ristoranti : UIViewController <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,MKMapViewDelegate,MKAnnotation, CLLocationManagerDelegate,UIAlertViewDelegate,GeoDecoderDelegate> {
	UITableView *tableview;
	NSMutableArray *rows;
	UIViewController *detail;
	IBOutlet UISearchBar *barraRicerca;
	IBOutlet  MKMapView *map;
	NSMutableArray *risultatoRicerca;
	NSMutableDictionary *dict;
	UIView *mappa;
	IBOutlet UISegmentedControl *tiporicerca;
	IBOutlet UITableViewCell *cellapersonalizzata;
	IBOutlet UITableViewCell *cellafinale;
	IBOutlet UISegmentedControl *tipoMappa;
	NSString *provincia;
	float mylatitudine;
	float mylongitudine;
	NSString *giorno;
	NSString *tiporic;
	int indice;
	IBOutlet UIView* footerView;
	NSURL *url;
	Reachability* internetReach;
	Reachability* wifiReach;
    GeoDecoder *geodec;
    CLLocationDegrees latitude;
    CLLocationDegrees longitude;
    NSUserDefaults *prefs;

}

@property (nonatomic,retain) IBOutlet UITableView *tableview;
@property (nonatomic,retain) IBOutlet  MKMapView *map;
@property (nonatomic, retain) NSMutableArray *rows;
@property (retain,nonatomic) NSMutableDictionary *dict;
@property (nonatomic, retain) UISearchBar * barraRicerca;
@property (nonatomic, retain) NSMutableArray *risultatoRicerca;
@property (nonatomic, retain) NSString *provincia;
@property (nonatomic, retain) NSString *giorno;
@property  (assign, readwrite) float mylatitudine;
@property  (assign, readwrite) float  mylongitudine;
@property (nonatomic, retain) IBOutlet UIView *footerView;
@property (nonatomic, retain) NSURL *url;
@property (retain,nonatomic) IBOutlet UIView *mappa;

- (void) ricerca:(NSString*)tiporic;
- (IBAction)mostratiporicerca:(id)sender;
-(void)showMap:(id)sender;
-(void)removeMap:(id)sender;
- (IBAction)mostraTipoMappa:(id)sender;
- (int)aggiorna;
-(void)spinTheSpinner;
-(void)doneSpinning;
-(int)check:(Reachability*) curReach;


@end