//
//  DettaglioEsercente.m
//  Per Due
//
//  Created by Gabriele "Whisky" Visconti on 04/04/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MessageUI/MessageUI.h>

@interface DettaglioEsercenteNew : UIViewController <UITableViewDelegate,UITableViewDataSource,MKMapViewDelegate,MKAnnotation, CLLocationManagerDelegate,MFMailComposeViewControllerDelegate,UIWebViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate> {
    NSInteger _identificativo; 
    NSDictionary *_dict;
    UIWebView *_webView;
    // UITableView *tableview;
    // IBOutlets:
    UIViewController *_mappa;
    UIViewController *_condizioni;
    UITextView *_cond;
    UISegmentedControl *_tipoMappa;
    MKMapView *_map;
    UITableViewCell *_cellavalidita;
    UIViewController *_sito;

	IBOutlet UITableViewCell *provacella;
	IBOutlet UITableViewCell *cellaindirizzo;
	IBOutlet UITableViewCell *CellaDettaglio1;
}


@property (nonatomic, assign) NSInteger identificativo; 
@property (nonatomic, retain) NSDictionary *dict;
@property (nonatomic, retain) UIWebView *webView;
//@property (retain,nonatomic) UITableView *tableview;
@property (nonatomic, retain) IBOutlet UIViewController *mappa;
@property (nonatomic, retain) IBOutlet UIViewController *condizioni;
@property (nonatomic, retain) IBOutlet UITextView *cond;
@property (nonatomic, retain) IBOutlet UISegmentedControl *tipoMappa;
@property (nonatomic, retain) IBOutlet MKMapView *map;
@property (nonatomic, retain) IBOutlet UITableViewCell *cellavalidita;
@property (nonatomic, retain) IBOutlet UIViewController *sito;


- (IBAction)mostraTipoMappa:(id)sender;


@end


