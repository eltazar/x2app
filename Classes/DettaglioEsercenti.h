//
//  DettaglioEsercenti.h
//  Per Due
//
//  Created by Giuseppe Lisanti on 30/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MessageUI/MessageUI.h>
#import "DatabaseAccess.h"


@interface DettaglioEsercenti : UIViewController <UITableViewDelegate,UITableViewDataSource,MKMapViewDelegate,MKAnnotation, CLLocationManagerDelegate,MFMailComposeViewControllerDelegate,UIWebViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate, DatabaseAccessDelegate> {
    NSInteger _identificativo;
    NSDictionary *_dataModel;
    UIWebView *_webView;
    
    UITableView *_tableView;
    UIViewController *_mappa;
    UIViewController *_condizioni;
    UITextView *_cond;
    UISegmentedControl *_tipoMappa;
    MKMapView *_map;
    UITableViewCell *_cellavalidita;
    UIViewController *_sito;
    UIActivityIndicatorView *_activityIndicator;

	IBOutlet UITableViewCell *provacella;
	IBOutlet UITableViewCell *cellaindirizzo;
	IBOutlet UITableViewCell *CellaDettaglio1;
}


@property (nonatomic, assign) NSInteger identificativo; 
@property (nonatomic, retain) NSDictionary *dataModel;
@property (nonatomic, retain) UIWebView *webView;

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIViewController *mappa;
@property (nonatomic, retain) IBOutlet UIViewController *condizioni;
@property (nonatomic, retain) IBOutlet UITextView *cond;
@property (nonatomic, retain) IBOutlet UISegmentedControl *tipoMappa;
@property (nonatomic, retain) IBOutlet MKMapView *map;
@property (nonatomic, retain) IBOutlet UITableViewCell *cellavalidita;
@property (nonatomic, retain) IBOutlet UIViewController *sito;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;



- (IBAction)mostraTipoMappa:(id)sender;


@end